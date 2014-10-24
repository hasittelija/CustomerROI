
shinyUI(fluidPage(
    titlePanel("Sports bettor simulator"),
    sidebarLayout(
        sidebarPanel(
                     
                     
                     fluidRow(
                         
                         column(3, numericInput("SampleSize1", label = "Number of bets Alice",
                                                min = 0, max = 50000, step = 100, value = 1000)),
                         column(3, sliderInput("c1ROI", label = "Alice ROI %",
                                               min = -25, max = 25, value = 3)),
                         column(3, sliderInput("GameProb1", label = "Bet win probability % Alice",
                                               min = 0, max = 100, value = 10))
                         
                         
                         
                     ),
                     
                     fluidRow(
                         
                         
                         column(3, numericInput("SampleSize2", label = "Number of bets Bob",
                                                min = 0, max = 50000, step = 100, value = 1000)),
                         column(3, sliderInput("c2ROI", label = "Bob ROI %",
                                               min = -25, max = 25, value = 3)),
                         column(3, sliderInput("GameProb2", label = "Bet win probability % Bob",
                                               min = 0, max = 100, value = 50))
                         
                     ),
                     
                     
                     fluidRow(
                         
                         column(3, numericInput("SampleSize3", label = "Number of bets Carol",
                                                min = 0, max = 50000, step = 100, value = 1000)),
                         column(3, sliderInput("c3ROI", label = "Carol ROI %",
                                               min = -25, max = 25, value = 3)),
                         column(3, sliderInput("GameProb3", label = "Bet win probability % Carol",
                                               min = 0, max = 100, value = 90))
                         
                         
                     ),
                     
                     radioButtons("PlotType", label = h3("Graph Type"),
                                  choices = list("Bet Probability %" = 1, "Customer ROI %" = 2,
                                                 "Customer Hold %" = 4, "Customer WinLoss" = 3)
                                  ,selected = 2)
                     
                     ,
                     
                     
                     h3("Input"),
                     "Simulation of 3 different sports bettors: Alice, Bob and Carol. Each bettor has their own parameters and these are independent from the other bettors. You can set the number of bets they do, the probability of the games they bet and return on investment (ROI).",
                     
                     br(),
                     br(),
                     p("For example if we choose 300 bets, 50% bet win probability and 10% ROI. It means the bettor bets 300 bets where each bet has 50% probability of winning, and on average for each unit wagered, bettor expects to make 10% profit. Since the ROI is positive, this customer is winning sports bettor and manages to find bets where the odds offered are too good."),
                     
                     #br(),
                     br(),
                     p("You can choose from 3 different graphs: game probability, customer ROI% or customer win loss (assuming each bet is for $1). The graphs will show the probability density function of the chosen statistic after all the bets are done. By changing the parameters you can test how these parameters change the probability density function.")
                     
                     
                     
                     
                     
                     
                     
        ),
        mainPanel(
            h2("H2 title"),
            p("paragraph"),
            
            plotOutput("plot"),
            h4("Quantiles and mean:"),
            tableOutput("table1")
            
            
            
            
        )
    )
))
