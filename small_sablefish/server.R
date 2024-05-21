library(dplyr)
library(tidyr)
library(ggplot2)
# library(afscassess)
library(scico)
library(vroom)
theme_report <- function (base_size = 18, base_family = "Times"){
  # windowsFonts(Times = windowsFont("TT Times New Roman"))
  half_line <- base_size/2
  ggplot2::theme_light(base_size = base_size, base_family = base_family) + 
    ggplot2::theme(panel.grid.major = ggplot2::element_blank(), 
                   panel.grid.minor = ggplot2::element_blank(), axis.ticks.length = grid::unit(half_line/2.2, 
                                                                                               "pt"), strip.background = ggplot2::element_rect(fill = NA, 
                                                                                                                                               colour = NA), strip.text.x = ggplot2::element_text(colour = "black"), 
                   strip.text.y = ggplot2::element_text(colour = "black"), 
                   panel.border = ggplot2::element_rect(fill = NA), 
                   legend.key.size = grid::unit(0.9, "lines"), legend.key = ggplot2::element_rect(colour = NA, 
                                                                                                  fill = NA), legend.background = ggplot2::element_rect(colour = NA, 
                                                                                                                                                        fill = NA))
}
theme_set(theme_report())
library(shiny)

base <- dplyr::bind_rows(readRDS('base.RDS')$ts)# 16
trwl_10 <- dplyr::bind_rows(readRDS('trwl_10.RDS')$ts) # 16
# reg_shift <- dplyr::bind_rows(readRDS(here::here('output', 'reg_shift.RDS'))$ts)
var <- dplyr::bind_rows(readRDS('var.RDS')$ts) # 16
avg <- dplyr::bind_rows(readRDS('avg.RDS')$ts) # 16
log <- dplyr::bind_rows(readRDS('log.RDS')$ts) # 12
full_abc <- dplyr::bind_rows(readRDS('full_abc.RDS')$ts) #16
cap <- dplyr::bind_rows(readRDS('cap.RDS')$ts)
cap_var <- dplyr::bind_rows(readRDS('cap_var.RDS')$ts)
hind_cap <- dplyr::bind_rows(readRDS('hind_cap.RDS')$ts)
hind_var <- dplyr::bind_rows(readRDS('hind_var.RDS')$ts)
four <- dplyr::bind_rows(readRDS('four.RDS')$ts) # 12
five <- dplyr::bind_rows(readRDS('five.RDS')$ts) #12


# input <- list(recr0 = c('hist', 'rec', 'lohi', 'hilo'),
#                     dmr0 = c(0,20),
#                     age = c(3,4,5, 'log'),
#                     price = c('base', 'avg', 'var'))
a = scico::scico(16, palette = 'roma')
b = scico::scico(16, palette = 'grayC', begin= 0, end = 0.5)
c = scico::scico(16, palette = 'vik', begin= 0.1, end = 0.3)
d = scico::scico(16, palette = 'hawaii')
# clrs = c(a[1], a[2], a[3], a[4],
#           b[1], b[2], b[3], b[4],
#           c[1], c[2], c[3], c[4],
#           d[1], d[2], d[3], d[4],
#          a[5], a[6], a[7], a[8],
#          b[5], b[6], b[7], b[8],
#          c[5], c[6], c[7], c[8],
#          d[5], d[6], d[7], d[8],
#          a[9], a[10], a[11], a[12],
#          b[9], b[10], b[11], b[12],
#          c[9], c[10], c[11], c[12],
#          d[9], d[10], d[11], d[12],
#          a[13], a[14], a[15], a[16],
#          b[13], b[14], b[15], b[16],
#          c[13], c[14], c[15], c[16],
#          d[13], d[14], d[15], d[16])

