
shinyUI(fluidPage(
    titlePanel("Sports bettor simulator"),
    sidebarLayout(
        sidebarPanel(
            
            
            h3("Alice"),
            
            fluidRow(
                
                column(3, numericInput("SampleSize1", label = "Number of bets",
                                       min = 0, max = 50000, step = 100, value = 1000)),
                column(3, numericInput("c1ROI", label = "ROI %",
                                       min = -80, max = 80, value = 3)),
                column(3, numericInput("GameProb1", label = "Bet win probabilty %",
                                       min = 0, max = 100, value = 10))
                
                
                
            ),
            
            h3("Bob"),
            
            fluidRow(
                
                
                column(3, numericInput("SampleSize2", label = "Number of bets",
                                       min = 0, max = 50000, step = 100, value = 1000)),
                column(3, numericInput("c2ROI", label = "ROI %",
                                       min = -80, max = 80, value = 3)),
                column(3, numericInput("GameProb2", label = "Bet win probability %",
                                       min = 0, max = 100, value = 50))
                
            ),
            
            h3("Carol"),
            
            fluidRow(
                
                column(3, numericInput("SampleSize3", label = "Number of bets",
                                       min = 0, max = 50000, step = 100, value = 1000)),
                column(3, numericInput("c3ROI", label = "ROI %",
                                       min = -80, max = 80, value = 3)),
                column(3, numericInput("GameProb3", label = "Bet win probability %",
                                       min = 0, max = 100, value = 90))
                
                
            ),
            
            radioButtons("PlotType", label = h3("Graph Type"),
                         choices = list("Bet win probability %" = 1, "Bettor ROI %" = 2,
                                        "Bettor netwin" = 3)
                         ,selected = 2)
            
            ,
            
            
            h3("Instructions"),
            "Simulation of 3 different sports bettors: Alice, Bob and Carol. Each bettor has their own parameters and these are independent from the other bettors. You can set the number of bets, bet win probability for the bets and return on investment (ROI).",
            
            br(),
            br(),
            p("The odds these bettors get are calculated from the bet win probabilities and ROI. ROI is a measure of how much the bettor is expected to win. For example 5% ROI means for each $100 wagered expected netwin is $5. If the ROI is 0%, then the odds are fair odds based on the bet win probability. In other words the bet win probabilty doesn't affect how good the sports bettor is, because the odds also change when the bet win probability changes. Low bet win probabilty means the bettor is betting big underogs and high bet win probability means he/she is betting on big favorites."),
            
            br(),
            br(),
            p("For example if we choose 300 bets, 50% bet win probability and 10% ROI. It means the bettor bets 300 bets where each bet has 50% probability of winning, and on average for each unit wagered, bettor expects to make 10% profit. Since the ROI is positive, this bettor is winning sports bettor and manages to find bets where the odds offered are too good. 50% bet win probability means he bets on games where the teams are evenly matched."),
            
            br(),
            br(),
            p("You can choose from 3 different graphs: bet win probability, bettor ROI% or bettor netwin (assuming each bet is for $1). Each of these 3 bettors are simulated 50000 times and the plot will show the histogram for these simulations and the table below it shows certain quantiles of the simulations.")
            
            
            
            
            
            
            
        ),
        mainPanel(
            h2("Output"),
            #p("paragraph"),
            
            plotOutput("plot"),
            h4("Quantiles and mean:"),
            tableOutput("table1")
            
            
            
            
        )
    )
))
