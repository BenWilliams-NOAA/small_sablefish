library(tidyverse)
library(afscassess)
library(patchwork)
library(scico)
library(afscassess)
theme_set(theme_report())

# data ----
base <- readRDS(here::here('output', 'base.RDS'))
trwl_10 <- readRDS(here::here('output', 'trwl_10.RDS'))
reg_shift <- readRDS(here::here('output', 'reg_shift.RDS'))
var <- readRDS(here::here('output', 'var.RDS'))
avg <- readRDS(here::here('output', 'avg.RDS'))
log <- readRDS(here::here('output', 'log.RDS'))
full_abc <- readRDS(here::here('output', 'full_abc.RDS'))
cap <- readRDS(here::here('output', 'cap.RDS'))
cap_var <- readRDS(here::here('output', 'cap_var.RDS'))
hind_cap <- readRDS(here::here('output', 'hind_cap.RDS'))
hind_var <- readRDS(here::here('output', 'hind_var.RDS'))
four <- readRDS(here::here('output', 'four.RDS'))
five <- readRDS(here::here('output', 'five.RDS'))


# median tables ------
bind_rows(bind_rows(log$ts), bind_rows(full_abc$ts), bind_rows(trwl_10$ts), bind_rows(avg$ts), bind_rows(var$ts)) %>%   
  filter(id!='recr', grepl('hist-0', scenario)) %>% #,
  # years %in% 2025:2034) %>%
  mutate(median = ifelse(id == 'dead', mean, median)) %>% 
  # mutate(type = case_when(grepl('-log', scenario) ~ log,
  #                         grepl('-5', scenario) ~ 5,
  #                         TRUE ~ 3),
  #        scenario = gsub('.{2}$', '', scenario)) %>% 
  group_by(scenario, id) %>% 
  summarise(m = mean(median, na.rm=T))  %>% 
  pivot_wider(names_from = scenario, values_from = m) %>% View

bind_rows(base$ts) %>% 
  filter(
    id != 'recr') %>% 
  filter(years %in% c(2024:2034)) %>% 
  group_by(id, scenario) %>% 
  mutate(median = ifelse(id == 'dead', mean, median)) %>% 
  summarise(median = round(mean(median, na.rm=T),4)) %>% 
  pivot_wider(names_from = id, values_from = median) 

filter(years %in% c(2024:2034)) %>% 
  group_by(id, scenario) %>% 
  mutate(median = ifelse(id == 'dead', mean, median)) %>% 
  summarise(median = round(mean(median, na.rm=T),4)) %>% 
  pivot_wider(names_from = id, values_from = median) %>% View
mutate(dead_catch = round(dead_catch, 4))




