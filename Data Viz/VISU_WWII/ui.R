##################################
### Thilbaut Allin & Jan Malik ###
###      25 November 2018      ###
##################################

navbarPage("WW2 Damages", id="nav",
           
           ###############################################################################################################
           ################################################# 1. Acceuil ##################################################
           ###############################################################################################################
           
           tabPanel("Accueil",
                    h2("WW2 Allied Bombing Visualisation", align="center"),
                    br(), 
                    br(),
                    fluidRow(
                      column(7, offset=0,
                             mainPanel(
                               h4("La Seconde guerre mondiale a été l'un des plus terribles conflits armés de l'histoire. Lors de cette guerre, les raids aériens ont pris une ampleur considérable dans les affrontements. Nous vous proposons d’explorer les caractéristiques et l’évolution des assauts aériens des forces des Alliés tout au long de la guerre avec cette application, qui se veut simple d’utilisation et à vocation pédagogique. A travers les différents onglets, vous pourrez revivre le déroulement de la guerre, comprendre en finesse les événements clefs comme le D-Day à travers l’évolution nu nombre de missions, des lieux de bombardements et des cibles visés. Dans l’ensemble de l’application, on appelle une mission l’ensemble des attaques sur un même lieu pour un même jour. Les détails des bombardements de chaque mission rassemblent donc les informations de chacune des attaques qui la constituent.", align="center")
                               
                             )
                      ),
                      column(3,
                             imageOutput("image"))
                    ),
                    hr(),
                    fluidRow(
                      column(3,
                             wellPanel(
                               fluidRow(
                                 column(3, offset=2,
                                        actionButton('jumpToMap1', 'Go to Day map explorer'))),
                               h5("L’onglet « Day Map Explorer » contient une carte du monde sur laquelle est représenté l’ensemble des missions de bombardement qui ont eu lieu au jour sélectionné, symbolisés par un cercle rouge. La taille de chaque cercle dépend de l’importance du bombardement (en tonnes de bombes larguées). Entrez la date qui vous intéresse et interagissez avec la carte pour en extraire les informations que vous souhaitez !", align="center"))
                      ),
                      
                      
                      column(3,
                             wellPanel(
                               fluidRow(
                                 column(3, offset=2,
                                        actionButton('jumpToMapTimer', 'Go to Map Timer'))),
                               h5("Dans l’onglet « Map Timer », vous pouvez suivre l’évolution de la WW2 jour par jour. Cliquez sur la petite flèche en dessous de l’affichage de la date pour lancer un décompte automatique des jours. La carte se mettra à jour automatiquement", align="center"))
                      ),
                      
                      
                      column(3,
                             wellPanel(
                               fluidRow(
                                 column(3, offset=2,
                                        actionButton('jumpToClusterMap', 'Go to Cluster Map'))),
                               h5("L’onglet « Cluster Map » est une autre carte faisant la synthèse de l’ensemble des missions de bombardements aériens menés lors de la WW2. Les points reliés entre eux correspondent à différentes missions menés au même endroit. Cliquez sur chaque point pour avoir plus de détail sur lesdites missions", align="center"))
                      ),
                      
                      
                      column(3,
                             wellPanel(
                               fluidRow(
                                 column(3, offset=2,
                                        actionButton('jumpToVisu', 'Go to Elegant Visualization'))),
                               h5("L’onglet « Elegant Visualisation » contient plusieurs graphiques pour explorer plus en détail les bombardements. Vous trouverez un graphique avec l’évolution du nombre de missions par jour pendant la guerre, et aussi un montrant les types d’industries ciblées et le nombre de fois où elles ont été ciblées. Vous pouvez ajuster plusieurs paramètres comme l’année, pour par exemple choisir de regarder plus en détail la tournure des événements autour du D’Day (les types d’industries ciblés évoluent-ils ?)", align="center"))
                      )
                    )
                    ),
           
           ###############################################################################################################
           ########################################## 2. Interactive Map_day #############################################
           ###############################################################################################################
           
           tabPanel("Day map explorer",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        leafletOutput("map", width="100%", height="100%"),
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 80, left = 20, right = "auto", bottom = "auto",
                                      width = 330, height = "auto",
                                      h2("Damages explorer"),
                                      actionButton("mapButton","Update!"),
                                      textInput("date", "Select your Day", value="1945-08-06", placeholder = "example : 1945-08-06"),
                                      plotOutput("BarCountry", height = 200),
                                      plotOutput("BarIndustrie", height = 200),
                                      
                                      #### ajout du bouton de retour a l'accueil
                                      actionButton('jumpToAccueil', 'Back to Dashboard')
                        ),
                        
                        tags$div(id="cite",
                                 'Interactive map of ', tags$em('bombing during WW2 (1939–1945'), ' by T.Alin & J.Malik  (AgroCampus-Ouest, 2018).'
                        )
                    )
           ),
           
           ###############################################################################################################
           ############################################### 3. Map Timer ##################################################
           ###############################################################################################################
           
           tabPanel("Map Timer",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        leafletOutput("mapTime", width="100%", height = "100%"),

                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = 20, right = "auto", bottom = "auto",
                                      width = 330, height = "auto",

                                      h2("Mission explorer"),
                                      
                                      sliderInput("days", "Date",
                                                  min = as.Date("1939-09-03","%Y-%m-%d"),
                                                  max = as.Date("1945-12-31","%Y-%m-%d"),
                                                  value=as.Date("1939-09-03"),
                                                  timeFormat="%Y-%m-%d", 
                                                  animate = TRUE),
                                      actionButton('jumpToAccueil2', 'Back to Dashboard')
                                      ),
                        
                        tags$div(id="cite",
                                 'Interactive Time map of ', tags$em('bombing during WW2 (1939–1945'), ' by T.Alin & J.Malik  (AgroCampus-Ouest, 2018).'
                        )
                    )
           ),
           
           ###############################################################################################################
           ############################################# 4. Map Clusters #################################################
           ###############################################################################################################
           
           tabPanel("Cluster map",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        leafletOutput("mapCluster", width="100%", height="100%"),
                        
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 380, height = "auto",
                                      h2("Bombed areas explorer"),
                                      actionButton("mapButtonCluster","Update!"),
                                      selectInput("Cluster", "Choose you Criterium", c("Mission","Year", "Damage")),
                                      plotOutput("BarClust", height = 200),
                                      
                                      #### ajout du bouton de retour a l'accueil
                                      actionButton('jumpToAccueil3', 'Back to Dashboard')
                        ),
                        
                        tags$div(id="cite",
                                 'Interactive map of ', tags$em('bombing during WW2 (1939–1945'), ' by T.Alin & J.Malik  (AgroCampus-Ouest, 2018).'
                        )
                    )
           ),
           
           ###############################################################################################################
           ############################################# 5. Visu Elegante ################################################
           ###############################################################################################################
           
           tabPanel("Elegant Visualization",
                    
                    #### ajout du bouton de retour a l'accueil
                    actionButton('jumpToAccueil4', 'Back to Dashboard'),
                    hr(),
                    fluidRow(
                      column(2, offset = 1, 
                             selectInput("Period", "Select Period", c("Month by Month", "Year by Year"))),
                      column(2, offset = 1, 
                             selectInput("Type", "Select curve type", c("linear", "step"))),
                      column(2, offset = 1,
                             actionButton("metricGO", "Update"))
                      #A voir si ça sert vraiment à qqch de mettre un button GO
                      ),
                      fluidRow(
                             metricsgraphicsOutput("PeriodMissions")),
                    hr(),
                    ### Barplot des pays cible des attaques, en nombre d'attaque par pays
                    fluidRow(
                      column(3,
                             actionButton("Target_country_button","Update"),
                             sliderInput("attak_mini",
                                         "Nombre minimum d'attaques", min=0, max=5000, value=3000),
                             selectInput(inputId = "tc_annee", label = "Année : ", multiple = TRUE, 
                                                choices = All_annee,
                                                selected = "1944")
                             
                      ),
                      column(9,
                             plotlyOutput("TargetCountry")
                      )
                    ),
                    hr(),
                    fluidRow(
                      column(3,
                             actionButton("Theatre_opButton", "Update"),
                             selectInput("t_ops_annee", "Année : ", multiple = TRUE, 
                                         choices = All_annee, 
                                         selected = "1944"),
                             p("TOO : Theatre of Operations"),
                             p("ETO : European Theatre of Operations"),
                             p("CBI : China Burma India Theater"), 
                             p("MTO : Mediterranean Theater of Operations"),
                             p("PTO : Pacific Theater of Operations")
                             ),
                      column(9, 
                             plotlyOutput("Theatre_ops_plotly")
                             )
                    )
           )
)