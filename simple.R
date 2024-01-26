#'easy' small sablefish
# duplicates code used in the shiny app, w/o all the shiny app nonsense
# notes: things that end in 'd' are discards, end in 0 is unfished, no suffix = full retention

# load ----
library(dplyr)
library(tidyr)
library(ggplot2)
library(tidytable)
theme_set(theme_bw())

# setup ----
# these values would come from the shiny user interface (ui)
disc_age = 3
dmr = 0.2
fish = 0.06 # ll fishing mort
fish_t = 0.02 # trawl fishing mort
grade12 = 0.64
grade23 = 1.29
grade34 = 1.84
grade45 = 2.63
grade57 = 5.49
grade7 = 6.73

# hard coded
age = 30
M = 0.113
meanpop = 6.5
sigr = 1.3

# ll selectivity - logistic, values from SAFE
slx_f = 1 / (1 + exp(-2.259144 * (1:age - 1.931495)) )
slx_m = 1 / (1 + exp(-0.6841568 * (1:age - 2.895402)) )

# trawl selectivity - dome
p = 0.5 * (sqrt(5.87167^2 + (4 * 10.29344^2)) - 5.87167)
slx_t_f = ( (1:age / 5.87167)^(5.87167/p)) * exp( (5.87167 - 1:age) / p )
p = 0.5 * (sqrt(8.205862^2 + (4 * 10.005304^2)) - 8.205862)
slx_t_m = ( (1:age / 8.205862)^(8.205862/p)) * exp( (8.205862 - 1:age) / p )

# weight (lbs) and maturity - values from SAFE
waaf = exp(log(5.87) + 3.02 * log(1 - exp(-0.17 * (1:age + 2.98)))) * 2.205
waam = exp(log(3.22) + 3.02 * log(1 - exp(-0.27 * (1:age + 2.41)))) * 2.205
maa = exp(-5.1560 + 0.7331 * 1:age) / (1 + exp(-5.1560 + 0.7331 * 1:age))

# exvessel
exf = case_when(waaf<=2.5 ~ grade12,
                waaf>2.5 & waaf<=3.5 ~ grade23,
                waaf>3.5 & waaf<=4.5 ~ grade34,
                waaf>4.5 & waaf<=5.5 ~ grade45,
                waaf>5.5 & waaf<=7.5 ~ grade57,
                TRUE ~ grade7)

exm = case_when(waam<=2.5 ~ grade12,
                waam>2.5 & waam<=3.5 ~ grade23,
                waam>3.5 & waam<=4.5 ~ grade34,
                waam>4.5 & waam<=5.5 ~ grade45,
                waam>5.5 & waam<=7.5 ~ grade57,
                TRUE ~ grade7)

# fishing mortality
# full retention
# longline fully selected F
ffd = ff = slx_f * fish 
fmd = fm = slx_m * fish

# discard Fs only adjust ages that are discarded
if(disc_age>0){
  for(i in 1:disc_age){
    ffd[i] = ff[i] * dmr
    fmd[i] = fm[i] * dmr
  }
}

# trawl fully select F
ftf = slx_t_f * fish_t
ftm = slx_t_m * fish_t

Zf = ff + ftf + M
Zm = fm + ftm + M

Zfd = ffd + ftf + M
Zmd = fmd + ftm + M

Sf = exp(-Zf)
Sm = exp(-Zm)

Sfd = exp(-Zfd)
Smd = exp(-Zmd)

# numbers at age ----
# initializing by taking number of ages and adding 50
# so assumes the discarding practices have been implemented prior to the population starting
# lognormal random recruits
n = matrix(c(rlnorm(50 + age, meanpop, sigr),
             rep(NA, (50 + age)* (age - 1))),
           nrow = age, byrow = TRUE)

# estimate the 1st column 
for(i in 2:age){
  n[i,1] = n[i-1,1] * exp(-M)
}

# all the natages start from the same n
nf = nf0 = nfd = nm = nm0 = nmd = n/2