# fig 1 -----
data.frame(sex = c(rep('female', 30), rep('male', 30)),
           age = rep(2:31, times=2),
           fg = c(0.108672, 0.538614, 0.917882, 0.990743, 0.999025, 0.999898, 0.999989, 0.999999, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                  0.214712, 0.351467, 0.517883, 0.680423, 0.808435, 0.893217, 0.943117, 0.970469, 0.98488, 0.992314, 0.996108, 0.998032, 0.999006, 0.999498, 0.999747, 0.999872, 0.999936, 0.999967, 0.999984, 0.999992, 0.999996, 0.999998, 0.999999, 0.999999, 1, 1, 1, 1, 1, 1),
           tr = c(0.49131, 0.729438, 0.87133, 0.952166, 0.990961, 1, 0.98786, 0.960777, 0.923378, 0.879142, 0.83069, 0.78, 0.728556, 0.677459, 0.627514, 0.579298, 0.533207, 0.489499, 0.448325, 0.409754, 0.373794, 0.340405, 0.309514, 0.281025, 0.254822, 0.230784, 0.208779, 0.188676, 0.170345, 0.153656,
                  0.236413, 0.46284, 0.646052, 0.785149, 0.884456, 0.949626, 0.986374, 1, 0.995212, 0.976084, 0.946076, 0.908085, 0.864506, 0.817294, 0.768027, 0.71796, 0.668074, 0.619126, 0.571682, 0.526155, 0.48283, 0.441891, 0.403441, 0.367518, 0.33411, 0.303168, 0.274613, 0.248346, 0.224255, 0.202217),
           age_3 = c(0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                     0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
           age_4 = c(0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                     0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
           age_5 = c(0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                     0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
           log = c(0.182426, 0.817574, 0.989013, 0.999447, 0.999972, 0.999999, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                   0.182426, 0.817574, 0.989013, 0.999447, 0.999972, 0.999999, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)) %>% 
  pivot_longer(-c(age, sex))  %>% 
  mutate(fleet = case_when(grepl('tr', name) ~ 'Trawl Gear',
                           TRUE ~ 'Fixed Gear'),
         type = case_when(grepl('fg', name) | grepl('tr', name) ~ 'Selectivity',
                          grepl('age_3', name) ~ "Retention (Age-3 Knife-edge)",
                          grepl('age_4', name) ~ "Retention (Age-4 Knife-edge)",
                          grepl('age_5', name) ~ "Retention (Age-5 Knife-edge)",
                          grepl('log', name) ~ "Retention (Logistic)")
  ) %>% 
  ggplot(aes(age, value, color = interaction(fleet, sex), group = interaction(type, fleet, sex))) + 
  geom_line() + 
  facet_wrap(~fleet)

data.frame(sex = c(rep('female', 30), rep('male', 30)),
           age = rep(2:31, times=2),fg = c(0.108672, 0.538614, 0.917882, 0.990743, 0.999025, 0.999898, 0.999989, 0.999999, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                           0.214712, 0.351467, 0.517883, 0.680423, 0.808435, 0.893217, 0.943117, 0.970469, 0.98488, 0.992314, 0.996108, 0.998032, 0.999006, 0.999498, 0.999747, 0.999872, 0.999936, 0.999967, 0.999984, 0.999992, 0.999996, 0.999998, 0.999999, 0.999999, 1, 1, 1, 1, 1, 1),
           tr = c(0.49131, 0.729438, 0.87133, 0.952166, 0.990961, 1, 0.98786, 0.960777, 0.923378, 0.879142, 0.83069, 0.78, 0.728556, 0.677459, 0.627514, 0.579298, 0.533207, 0.489499, 0.448325, 0.409754, 0.373794, 0.340405, 0.309514, 0.281025, 0.254822, 0.230784, 0.208779, 0.188676, 0.170345, 0.153656,
                  0.236413, 0.46284, 0.646052, 0.785149, 0.884456, 0.949626, 0.986374, 1, 0.995212, 0.976084, 0.946076, 0.908085, 0.864506, 0.817294, 0.768027, 0.71796, 0.668074, 0.619126, 0.571682, 0.526155, 0.48283, 0.441891, 0.403441, 0.367518, 0.33411, 0.303168, 0.274613, 0.248346, 0.224255, 0.202217),
           age_3 = c(0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                     0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
           age_4 = c(0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                     0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
           age_5 = c(0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                     0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
           log = c(0.182426, 0.817574, 0.989013, 0.999447, 0.999972, 0.999999, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                   0.182426, 0.817574, 0.989013, 0.999447, 0.999972, 0.999999, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))  %>% 
  pivot_longer(-c(age, sex)) %>% 
  mutate(type = ifelse(grepl('age', name) | grepl('log', name), 'Retention', 'Selectivity'),
         Scenario = case_when(name=='fg' ~ 'Fixed gear',
                              name=='tr' ~ 'Trawl gear',
                              name=='age_3' ~ 'Age-3 knife edge',
                              name=='age_4' ~ 'Age-4 knife edge',
                              name=='age_5' ~ 'Age-5 knife edge',
                              name=='log' ~ 'Logistic')) -> dat



dat %>% 
  filter(age<=10, type=='Retention' ) %>% 
  ggplot(aes(age, value, color = Scenario)) + 
  geom_line() + 
  afscassess::scale_x_tickr(data = dat, var = age, start = 0) +
  scico::scale_color_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Age-3 knife edge', 'Age-4 knife edge', 'Age-5 knife edge', 'Logistic', 'Fixed gear', 'Trawl gear female', 'Trawl gear male')) +
  facet_wrap(~type, scales = 'free_x') +
  expand_limits(y = 0) + 
  xlab('Age') + 
  ylab('') + 
  theme(legend.position = c(0.7, 0.2)) -> p1


dat %>% 
  rename(Sex=sex) %>% 
  filter(type=='Selectivity') %>% 
  ggplot(aes(age, value, color = Sex, linetype = Scenario)) + 
  geom_line() + 
  scale_x_tickr(data = dat, var = age, start = 0) +
  scico::scale_color_scico_d(palette = 'roma') +
  facet_wrap(~type, scales = 'free_x') +
  expand_limits(y = 0) + 
  xlab('Age') + 
  ylab('') + 
  theme(legend.position = c(0.4, 0.3)) -> p2

png(filename=here::here("figs", "retention.png"), width = 6.5, height = 3.5,
    units = "in", type ="cairo", res = 200)
p1 + p2

dev.off()


# fig 2 ----

rep_file <- readLines(here::here('data', "ypr.rep"))

repit <- function(item) {
  a = as.numeric(unlist(strsplit(rep_file[grep(item,rep_file)+1],split=" ")))
  a / max(a, na.rm=T)
}

png(filename=here::here("figs", "pr.png"), width = 6.5, height = 3.5,
    units = "in", type ="cairo", res = 200)
data.frame(
  F = as.numeric(unlist(strsplit(rep_file[grep("f_fr",rep_file)+1],split=" "))),
  ypr_fr = repit('ypr_fr'),
  spr_fr = repit('spr_fr'),
  rpr_fr = repit('rpr_fr'),
  ypr_12 = repit('ypr_12'),
  spr_12 = repit('spr_12'),
  rpr_12 = repit('rpr_12'),
  ypr_20 = repit('ypr_20'),
  spr_20 = repit('spr_20'),
  rpr_20 = repit('rpr_20'),
  ypr_35 = repit('ypr_35'),
  spr_35 = repit('spr_35'),
  rpr_35 = repit('rpr_35')) %>% 
  pivot_longer(-F) %>% 
  # drop_na() %>% 
  mutate(Type = case_when(grepl('ypr', name) ~ "Yield-per-Recruit",
                          grepl('spr', name) ~ "Spawner-per-Recruit",
                          grepl('rpr', name) ~ "Revenue-per-Recruit"),
         DMR = case_when(
           grepl("_fr", name) ~ "Full Retention",
           grepl("_35", name) ~ "35% DMR",
           grepl("_20", name) ~ "20 % DMR",
           grepl("_12", name) ~ "12% DMR")) %>% 
  ggplot(aes(F, value, color = DMR)) + 
  geom_line() +
  facet_wrap(~Type) +
  scico::scale_color_scico_d(palette = 'roma', begin = 0.2) +
  ylab('Per Recruit Quantity (scaled to max = 1)\n') +
  xlab('Fishing Mortality') +
  theme(legend.position = c(.82,.2))
dev.off()

ggplot(aes(F, value, color = Type)) + 
  geom_line() + 
  geom_point() +
  facet_wrap(~DMR) + 
  scico::scale_color_scico_d(palette = 'roma', begin = 0.2) +
  ylab('Per Recruit Quantity (scaled to max = 1)\n') +
  xlab('Fishing Mortality') +
  theme(legend.position = c(.8,.18))

# fig 3 ----

png(filename=here::here("figs", "recruits.png"), width = 6.5, height = 6.5,
    units = "in", type ="cairo", res = 200)

bind_rows(base$ts) %>% 
  filter(id == 'recr', grepl('0-1', scenario)) %>% 
  mutate(scenario = case_when(grepl('hist', scenario) ~ 'Historical',
                              grepl('rec', scenario) ~ 'Recent',
                              grepl('lohi', scenario) ~ 'Low to High',
                              grepl('hilo', scenario) ~ 'High to Low'),
         scenario = factor(scenario, levels = c('Historical', 'Recent', 'Low to High', 'High to Low'))) %>% 
  ggplot(aes(years, mean)) + 
  geom_ribbon(aes(ymin=min, ymax=max), alpha = 0.2) +
  geom_line() + 
  facet_wrap(~scenario) +
  afscassess::scale_x_tickr(data=base$ts$no_disc, var=years, to=10, start = 2020)  +
  expand_limits(y=0) +
  xlab('Year') +
  ylab('Recruitment')

dev.off()


# figure 4 ----
png(filename=here::here("figs", "hist.png"), width = 6.5, height = 6.5,
    units = "in", type ="cairo", res = 200)

bind_rows(base$ts) %>% 
  filter(scenario %in% c('hist-0-1' ,
                         'hist-12-3',
                         'hist-20-3',
                         'hist-35-3'),
         id != 'recr') %>% 
  mutate(scenario = case_when(scenario == 'hist-0-1' ~ 'Full Retention',
                              scenario == 'hist-12-3' ~ '12% DMR',
                              scenario == 'hist-20-3' ~ '20% DMR',
                              scenario == 'hist-35-3' ~ '35% DMR',
                              TRUE ~ scenario),
         median = ifelse(id == 'dead', mean, median),
         id = case_when(id == 'dead' ~ 'Dead discards',
                        id == 'ssb' ~ 'SSB',
                        id == 'rev' ~ 'Gross revenue',
                        id == 'dead_catch' ~ 'Landed catch'),
         id = factor(id, levels = c('SSB', 'Landed catch', 'Gross revenue', 'Dead discards'))) %>% 
  ggplot2::ggplot(ggplot2::aes(years, group = interaction(id, scenario, name), color = scenario, fill = scenario)) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = min, ymax = max), alpha = 0.15, color = NA) +
  ggplot2::geom_line(ggplot2::aes(y = median)) +
  afscassess::scale_x_tickr(data=base$ts$no_disc, var=years, to=10, start = 2020)  +
  facet_wrap(~id, scales = 'free_y') +
  scico::scale_color_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Base',
                                                                             'Hist_Recr_12%_DMR',
                                                                             'Hist_Recr_20%_DMR',
                                                                             'Hist_Recr_35%_DMR',
                                                                             'Full Retention',
                                                                             '12% DMR',
                                                                             '20% DMR',
                                                                             '35% DMR'),
                             guide = guide_legend(reverse = TRUE)) +
  scico::scale_fill_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Base',
                                                                            'Hist_Recr_12%_DMR',
                                                                            'Hist_Recr_20%_DMR',
                                                                            'Hist_Recr_35%_DMR',
                                                                            'Full Retention',
                                                                            '12% DMR',
                                                                            '20% DMR',
                                                                            '35% DMR' ),
                            guide = guide_legend(reverse = TRUE)) +
  expand_limits(y=0) +
  ylab("") +
  xlab("Year")
