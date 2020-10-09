#####################
###   Malik Jan   ###
### 01 March 2018 ###
#####################


library(shiny)
library(DT)

shinyUI(fluidPage(
  titlePanel("Quelques statistiques descriptives"),
  
  sidebarLayout(
    sidebarPanel(
      #sliderInput("bins", "Number of bins:", min = 1, max = 10, value = 5, step = 1),
      selectInput("Groupe", "Sélectionnez le groupe de clients",
                  choices = c("01_TRES_BONS", "02_BONS", "03_PERTES", "04_PETITS",
                              "05_FAIBLES", "06_NOUVEAUX", "07_INACTIFS"))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Âge", div(h1("Distribution des âges"), align = "center", style = "color:blue"),
                 plotOutput("distPlot")),
        tabPanel("Régions", div(h1("Régions par groupe"), align = "center", style = "color:blue"),
                 plotOutput("distPlot2"))
      )
    )
  )
))