for(i in 2:age){
  for(j in 2:(50 + age)){
    nf0[i,j] = nf0[i-1,j-1] * exp(-M) 
    nm0[i,j] = nm0[i-1,j-1] * exp(-M)
    nf[i,j] = nf[i-1,j-1] * Sf[i-1] 
    nm[i,j] = nm[i-1,j-1] * Sm[i-1]
    nfd[i,j] = nfd[i-1,j-1] * Sfd[i-1] 
    nmd[i,j] = nmd[i-1,j-1] * Smd[i-1]
  }
}
  
  # weight at age ----
  wtf = wtm = wtf0 = wtm0 = wtfd = wtmd = matrix(NA, ncol = age+50, nrow = age)
  
  for(j in 1:(age+50)){
    wtf0[,j] = nf0[,j] * waaf
    wtm0[,j] = nm0[,j] * waam
    wtf[,j] = nf[,j] * waaf
    wtm[,j] = nm[,j] * waam
    wtfd[,j] = nfd[,j] * waaf
    wtmd[,j] = nmd[,j] * waam
  }
  
  # value (total) at age ----
  vf = vm = vf0 = vm0 = vfd = vmd = matrix(NA, ncol = age+50, nrow = age)
  
  for(j in 1:(age+50)){
    vf0[,j] = nf0[,j] * exf
    vm0[,j] = nm0[,j] * exm
    vf[,j] = nf[,j] * exf
    vm[,j] = nm[,j] * exm
    vfd[,j] = nfd[,j] * exf
    vmd[,j] = nmd[,j] * exm
  }
  
  Ff = ff + ftf
  Zf = Zf
  Sf = Sf
  Fm = fm + ftm
  Zm = Zm
  Sm = Sm
  wf = wtf
  wm = wtm
  catch = matrix(NA, ncol = age+50, nrow = age)
  n = nf + nm
  for(i in 1:age){
    for(j in 1:(age+50)){
      catch[i,j] = (Ff[i]) / Zf[i] * wf[i,j] * (1.0 - Sf[i]) + (Fm[i]) / Zm[i] * wm[i,j] * (1.0 - Sm[i])
    }
  }
  
  # value of catch
  wtf = vf
  wtm = vm
  catch_value = matrix(NA, ncol = age+50, nrow = age)
  n = nf + nm
  for(i in 1:age){
    for(j in 1:(age+50)){
      catch_value[i,j] = (Ff[i]) / Zf[i] * wtf[i,j] * (1.0 - Sf[i]) + (Fm[i]) / Zm[i] * wtm[i,j] * (1.0 - Sm[i])
    }
  }
  
  Ff = ffd + ftf
  Zf = Zfd
  Sf = Sfd
  Fm = fmd + ftm
  Zm = Zmd
  Sm = Smd
  wf = wtfd
  wm = wtmd
  catchd = matrix(NA, ncol = age+50, nrow = age)
  for(i in 1:age){
    for(j in 1:(age+50)){
      catchd[i,j] = (Ff[i]) / Zf[i] * wf[i,j] * (1.0 - Sf[i]) + (Fm[i]) / Zm[i] * wm[i,j] * (1.0 - Sm[i])
    }
  }
  
  # value of catch
  wtf = vfd
  wtm = vmd
  catch_valued = matrix(NA, ncol = age+50, nrow = age)

  for(i in 1:age){
    for(j in 1:(age+50)){
      catch_valued[i,j] = (Ff[i]) / Zf[i] * wtf[i,j] * (1.0 - Sf[i]) + (Fm[i]) / Zm[i] * wtm[i,j] * (1.0 - Sm[i])
    }
  }

  # ssb
  ssb0 =  colSums(wtf0 * maa)[-c(1:age)]
  ssb = colSums(wtf * maa)[-c(1:age)]
  ssbd = colSums(wtfd * maa)[-c(1:age)]
  # total biomass
  tb0 =  colSums(wtf0 + wtm0)[-c(1:age)]
  tb = colSums(wtf + wtm)[-c(1:age)]
  tbd = colSums(wtfd + wtmd)[-c(1:age)]
  # total value
  tvf = colSums(vf)[-c(1:age)]
  tvm = colSums(vm)[-c(1:age)]
  tvfd = colSums(vfd)[-c(1:age)]
  tvmd = colSums(vmd)[-c(1:age)]
  
  # annual total catch 
  atc = colSums(catch)[-c(1:age)]
  atv = colSums(catch_value)[-c(1:age)]
  
  atcd = colSums(catchd)[-c(1:age)]
  atvd = colSums(catch_valued)[-c(1:age)]

  data.frame(year = 1:50,
             catch = atc,
             catchd = atcd,
             value = atv,
             valued = atvd) %>% 
    pivot_longer(-year) %>% 
    mutate(id = ifelse(grepl('ca', name), 'catch', 'value'),
           name = ifelse(grepl('d', name), 'discard', 'full retention')) -> dat

  dat %>% 
    ggplot(aes(year, value, color = name)) + 
    geom_line() + 
    expand_limits(y=0) +
    facet_wrap(~id)
  