dev.off()

# fig 5 ----
png(filename=here::here("figs", "recent.png"), width = 6.5, height = 6.5,
    units = "in", type ="cairo", res = 200)

bind_rows(base$ts) %>%
  filter(scenario %in% c('rec-0-1' ,
                         'rec-12-3',
                         'rec-20-3',
                         'rec-35-3'),
         id != 'recr') %>% 
  mutate(scenario = case_when(scenario == 'rec-0-1' ~ 'Full Retention',
                              scenario == 'rec-12-3' ~ '12% DMR',
                              scenario == 'rec-20-3' ~ '20% DMR',
                              scenario == 'rec-35-3' ~ '35% DMR',
                              TRUE ~ scenario),
         median = ifelse(id == 'dead', mean, median),
         id = case_when(id == 'dead' ~ 'Dead discards',
                        id == 'ssb' ~ 'SSB',
                        id == 'rev' ~ 'Gross revenue',
                        id == 'dead_catch' ~ 'Landed catch'),
         id = factor(id, levels = c('SSB', 'Landed catch', 'Gross revenue', 'Dead discards'))) %>% 
  ggplot2::ggplot(ggplot2::aes(years, group = interaction(id, scenario, name), color = scenario, fill = scenario)) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = min, ymax = max), alpha = 0.15, color = NA) +
  ggplot2::geom_line(ggplot2::aes(y = median)) +
  afscassess::scale_x_tickr(data=base$ts$no_disc, var=years, to=10, start = 2020)  +
  facet_wrap(~id, scales = 'free_y') +
  scico::scale_color_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Base',
                                                                             'Hist_Recr_12%_DMR',
                                                                             'Hist_Recr_20%_DMR',
                                                                             'Hist_Recr_35%_DMR',
                                                                             'Full Retention',
                                                                             '12% DMR',
                                                                             '20% DMR',
                                                                             '35% DMR'),
                             guide = guide_legend(reverse = TRUE)) +
  scico::scale_fill_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Base',
                                                                            'Hist_Recr_12%_DMR',
                                                                            'Hist_Recr_20%_DMR',
                                                                            'Hist_Recr_35%_DMR',
                                                                            'Full Retention',
                                                                            '12% DMR',
                                                                            '20% DMR',
                                                                            '35% DMR' ),
                            guide = guide_legend(reverse = TRUE)) +
  expand_limits(y=0) +
  ylab("") +
  xlab("Year")
