# server.R
require(ggplot2)
require(reshape)
require(scales)
require(shiny)
number_of_simulations <- 5000



shinyServer(function(input, output) {
    
    
    
    plotType <- reactive({
        return(input$PlotType)
        # 1 = game prob, 2 = ROI, 3 = winloss
        })
    
    # returns vector of length nuber_of_simulations that says on each simulation how many bets won
    cust1flips1 <- reactive({
        samplesize <- input$SampleSize1
        ROI <- input$c1ROI
        lineprob <- input$GameProb1/100

        decimal_odds <- (1+ROI)/lineprob
    
        #simulate game results
        flips <- sapply(lineprob, function(x) rbinom(number_of_simulations, samplesize, x))
    })
    
    
    simulatedlineprob <- reactive({
        simulatedlineprob <- cust1flips1()/input$SampleSize1
    })
    
    
    
    
    
    output$text1 <- renderText({
      #  cust1flips()[1]
        simulatedlineprob <- simulatedlineprob()
        
CI_and_mean <-        cbind("2.5%" = c(apply(simulatedlineprob, 2, function (x) quantile(x, 0.025))), "mean" = apply(simulatedlineprob, 2, mean), "97.5%" = c(apply(simulatedlineprob, 2, function (x) quantile(x, 0.975))))
        names(CI_and_mean) <- c("2.5%", "mean", "97.5%")
        return(CI_and_mean)


})
    
    
    

    
    output$plot <- renderPlot({
        simulatedlineprob <- simulatedlineprob()
        
        
        melted_simulatedlineprob <- melt(simulatedlineprob)
        colnames(melted_simulatedlineprob)[2] <- "Customer"
        ggplot(melted_simulatedlineprob, aes(value, fill = Customer)) + geom_density(alpha = 0.2) +
            ggtitle("Histogram of maximum likehood estimates for win probabilities") + xlab("Win probability") +
            scale_x_continuous(label = percent)
        
        
        
        
    })
    
})