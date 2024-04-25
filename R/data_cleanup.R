# load ----0
source(here::here('R', 'utils.R'))

# get all files
fls <- tolower(list.files(here::here('data'), pattern = ".RData", full.names = F))

# filter to groupings of files 
four_fls <- fls[grepl('age-4', fls)]
five_fls <- fls[grepl('age-5', fls)]
cap_fls <- fls[grepl('cap_hcr', fls) & !grepl('var', fls)]
cap_var_fls <- fls[grepl('cap_hcr', fls) & grepl('var', fls) & !grepl('hind', fls)]
full_abc_fls <- fls[grepl('full_abc', fls) & !grepl('hind', fls) & !grepl('cap', fls)]
log_fls <- fls[grepl('log', fls)]
avg_fls <- fls[grepl('price_avg', fls)]
var_fls <- fls[grepl('price_var', fls) & !grepl('cap', fls)]
reg_fls <- fls[grepl('reg', fls)]
trwl_fls <- fls[grepl('trwl', fls)]
hind_cap_fls <- fls[grepl('hind', fls) & grepl('cap', fls)]
hind_var_fls <- fls[grepl('hind', fls) & !grepl('cap', fls)]

base_fls <- fls[!grepl('trwl', fls, ignore.case = T) &
                  !grepl('var', fls, ignore.case = T) &
                  !grepl('cap', fls, ignore.case = T) &
                  !grepl('hind', fls, ignore.case = T) &
                  !grepl('full_abc', fls, ignore.case = T) &
                  !grepl('avg', fls, ignore.case = T) & 
                  !grepl('reg', fls, ignore.case = T) &
                  !grepl('log', fls, ignore.case = T) &
                  !grepl('age-4', fls, ignore.case = T) & 
                  !grepl('age-5', fls, ignore.case = T)]

base <- cleanup(base_fls) 
trwl_10 <- cleanup(trwl_fls, id='-trwl_10') 
reg_shift <- cleanup(reg_fls, id='-reg_shft') 
var <- cleanup(var_fls, id='-var') 
avg <- cleanup(base_fls, id='-avg') 
log <- cleanup(base_fls, id='-log') 
full_abc <- cleanup(full_abc_fls, id='-full_abc') 
cap <- cleanup(cap_fls, id='-cap') 
cap_var <- cleanup(cap_var_fls, id='-cap_var') 
hind_cap <- cleanup(hind_cap_fls, id='-hind_cap') 
hind_var <- cleanup(hind_var_fls, id='-hind_var') 
four <- cleanup(four_fls, age=4) 
five <- cleanup(five_fls, age=5) 


saveRDS(base, here::here('output', 'base.RDS'))
saveRDS(trwl_10, here::here('output', 'trwl_10.RDS'))
saveRDS(reg_shift, here::here('output', 'reg_shift.RDS'))
saveRDS(var, here::here('output', 'var.RDS'))
saveRDS(avg, here::here('output', 'avg.RDS'))
saveRDS(log, here::here('output', 'log.RDS'))
saveRDS(full_abc, here::here('output', 'full_abc.RDS'))
saveRDS(cap, here::here('output', 'cap.RDS'))
saveRDS(cap_var, here::here('output', 'cap_var.RDS'))
saveRDS(hind_cap, here::here('output', 'hind_cap.RDS'))
saveRDS(hind_var, here::here('output', 'hind_var.RDS'))
saveRDS(four, here::here('output', 'four.RDS'))
saveRDS(five, here::here('output', 'five.RDS'))
