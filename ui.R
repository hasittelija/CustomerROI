
shinyUI(fluidPage(
    titlePanel("My Shiny App"),
    sidebarLayout(
        sidebarPanel(h3("Installation"),
                     "Shiny is available on CRAN, so you can install it in the usual way from your R console:",
                     
                     
                     numericInput("SampleSize1", label = "Number of Games 1",
                                  min = 0, max = 50000, step = 100, value = 1000),
                     sliderInput("c1ROI", label = "Alice ROI",
                                 min = -25, max = 25, value = 3),
                     sliderInput("GameProb1", label = "Line Prob 1",
                                 min = 0, max = 100, value = 10),
                     
                     numericInput("SampleSize2", label = "Number of Games 2",
                                  min = 0, max = 50000, step = 100, value = 1000),
                     sliderInput("c2ROI", label = "Bob ROI",
                                 min = -25, max = 25, value = 3),
                     sliderInput("GameProb2", label = "Line Prob 2",
                                 min = 0, max = 100, value = 50),
                     
                     
                     numericInput("SampleSize3", label = "Number of Games 3",
                                  min = 0, max = 50000, step = 100, value = 1000),
                     sliderInput("c3ROI", label = "Charlie ROI",
                                 min = -25, max = 25, value = 3),
                     sliderInput("GameProb3", label = "Line Prob 3",
                                 min = 0, max = 100, value = 90),
                     
                     radioButtons("PlotType", label = h3("Confidence Interval Type"),
                                  choices = list("Game Probability" = 1, "Customer ROI" = 2,
                                                 "Customer WinLoss" = 3),selected = 2)
        
                     
                     
                     
                     
                     
                     
                     
                     
        ),
        mainPanel(
            h2("Introducing Shiny"),
            p("Shiny is a new package from RStudio that makes it", em("incredibly"),
              "easy to build interactive web applications with R."),
            p("For an introduction and live examples, visit the ", 
              span("Shiny homepage.", style = "color:blue")),

            plotOutput("plot"),
            textOutput("text1"),
            
            
            p(h2("Features")),
            p("* Build useful web applications with only a few lines of code - no JavaScript required."),
            p("* Shiny applications are automatically \"live\" in the same way that ",
              strong("spreadsheets"), "are live. Outputs change instantly as users modify
              inputs, without requireing a reload of the browser.")
            
            
        )
    )
))