dev.off()

# fig 6 ----
png(filename=here::here("figs", "hilo.png"), width = 6.5, height = 6.5,
    units = "in", type ="cairo", res = 200)

bind_rows(base$ts) %>%
  filter(scenario %in% c('hilo-0-1' ,
                         'hilo-12-3',
                         'hilo-20-3',
                         'hilo-35-3'),
         id != 'recr') %>% 
  mutate(scenario = case_when(grepl('-0-1', scenario) ~ 'Full Retention',
                              grepl('-12-3', scenario) ~ '12% DMR',
                              grepl('-20-3', scenario) ~ '20% DMR',
                              grepl('-35-3', scenario) ~ '35% DMR',
                              TRUE ~ scenario),
         median = ifelse(id == 'dead', mean, median),
         id = case_when(id == 'dead' ~ 'Dead discards',
                        id == 'ssb' ~ 'SSB',
                        id == 'rev' ~ 'Gross revenue',
                        id == 'dead_catch' ~ 'Landed catch'),
         id = factor(id, levels = c('SSB', 'Landed catch', 'Gross revenue', 'Dead discards'))) %>% 
  ggplot2::ggplot(ggplot2::aes(years, group = interaction(id, scenario, name), color = scenario, fill = scenario)) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = min, ymax = max), alpha = 0.15, color = NA) +
  ggplot2::geom_line(ggplot2::aes(y = median)) +
  afscassess::scale_x_tickr(data=base$ts$no_disc, var=years, to=10, start = 2020)  +
  facet_wrap(~id, scales = 'free_y') +
  scico::scale_color_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Base',
                                                                             'Hist_Recr_12%_DMR',
                                                                             'Hist_Recr_20%_DMR',
                                                                             'Hist_Recr_35%_DMR',
                                                                             'Full Retention',
                                                                             '12% DMR',
                                                                             '20% DMR',
                                                                             '35% DMR'),
                             guide = guide_legend(reverse = TRUE)) +
  scico::scale_fill_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Base',
                                                                            'Hist_Recr_12%_DMR',
                                                                            'Hist_Recr_20%_DMR',
                                                                            'Hist_Recr_35%_DMR',
                                                                            'Full Retention',
                                                                            '12% DMR',
                                                                            '20% DMR',
                                                                            '35% DMR' ),
                            guide = guide_legend(reverse = TRUE)) +
  expand_limits(y=0) +
  ylab("") +
  xlab("Year")
