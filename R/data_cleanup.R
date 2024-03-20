
source(here::here('R', 'utils.R'))

# read in report file
data <- pull_data(here::here('data', 'base'), years, ages) 
hist_12 <- pull_data(here::here('data', 'hist_12'), years, ages) 
low_hi_12 <- pull_data(here::here('data', 'low_hi_12'), years, ages) 
hi_low_12 <- pull_data(here::here('data', 'hi_low_12'), years, ages) 
rec_12 <- pull_data(here::here('data', 'rec_12'), years, ages) 

# timeseries stuff
ts <- data$ts
tsh12 <- hist_12$ts
tslh12 <- low_hi_12$ts
tshl12 <- hi_low_12$ts
tsr12 <- rec_12$ts

# age data stuff
ad <- data$ad

recr = 'h' # historical 
dmr = 0 # no mortality, cause no discards
ret_age = 1 # keep em all 
dead_catch <- quants(ts, 'dead_catch', recr, dmr, ret_age)
rev_abc <- quants(ts, 'rev_abc', recr, dmr, ret_age)
rev <- quants(ts, 'rev', recr, dmr, ret_age)
ssb <- quants(ts, 'ssb', recr, dmr, ret_age)
bio <- quants(ts, 'bio', recr, dmr, ret_age)


recr = 'h'
dmr = 12 # 12% dmr
ret_age = 3 # knife-edge age-3
dead_catch1 <- quants(tsh12, 'dead_catch', recr, dmr, ret_age)
rev_abc1 <- quants(tsh12, 'rev_abc', recr, dmr, ret_age)
rev1 <- quants(tsh12, 'rev', recr, dmr, ret_age)
ssb1 <- quants(tsh12, 'ssb', recr, dmr, ret_age)
bio1 <- quants(tsh12, 'bio', recr, dmr, ret_age)

recr = 'hi-lo'
dmr = 12
ret_age = 3
dead_catch2 <- quants(tslh12, 'dead_catch', recr, dmr, ret_age)
rev_abc2 <- quants(tslh12, 'rev_abc', recr, dmr, ret_age)
rev2 <- quants(tslh12, 'rev', recr, dmr, ret_age)
ssb2 <- quants(tslh12, 'ssb', recr, dmr, ret_age)
bio2 <- quants(tslh12, 'bio', recr, dmr, ret_age)


recr = 'lo-hi'
dmr = 12
ret_age = 3
dead_catch3 <- quants(tshl12, 'dead_catch', recr, dmr, ret_age)
rev_abc3 <- quants(tshl12, 'rev_abc', recr, dmr, ret_age)
rev3 <- quants(tshl12, 'rev', recr, dmr, ret_age)
ssb3 <- quants(tshl12, 'ssb', recr, dmr, ret_age)
bio3 <- quants(tshl12, 'bio', recr, dmr, ret_age)

recr = 'recent'
dmr = 12
ret_age = 3
dead_catch4 <- quants(tsr12, 'dead_catch', recr, dmr, ret_age)
rev_abc4 <- quants(tsr12, 'rev_abc', recr, dmr, ret_age)
rev4 <- quants(tsr12, 'rev', recr, dmr, ret_age)
ssb4 <- quants(tsr12, 'ssb', recr, dmr, ret_age)
bio4 <- quants(tsr12, 'bio', recr, dmr, ret_age)

rev %>% 
  mutate(scenario = paste(recruitment, dmr, retention, sep = '-' )) %>% 
  bind_rows(  rev1 %>% mutate(scenario = paste(recruitment, dmr, retention, sep = '-' )),
              rev2 %>% mutate(scenario = paste(recruitment, dmr, retention, sep = '-' )),
              rev3 %>% mutate(scenario = paste(recruitment, dmr, retention, sep = '-' )),
              rev4%>% mutate(scenario = paste(recruitment, dmr, retention, sep = '-' ))) -> newd


plot_swath2(newd, years) + 
  facet_wrap(~scenario)



plot_swath(dead_catch, years)
plot_swath(rev_abc, years)
plot_swath(rev, years) + 
  ylab('revenue')
plot_swath(ssb, years) + 
  ylab('ssb')
plot_swath(bio, years) + 
  ylab('total biomass')
