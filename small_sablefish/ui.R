shinyUI(fluidPage(
  navbarPage("Small sablefish simulations",
             navbarMenu("Background",
                        tabPanel('Descriptions',
                                 mainPanel(p("This app illustrates the results of an Acceptable Biological Catch (ABC) projection model that was adapted to address the potential implications of a North Pacific Fisheries Management Council (NPFMC) proposed action that would remove the regulatory prohibition on discarding sablefish in the Alaska fixed gear sablefish fishery. 
                                             The action is intended to provide limited flexibility to fixed gear sablefish participants who encounter catches of small, low-value fish as recent large year classes of sablefish recruit to the fishery. 
                                             The action would provide for voluntary release of sablefish under 22 inch total body length."),
                                             br(),
                                             p("To explore the potential implications of the small sablefish action, the simulation framework for projecting Acceptable Biological Catch (ABC) for Alaska sablefish was adapted to allow for fishery discarding. 
Specifically, an age-based retention function and discard mortality rate (DMR) were integrated into the sex- and age-based projection module and associated F40% calculations. 
A variety of scenarios were then developed assuming full retention or discarding with a 22 inch total length minimum size limit, which was assumed equivalent to discarding only age-2 fish (i.e., by using a knife-edge retention function where no fish of age-2 are retained and all fish age-3 and older are retained). 
Three DMRs were implemented (12%, 20%, and 35%) based on recommendations provided by the SSC at their February 2024 meeting. 
Projections were carried out for 50 years and important performance metrics (e.g., SSB, landed catch, gross revenue, and dead discards) were calculated and compared across scenarios. 
Sensitivity runs were also conducted (e.g., alternate recruitment, retention, and future price scenarios) to address SSC concerns. 
The full methods for conducting these analyses as well a description of each scenario can be found in the associated documentation", tags$a(href="https://meetings.npfmc.org/Meeting/Details/3046", "(C4 Small Sablefish Release – Initial Review)."), 
"The inputs for the projections (e.g., biological and fishery inputs) were taken from the", tags$a(href="https://www.npfmc.org/wp-content/PDFdocuments/SAFE/2023/sablefish.pdf", "2023 sablefish SAFE."),""),
br(),
p("
The purpose of this app is to allow interactive exploration and more in-depth analysis of the results for SSC members, the NPFMC, and any interested stakeholders. 
The app allows for ease of comparison among the range of scenarios explored, enables closer examination through the zoom functionality, and provides a wider range of scenarios to be illustrated than could be provided in a single document.
Under the ‘Scenarios’ tab, there are 6 different groups of scenarios that can be explored. 
The ‘SSC Main Scenarios’ tab represent those that were explicitly requested and reviewed by the NPFMC Science and Statistical Committee. 
The remaining tabs include a mixture of sensitivity scenarios, some of which were included in the SSC review and others that were not (these are provided on an informational basis only)."),
br(),

"Scenario Tabs:",
br(),
p(tags$li(tags$b("SSC Main Scenarios:"), "These are the main scenarios used, reviewed, and requested by the NPFMC SSC to better understand the potential implications of the proposed motion."),
tags$li(tags$b("Alternative Retention:"), "These scenarios illustrate the impacts of increasing the age of retention, including a logistic retention scenario that allows for low retention at age-2 and high, but <100%, retention at ages 3 and 4."),
tags$li(tags$b("Price Scenarios:"), "These scenarios utilize a different price structure, including average price and a variable price where the price is inversely proportional to landings (i.e., higher landings lead to lower prices, which is meant to mimic market saturation, and lower landings lead to higher prices)."),
tags$li(tags$b("Alternative Catch:"), "The ‘Full ABC’ scenario demonstrates the impact of taking 100% of the ABC, given that all other scenarios assume specified catch where only 66% of the ABC is utilized (based on the recent ABC utilization percentage); the ‘10% Trawl’ scenario decreases the proportion of the catch taken by the trawl fleet to better align with long-term average removals among fleets."),
tags$li(tags$b("Capped Harvest Control Rule:"), "These scenarios implement a total landings cap of 15kt, which illustrates the impacts on limiting fishery removals; this is not meant as a potential option for sablefish, but simply illustrates an alternative to a maximum ABC strategy using the F40% HCR."),
tags$li(tags$b("Hindcast:"), "These runs start in 2017 and utilize the actual estimated recruitment from 2017-2023 to demonstrate how the metrics may have differed if discarding had been allowed starting at that time; two version of the hindcast are provide, the full ABC utilization and a capped HCR, both of which assume the variable price structure.")),
br(),
tags$b("Instructions"),
br(),
p("
  After clicking on a given", tags$i('Scenario'), "tab, the user can than choose (by clicking the associated check box) among a variety of alternate scenarios that they wish to graph and compare. 
For each tab, all of the scenarios originally requested by the SSC", tags$i('SSC Main Scenarios'), "are provided, which included the 4 future recruitment scenarios (Historical, Recent, Low-High, High-Low), the 2 retention scenarios (Full Retention vs. Discarding of Age-2 fish only), and the 3 discard mortality rates (12%, 20%, and 35%). 
A different selection of sensitivity scenarios can then also be clicked under each tab. 
Once the scenarios to be plotted have been chosen, they will appear in the figures and identified by the different colored lines and described by the figure caption and associated scenario table (under the figure). 
There will be 5 tabs above the figure, each of which can be clicked to demonstrate a different performance metric (i.e., Gross Revenue for the fixed gear fleet, Spawning Stock Biomass, Total Dead Catch, Total Biomass, and Dead Discards). 
A zoom feature allows the user to draw a box around a specific region of each graph and double click to zoom to that area. 
Just double click the figure again to reset the view.
Gross revenue was calculated by assigning a sablefish of a given age and sex to a price grade, multiplying the weight of fish at each age by the given price per kg, and summing across ages to get total gross revenue. 
Recent price grade information (Table 3 of COuncil document) was used and all main scenarios assumed constant price for future years equivalent to the 2023 prices. 
Alternate price scenarios assumed either the 2015-2023 average prices or that price was inversely proportional to landings."))), 

br(),

tabPanel('Retention and Selectivity',
         mainPanel(
           "The input retention-at-age for the fixed gear fleet and selectivity-at-age for the fixed gear and trawl fleets by sex. 
           The knife-edge retention curve at age-3 (left panel, red line) was used for the main scenarios (except when full retention was assumed). 
           The other retention curves were used for the various retention sensitivity scenarios.", 
           img(src='retention.png', height="100%", width="100%", align = "center"))),
                        tabPanel('Disclaimer',
                                 mainPanel('This work is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. 
                                           All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. 
                                           Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. 
                                           Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. 
                                           The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.',
                                           br(),br(),
                                           

'NOAA License',
br(),
'Software code created by U.S. Government employees is not subject to copyright in the United States (17 U.S.C. §105). 
The United States/Department of Commerce reserve all rights to seek and obtain copyright protection in countries other than the United States for Software authored in its entirety by the Department of Commerce. 
To this end, the Department of Commerce hereby grants to Recipient a royalty-free, nonexclusive license to use, copy, and create derivative works of the Software outside of the United States.',
br(),
br(),
'Simulations completed by Dan Goethel (dan.goethel@noaa.gov)',
br(),
'Shiny application completed by Ben Williams (ben.williams@noaa.gov)',
br(),
uiOutput("tab")
))),


tabPanel('SSC Main Scenarios', fluid = TRUE,
         sidebarLayout(
           sidebarPanel(
             column(8, 
                    fluidRow(
                      HTML("<style> #show_values {height: 20px; width: 20px;} </style>"),
                      HTML('<div style="position: relative; top: -15px; left: 30px;">'),
                      HTML('<h4> Main Scenarios requested by SSC</h4>'),
                      HTML("</div>")
                      
                    ), # fluidRow
                    checkboxGroupInput('recr0', 'Recruitment Type:',
                                       c('Historical' = 'hist',
                                         'Recent' = 'rec',
                                         'Low to High' = 'lohi',
                                         'High to Low' = 'hilo'),
                                       selected = 'hist'
                    ),
                    checkboxGroupInput('dmr0', 'Discard Mortality Rate (DMR):',
                                       c('Full retention' = '0',
                                         '12%' = '12',
                                         '20%' = '20',
                                         '35%' = '35'),
                                       selected = '0')
                    
             )
           ),
           mainPanel(
             tabsetPanel(
               p(br(),
                 ("These are the main scenarios used, reviewed, and requested by the NPFMC SSC to better understand the potential implications of the proposed motion.")),
               tabPanel('Revenue', class = "well", plotOutput("p01",
                                                              dblclick = "plot01_dblclick",
                                                              brush = brushOpts(
                                                                id = "plot01_brush",
                                                                resetOnNew = TRUE
                                                              ))),
               tabPanel('SSB', class = "well", plotOutput("p02",
                                                          dblclick = "plot02_dblclick",
                                                          brush = brushOpts(
                                                            id = "plot02_brush",
                                                            resetOnNew = TRUE
                                                          ))),
               tabPanel('Catch', class = "well", plotOutput("p03",
                                                            dblclick = "plot03_dblclick",
                                                            brush = brushOpts(
                                                              id = "plot03_brush",
                                                              resetOnNew = TRUE
                                                            ))),
               tabPanel('Total Biomass', class = "well", plotOutput("p04",
                                                                    dblclick = "plot04_dblclick",
                                                                    brush = brushOpts(
                                                                      id = "plot04_brush",
                                                                      resetOnNew = TRUE
                                                                    ))),
               tabPanel('Dead Discards', class = "well", plotOutput("p05",
                                                                    dblclick = "plot05_dblclick",
                                                                    brush = brushOpts(
                                                                      id = "plot05_brush",
                                                                      resetOnNew = TRUE
                                                                    ))),
               tabPanel('Per-Recruit', class = "well", p('Revenue-per-recruit (RPR), spawning stock biomass-per-recruit (SSBR), and yield-per-recruit (YPR) for each of the base discard mortality rate scenarios, including full retention, assuming knife-edge retention starting at age-3. The location of the fishing mortality that maximized yield-per-recruit (i.e., FMAX) varied by less than 7% (i.e., range of 0.43 to 0.46). 
                                                         Revenue-per-recruit is maximized at a lower fishing mortality (~0.15). F40% was ~0.086 with slight variability depending on the discard scenario.
                                                         *Note that these figures are fixed and will not change if the inputs are changed.'),
                        img(src='pr.png', height="100%", width="100%", align = "center"))
             ),
             tableOutput('da0'),
           )
         )
         # )
         
),
             tabPanel('Alternative Retention', fluid = TRUE,
                      sidebarLayout(
                        sidebarPanel(
                          column(8, 
                                 fluidRow(
                                   HTML("<style> #show_values {height: 20px; width: 20px;} </style>"),
                                         HTML('<div style="position: relative; top: -15px; left: 30px;">'),
                                   HTML('<h4> Alternative Retention Scenarios</h4>'),
                                   HTML("</div>")
                                   
                                 ), # fluidRow
                                 checkboxGroupInput('recr', 'Recruitment Type:',
                                                    c('Historical' = 'hist',
                                                      'Recent' = 'rec',
                                                      'Low to High' = 'lohi',
                                                      'High to Low' = 'hilo'),
                                                    selected = 'hist'
                                 ),
                                 checkboxGroupInput('dmr', 'Discard Mortality Rate (DMR):',
                                                    c('Full retention' = '0',
                                                      '12%' = '12',
                                                      '20%' = '20',
                                                      '35%' = '35'),
                                                    selected = '0'),
                                 checkboxGroupInput('age', 'Discard age:',
                                                    c('SSC Main' = '3',
                                                      'Age-4 (knife-edge)' = '4',
                                                      'Age-5 (knife-edge)' = '5',
                                                      'Logistic' = 'log'),
                                                    selected = '3')
                                
                          )
                        ),
                        mainPanel(
                          tabsetPanel(
                            p(br(),
                              ("These scenarios illustrate the impacts of increasing the age of retention, including a logistic retention scenario that allows for low retention at age-2 and high, but <100%, retention at ages 3 and 4.")),
                            tabPanel('Revenue', class = "well", plotOutput("p1",
                                                           dblclick = "plot1_dblclick",
                                                           brush = brushOpts(
                                                             id = "plot1_brush",
                                                             resetOnNew = TRUE
                                                           ))),
                            tabPanel('SSB', class = "well", plotOutput("p2",
                                                                       dblclick = "plot2_dblclick",
                                                                       brush = brushOpts(
                                                                         id = "plot2_brush",
                                                                         resetOnNew = TRUE
                                                                       ))),
                            tabPanel('Catch', class = "well", plotOutput("p3",
                                                                         dblclick = "plot3_dblclick",
                                                                         brush = brushOpts(
                                                                           id = "plot3_brush",
                                                                           resetOnNew = TRUE
                                                                         ))),
                            tabPanel('Total Biomass', class = "well", plotOutput("p4",
                                                                                 dblclick = "plot4_dblclick",
                                                                                 brush = brushOpts(
                                                                                   id = "plot4_brush",
                                                                                   resetOnNew = TRUE
                                                                                 ))),
                            tabPanel('Dead Discards', class = "well", plotOutput("p5a",
                                                                                 dblclick = "plot5a_dblclick",
                                                                                 brush = brushOpts(
                                                                                   id = "plot5_brush",
                                                                                   resetOnNew = TRUE
                                                                                 ))),
                          ),
                          tableOutput('da'),
                        )
                      )
                      # )
                      
             ),
             # navbarMenu("Price scenarios",
             tabPanel('Price scenarios', fluid = TRUE,
                      sidebarLayout( 
                        sidebarPanel(
                          column(8, 
                                 fluidRow(
                                   HTML("<style> #show_values {height: 20px; width: 20px;} </style>"),
                                   HTML('<div style="position: relative; top: -15px; left: 30px;">'),
                                   HTML('<h4> Alternate Price Scenarios</h4>'),
                                   HTML("</div>")
                                   
                                 ), # fluidRow
                                 checkboxGroupInput('recrp', 'Recruitment Type:',
                                                    c('Historical' = 'hist',
                                                      'Recent' = 'rec',
                                                      'Low to High' = 'lohi',
                                                      'High to Low' = 'hilo'),
                                                    selected = 'hist'
                                 ),
                                 checkboxGroupInput('dmrp', 'Discard Mortality Rate (DMR):',
                                                    c('Full retention' = '0',
                                                      '12%' = '12',
                                                      '20%' = '20',
                                                      '35%' = '35'),
                                                    selected = '0'),
                                 checkboxGroupInput('price', 'Scenario:',
                                                    c('SSC Main' = 'base', 
                                                      'Average Price' = 'avg',
                                                      'Variable Price' = 'var'),
                                                    selected = 'base')
                          )
                        ),
                        mainPanel(
                          tabsetPanel(
                            p(br(),
                              ("These scenarios utilize a different price structure, including average price and a variable price where the price is inversely proportional to landings (i.e., higher landings lead to lower prices, which is meant to mimic market saturation, and lower landings lead to higher prices)")),
                            tabPanel('Revenue', class = "well", plotOutput("p5",
                                                                           dblclick = "plot5_dblclick",
                                                                           brush = brushOpts(
                                                                             id = "plot5_brush",
                                                                             resetOnNew = TRUE
                                                                           ))),
                            tabPanel('SSB', class = "well", plotOutput("p6",
                                                                       dblclick = "plot6_dblclick",
                                                                       brush = brushOpts(
                                                                         id = "plot6_brush",
                                                                         resetOnNew = TRUE
                                                                       ))),
                            tabPanel('Catch', class = "well", plotOutput("p7",
                                                                         dblclick = "plot7_dblclick",
                                                                         brush = brushOpts(
                                                                           id = "plot7_brush",
                                                                           resetOnNew = TRUE
                                                                         ))),
                            tabPanel('Total Biomass', class = "well", plotOutput("p8",
                                                                                 dblclick = "plot8_dblclick",
                                                                                 brush = brushOpts(
                                                                                   id = "plot8_brush",
                                                                                   resetOnNew = TRUE
                                                                                 ))),
                            tabPanel('Dead Discards', class = "well", plotOutput("p8a",
                                                                                 dblclick = "plot8a_dblclick",
                                                                                 brush = brushOpts(
                                                                                   id = "plot8a_brush",
                                                                                   resetOnNew = TRUE
                                                                                 )))
                          ) ,
                          tableOutput('dap'),
                          
                        )
                      )
             ),
             # navbarMenu("Price scenarios",
             tabPanel('Alternative Catch', fluid = TRUE,
                      sidebarLayout( 
                        sidebarPanel(
                          column(8, 
                                 fluidRow(
                                   HTML("<style> #show_values {height: 20px; width: 20px;} </style>"),
                                   HTML('<div style="position: relative; top: -15px; left: 30px;">'),
                                   HTML('<h4> Alternate Catch Scenarios</h4>'),
                                   HTML("</div>")
                                   
                                 ), # fluidRow
                                 
                                 checkboxGroupInput('recra', 'Recruitment Type:',
                                                    c('Historical' = 'hist',
                                                      'Recent' = 'rec',
                                                      'Low to High' = 'lohi',
                                                      'High to Low' = 'hilo'),
                                                    selected = 'hist'
                                 ),
                                 checkboxGroupInput('dmra', 'Discard Mortality Rate (DMR):',
                                                    c('Full retention' = '0',
                                                      '12%' = '12',
                                                      '20%' = '20',
                                                      '35%' = '35'),
                                                    selected = '0'),
                                 checkboxGroupInput('pricea', 'Scenario:',
                                                    c('SSC Main' = 'base', 
                                                      '10% Trawl Catch' = 'trwl_10',
                                                      'Full ABC Caught' = 'full_abc'),
                                                    selected = 'base')
                          )
                        ),
                        mainPanel(
                          tabsetPanel(
                            p(br(),
                            ("The ‘Full ABC’ scenario demonstrates the impact of taking 100% of the ABC, given that all other scenarios assume specified catch where only 66% of the ABC is utilized (based on the recent ABC utilization percentage); the ‘10% Trawl’ scenario decreases the proportion of the catch taken by the trawl fleet to better align with long-term average removals among fleets.")),
                            tabPanel('Revenue', class = "well", plotOutput("p9",
                                                                           dblclick = "plot9_dblclick",
                                                                           brush = brushOpts(
                                                                             id = "plot9_brush",
                                                                             resetOnNew = TRUE
                                                                           ))),
                            tabPanel('SSB', class = "well", plotOutput("p10",
                                                                       dblclick = "plot10_dblclick",
                                                                       brush = brushOpts(
                                                                         id = "plot10_brush",
                                                                         resetOnNew = TRUE
                                                                       ))),
                            tabPanel('Catch', class = "well", plotOutput("p11",
                                                                         dblclick = "plot11_dblclick",
                                                                         brush = brushOpts(
                                                                           id = "plot11_brush",
                                                                           resetOnNew = TRUE
                                                                         ))),
                            tabPanel('Total Biomass', class = "well", plotOutput("p12",
                                                                                 dblclick = "plot12_dblclick",
                                                                                 brush = brushOpts(
                                                                                   id = "plot12_brush",
                                                                                   resetOnNew = TRUE
                                                                                 ))),
                            tabPanel('Dead Discards', class = "well", plotOutput("p12a",
                                                                                 dblclick = "plot12a_dblclick",
                                                                                 brush = brushOpts(
                                                                                   id = "plot12a_brush",
                                                                                   resetOnNew = TRUE
                                                                                 )))
                          ) ,
                          tableOutput('daa')
                          
                        )
                      )
             ),
             # navbarMenu("cap",
             tabPanel('Capped Harvest Control Rules (HCR)', fluid = TRUE,
                      sidebarLayout( 
                        sidebarPanel(
                          column(8, 
                                 fluidRow(
                                   HTML("<style> #show_values {height: 20px; width: 20px;} </style>"),
                                   HTML('<div style="position: relative; top: -15px; left: 30px;">'),
                                   HTML('<h4> Capped HCR Scenarios</h4>'),
                                   HTML("</div>")
                                   
                                 ), # fluidRow
                                 
                                 checkboxGroupInput('recrc', 'Recruitment Type:',
                                                    c('Historical' = 'hist',
                                                      'Recent' = 'rec',
                                                      'Low to High' = 'lohi',
                                                      'High to Low' = 'hilo'),
                                                    selected = 'hist'
                                 ),
                                 checkboxGroupInput('dmrc', 'Discard Mortality Rate (DMR):',
                                                    c('Full retention' = '0',
                                                      '12%' = '12',
                                                      '20%' = '20',
                                                      '35%' = '35'),
                                                    selected = '0'),
                                 checkboxGroupInput('cap', 'Scenario:',
                                                    c('SSC Main' = 'base', 
                                                      'Capped HCR' = 'cap',
                                                      'Capped HCR w/Variable Price' = 'cap_var'),
                                                    selected = 'base')
                          )
                        ),
                        mainPanel( 
                          p(br(),
                          ("These scenarios implement a total landings cap of 15kt, which illustrates the impacts on limiting fishery removals; this is not meant as a potential option for sablefish, but simply illustrates an alternative to a maximum ABC strategy using the F40% HCR.")),
                          tabsetPanel(
                            tabPanel('Revenue', class = "well", plotOutput("p13",
                                                                           dblclick = "plot13_dblclick",
                                                                           brush = brushOpts(
                                                                             id = "plot13_brush",
                                                                             resetOnNew = TRUE
                                                                           ))),
                            tabPanel('SSB', class = "well", plotOutput("p14",
                                                                       dblclick = "plot14_dblclick",
                                                                       brush = brushOpts(
                                                                         id = "plot14_brush",
                                                                         resetOnNew = TRUE
                                                                       ))),
                            tabPanel('Catch', class = "well", plotOutput("p15",
                                                                         dblclick = "plot15_dblclick",
                                                                         brush = brushOpts(
                                                                           id = "plot15_brush",
                                                                           resetOnNew = TRUE
                                                                         ))),
                            tabPanel('Total Biomass', class = "well", plotOutput("p16",
                                                                                 dblclick = "plot16_dblclick",
                                                                                 brush = brushOpts(
                                                                                   id = "plot16_brush",
                                                                                   resetOnNew = TRUE
                                                                                 ))),
                            tabPanel('Dead Discards', class = "well", plotOutput("p16a",
                                                                                 dblclick = "plot16a_dblclick",
                                                                                 brush = brushOpts(
                                                                                   id = "plot16a_brush",
                                                                                   resetOnNew = TRUE
                                                                                 )))
                          ) ,
                          tableOutput('dac')
                          
                        )
                      )
             ),
             # navbarMenu("cap",
             tabPanel('Hindcast', fluid = TRUE,
                      sidebarLayout( 
                        sidebarPanel(
                          column(8, 
                                 fluidRow(
                                   HTML("<style> #show_values {height: 20px; width: 20px;} </style>"),
                                   HTML('<div style="position: relative; top: -15px; left: 30px;">'),
                                   HTML('<h4> Hindcast Scenarios</h4>'),
                                   HTML("</div>")
                                   
                                 ), # fluidRow
                                 
                                 checkboxGroupInput('recrh', 'Recruitment Type:',
                                                    c('Historical' = 'hist',
                                                      'Recent' = 'rec',
                                                      'Low to High' = 'lohi',
                                                      'High to Low' = 'hilo'),
                                                    selected = 'hist'
                                 ),
                                 checkboxGroupInput('dmrh', 'Discard Mortality Rate (DMR):',
                                                    c('Full retention' = '0',
                                                      '12%' = '12',
                                                      '20%' = '20',
                                                      '35%' = '35'),
                                                    selected = '0'),
                                 checkboxGroupInput('hind', 'Scenario:',
                                                    c('Full ABC w/Variable Pricing' = 'hind_var', 
                                                      'Capped harvest w/Variable Pricing' = 'hind_cap'),
                                                    selected = 'hind_var')
                          )
                        ),
                        mainPanel(
                          p(br(),
                            ("These runs begin in 2017 and utilize the actual estimated recruitment from 2017-2023 to demonstrate how the metrics may have differed if discarding had been permitted since 2017; two version of the hindcast are provide, the full ABC utilization and a capped HCR, both of which assume the variable price structure.")),
                          tabsetPanel(
                            tabPanel('Revenue', class = "well", plotOutput("p17",
                                                                           dblclick = "plot17_dblclick",
                                                                           brush = brushOpts(
                                                                             id = "plot17_brush",
                                                                             resetOnNew = TRUE
                                                                           ))),
                            tabPanel('SSB', class = "well", plotOutput("p18",
                                                                       dblclick = "plot18_dblclick",
                                                                       brush = brushOpts(
                                                                         id = "plot18_brush",
                                                                         resetOnNew = TRUE
                                                                       ))),
                            tabPanel('Catch', class = "well", plotOutput("p19",
                                                                         dblclick = "plot19_dblclick",
                                                                         brush = brushOpts(
                                                                           id = "plot19_brush",
                                                                           resetOnNew = TRUE
                                                                         ))),
                            tabPanel('Total Biomass', class = "well", plotOutput("p20",
                                                                                 dblclick = "plot20_dblclick",
                                                                                 brush = brushOpts(
                                                                                   id = "plot20_brush",
                                                                                   resetOnNew = TRUE
                                                                                 ))),
                            tabPanel('Dead Discards', class = "well", plotOutput("p20a",
                                                                                 dblclick = "plot20a_dblclick",
                                                                                 brush = brushOpts(
                                                                                   id = "plot20a_brush",
                                                                                   resetOnNew = TRUE
                                                                                 )))
                          ) ,
                          tableOutput('dah')
                          
                        )
                      )
             ))

             
  # )
  
))