dev.off()

# fig 7 ----
png(filename=here::here("figs", "lohi.png"), width = 6.5, height = 6.5,
    units = "in", type ="cairo", res = 200)

bind_rows(base$ts) %>%
  filter(scenario %in% c('lohi-0-1' ,
                         'lohi-12-3',
                         'lohi-20-3',
                         'lohi-35-3'),
         id != 'recr') %>% 
  mutate(scenario = case_when(grepl('-0-1', scenario) ~ 'Full Retention',
                              grepl('-12-3', scenario) ~ '12% DMR',
                              grepl('-20-3', scenario) ~ '20% DMR',
                              grepl('-35-3', scenario) ~ '35% DMR',
                              TRUE ~ scenario),
         median = ifelse(id == 'dead', mean, median),
         id = case_when(id == 'dead' ~ 'Dead discards',
                        id == 'ssb' ~ 'SSB',
                        id == 'rev' ~ 'Gross revenue',
                        id == 'dead_catch' ~ 'Landed catch'),
         id = factor(id, levels = c('SSB', 'Landed catch', 'Gross revenue', 'Dead discards'))) %>% 
  ggplot2::ggplot(ggplot2::aes(years, group = interaction(id, scenario, name), color = scenario, fill = scenario)) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = min, ymax = max), alpha = 0.15, color = NA) +
  ggplot2::geom_line(ggplot2::aes(y = median)) +
  afscassess::scale_x_tickr(data=base$ts$no_disc, var=years, to=10, start = 2020)  +
  facet_wrap(~id, scales = 'free_y') +
  scico::scale_color_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Base',
                                                                             'Hist_Recr_12%_DMR',
                                                                             'Hist_Recr_20%_DMR',
                                                                             'Hist_Recr_35%_DMR',
                                                                             'Full Retention',
                                                                             '12% DMR',
                                                                             '20% DMR',
                                                                             '35% DMR'),
                             guide = guide_legend(reverse = TRUE)) +
  scico::scale_fill_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Base',
                                                                            'Hist_Recr_12%_DMR',
                                                                            'Hist_Recr_20%_DMR',
                                                                            'Hist_Recr_35%_DMR',
                                                                            'Full Retention',
                                                                            '12% DMR',
                                                                            '20% DMR',
                                                                            '35% DMR' ),
                            guide = guide_legend(reverse = TRUE)) +
  expand_limits(y=0) +
  ylab("") +
  xlab("Year")
