library(shiny)
library(dplyr)
library(ggplot2)
# remotes::install_github("BenWilliams-NOAA/afscassess)
library(afscassess)
theme_set(theme_report())


function(input, output, session) {

  # setup ----
  # setup
  age = 30
  M = 0.113
  meanpop = 6.5
  sigr = 1.3
  
  disc_age = reactive({input$disc_age})
  dmr = reactive({input$dmr})
  fish = reactive({input$fish})
  fish_t = reactive({input$fish_t})
  grade12 = reactive({input$grade12})
  grade23 = reactive({input$grade23})
  grade34 = reactive({input$grade34})
  grade45 = reactive({input$grade45})
  grade57 = reactive({input$grade57})
  grade7 = reactive({input$grade7})
  
  # ll selectivity
  slx_f = 1 / (1 + exp(-2.259144 * (1:age - 1.931495)) )
  slx_m = 1 / (1 + exp(-0.6841568 * (1:age - 2.895402)) )
  
  # trawl selectivity
  p = 0.5 * (sqrt(5.87167^2 + (4 * 10.29344^2)) - 5.87167)
  slx_t_f = ( (1:age / 5.87167)^(5.87167/p)) * exp( (5.87167 - 1:age) / p )
  p = 0.5 * (sqrt(8.205862^2 + (4 * 10.005304^2)) - 8.205862)
  slx_t_m = ( (1:age / 8.205862)^(8.205862/p)) * exp( (8.205862 - 1:age) / p )
  
  # weight (lbs) and maturity
  waaf = exp(log(5.87) + 3.02 * log(1 - exp(-0.17 * (1:age + 2.98)))) * 2.205
  waam = exp(log(3.22) + 3.02 * log(1 - exp(-0.27 * (1:age + 2.41)))) * 2.205
  maa = exp(-5.1560 + 0.7331 * 1:age) / (1 + exp(-5.1560 + 0.7331 * 1:age))
  
  # exvessel
  exf = reactive({
    case_when(waaf<=2.5 ~ grade12(),
              waaf>2.5 & waaf<=3.5 ~ grade23(),
              waaf>3.5 & waaf<=4.5 ~ grade34(),
              waaf>4.5 & waaf<=5.5 ~ grade45(),
              waaf>5.5 & waaf<=7.5 ~ grade57(),
              TRUE ~ grade7())
  })
  exm = reactive({
    case_when(waam<=2.5 ~ grade12(),
              waam>2.5 & waam<=3.5 ~ grade23(),
              waam>3.5 & waam<=4.5 ~ grade34(),
              waam>4.5 & waam<=5.5 ~ grade45(),
              waam>5.5 & waam<=7.5 ~ grade57(),
              TRUE ~ grade7())
  })
  
  # fishing mortality
  ff = reactive({slx_f * fish()}) 
  fm = reactive({slx_m * fish()})
  
  ftf = reactive({slx_t_f * fish_t()})
  ftm = reactive({slx_t_m * fish_t()})
  
  Zf = reactive({ff() + ftf() + M})
  Zm = reactive({fm() + ftm() + M})
  
  Sf = reactive({exp(-Zf())})
  Sm = reactive({exp(-Zm())})
  
  # discards
  ffd = reactive({
    df = ff()
    if(disc_age()>0){
      for(i in 1:disc_age()){
        df[i] = df[i] * dmr() 
      }
    }
    df
  })
  
  fmd = reactive({
    df = fm()
    if(disc_age()>0){
      for(i in 1:disc_age()){
        df[i] = df[i] * dmr() 
      }
    }
    df
  })
  Zfd = reactive({ffd() + ftf() + M})
  Zmd = reactive({fmd() + ftm() + M})
  
  Sfd = reactive({exp(-Zfd())})
  Smd = reactive({exp(-Zmd())})
  
  # initialize numbers at age ----
  n = matrix(c(rlnorm(50 + age, meanpop, sigr),
               rep(NA, (50 + age)* (age - 1))),
             nrow = age, byrow = TRUE)
  for(i in 2:age){
    n[i,1] = n[i-1,1] * exp(-M)
  }
  
  nf0 = nm0 = n/2
  
  for(i in 2:age){
    for(j in 2:(50 + age)){
      nf0[i,j] = nf0[i-1,j-1] * exp(-M) 
      nm0[i,j] = nm0[i-1,j-1] * exp(-M)
    }
  }
  
  nf = reactive({
    df = n/2
    S = Sf()
    for(i in 2:age){
      for(j in 2:(50 + age)){
        df[i,j] = df[i-1,j-1] * S[i-1] 
      }
    }
    df
  })
  
  nm = reactive({
    df = n/2
    S = Sm()
    for(i in 2:age){
      for(j in 2:(50 + age)){
        df[i,j] = df[i-1,j-1] * S[i-1] 
      }
    }
    df
  })
  
  nfd = reactive({
    df = n/2
    S = Sfd()
    for(i in 2:age){
      for(j in 2:(50 + age)){
        df[i,j] = df[i-1,j-1] * S[i-1] 
      }
    }
    df
  })
  
  nmd = reactive({
    df = n/2
    S = Smd()
    for(i in 2:age){
      for(j in 2:(50 + age)){
        df[i,j] = df[i-1,j-1] * S[i-1] 
      }
    }
    df
  })
  
  
  # weight ----
  wtf0 = wtm0 = matrix(NA, ncol = age+50, nrow = age)

    for(j in 1:(age+50)){
      wtf0[,j] = nf0[,j] * waaf
      wtm0[,j] = nm0[,j] * waam
    }

  wtf = reactive({
    df = matrix(NA, ncol = age+50, nrow = age)
    nf = nf()
    for(i in 1:age){
      for(j in 1:(age+50)){
        df[i,j] = nf[i,j] * waaf[i]
      }
    }
    df
  })

  wtm = reactive({
    df = matrix(NA, ncol = age+50, nrow = age)
    nm = nm()
    for(i in 1:age){
      for(j in 1:(age+50)){
        df[i,j] = nm[i,j] * waam[i]
      }
    }
    df
  })

  wtfd = reactive({
    df = matrix(NA, ncol = age+50, nrow = age)
    nfd = nfd()
    for(i in 1:age){
      for(j in 1:(age+50)){
        df[i,j] = nfd[i,j] * waaf[i]
      }
    }
    df
  })

  wtmd = reactive({
    df = matrix(NA, ncol = age+50, nrow = age)
    nmd = nmd()
    for(i in 1:age){
      for(j in 1:(age+50)){
        df[i,j] = nmd[i,j] * waam[i]
      }
    }
    df
  })

  # # value 
  vtf = reactive({
    df = matrix(NA, ncol = age+50, nrow = age)
    nf = nf()
    exf = exf()
    for(i in 1:age){
      for(j in 1:(age+50)){
        df[i,j] = nf[i,j] * exf[i]
      }
    }
    df
  })

  vtm = reactive({
    df = matrix(NA, ncol = age+50, nrow = age)
    nm = nm()
    exm = exm()
    for(i in 1:age){
      for(j in 1:(age+50)){
        df[i,j] = nm[i,j] * exm[i]
      }
    }
    df
  })

  vtfd = reactive({
    df = matrix(NA, ncol = age+50, nrow = age)
    nfd = nfd()
    exf = exf()
    for(i in 1:age){
      for(j in 1:(age+50)){
        df[i,j] = nfd[i,j] * exf[i]
      }
    }
    df
  })

  vtmd = reactive({
    df = matrix(NA, ncol = age+50, nrow = age)
    nmd = nmd()
    exm = exm()
    for(i in 1:age){
      for(j in 1:(age+50)){
        df[i,j] = nmd[i,j] * exm[i]
      }
    }
    df
  })
  # 
  # bio0 =  colSums(wtf0 + wtm0)
  # bio =  reactive({colSums(wtf() + wtm())})
  # biod =  reactive({colSums(wtfd() + wtmd())})
  # 
   ssb0 =  colSums(wtf0 * maa)[-c(1:age)]
   ssb = reactive({colSums(wtf() * maa)[-c(1:age)]})
   ssbd = reactive({colSums(wtfd() * maa)[-c(1:age)]})
   
   tb0 =  colSums(wtf0 + wtm0)[-c(1:age)]
   tb = reactive({colSums(wtf() + wtm())[-c(1:age)]})
   tbd = reactive({colSums(wtfd() + wtmd())[-c(1:age)]})
  # 
   tvtf = reactive({colSums(vtf())[-c(1:age)]})
   tvtm = reactive({colSums(wtm())[-c(1:age)]})
   tvtfd = reactive({colSums(vtfd())[-c(1:age)]})
   tvtmd = reactive({colSums(vtmd())[-c(1:age)]})
  
  catch = reactive({
    Ff = ff() + ftf()
    Zf = Zf()
    Sf = Sf()
    Fm = fm() + ftm()
    Zm = Zm()
    Sm = Sm()
    wtf = vtf()
    wtm = vtm()
    df = matrix(NA, ncol = age+50, nrow = age)
    n = nf()
    for(i in 1:age){
      for(j in 1:(age+50)){
        df[i,j] = (Ff[i]) / Zf[i] * wtf[i,j] * (1.0 - Sf[i]) + (Fm[i]) / Zm[i] * wtm[i,j] * (1.0 - Sm[i])
      }
    }
    df
  })
  
  catchd = reactive({
    Ff = ffd() + ftf()
    Zf = Zfd()
    Sf = Sfd()
    Fm = fmd() + ftm()
    Zm = Zmd()
    Sm = Smd()
    wtf = vtfd()
    wtm = vtmd()
    df = matrix(NA, ncol = age+50, nrow = age)
    n = nfd()
    for(i in 1:age){
      for(j in 1:(age+50)){
        df[i,j] = (Ff[i]) / Zf[i] * wtf[i,j] * (1.0 - Sf[i]) + (Fm[i]) / Zm[i] * wtm[i,j] * (1.0 - Sm[i])
      }
    }
    df
  })
   
  # catch = reactive({
  #   (ff() + ftf()) / Zf() * wtf() * (1.0 - Sf()) + (fm() + ftm()) / Zm() * wtm() * (1.0 - Sm())
  # })
  # catchd =  reactive({
  #   (ffd() + ftf()) / Zfd() * wtfd() * (1.0 - Sfd()) + (fmd() + ftm()) / Zmd() * wtmd() * (1.0 - Smd())
  # })
  # 
  # rev = reactive({
  #   (ff() + ftf()) / Zf() * vtf() * (1.0 - Sf()) + (fm() + ftm()) / Zm() * vtm() * (1.0 - Sm())
  # })
  # revd =  reactive({
  #   (ffd() + ftf()) / Zfd() * vtfd() * (1.0 - Sfd()) + (fmd() + ftm()) / Zmd() * vtmd() * (1.0 - Smd())
  # })
  # 
  # exv = reactive({colSums(rev())[-c(1:age)]})
  # exvd = reactive({colSums(revd())[-c(1:age)]})
  # 
  # pop0 =  nf0 + nm0
  # pop =  reactive({nf() + nm()})
  # popd =  reactive({nfd() + nmd()})
  
  revs = reactive({colSums(catch())[-c(1:age)]})
  revsd = reactive({colSums(catchd())[-c(1:age)]})

  output$pop0Plot <- renderPlot({
    data.frame(nf0 + nm0, id = "no fishing") %>%
      tidytable::bind_rows(data.frame(nf() + nm(), id = "full retention")) %>%
      tidytable::bind_rows(data.frame(nfd() + nmd(), id = "discards")) %>%
      tidytable::mutate(age = rep(1:age, 3)) %>%
      tidytable::pivot_longer(cols = dplyr::starts_with("X"),
                              names_to = "year") %>%
      tidytable::mutate(year = as.numeric(substring(year,2)),
                        year = year + age) %>%
      tidytable::filter(value > -1, year %in% max(age):(max(age) + 49)) %>%
      tidytable::mutate(year = year - max(age) + 1) %>% 
      ggplot2::ggplot(ggplot2::aes(year, age, size = value)) +
      ggplot2::geom_point(alpha = 0.5) +
      ggplot2::scale_size_area() +
      xlab("Year") +
      ylab("Age") +
      facet_wrap(~id)
  })
  
  output$totPlot <- renderPlot({
    
    data.frame(ssb = tb(), id = 'full retention') %>%
      tidytable::bind_rows(data.frame(ssb = tbd(), id = "discard")) %>%
      tidytable::bind_rows(data.frame(ssb =tb0, id = "no fishing")) %>%
      tidytable::mutate(year = rep(1:50, 3)) %>%
      ggplot(aes(year, ssb, color = id)) +
      geom_line() +
      expand_limits(y = 0) +
      ylab('Total biomass')
    # 
  })
  output$ssbPlot <- renderPlot({
    
    # data.frame(ssb(), id = 'full retention') %>%
    #   tidytable::bind_rows(data.frame(ssb0, id = id = "no fishing")) %>%
    #   tidytable::bind_rows(data.frame(ssbd(), id = "discard")) %>%
    #   tidytable::mutate(age = rep(1:age, 3)) %>%
    #   tidytable::pivot_longer(cols = dplyr::starts_with("X"),
    #                           names_to = "year") %>%
    #   tidytable::mutate(year = as.numeric(substring(year,2)),
    #                     year = year + age) %>%
    #   tidytable::filter(value > -1, year %in% max(age):(max(age) + 49)) %>%
    #   tidytable::mutate(year = year - max(age) + 1) %>%
    #   tidytable::summarise(value = sum(value), .by = c(year, id)) %>% 
    #   ggplot(aes(year, value, color = id)) + 
    #   geom_point()
    
    
    # # generate bins based on input$bins from ui.R
    data.frame(ssb = ssb(), id = 'full retention') %>%
      tidytable::bind_rows(data.frame(ssb = ssbd(), id = "discard")) %>%
      tidytable::bind_rows(data.frame(ssb = ssb0, id = "no fishing")) %>%
      tidytable::mutate(year = rep(1:50, 3)) %>%
      ggplot(aes(year, ssb, color = id)) +
      geom_line() +
      expand_limits(y = 0) +
      ylab('SSB')
    # 
  })
  
  output$revPlot <- renderPlot({

   
        # generate bins based on input$bins from ui.R
    data.frame(ssb = scale(revs()), id = 'full retention') %>%
         tidytable::bind_rows(data.frame(ssb = scale(revsd()), id = "discard")) %>%
         tidytable::mutate(year = rep(1:50, 2)) %>%
      ggplot(aes(year, ssb, color = id)) +
      geom_line() +
      expand_limits(y = 0) +
      ylab('Relative revenue')
    # 
    })

}
