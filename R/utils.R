# load ----
library(dplyr)
library(tidyr)
library(purrr)
library(ggplot2)
library(afscassess)
library(scico)
library(vroom)
theme_set(theme_report())

# functions to read rep files 
# the following 3 functions are used to consolidate the raw .rep files retuned by ADMB
vals <- function(item, report, years = 2024:2073, ages = 2:31, lengths = NULL) {
  
  steps = grep("\\$", report)
  it =  which(report == paste0('$', item))
  test = as.numeric(steps>it)
  # find next step
  p <- function(f,b) function(a) f(a,b)
  g <- function(x) {
    r = vector("list",3)
    r[[1]] = Position(p(`==`,1),x)
    r[[2]] = Position(p(`>`,1),x)
    r[[3]] = Find(p(`>`,10),x)
    return(r)
  }
  f <- function(x){
    subset(x, x!="")
  }
  s = g(test)[[1]]
  
  out = report[(it+1):(steps[s]-1)]
  out = base::strsplit(out, " ")
  if(length(out)==1) {
    out = subset(out[[1]], out[[1]]!="")
    out = as.numeric(out)
  } else if(!is.null(ages)){
    
    dd = purrr::map(out, f)
    out = data.frame(year = years,
                     matrix(unlist(dd), nrow = length(years), ncol = length(ages), byrow = TRUE))
    names(out)[-1] <- paste0('age',ages)
    out %>% 
      tidyr::pivot_longer(-year) %>% 
      mutate(age = as.numeric(gsub('age', '', name))) -> out
  } else {
    dd = purrr::map(out, f)
    out = data.frame(year = years,
                     matrix(unlist(dd), nrow = length(years), ncol = length(length), byrow = TRUE))
    names(out)[-1] <- paste0('length',length)
    out %>% 
      tidyr::pivot_longer(-year) %>% 
      mutate(length = as.numeric(gsub('length', '', name))) -> out
  }
  out
}

# need updated if add items or want additional/other items reported out  
get_vals <- function(REP, years, ages) {
  
  ts <- data.frame(years = years,
                   f_abc = vals('f_abc', REP),
                   f_ofl = vals('f_ofl', REP),
                   dead_catch = vals('dead_catch', REP),  
                   abc = vals('abc', REP),
                   ofl = vals('ofl', REP),
                   bio = vals('bio', REP),
                   ssb = vals('ssb', REP),
                   recr = vals('recr', REP),
                   tot_n = vals('tot_n', REP),
                   f = vals('f', REP),
                   land_fg = vals('land_fg', REP),
                   land_tr = vals('land_tr', REP),
                   disc = vals('disc', REP),
                   dead = vals('disc_dead', REP),
                   abc_land_fg = vals('abc_land_fg', REP),
                   abc_land_tr = vals('abc_land_tr', REP),
                   abc_disc = vals('abc_disc', REP),
                   abc_disc_dead = vals('abc_disc_dead', REP),
                   ofl_land_fg = vals('ofl_land_fg', REP),
                   ofl_land_tr = vals('ofl_land_tr', REP),
                   ofl_disc = vals('ofl_disc', REP),
                   ofl_disc_dead = vals('ofl_disc_dead', REP),
                   rev = vals('rev', REP),
                   rev_abc = vals('rev_abc', REP),
                   rev_ofl = vals('rev_ofl', REP))
  # age related data 
  ad <- data.frame(age = ages,
                   price_age_f = vals('price_age_f', REP),
                   price_age_m = vals('price_age_m', REP),
                   slx_fg_f = vals('slx_fg_f', REP),
                   slx_fg_m = vals('slx_fg_f', REP),
                   slx_tr_f = vals('slx_tr_f', REP),
                   slx_tr_m = vals('slx_tr_m', REP),
                   ret_fg_f = vals('ret_fg_f', REP),
                   ret_fg_m = vals('ret_fg_m', REP))
  caa = vals('caa_ofl_dead_f', REP, years, ages)
  list(ts = ts, ad = ad, caa = caa)
}

