#####################
###   Malik Jan   ###
### 01 March 2018 ###
#####################

library(shiny)
library(DT)
library(ggplot2)

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    data <- read.csv("r_ANALYSE_RFM2016.csv", header = T, sep=';')
    G <- data[data$TYPO==input$Groupe,]
    ggplot(G)+geom_bar(aes(x=AGE), fill = "red", title = input$Groupe)
    #hist(x$AGE, main = input$Groupe, xlab = "Classe d'âge", ylab = "Fréquence", breaks = 5,
         #col = "blue", border = 'white')
  })
  output$distPlot2 <- renderPlot({
    data <- read.csv("r_ANALYSE_RFM2016.csv", header = T, sep=';')
    G <- data[data$TYPO==input$Groupe,]
    ggplot(G)+geom_bar(aes(x=REGIONS), fill = "blue", title = input$Groupe, na.rm = T)
    #hist(x$REGIONS, main = input$Groupe, xlab = "Régions", ylab = "Effectifs",
         #col = "yellow", border = 'white')
  })
})
