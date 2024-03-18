source(here::here('R', 'utils.R'))

# read in report file
data <- pull_data(here::here('data', 'results'), years, ages) 


# timeseries stuff
ts <- data$ts
# age data stuff
ad <- data$ad

dead_catch <- quants(ts, 'dead_catch', scenario = 'base')
plot_swath(dead_catch, years)

rev_abc <- quants(ts, 'rev_abc', scenario = 'base')
plot_swath(rev_abc, years)

rev <- quants(ts, 'rev', scenario = 'base')
plot_swath(rev, years) + 
  ylab('revenue')
