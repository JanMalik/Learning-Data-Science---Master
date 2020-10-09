###############################
### Bryan Jacob & Jan Malik ###
###      03 March 2018      ###
###############################

ui <- fluidPage(
  
  
  titlePanel("Projet Visualisation des données M1 Mathématiques Appliquées, Statistique"),
  #Titre de l'application shiny
  
  tabsetPanel(
    #Définition de plusieurs onglets au sein de l'application shiny
    tabPanel("Graphiques descriptifs", 
             sidebarLayout(
               sidebarPanel(
                 selectInput("colonneDes","Choix de la variable :", c("Bassin de natation", "Boulodrome", "Tennis" ,"équipement de cyclisme" , "Domaine skiable" , "Centre équestre" , "Athlétisme" , "Terrain de golf", "Parcours sportif/santé", "Sports de glace" , "Plateaux et terrains de jeux extérieurs" , "Salles spécialisées" , "Terrains de grands jeux" , "Salles de combat" , "Salles non spécialisées" , "Roller-Skate-Vélo bicross ou freestyle" , "Sports nautiques" , "Bowling" , "Salles de remise en forme" , "Salles multisports (gymnase)" , "Baignade aménagée" , "Mouillage" , "Boucle de randonnée" , "Théétre" , "Cinéma" , "Musée" , "Conservatoire")),
                 radioButtons("Test","Type:",c("Nuage de points","Départements les mieux équipés","Densité de la variable","Distribution continue par quartile de la variable", "Distribution discréte par quartile de la variable", "Distribution bivariée de variables")),
                 h6("Pour les distributions discrétes : la moyenne de chaque quartile est représentée par le point de couleur bleu, la médiane de chaque quartile est représentée par le point de couleur rouge")
               ),
               mainPanel(
                 plotOutput("map1")
               )
             )
    ),
    tabPanel("Cartographie de la répartition des équipements par départements", #Nom de l'onglet
             sidebarLayout(
               sidebarPanel(
                 selectInput("colonne","Choix de la variable :", names(dataComplet)[-c(1:5)]), 
                 #On stock dans une liste déroulante le nom des colonnes du dataframe "dataComplet" sauf les 5 premiéres
                 h5("Moyenne de la variable sélectionnée:"),
                 textOutput('meanLeaflet'),
                 #Affichage de la moyenne de la variable sélectionnée
                 h5("écart-type de la variable sélectionnée:"),
                 textOutput('sdLeaflet'),
                 #Affichage de l'écart-type de la variable sélectionnée
                 h5("Valeur minimale de la variable sélectionnée:"),
                 textOutput('minLeaflet'),
                 #Affichage du minimum de la variable sélectionnée
                 h5("Valeur maximale de la variable sélectionnée:"),
                 textOutput('maxLeaflet'),
                 #Affichage du maximum de la variable sélectionnée
                 h5("Densité en France de la variable sélectionnée:"),
                 textOutput('densLeaflet'),
                 #Affichage de la densité moyenne de la variable sélectionnée en france
                 h5("Valeur minimale de la densité de la variable sélectionnée:"),
                 textOutput('minDensLeaflet'),
                 #Affichage de la densité minimale de la variable sélectionnée en france
                 h5("Valeur maximale de la densité de la variable sélectionnée:"),
                 textOutput('maxDensLeaflet'),
                 #Affichage de la densité maximale de la variable sélectionnée en france
                 tags$head(tags$style("#meanLeaflet{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }",
                                      "#sdLeaflet{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }",
                                      "#minLeaflet{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }",
                                      "#maxLeaflet{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }",
                                      "#densLeaflet{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }",
                                      "#minDensLeaflet{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }",
                                      "#maxDensLeaflet{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }"
                         )
                 )
                 ),
               
               mainPanel(
                 leafletOutput("mymap", height = 700, width = 1000) 
                 #Affichage de la map sous leaflet
               )
                 )
                 ),
    
    tabPanel("Régression linéaire: Analyse par variable", #nom de l'onglet
             sidebarLayout(
               sidebarPanel(
                 selectInput("colonneTest", "Choix de la variable", names(dataRegLineaire)[-c(length(names(dataRegLineaire))-1, length(names(dataRegLineaire)))]), #Stockage des variables dans une liste déroulante
                 h5("Coefficient de la regression linéaire de la variable:"),
                 textOutput("coeff"),
                 #Coefficient de la régression pour la variable sélectionnée
                 h5("écart-type du coefficient de la regression linéaire de la variable:"),
                 textOutput("sdCoeff"),
                 #écart-type du coefficient de la régression pour la variable sélectionnée
                 h5("Statistique au test de Fisher du coefficient de la regression linéaire de la variable:"),
                 textOutput("statCoeff"),
                 #Statistique de Fisher du coefficient de la régression pour la variable sélectionnée
                 h5("P-value au test de Fisher du coefficient de la regression linéaire de la variable:"),
                 textOutput("pvalCoeff"),
                 #P_value du coefficient de la régression pour la variable sélectionnée
                 plotOutput("boxPlotReg"),
                 tags$head(tags$style("#coeff{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }",
                                      "#sdCoeff{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }",
                                      "#statCoeff{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }",
                                      "#pvalCoeff{color: red;
                                      font-size: 20px;
                                      text-align: center;
                                      }"
                 )
                 )
               ),
               
               mainPanel(
                 plotOutput("pointPlot") #Affichage du graphique dans shiny avec plotoutput
               )
             )
    )
             )
    )