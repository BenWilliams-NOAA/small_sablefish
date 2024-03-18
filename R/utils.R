# load ----
library(dplyr)
library(tidyr)
library(purrr)
library(ggplot2)
library(afscassess)
library(scico)
theme_set(theme_report())

# globals 
years = 2024:2073
ages = 2:31

# helper functions
# in a normal world i'd put these in an R package 
vals <- function(item, report, years = NULL, ages = NULL, lengths = NULL) {
  
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
                   mat = vals('mat', REP),
                   wt_m = vals('wt_m', REP),
                   wt_f = vals('wt_f', REP),
                   m = vals('m', REP),
                   price_age_f = vals('price_age_f', REP),
                   price_age_m = vals('price_age_m', REP))
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

plotit <- function(data, x, y) {
  
  data %>% 
    ggplot(aes(x = {{ x }}, y = {{ y }})) + 
    stat_summary(fun = median, geom="line") +
    geom_line(aes(group = sim), alpha = 0.3) +
    expand_limits(y=0) +
    theme(legend.position='none') -> p
  plotly::ggplotly(p)
}

quants <- function(data, var, scenario) {
  q_name <- tidytable::map_chr(seq(.025,.975,.05), ~ paste0("q", .x*100))
  q_fun <- tidytable::map(seq(.025,.975,.05), ~ purrr::partial(quantile, probs = .x, na.rm = TRUE)) %>%
    purrr::set_names(nm = q_name)
  
  data %>% 
    tidytable::select(years, {{var}}) %>% 
    dplyr::group_by(years) %>%
    dplyr::summarise_at(dplyr::vars({{var}}), tibble::lst(!!!q_fun, median)) %>% 
    tidytable::pivot_longer(-c(years, median)) %>%
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
                      .by = c(years, grouping),
                      id = !!var,
                      scenario = scenario) 
}

plot_swath <- function(data, x) {
  data %>%
    ggplot2::ggplot(ggplot2::aes({{x}}, group = grouping)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = min, ymax = max), alpha = 0.07) +
    ggplot2::geom_line(ggplot2::aes(y = median)) +
    afscassess::scale_x_tickr(data=data, var={{x}}, to=10, start = 2024) +
    # ggplot2::ylab("Revenue OFL") +
    # ggplot2::xlab("Year") +
    ggplot2::expand_limits(y = 0) 
}
