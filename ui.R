#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

fluidPage(
  
  # Application title
  titlePanel("Small sablefish"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("disc_age",
                  "Discard age:",
                  min = 0,
                  max = 5,
                  value = 0),
      sliderInput("dmr",
                  "Discard mortality rate:",
                  min = 0,
                  max = 1,
                  value = 0.2),
      sliderInput("fish",
                  "Hook & Line fishery mortality rate:",
                  min = 0,
                  max = 0.25,
                  value = 0.06),
      sliderInput("fish_t",
                  "Trawl fishery mortality rate:",
                  min = 0,
                  max = 0.25,
                  value = 0.02),
      sliderInput("grade12",
                  "Grade 1/2 $:",
                  min = 0,
                  max = 3.0,
                  value = 0.64,
                  step = 0.01),
      sliderInput("grade23",
                  "Grade 2/3 $:",
                  min = 0,
                  max = 4.0,
                  value = 1.29,
                  step = 0.01),
      sliderInput("grade34",
                  "Grade 3/4 $:",
                  min = 0,
                  max = 5.0,
                  value = 1.84,
                  step = 0.01),
      sliderInput("grade45",
                  "Grade 4/5 $:",
                  min = 0,
                  max = 6.0,
                  value = 2.63,
                  step = 0.01),
      sliderInput("grade57",
                  "Grade 5/7 $:",
                  min = 0,
                  max = 8.0,
                  value = 5.49,
                  step = 0.01),
      sliderInput("grade7",
                  "Grade 7+ $:",
                  min = 0,
                  max = 8.0,
                  value = 6.73,
                  step = 0.01),
    ),
    
    # Show a plot of the generated distribution
    mainPanel(h3("Nonsense", align = "center"), 
              plotOutput("totPlot"),
              plotOutput("ssbPlot"),
              plotOutput("revPlot")
    )
  )
)