pull_data <- function(loc, years, ages) {
  files <- list.files(loc, pattern="*.rep", full.names=TRUE)
  ldf <- lapply(files, readLines)
  
  ldf %>% 
    purrr::map(get_vals, years, ages) -> newd
  
  do.call(mapply, c(list, newd, SIMPLIFY=FALSE))$ts %>% 
    purrr::map_df(., ~as.data.frame(.x), .id = "sim") -> ts
  
  
  do.call(mapply, c(list, newd, SIMPLIFY=FALSE))$ad %>% 
    purrr::map_df(., ~as.data.frame(.x), .id = "sim") -> ad
  
  do.call(mapply, c(list, newd, SIMPLIFY=FALSE))$caa %>% 
    purrr::map_df(., ~as.data.frame(.x), .id = "sim") -> caa
  
  list(ts = ts, ad = ad, caa = caa)
}


quants <- function(data, var, recr, dmr, ret_age) {
  q_name <- tidytable::map_chr(c(0.075,0.25, 0.75, 0.925), ~ paste0("q", .x*100))
  q_fun <- tidytable::map(c(0.075,0.25, 0.75, 0.925), ~ purrr::partial(quantile, probs = .x, na.rm = TRUE)) %>%
    purrr::set_names(nm = q_name)
  
  data %>% 
    tidytable::select(years, {{var}}) %>% 
    dplyr::group_by(years) %>%
    dplyr::summarise_at(dplyr::vars({{var}}), tibble::lst(!!!q_fun, median)) %>% 
    tidytable::pivot_longer(-c(years, median)) %>% 
    tidytable::mutate(grouping = tidytable::case_when(name == q_name[1] | name == q_name[4] ~ 1,
                                                      name == q_name[2] | name == q_name[3] ~ 2
                                                      )) %>% 
    tidytable::mutate(min = min(value),
                      max = max(value),
                      .by = c(years, grouping),
                      id = !!var,
                      scenario = paste(recr, dmr, ret_age, sep = '-')) 
}

quantsssb <- function(data, recr, dmr, ret_age) {
  q_name <- tidytable::map_chr(c(0.075,0.25, 0.75, 0.925), ~ paste0("q", .x*100))
  q_fun <- tidytable::map(c(0.075,0.25, 0.75, 0.925), ~ purrr::partial(quantile, probs = .x, na.rm = TRUE)) %>%
    purrr::set_names(nm = q_name)
  
  data %>% 
    tidytable::mutate(value = as.numeric(value)) %>% 
    tidytable::summarise(n = sum(value[age>=10]),
                         tot = sum(value), .by = c(sim, year)) %>% 
    tidytable::mutate(perc = n / tot) %>%
    group_by(year) %>% 
    dplyr::summarise_at(dplyr::vars(perc), tibble::lst(!!!q_fun, median)) %>% 
    tidytable::pivot_longer(-c(year, median)) %>% 
    tidytable::mutate(grouping = tidytable::case_when(name == q_name[1] | name == q_name[4] ~ 1,
                                                      name == q_name[2] | name == q_name[3] ~ 2
    )) %>% 
    tidytable::mutate(min = min(value),
                      max = max(value),
                      .by = c(year, grouping),
                      id = 'ssbaa',
                      scenario = paste(recr, dmr, ret_age, sep = '-')) 
}

