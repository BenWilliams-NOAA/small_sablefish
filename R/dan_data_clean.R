# there are 3 lists that are output by the pull_data() function
# ts = time series, ad = age data, caa = example catch at age
# we can add more outputs as desired via the get_vals() function in the utils.R script

# load the utils.r script
# you aren't using an Rproj setup so you will need to direct the source to the proper location
source(here::here('R', 'utils.R'))

# make an output folder to store results in 
# same for this, tell it where you want the 'output' folder
dir.create(here::here('output'))

# read in report files by scenario
# also point to the appropriate place
data <- pull_data(here::here('data', 'base'), years, ages) 
hist_12 <- pull_data(here::here('data', 'hist_12'), years, ages) 
low_hi_12 <- pull_data(here::here('data', 'low_hi_12'), years, ages) 
hi_low_12 <- pull_data(here::here('data', 'hi_low_12'), years, ages) 
rec_12 <- pull_data(here::here('data', 'rec_12'), years, ages) 


# timeseries stuff
# push these up to the google drive (or github)
vroom::vroom_write(data$ts, here::here('output', 'ts_base.csv'), delim = ',')
vroom::vroom_write(hist_12$ts, here::here('output', 'ts_hist_12.csv'), delim = ',')
vroom::vroom_write(low_hi_12$ts, here::here('output', 'ts_low_hi_12.csv'), delim = ',')
vroom::vroom_write(hi_low_12$ts, here::here('output', 'ts_hi_low_12.csv'), delim = ',')
vroom::vroom_write(rec_12$ts, here::here('output', 'ts_rec_12.csv'), delim = ',')

# age data stuff
# push these up to the google drive (or github)
vroom::vroom_write(data$ad, here::here('output', 'ad_base.csv'), delim = ',')
vroom::vroom_write(hist_12$ad, here::here('output', 'ad_hist_12.csv'), delim = ',')
vroom::vroom_write(low_hi_12$ad, here::here('output', 'ad_low_hi_12.csv'), delim = ',')
vroom::vroom_write(hi_low_12$ad, here::here('output', 'ad_hi_low_12.csv'), delim = ',')
vroom::vroom_write(rec_12$ad, here::here('output', 'ad_rec_12.csv'), delim = ',')