dev.off()

# fig 8 ----
png(filename=here::here("figs", "alt_retention.png"), width = 6.5, height = 6.5,
    units = "in", type ="cairo", res = 200)

bind_rows(bind_rows(base$ts), bind_rows(four$ts), bind_rows(five$ts), bind_rows(log$ts)) %>% 
  filter(id %in% c('ssb', 'dead_catch', 'rev', 'dead'),
         scenario %in% c('hist-0-1', 'hist-20-3', 'hist-20-4', 'hist-20-5', 'hist-20-3-log')) %>% 
  mutate(
    scenario = case_when(grepl('-0-1', scenario) ~ 'Full Retention',
                         grepl('-20-3-log', scenario) ~ 'Log',
                         grepl('-20-4', scenario) ~ 'Age 4',
                         grepl('-20-5', scenario) ~ 'Age 5',
                         grepl('-20-3', scenario) ~ 'Age 3',
                         TRUE ~ scenario),
    median = ifelse(id == 'dead', mean, median),
    id = case_when(id == 'dead' ~ 'Dead discards',
                   id == 'ssb' ~ 'SSB',
                   id == 'rev' ~ 'Gross revenue',
                   id == 'dead_catch' ~ 'Landed catch'),
    id = factor(id, levels = c('SSB', 'Landed catch', 'Gross revenue', 'Dead discards'))) %>% 
  ggplot2::ggplot(ggplot2::aes(years, group = interaction(id, scenario, name), color = scenario, fill = scenario)) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = min, ymax = max), alpha = 0.15, color = NA) +
  ggplot2::geom_line(ggplot2::aes(y = median)) +
  afscassess::scale_x_tickr(data=base$ts$no_disc, var=years, to=10, start = 2020)  +
  facet_wrap(~id, scales = 'free_y') +
  scico::scale_color_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Full Retention',
                                                                             'Age 3',
                                                                             'Age 4',
                                                                             'Age 5',
                                                                             'Log'), begin = 0.2) +
  scico::scale_fill_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Full Retention',
                                                                            'Age 3',
                                                                            'Age 4',
                                                                            'Age 5',
                                                                            'Log'), begin = 0.2) +
  ylab("") +
  expand_limits(y=0) +
  xlab("Year")