# same, but for age data 
quantsa <- function(data, var, recr, dmr, ret_age) {
  q_name <- tidytable::map_chr(c(0.075,0.25, 0.75, 0.925), ~ paste0("q", .x*100))
  q_fun <- tidytable::map(c(0.075,0.25, 0.75, 0.925), ~ purrr::partial(quantile, probs = .x, na.rm = TRUE)) %>%
    purrr::set_names(nm = q_name)
  
  data %>% 
    tidytable::select(age, {{var}}) %>% 
    dplyr::group_by(age) %>%
    dplyr::summarise_at(dplyr::vars({{var}}), tibble::lst(!!!q_fun, median)) %>% 
    tidytable::pivot_longer(-c(age, median)) %>%
    tidytable::mutate(grouping = tidytable::case_when(name == q_name[1] | name == q_name[20] ~ 1,
                                                      name == q_name[2] | name == q_name[19] ~ 2,
                                                      name == q_name[3] | name == q_name[18] ~ 3,
                                                      name == q_name[4] | name == q_name[17] ~ 4,
                                                      name == q_name[5] | name == q_name[16] ~ 5,
                                                      name == q_name[6] | name == q_name[15] ~ 6,
                                                      name == q_name[7] | name == q_name[14] ~ 7,
                                                      name == q_name[8] | name == q_name[13] ~ 8,
                                                      name == q_name[9] | name == q_name[12] ~ 9,
                                                      name == q_name[10] | name == q_name[11] ~ 10)) %>% 
    tidytable::mutate(min = min(value),
                      max = max(value),
                      .by = c(age, grouping),
                      id = !!var,
                      scenario = paste(recr, dmr, ret_age, sep = '-')) 
}

# same but returns a mean instead of median 
# currently only used for 'dead' variable
quants_mean <- function(data, var, recr, dmr, ret_age) {
  q_name <- tidytable::map_chr(c(0.075,0.25, 0.75, 0.925), ~ paste0("q", .x*100))
  q_fun <- tidytable::map(c(0.075,0.25, 0.75, 0.925), ~ purrr::partial(quantile, probs = .x, na.rm = TRUE)) %>%
    purrr::set_names(nm = q_name)
  
  data %>% 
    tidytable::select(years, {{var}}) %>% 
    dplyr::group_by(years) %>%
    dplyr::summarise_at(dplyr::vars({{var}}), tibble::lst(!!!q_fun, mean)) %>% 
    tidytable::pivot_longer(-c(years, mean)) %>%
    tidytable::mutate(grouping = tidytable::case_when(name == q_name[1] | name == q_name[4] ~ 1,
                                                      name == q_name[2] | name == q_name[3] ~ 2)) %>% 
    tidytable::mutate(min = min(value),
                      max = max(value),
                      .by = c(years, grouping),
                      id = !!var,
                      scenario = paste(recr, dmr, ret_age, sep = '-')) 
}

# evaluate multiple varaibles at once - may need updated with additional/other variables
# for time series data 
quant_it <- function(data, recr, dmr, ret_age) {
  dplyr::bind_rows(quants(data, 'dead_catch', recr, dmr, ret_age),
                   quants(data, 'rev', recr, dmr, ret_age),
                   quants(data, 'ssb', recr, dmr, ret_age),
                   quants_mean(data, 'dead', recr, dmr, ret_age),
                   quants_mean(data, 'recr', recr, dmr, ret_age),
                   quants(data, 'bio', recr, dmr, ret_age))
}
# evaluate multiple varaibles at once - may need updated with additional/other variables
# for age data 
quant_ita <- function(data, recr, dmr, ret_age) {
  dplyr::bind_rows(quantsa(data, 'ypr_age', recr, dmr, ret_age),
                   quantsa(data, 'spr_age', recr, dmr, ret_age),
                   quantsa(data, 'rpr_age', recr, dmr, ret_age))
}

# plotting functions 
plot_swath <- function(data, x) {
  data %>%
    filter(id==x) %>% 
    ggplot2::ggplot(ggplot2::aes(years, group = interaction(grouping, scenario), color = scenario, fill = scenario)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = min, ymax = max), alpha = 0.07, color = NA) +
    ggplot2::geom_line(ggplot2::aes(y = median)) +
    # afscassess::scale_x_tickr(data=data, var=years, to=10, start = 2024) +
    # ggplot2::ylab("Revenue OFL") +
    # ggplot2::xlab("Year") +
    ggplot2::expand_limits(y = 0) +
    scico::scale_color_scico_d(palette = 'roma') +
    scico::scale_fill_scico_d(palette = 'roma')
}


