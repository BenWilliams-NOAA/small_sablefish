# there are 3 lists that are output by the pull_data() function
# ts = time series, ad = age data, caa = example catch at age
# we can add more outputs as desired via the get_vals() function in the utils.R script

# load the utils.r script
# you aren't using an Rproj setup so you will need to direct the source to the proper location
source(paste0(wd, '\\utils.R', sep=''))

# read in report files by scenario
# also point to the appropriate place
data <- pull_data(paste0(wd, '\\Results',sep=''), years, ages) 


saveRDS(object = data, file = paste0(summ_res_dir,"\\",scen_nm,".RData", sep=''))
#data2<-readRDS(paste0(summ_res_dir,"\\",scen_nm,".RData", sep=''))

# timeseries stuff
# and last one to tell where to go
# push these up to the google drive (or github)
#vroom::vroom_write(data$ts, paste0(summ_res_dir,"\\ts_",scen_nm,".csv", sep=''), delim = ',')
#vroom::vroom_write(data$ad, paste0(summ_res_dir,"\\ad_",scen_nm,".csv", sep=''), delim = ',')
#vroom::vroom_write(data$ad, paste0(summ_res_dir,"\\ad_",scen_nm,".csv", sep=''), delim = ',')

#quants(data$ts, 'ssb', "Historical", "0%", "Full") 
#plot_swath(data$ts, 'ssb')