dev.off()

# fig 9 ----
png(filename=here::here("figs", "alt_price.png"), width = 6.5, height = 6.5,
    units = "in", type ="cairo", res = 200)

bind_rows(
  bind_rows(base$ts), 
  bind_rows(avg$ts), 
  bind_rows(var$ts),
  bind_rows(full_abc$ts),
  bind_rows(trwl_10$ts)
) %>% 
  filter(id %in% c('ssb', 'dead_catch', 'rev', 'dead'),
         scenario %in% c('hist-0-1', 'hist-20-3-full_abc', 'hist-20-3-trwl', 'hist-20-3-avg', 'hist-20-3-var', 'hist-20-3-trwl_10')) %>% 
  mutate(
    scenario = case_when(grepl('-0-1', scenario) ~ 'Full Retention',
                         grepl('-20-3-full_abc', scenario) ~ 'Full ABC',
                         grepl('-20-3-avg', scenario) ~ 'Average price',
                         grepl('-20-3-var', scenario) ~ 'Variable price',
                         # grepl('-20-3', scenario) ~ 'Age 3 (knife-edge)',
                         grepl('-20-3-trwl_10', scenario) ~ 'Trawl 10%',
                         TRUE ~ scenario),
    median = ifelse(id == 'dead', mean, median),
    id = case_when(id == 'dead' ~ 'Dead discards',
                   id == 'ssb' ~ 'SSB',
                   id == 'rev' ~ 'Gross revenue',
                   id == 'dead_catch' ~ 'Landed catch'),
    id = factor(id, levels = c('SSB', 'Landed catch', 'Gross revenue', 'Dead discards'))) %>% 
  ggplot2::ggplot(ggplot2::aes(years, group = interaction(id, scenario, name), color = scenario, fill = scenario)) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = min, ymax = max), alpha = 0.15, color = NA) +
  ggplot2::geom_line(ggplot2::aes(y = median)) +
  afscassess::scale_x_tickr(data=base$ts$no_disc, var=years, to=10, start = 2020)  +
  facet_wrap(~id, scales = 'free_y') +
  scico::scale_color_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Full Retention',
                                                                             'Age 3 (knife-edge)',
                                                                             'Average price',
                                                                             'Variable price',
                                                                             'Full ABC',
                                                                             'Trawl 10%'), begin = 0.2) +
  scico::scale_fill_scico_d(name = 'Scenario', palette = 'roma', breaks = c('Full Retention',
                                                                            'Age 3 (knife-edge)',
                                                                            'Average price',
                                                                            'Variable price',
                                                                            'Full ABC',
                                                                            'Trawl 10%'), begin = 0.2) +
  ylab("") +
  xlab("Year") +
  expand_limits(y=0)
dev.off()


