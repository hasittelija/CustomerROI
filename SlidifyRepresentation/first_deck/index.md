---
title       : Bet Simulator
author      : Tommi Hovi
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]     # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Introduction

The goal of the application is to show how different sample sizes (number of bets) affect the confidence interval for return on investment (ROI). The bigger the sample size the tighter is the confidence interval. However what might be slightly surprising is that we can see that the bigger underdogs you bet, the higher samples size you need to get the same confidence level in ROI statistic. 

However if we are only interested in estimating the win probabilities of the bets, Then because of symmetry, 200 bets for 10% underdogs and 200 bets for 90% favorites have the same confidence interval. 

---

## Basic formula

The application simulates sports bettors based on 3 parameters the user can choose: number of bets, ROI (return on investment) and the win probabilities for the bets. ROI of 5 means for each 100 dollars wagered the bettors expected net win is 5 dollars. The win probabilities mean whether bettor bets on underdogs (small win probability) or favorites (high win probability), or something in between. The formula to determine the decimal odds of the bet is:



```r
ROI <- 2/100 # 2%
win_probability <- 50/100 # 50%
print(decimal_odds <- (ROI+1)/win_probability)
```

```
## [1] 2.04
```

---

So the decimal odds for 50% bet win and 2% ROI are 2.04. 50% of the time bettor wins the bet to gain 2.04 units and we have to subtract the initial stake that the bettor pays whether he/she wins or loses.


```r
0.5 * 2.04 - 1 
```

```
## [1] 0.02
```

From the formula we can see that when bet probability goes up, the decimal odds go down. When ROI goes up so do the decimal odds. Basically only ROI is a measure of how good the sports bettor is, and changing bet probabilities does not change the expected gains of the bettor. However it changes the variance of the net wins.

---

## ROI and bet win probability

Since $$latex ROI = decimal odds * win probability$$ Now if we take derivative respect to win probability:
we get:
$$latex
\Delta ROI = decimal odds
$$

This means that one percentage point change in the bet probability changes ROI more if the decimal odds are high. This explains why when betting big underdogs (big decimal odds) the ROI confidence interval is wider, even tho bet win probability confidence interval is narrow. And conversely betting big favorites means the decimal odds are low and changes in the win probabilities don't affect ROI as much.
