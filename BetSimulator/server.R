# server.R
require(ggplot2)
require(reshape)
require(scales)
require(shiny)
number_of_simulations <- 50000



shinyServer(function(input, output) {
    
    # returns vector of length nuber_of_simulations that says on each simulation how many bets won
    # code for all 3 versions should be identical except Bettor number
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
        colnames(lineprobmatrix) <- c("Alice", "Bob", "Carol")
        return(lineprobmatrix)
    })
    

    get_bet_probs <- reactive({
        g1prob <- input$GameProb1
        g2prob <- input$GameProb2
        g3prob <- input$GameProb3
        
        probs <- c(g1prob, g2prob, g3prob)
        return(probs)
        
    })
    
    
    simulatedwinloss <- reactive({
        decimal_odds1 <- (1+input$c1ROI/100)/(input$GameProb1/100)
        decimal_odds2 <- (1+input$c2ROI/100)/(input$GameProb2/100)
        decimal_odds3 <- (1+input$c3ROI/100)/(input$GameProb3/100)
        
        simulatedlineprob1 <- cust1flips()*decimal_odds1 - input$SampleSize1
        simulatedlineprob2 <- cust2flips()*decimal_odds2 - input$SampleSize2
        simulatedlineprob3 <- cust3flips()*decimal_odds3 - input$SampleSize3
        
        lineprobmatrix <- cbind(simulatedlineprob1, simulatedlineprob2, simulatedlineprob3)
        colnames(lineprobmatrix) <- c("Alice", "Bob", "Carol")
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
    
    simulatedhold <- reactive({
        simulatedholdrisk <- simulatedROI()
        betprobs <- get_bet_probs()/100
        # calculate how much bettor can max bet in pinny format
        # where you can max bet more if line prob is over 50%
        volume_vec <- rep(NA,length(betprobs))
        for(i in 1:length(betprobs)) {
            prob <- betprobs[i]
            if(prob <= 0.5) {
                volume_vec[i] <- 1
            }
            if(prob > 0.5) {
                volume_vec[i] <- 1/(1-prob)
            }
            
        }
        
        # multiply simulatedholdrisk vector with volume vector, so that cust1 holdrisks get multiplied
        # by his volume vector, cust2 by her and so on
        return(t(t(simulatedholdrisk)*volume_vec))
        # simulatedhold <- simulatedholdrisk 
        
        
        
    })
    
    
    
    plotType <- reactive({
        return(input$PlotType)
        # 1 = game prob, 2 = ROI, 3 = winloss
    })
    
    
    
    output$table1 <- renderTable({
        #  cust1flips()[1]
        
        plot_type <- plotType() # 1 for game prob, 2 for ROI, 3 for winloss, 4 for hold
        
        if(plot_type == 1) 
            getquantiles <- simulatedlineprob()*100
        if(plot_type == 2) 
            getquantiles <- simulatedROI()*100
        if(plot_type == 3) 
            getquantiles <- simulatedwinloss()
        if(plot_type == 4)
            getquantiles <- simulatedhold()*100
        
        CI_and_mean <- apply(getquantiles, 2, function(x) quantile(x, c(0.025, 0.1, 0.25, 0.5, 0.75, 0.9, 0.975)))
        CI_and_mean <- t(CI_and_mean)

        colnames(CI_and_mean)[ncol(CI_and_mean)/2+1] <- "mean" #assumes mean is the middle column

        return(CI_and_mean)
        
        
    })
    
    
    
    
    
    
    
    output$plot <- renderPlot({
        
        plot_type <- plotType() # 1 for game prob, 2 for ROI, 3 for winloss
        
        if(plot_type == 1){
            simulatedlineprob <- simulatedlineprob()
            
            melted_simulatedlineprob <- melt(simulatedlineprob)
            colnames(melted_simulatedlineprob)[2] <- "Bettor"
            return(ggplot(melted_simulatedlineprob, aes(value, fill = Bettor)) + geom_density(alpha = 0.2) +
                       ggtitle("Histogram of maximum likehood estimates for bet win probabilities") + xlab("Win probability") +
                       scale_x_continuous(label = percent))
        }
        
        if(plot_type == 2){
            simulatedholdrisk <- simulatedROI()
            
            
            melted_simulatedholdrisk <- melt(simulatedholdrisk)
            colnames(melted_simulatedholdrisk)[2] <- "Bettor"
            return(ggplot(melted_simulatedholdrisk, aes(value, fill = Bettor)) + geom_density(alpha = 0.2) +
                       ggtitle("Histogram of calculated ROI") + xlab("Bettor ROI percentage") +
                       scale_x_continuous(label = percent))
        }
        
        
        
        
        
        
        if(plot_type == 3) {
            simulatedwinloss <- simulatedwinloss()

            melted_simulatedwinloss <- melt(simulatedwinloss)
            colnames(melted_simulatedwinloss)[2] <- "Bettor"
            return(ggplot(melted_simulatedwinloss, aes(value, fill = Bettor)) + geom_density(alpha = 0.2) +
                ggtitle("Histogram of bettor netwin amounts") + xlab("Bettor netwin") +
                scale_x_continuous(label = dollar))
            
        }
        
        if(plot_type == 4) {
            simulatedhold <- simulatedhold()
            
            
            melted_simulatedhold <- melt(simulatedhold)
            colnames(melted_simulatedhold)[2] <- "Bettor"
            ggplot(melted_simulatedhold, aes(value, fill = Bettor)) + geom_density(alpha = 0.2) +
                ggtitle("Histogram of calculated hold") + xlab("Bettor hold percentage") +
                scale_x_continuous(label = percent)   
            
            
            
            
            
            
        }
        
        
        
        
    })
    
})