# server.R
require(ggplot2)
require(reshape)
require(scales)
require(shiny)
number_of_simulations <- 10000



shinyServer(function(input, output) {
    
    # returns vector of length nuber_of_simulations that says on each simulation how many bets won
    # code for all 3 versions should be identical except customer number
    cust1flips <- reactive({
        samplesize <- input$SampleSize1
        ROI <- input$c1ROI/100
        lineprob <- input$GameProb1/100
        
        decimal_odds <- (1+ROI)/lineprob
        
        #simulate game results
        flips <- rbinom(number_of_simulations, samplesize, lineprob)
        
        #flips <- sapply(lineprob, function(x) rbinom(number_of_simulations, samplesize, x))
    })
    
    cust2flips <- reactive({
        samplesize <- input$SampleSize2
        ROI <- input$c2ROI
        lineprob <- input$GameProb2/100
        
        decimal_odds <- (1+ROI)/lineprob
        
        #simulate game results
        flips <- rbinom(number_of_simulations, samplesize, lineprob)
    })
    
    cust3flips <- reactive({
        samplesize <- input$SampleSize3
        ROI <- input$c3ROI
        lineprob <- input$GameProb3/100
        
        decimal_odds <- (1+ROI)/lineprob
        
        #simulate game results
        flips <- rbinom(number_of_simulations, samplesize, lineprob)
    })
    
    
    simulatedlineprob <- reactive({
        simulatedlineprob1 <- cust1flips()/input$SampleSize1
        simulatedlineprob2 <- cust2flips()/input$SampleSize2
        simulatedlineprob3 <- cust3flips()/input$SampleSize3
        
        lineprobmatrix <- cbind(simulatedlineprob1, simulatedlineprob2, simulatedlineprob3)
        colnames(lineprobmatrix) <- c("Alice", "Bob", "Charlie")
        return(lineprobmatrix)
    })
    
    
    simulatedwinloss <- reactive({
        decimal_odds1 <- (1+input$c1ROI/100)/(input$GameProb1/100)
        decimal_odds2 <- (1+input$c2ROI/100)/(input$GameProb2/100)
        decimal_odds3 <- (1+input$c3ROI/100)/(input$GameProb3/100)
        
        simulatedlineprob1 <- cust1flips()*decimal_odds1 - input$SampleSize1
        simulatedlineprob2 <- cust2flips()*decimal_odds2 - input$SampleSize2
        simulatedlineprob3 <- cust3flips()*decimal_odds3 - input$SampleSize3
        
        lineprobmatrix <- cbind(simulatedlineprob1, simulatedlineprob2, simulatedlineprob3)
        colnames(lineprobmatrix) <- c("Alice", "Bob", "Charlie")
        return(lineprobmatrix)
    })
    
    simulatedROI <- reactive({
        simulatedwinloss <- simulatedwinloss()
        ss1 <- input$SampleSize1
        ss2 <- input$SampleSize2
        ss3 <- input$SampleSize3
        
        ss <- c(ss1,ss2,ss3)
        # divide simulatedwinloss vector with sample size, so that cust1 winlosses get divided
        # by his sample size, cust2 by her and so on
        return(t(t(simulatedwinloss)/ss))
    }
    )
    
    
    plotType <- reactive({
        return(input$PlotType)
        # 1 = game prob, 2 = ROI, 3 = winloss
    })
    
    
    
    output$table1 <- renderTable({
        #  cust1flips()[1]
        
        plot_type <- plotType() # 1 for game prob, 2 for ROI, 3 for winloss
        
        
        if(plot_type == 1) {
            
            simulatedlineprob <- simulatedlineprob()
            
            
            CI_and_mean <-        cbind("2.5%" = c(apply(simulatedlineprob, 2, function (x) quantile(x, 0.025))), "mean" = apply(simulatedlineprob, 2, mean), "97.5%" = c(apply(simulatedlineprob, 2, function (x) quantile(x, 0.975))))
            names(CI_and_mean) <- c("2.5%", "mean", "97.5%")
            return(CI_and_mean)
        }
        
        if(plot_type == 2) {
            
            simulatedholdrisk <- simulatedROI()
            
            CI_and_mean <-  cbind("2.5%" = c(apply(simulatedholdrisk, 2, function (x) quantile(x, 0.025))), "mean" = apply(simulatedholdrisk, 2, mean), "97.5%" = c(apply(simulatedholdrisk, 2, function (x) quantile(x, 0.975))))
            names(CI_and_mean) <- c("2.5%", "mean", "97.5%")
            return(CI_and_mean)
            
            
            
        }
        
        if(plot_type == 3) {
            
            simulatedwinloss <- simulatedwinloss()
            
            
            CI_and_mean <- cbind("2.5%" = c(apply(simulatedwinloss, 2, function (x) quantile(x, 0.025))), "mean" = apply(simulatedwinloss, 2, mean), "97.5%" = c(apply(simulatedwinloss, 2, function (x) quantile(x, 0.975))))

            names(CI_and_mean) <- c("2.5%", "mean", "97.5%")
            return(CI_and_mean)
            
            
        }
        
        
        
        
        
    })
    
    
    
    
    
    
    
    output$plot <- renderPlot({
        
        plot_type <- plotType() # 1 for game prob, 2 for ROI, 3 for winloss
        
        if(plot_type == 1){
            simulatedlineprob <- simulatedlineprob()
            
            melted_simulatedlineprob <- melt(simulatedlineprob)
            colnames(melted_simulatedlineprob)[2] <- "Customer"
            return(ggplot(melted_simulatedlineprob, aes(value, fill = Customer)) + geom_density(alpha = 0.2) +
                       ggtitle("Histogram of maximum likehood estimates for win probabilities") + xlab("Win probability") +
                       scale_x_continuous(label = percent))
        }
        
        if(plot_type == 2){
            simulatedholdrisk <- simulatedROI()
            
            
            melted_simulatedholdrisk <- melt(simulatedholdrisk)
            colnames(melted_simulatedholdrisk)[2] <- "Customer"
            return(ggplot(melted_simulatedholdrisk, aes(value, fill = Customer)) + geom_density(alpha = 0.2) +
                       ggtitle("Histogram of calculated hold risks") + xlab("Customer hold risk percentage") +
                       scale_x_continuous(label = percent))
        }
        
        
        
        
        
        
        if(plot_type == 3) {
            simulatedwinloss <- simulatedwinloss()

            melted_simulatedwinloss <- melt(simulatedwinloss)
            colnames(melted_simulatedwinloss)[2] <- "Customer"
            ggplot(melted_simulatedwinloss, aes(value, fill = Customer)) + geom_density(alpha = 0.2) +
                ggtitle("Histogram of customer winloss amounts") + xlab("Customer winloss") +
                scale_x_continuous(label = dollar)  
            
        }
        
        
    })
    
})