# plotting functions 
plot_ssb<- function(data, x) {
  data %>%
    filter(id==x) %>% 
    ggplot2::ggplot(ggplot2::aes(year, group = interaction(grouping, scenario), color = scenario, fill = scenario)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = min, ymax = max), alpha = 0.07, color = NA) +
    ggplot2::geom_line(ggplot2::aes(y = median)) +
    ggplot2::expand_limits(y = 0) 
}

# plot_swath2 <- function(data) {
#   data %>%
#     ggplot2::ggplot(ggplot2::aes(years, group = interaction(grouping, scenario), color = scenario, fill = scenario)) +
#     ggplot2::geom_ribbon(ggplot2::aes(ymin = min, ymax = max), alpha = 0.01, color = NA) +
#     ggplot2::geom_line(ggplot2::aes(y = median)) +
#     afscassess::scale_x_tickr(data=data, var=years, to=10, start = 2024) 
#   # ggplot2::ylab("Revenue OFL") +
#   # ggplot2::xlab("Year") +
#   # ggplot2::expand_limits(y = 0) 
# }

cleanup <- function(files, id=NULL, age=3){
  a <- files[grepl('base', files) | grepl('no_disc', files)]
  b <- files[grepl('12', files)]
  c <- files[grepl('20', files)]
  d <- files[grepl('35', files)]
  if(length(a)>0){
    a0 = readRDS(here::here('data', a[grepl('base', a) | grepl('hist', a)]))
    a1 = readRDS(here::here('data', a[grepl('rec_recr', a)]))
    a2 = readRDS(here::here('data', a[grepl('hi_lo', a)]))
    a3 = readRDS(here::here('data', a[grepl('lo_hi', a)]))
  }
  
  b0 = readRDS(here::here('data', b[grepl('hist', b)]))
  b1 = readRDS(here::here('data', b[grepl('rec_recr', b)]))
  b2 = readRDS(here::here('data', b[grepl('hi_lo', b)]))
  b3 = readRDS(here::here('data', b[grepl('lo_hi', b)]))
  
  c0 = readRDS(here::here('data', c[grepl('hist', c)]))
  c1 = readRDS(here::here('data', c[grepl('rec_recr', c)]))
  c2 = readRDS(here::here('data', c[grepl('hi_lo', c)])) 
  c3 = readRDS(here::here('data', c[grepl('lo_hi', c)])) 
  
  d0 = readRDS(here::here('data', d[grepl('hist', d)]))
  d1 = readRDS(here::here('data', d[grepl('rec_recr', d)]))
  d2 = readRDS(here::here('data', d[grepl('hi_lo', d)])) 
  d3 = readRDS(here::here('data', d[grepl('lo_hi', d)])) 
  
  ## no dmr 
  if(length(a)>0){
    dmr = 0 # no mortality, cause no discards
    ret_age = paste0(1, id)
    bind_rows(quant_it(a0$ts, recr='hist', dmr, ret_age),
              quant_it(a1$ts, recr='rec', dmr, ret_age),
              quant_it(a2$ts, recr='hilo', dmr, ret_age),
              quant_it(a3$ts, recr='lohi', dmr, ret_age)) -> a
    
    bind_rows(quant_ita(a0$ad, recr='hist', dmr, ret_age),
              quant_ita(a1$ad, recr='rec', dmr, ret_age),
              quant_ita(a2$ad, recr='hilo', dmr, ret_age),
              quant_ita(a3$ad, recr='lohi', dmr, ret_age)) -> aa
    
    bind_rows(quantsssb(a0$ssbaa, recr='hist', dmr, ret_age),
              quantsssb(a1$ssbaa, recr='rec', dmr, ret_age),
              quantsssb(a2$ssbaa, recr='hilo', dmr, ret_age),
              quantsssb(a3$ssbaa, recr='lohi', dmr, ret_age)) -> assb
  }
  
  ## 12% dmr 
  dmr = 12 
  ret_age = paste0(age, id)
  bind_rows(quant_it(b0$ts, recr='hist', dmr, ret_age),
            quant_it(b1$ts, recr='rec', dmr, ret_age),
            quant_it(b2$ts, recr='hilo', dmr, ret_age),
            quant_it(b3$ts, recr='lohi', dmr, ret_age)) -> b
  
  bind_rows(quant_ita(b0$ad, recr='hist', dmr, ret_age),
            quant_ita(b1$ad, recr='rec', dmr, ret_age),
            quant_ita(b2$ad, recr='hilo', dmr, ret_age),
            quant_ita(b3$ad, recr='lohi', dmr, ret_age)) -> ba
  
  bind_rows(quantsssb(b0$ssbaa, recr='hist', dmr, ret_age),
            quantsssb(b1$ssbaa, recr='rec', dmr, ret_age),
            quantsssb(b2$ssbaa, recr='hilo', dmr, ret_age),
            quantsssb(b3$ssbaa, recr='lohi', dmr, ret_age)) -> bssb
  
  ## 20% dmr  
  dmr = 20 
  bind_rows(quant_it(c0$ts, recr='hist', dmr, ret_age),
            quant_it(c1$ts, recr='rec', dmr, ret_age),
            quant_it(c2$ts, recr='hilo', dmr, ret_age),
            quant_it(c3$ts, recr='lohi', dmr, ret_age)) -> c
  
  bind_rows(quant_ita(c0$ad, recr='hist', dmr, ret_age),
            quant_ita(c1$ad, recr='rec', dmr, ret_age),
            quant_ita(c2$ad, recr='hilo', dmr, ret_age),
            quant_ita(c3$ad, recr='lohi', dmr, ret_age)) -> ca
  
  bind_rows(quantsssb(c0$ssbaa, recr='hist', dmr, ret_age),
            quantsssb(c1$ssbaa, recr='rec', dmr, ret_age),
            quantsssb(c2$ssbaa, recr='hilo', dmr, ret_age),
            quantsssb(c3$ssbaa, recr='lohi', dmr, ret_age)) -> cssb
  
  ## 35% dmr 
  dmr = 35 
  bind_rows(quant_it(d0$ts, recr='hist', dmr, ret_age),
            quant_it(d1$ts, recr='rec', dmr, ret_age),
            quant_it(d2$ts, recr='hilo', dmr, ret_age),
            quant_it(d3$ts, recr='lohi', dmr, ret_age)) -> d
  
  bind_rows(quant_ita(d0$ad, recr='hist', dmr, ret_age),
            quant_ita(d1$ad, recr='rec', dmr, ret_age),
            quant_ita(d2$ad, recr='hilo', dmr, ret_age),
            quant_ita(d3$ad, recr='lohi', dmr, ret_age)) -> da
  
  bind_rows(quantsssb(d0$ssbaa, recr='hist', dmr, ret_age),
            quantsssb(d1$ssbaa, recr='rec', dmr, ret_age),
            quantsssb(d2$ssbaa, recr='hilo', dmr, ret_age),
            quantsssb(d3$ssbaa, recr='lohi', dmr, ret_age)) -> dssb
  
  
  
  if(length(a)>0){
    rm(a0, a1, a2, a3)
  }
  
  rm(b0, b1, b2, b3, c0, c1, c2, c3, d0, d1, d2, d3)
  
  if(length(a)>0){
    list(ts = list(no_disc=a, dmr12=b, dmr20=c, dmr35=d),
         ad = list(no_disc=aa, dmr12=ba, dmr20=da, dmr35=da),
         ssbaa = list(no_disc=assb, dmr12=bssb, dmr20=cssb, dmr35=dssb))
  } else {
    list(ts = list(dmr12=b, dmr20=c, dmr35=d),
         ad = list(dmr12=ba, dmr20=da, dmr35=da),
         ssbaa = list(dmr12=bssb, dmr20=cssb, dmr35=dssb))
  }
  
  
}