clrs = clr = c(a[1], d[2], b[3], c[4],
         b[1], c[2], d[3], a[4],
         c[1], d[2], a[3], b[4],
         d[1], b[2], c[3], a[4],
         a[5], d[6], b[7], c[8],
         b[5], c[6], d[7], a[8],
         c[5], d[6], a[7], b[8],
         d[5], b[6], c[7], a[8],
         a[9], d[10], b[11], c[12],
         b[9], c[10], d[11], a[12],
         c[9], d[10], a[11], b[12],
         d[9], a[10], b[11], c[12],
         a[13], d[14], b[15], c[16],
         b[13], c[14], d[15], a[16],
         c[13], d[14], a[15], b[16],
         d[13], a[14], b[15], c[16])
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
# Define server logic required to draw a histogram
function(input, output, session) {
  # code link 
  url <- a("GitHub", href="https://github.com/BenWilliams-NOAA/small_sablefish")
  output$tab <- renderUI({
    tagList("Code for these analyses are available at:", url)
  })
  
  
  # base input
  flt0 <- reactive({ 
    
    expand.grid(unique(input$recr0[1:4]), unique(input$dmr0[1:4]), stringsAsFactors=FALSE) %>%
      tidyr::drop_na() %>% 
      dplyr::mutate(Var3 = ifelse(Var2=='0', 1, 3),
                    flt = paste(Var1, Var2, Var3, sep = '-')) %>% 
      dplyr::pull(flt) 
    
    
  })
  
  dat0 <- reactive({
    bind_rows(base) %>% 
      dplyr::filter(scenario %in% flt0()) %>% 
      dplyr::mutate(median = ifelse(id == 'dead', mean, median))
  })
  
  # base input
  flt <- reactive({ 
    
    expand.grid(unique(input$recr[1:4]), unique(input$dmr[1:4]), unique(input$age[1:4]), stringsAsFactors=FALSE) %>%
      tidyr::drop_na() %>% 
      dplyr::filter(!(Var2==0 & Var3 %in% c('4', '5', 'log'))) %>% 
      dplyr::mutate(Var3 = dplyr::case_when(Var3=='log' ~ '3-log',
                                            Var3 == '3' & Var2=='0' ~'1',
                                            TRUE ~ Var3),
                    flt = paste(Var1, Var2, Var3, sep = '-')) %>% 
      dplyr::pull(flt) 
  
    
  })
  
  dat <- reactive({
    bind_rows(base, four, five, log) %>% 
      filter(scenario %in% flt()) %>% 
      dplyr::mutate(median = ifelse(id == 'dead', mean, median))
  })
  
  # price input
  fltp <- reactive({
    expand.grid(unique(input$recrp[1:4]), unique(input$dmrp[1:4]), unique(input$price[1:4]), stringsAsFactors=FALSE) %>% 
      tidyr::drop_na() %>% 
      dplyr::mutate(Var3 = dplyr::case_when(Var3=='base' & Var2== '0' ~ '1', 
                                            Var3=='avg' & Var2== '0' ~ '1-avg',
                                            Var3=='var' & Var2== '0' ~ '1-var',
                                            Var3=='avg' ~ '3-avg',
                                            Var3=='var' ~ '3-var',
                                            TRUE ~ '3'),
                    flt = paste(Var1, Var2, Var3, sep = '-')) %>% 
      dplyr::pull(flt)
      
      
  })
  
  datp <- reactive({
    bind_rows(base, avg, var) %>% 
      filter(scenario %in% fltp())  %>% 
      dplyr::mutate(median = ifelse(id == 'dead', mean, median))
  })
  
  # alt TAC input
  flta <- reactive({
    expand.grid(unique(input$recra[1:4]), unique(input$dmra[1:4]), unique(input$pricea[1:4]), stringsAsFactors=FALSE) %>% 
      tidyr::drop_na() %>% 
      dplyr::mutate(Var3 = dplyr::case_when(Var3=='base' & Var2== '0' ~ '1', 
                                            Var3=='trwl_10' & Var2== '0' ~ '1-trwl_10',
                                            Var3=='full_abc' & Var2== '0' ~ '1-full_abc',
                                            Var3=='trwl_10' ~ '3-trwl_10',
                                            Var3=='full_abc' ~ '3-full_abc',
                                            TRUE ~ '3'),
                    flt = paste(Var1, Var2, Var3, sep = '-')) %>% 
      dplyr::pull(flt)
    
    
  })
  
  data <- reactive({
    bind_rows(base, trwl_10, full_abc) %>% 
      filter(scenario %in% flta())  %>% 
      dplyr::mutate(median = ifelse(id == 'dead', mean, median))
  })
  
  # capped HCR input
  fltc <- reactive({
    expand.grid(unique(input$recrc[1:4]), unique(input$dmrc[1:4]), unique(input$cap[1:4]), stringsAsFactors=FALSE) %>% 
      tidyr::drop_na() %>% 
      dplyr::mutate(Var3 = dplyr::case_when(Var3=='base' & Var2== '0' ~ '1', 
                                            Var3=='cap' & Var2== '0' ~ '1-cap',
                                            Var3=='cap_var' & Var2== '0' ~ '1-cap_var',
                                            Var3=='cap' ~ '3-cap',
                                            Var3=='cap_var' ~ '3-cap_var',
                                            TRUE ~ '3'),
                    flt = paste(Var1, Var2, Var3, sep = '-')) %>% 
      dplyr::pull(flt)
    
    
  })
  
  datc <- reactive({
    bind_rows(base, cap, cap_var) %>% 
      filter(scenario %in% fltc())  %>% 
      dplyr::mutate(median = ifelse(id == 'dead', mean, median))
  })
  
  # hindcast
  flth <- reactive({
    expand.grid(unique(input$recrh[1:4]), unique(input$dmrh[1:4]), unique(input$hind[1:4]), stringsAsFactors=FALSE) %>% 
      tidyr::drop_na() %>% 
      dplyr::mutate(Var3 = dplyr::case_when(Var3=='base' & Var2== '0' ~ '1', 
                                            Var3=='hind_cap' & Var2== '0' ~ '1-hind_cap',
                                            Var3=='hind_var' & Var2== '0' ~ '1-hind_var',
                                            Var3=='hind_cap' ~ '3-hind_cap',
                                            Var3=='hind_var' ~ '3-hind_var',
                                            TRUE ~ '3'),
                    flt = paste(Var1, Var2, Var3, sep = '-')) %>% 
      dplyr::pull(flt)
    
    
  })
  
  dath <- reactive({
    bind_rows(base, hind_cap, hind_var) %>% 
      filter(scenario %in% flth())  %>% 
      dplyr::mutate(median = ifelse(id == 'dead', mean, median))
  })
  
  
  ranges <- reactiveValues(x = NULL, y = NULL)
  # base plots
  


  output$p01 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario)))
    plot_swath(dat0(), x = 'rev') + 
      xlab('Year') + 
      ylab('Revenue ($ millions)') + 
      # ylim(0,200) + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
    
  })
  observeEvent(input$plot01_dblclick, {
    brush <- input$plot01_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p02 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario)))
    plot_swath(dat0(), x = 'ssb') + 
      xlab('Year') + 
      ylab('SSB (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot02_dblclick, {
    brush <- input$plot02_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p03 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario)))
    plot_swath(dat0(), x = 'dead_catch') + 
      xlab('Year') +
      ylab('Landings (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot03_dblclick, {
    brush <- input$plot03_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p04 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario)))
    plot_swath(dat0(), x = 'bio') + 
      xlab('Year') + 
      ylab('Total Biomass (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot04_dblclick, {
    brush <- input$plot04_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p05 <- renderPlot({

    clr = setNames(clrs, c(unique(base$scenario)))
    plot_swath(dat0(), x = 'dead') + 
      xlab('Year') + 
      ylab('Dead discards (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot05_dblclick, {
    brush <- input$plot05_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$da0 <- renderTable({
    data.frame(id = flt0()) %>% 
      mutate(recruitment = stringr::word(flt0(), 1, sep = "\\-"),
             recruitment = case_when(recruitment == "hist" ~ 'historical',
                                     recruitment == "lohi" ~ 'low to hi',
                                     recruitment == "hilo" ~ 'high to low',
                                     recruitment == "rec" ~ 'recent'),
             dmr = stringr::word(flt0(), 2, sep = "\\-"),
             retention_age = stringr::word(flt0(), 3, sep = "\\-"))
    
  })
  # alt price plots
  
  output$p1 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(four$scenario), unique(five$scenario), unique(log$scenario)))
        plot_swath(dat(), x = 'rev') + 
          xlab('Year') + 
          ylab('Revenue ($ millions)') + 
          # ylim(0,200) + 
          scale_fill_manual(values = clr) +
          scale_color_manual(values = clr) +
        guides(fill=guide_legend(ncol = 2), 
               color=guide_legend(ncol = 2)) +
          coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
          
  })
  observeEvent(input$plot1_dblclick, {
    brush <- input$plot1_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p2 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(four$scenario), unique(five$scenario), unique(log$scenario)))
    plot_swath(dat(), x = 'ssb') + 
      xlab('Year') + 
      ylab('SSB (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot2_dblclick, {
    brush <- input$plot2_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p3 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(four$scenario), unique(five$scenario), unique(log$scenario)))
    plot_swath(dat(), x = 'dead_catch') + 
      xlab('Year') + 
      ylab('Landings (kt)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot3_dblclick, {
    brush <- input$plot3_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p4 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(four$scenario), unique(five$scenario), unique(log$scenario)))
    plot_swath(dat(), x = 'bio') + 
      xlab('Year') + 
      ylab('Total Biomass (kt)') + #ylim(0,1500) + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot4_dblclick, {
    brush <- input$plot4_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p5a <- renderPlot({
    
    clr = setNames(clrs, c(unique(base$scenario)))
    plot_swath(dat(), x = 'dead') + 
      xlab('Year') + 
      ylab('Dead discards (kt)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot5a_dblclick, {
    brush <- input$plot5a_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$da <- renderTable({
    data.frame(id = flt()) %>% 
      mutate(recruitment = stringr::word(flt(), 1, sep = "\\-"),
             recruitment = case_when(recruitment == "hist" ~ 'historical',
                                     recruitment == "lohi" ~ 'low to hi',
                                     recruitment == "hilo" ~ 'high to low',
                                     recruitment == "rec" ~ 'recent'),
             dmr = stringr::word(flt(), 2, sep = "\\-"),
             retention_age = stringr::word(flt(), 3, sep = "\\-"))
    
  })
  # alt price plots
  

  output$p5 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(avg$scenario), unique(var$scenario)))
    plot_swath(datp(), x = 'rev') + 
      xlab('Year') +
      ylab('Revenue ($ millions)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot5_dblclick, {
    brush <- input$plot5_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p6 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(avg$scenario), unique(var$scenario)))
    plot_swath(datp(), x = 'ssb') + 
      xlab('Year') + 
      ylab('SSB (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot6_dblclick, {
    brush <- input$plot6_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p7 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(avg$scenario), unique(var$scenario)))
    plot_swath(datp(), x = 'dead_catch') + 
      xlab('Year') + 
      ylab('Landings (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot7_dblclick, {
    brush <- input$plot7_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p8 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(avg$scenario), unique(var$scenario)))
    plot_swath(datp(), x = 'bio') + 
      xlab('Year') + 
      ylab('Total Biomass (kt)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot8_dblclick, {
    brush <- input$plot8_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p8a <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(avg$scenario), unique(var$scenario)))
    plot_swath(datp(), x = 'dead') + 
      xlab('Year') + 
      ylab('Dead discards (kt)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot8a_dblclick, {
    brush <- input$plot8a_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$dap <- renderTable({
    data.frame(id = fltp()) %>% 
      mutate(recruitment = stringr::word(fltp(), 1, sep = "\\-"),
             recruitment = case_when(recruitment == "hist" ~ 'historical',
                                     recruitment == "lohi" ~ 'low to hi',
                                     recruitment == "hilo" ~ 'high to low',
                                     recruitment == "rec" ~ 'recent'),
             dmr = stringr::word(fltp(), 2, sep = "\\-"),
             retention_age = stringr::word(fltp(), 3, sep = "\\-"),
             type = stringr::word(fltp(), 4, sep = "\\-"),
             type = case_when(is.na(type) ~ 'base',
                              type=='avg' ~ 'average price',
                              type=='var' ~ 'variable price'))
    
  })
  # alt TAC

  output$p9 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(trwl_10$scenario), unique(full_abc$scenario)))  
    plot_swath(data(), x = 'rev') + 
      xlab('Year') + 
      ylab('Revenue ($ millions)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot9_dblclick, {
    brush <- input$plot9_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
 
   output$p10 <- renderPlot({
     clr = setNames(clrs, c(unique(base$scenario), unique(trwl_10$scenario), unique(full_abc$scenario)))  
    plot_swath(data(), x = 'ssb') + 
      xlab('Year') + 
      ylab('SSB (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot10_dblclick, {
    brush <- input$plot10_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
 
   output$p11 <- renderPlot({
     clr = setNames(clrs, c(unique(base$scenario), unique(trwl_10$scenario), unique(full_abc$scenario)))  
    plot_swath(data(), x = 'dead_catch') + 
      xlab('Year') + 
      ylab('Landings (kt)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot11_dblclick, {
    brush <- input$plot11_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
 
   output$p12 <- renderPlot({
     clr = setNames(clrs, c(unique(base$scenario), unique(trwl_10$scenario), unique(full_abc$scenario)))  
    plot_swath(data(), x = 'bio') + 
      xlab('Year') + 
      ylab('Total Biomass (kt)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot12_dblclick, {
    brush <- input$plot12_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p12a <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(trwl_10$scenario), unique(full_abc$scenario)))  
    plot_swath(data(), x = 'dead') + 
      xlab('Year') + 
      ylab('Dead discards (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot12a_dblclick, {
    brush <- input$plot12a_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$daa <- renderTable({
    data.frame(id = flta()) %>% 
      mutate(recruitment = stringr::word(flta(), 1, sep = "\\-"),
             recruitment = case_when(recruitment == "hist" ~ 'historical',
                                     recruitment == "lohi" ~ 'low to hi',
                                     recruitment == "hilo" ~ 'high to low',
                                     recruitment == "rec" ~ 'recent'),
             dmr = stringr::word(flta(), 2, sep = "\\-"),
             retention_age = stringr::word(flta(), 3, sep = "\\-"))
    
  })
  # capped HCR

  output$p13 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(cap$scenario), unique(cap_var$scenario)))  
    plot_swath(datc(), x = 'rev') + 
      xlab('Year') + 
      ylab('Revenue ($ millions)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot13_dblclick, {
    brush <- input$plot13_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p14 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(cap$scenario), unique(cap_var$scenario)))  
    plot_swath(datc(), x = 'ssb') + 
      xlab('Year') + 
      ylab('SSB (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot14_dblclick, {
    brush <- input$plot14_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p15 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(cap$scenario), unique(cap_var$scenario)))  
    plot_swath(datc(), x = 'dead_catch') + 
      xlab('Year') + 
      ylab('Landings (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot15_dblclick, {
    brush <- input$plot15_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p16 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(cap$scenario), unique(cap_var$scenario)))  
    plot_swath(datc(), x = 'bio') +
      xlab('Year') + 
      ylab('Total Biomass (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot16_dblclick, {
    brush <- input$plot16_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p16a <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(cap$scenario), unique(cap_var$scenario)))  
    plot_swath(datc(), x = 'dead') + 
      xlab('Year') + 
      ylab('Dead discards (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot16a_dblclick, {
    brush <- input$plot16a_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$dac <- renderTable({
    data.frame(id = fltc()) %>% 
      mutate(recruitment = stringr::word(fltc(), 1, sep = "\\-"),
             recruitment = case_when(recruitment == "hist" ~ 'historical',
                                     recruitment == "lohi" ~ 'low to hi',
                                     recruitment == "hilo" ~ 'high to low',
                                     recruitment == "rec" ~ 'recent'),
             dmr = stringr::word(fltc(), 2, sep = "\\-"),
             retention_age = stringr::word(fltc(), 3, sep = "\\-"))
    
  })
  # hindcast 
 
  output$p17 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(hind_cap$scenario), unique(hind_var$scenario))) 
    plot_swath(dath(), x = 'rev') + 
      xlab('Year') + 
      ylab('Revenue ($ millions)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot17_dblclick, {
    brush <- input$plot17_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p18 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(hind_cap$scenario), unique(hind_var$scenario))) 
    plot_swath(dath(), x = 'ssb') + 
      xlab('Year') + 
      ylab('SSB (kt)') +
      guides(fill=guide_legend(ncol = 2), color=guide_legend(ncol = 2)) + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot18_dblclick, {
    brush <- input$plot18_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p19 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(hind_cap$scenario), unique(hind_var$scenario))) 
    plot_swath(dath(), x = 'dead_catch') + 
      xlab('Year') + 
      ylab('Landings (kt)') +
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot19_dblclick, {
    brush <- input$plot19_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p20 <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(hind_cap$scenario), unique(hind_var$scenario))) 
    plot_swath(dath(), x = 'bio') + 
      xlab('Year') + 
      ylab('Total Biomass (kt)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot20_dblclick, {
    brush <- input$plot20_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$p20a <- renderPlot({
    clr = setNames(clrs, c(unique(base$scenario), unique(hind_cap$scenario), unique(hind_var$scenario))) 
    plot_swath(dath(), x = 'dead') + 
      xlab('Year') + 
      ylab('Dead discards (kt)') + 
      scale_fill_manual(values = clr) +
      scale_color_manual(values = clr) +
      guides(fill=guide_legend(ncol = 2), 
             color=guide_legend(ncol = 2)) +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y, expand = FALSE)
  })
  observeEvent(input$plot20a_dblclick, {
    brush <- input$plot20a_brush
    if (!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$dah <- renderTable({
    data.frame(id = flth()) %>% 
      mutate(recruitment = stringr::word(flth(), 1, sep = "\\-"),
             recruitment = case_when(recruitment == "hist" ~ 'historical',
                                     recruitment == "lohi" ~ 'low to hi',
                                     recruitment == "hilo" ~ 'high to low',
                                     recruitment == "rec" ~ 'recent'),
             dmr = stringr::word(flth(), 2, sep = "\\-"),
             retention_age = stringr::word(flth(), 3, sep = "\\-"))
    
  })
}
