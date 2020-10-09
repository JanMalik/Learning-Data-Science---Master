##################################
### Thilbaut Allin & Jan Malik ###
###      25 November 2018      ###
##################################

function(input, output, session){
  
  
  ######################################################################################################
  ############################################ 1. Acceuil ##############################################
  ######################################################################################################
  
  
  #Image page d'accueil
  
  output$image <- renderImage({
    list(src = 'avion_test.jpg',
         contentType = 'image/jpg',
         width = 400,
         height = 400
    )
  }, deleteFile = FALSE)
  
  observeEvent(input$jumpToMap1, {
    updateTabsetPanel(session, "nav",
                      selected = "Day map explorer")
  })
  
  observeEvent(input$jumpToMapTimer, {
    updateTabsetPanel(session, "nav",
                      selected = "Map Timer")
  })
  
  observeEvent(input$jumpToClusterMap, {
    updateTabsetPanel(session, "nav",
                      selected = "Cluster map")
  })
  
  observeEvent(input$jumpToVisu, {
    updateTabsetPanel(session, "nav",
                      selected = "Elegant Visualization")
  })
  
  
  observeEvent(input$jumpToAccueil, {
    updateTabsetPanel(session, "nav",
                      selected = "Accueil")
  })
  
  observeEvent(input$jumpToAccueil2, {
    updateTabsetPanel(session, "nav",
                      selected = "Accueil")
  })
  
  observeEvent(input$jumpToAccueil3, {
    updateTabsetPanel(session, "nav",
                      selected = "Accueil")
  })
  
  observeEvent(input$jumpToAccueil4, {
    updateTabsetPanel(session, "nav",
                      selected = "Accueil")
  })
  
  ###############################################################################################################
  ############################################ 2 Interactive Map_day ############################################
  ###############################################################################################################
  
  
  ###Leaflet()
  output$map <- renderLeaflet({
    input$mapButton  #ajout de dépendance au bouton
    isolate({#ajout de isolate
      dta <- Total.by.place[Total.by.place$Mission.Date == input$date,]
      leaflet(data = dta) %>% 
        addTiles(tilesURL) %>%
        addCircles(lng = ~Target.Longitude, lat = ~Target.Latitude,
                   radius = ~`Total.Weight..Tons.`*10,
                   popup = ~paste(sep = "<br/>",
                                  paste(sep =" ", "<b>Country :</b>", `Target.Country`),
                                  paste(sep =" ", "<b>City :</b>", `Target.City`),
                                  paste(sep =" ", "<b>Bomb Weight :</b>", `Total.Weight..Tons.`, "tons"),
                                  paste(sep =" ", "<b>Attacks :</b>", `Missions`)
                   ),
                   color = ~pal(Missions_Levels), #Couleur du cercle selon la palette definie dans global
                   fillOpacity = 1,
                   stroke = TRUE) %>%
        addLegend(pal=pal, values = ~Missions_Levels, title = paste("Number of Attacks"))
    }) #fin un isolate
  })
  
  ###Barplots 
  output$BarCountry <- renderPlot({
    input$mapButton  #ajout de dépendance au bouton
    isolate({
      ops <- operations[operations$Mission.Date == input$date, ]
      Total.by.Country <- ops %>%
        group_by(Target.Country) %>%
        summarise(Missions = n())
      Total.by.Country <- Total.by.Country[order(-Total.by.Country$Missions),]
      numbertop <- {
        if(length(levels(Total.by.Country$Target.Country)) > 4){numbertop = 4}
        else{numbertop = length(levels(Total.by.Country$Target.Country))}
      }
      Total.by.Country <- head(Total.by.Country, numbertop)
      pcountry <- ggplot(Total.by.Country, aes(x = Target.Country, y = Missions, fill=Target.Country))
      pcountry + geom_bar(stat="identity", fill="#E1AA74") + theme_minimal() + theme(axis.text.x = element_text(face="bold.italic", color="black", size=6, angle=0)) +
        labs(title = "Attacks on countries",
             x = "",
             y = "Count")
    })
  })
  
  output$BarIndustrie <- renderPlot({
    input$mapButton  #ajout de dépendance au bouton
    isolate({
      ops <- operations[operations$Mission.Date == input$date, ]
      Missions.By.Industrie <- ops %>% 
        group_by(Target.Industry) %>% 
        summarise(Raided = n()) %>% 
        mutate(Proportion = round(Raided/sum(Raided),4)) 
      Missions.By.Industrie <- Missions.By.Industrie[order(-Missions.By.Industrie$Raided),]
      Missions.By.Industrie$Target.Industry <- as.factor(Missions.By.Industrie$Target.Industry)
      numbertop <- {
        if(length(levels(Missions.By.Industrie$Target.Industry)) > 4){numbertop = 4}
        else{numbertop = length(levels(Missions.By.Industrie$Target.Industry))}
      }
      Missions.By.Industrie <- head(Missions.By.Industrie, numbertop)
      pindu <- ggplot(Missions.By.Industrie, aes(x = Target.Industry, y = Raided, fill=Target.Industry))
      pindu + geom_bar(stat="identity", fill="#82AFDD") + theme_minimal() + theme(axis.text.x = element_text(face="bold.italic", color="black", size=6, angle=0)) +
        labs(title = "Raided Industries",
             x = "",
             y = "Count")
    })
  })
  
  ########################################################################################################
  ############################################ 3. Map Timer ##############################################
  ########################################################################################################
  
  
  output$mapTime <- renderLeaflet({
    #dta <- opsDay[[input$days]]
    dta <- Total.by.place[Total.by.place$Mission.Date == input$days,]
    leaflet(data=dta) %>% 
      addTiles(tilesURL) %>%
      setView(lng=55, lat=30, zoom=3) %>%
      addCircles(lng = ~`Target.Longitude`, lat = ~`Target.Latitude`,
                 radius = ~`Total.Weight..Tons.` * 10,
                 #color = ~pal(`Missions_Levels`), #Couleur du cercle selon la palette definie dans global
                 color = "#6d071a", #bordeau
                 fillOpacity = 1,
                 stroke = TRUE) #%>%
      #addLegend(pal=pal, values = ~Missions_Levels, title = paste("Number of Attacks"))
  })
    
  
  ############################################################################################################
  ############################################# 4. Map Clusters ##############################################
  ############################################################################################################
  
  
  ###Leaflet()
  output$mapCluster <- renderLeaflet({
    input$mapButtonCluster  #ajout de dépendance au bouton & isolate leaflet
    isolate({
      if(input$Cluster == "Mission"){dta=opsMissions}
      else if(input$Cluster == "Year"){dta=opsYear}
      else{dta=opsDamage}
      ops.df <- split(dta, dta$Levels)
      l2 <- leaflet() %>% addTiles(tilesURL)
      library(purrr)
      names(ops.df) %>%
        purrr::walk(function(df){
          l2 <<- l2 %>%
            addMarkers(data=ops.df[[df]],
                       lng=~long, lat=~lat,
                       popup=~paste(sep = "<br/>",
                                    paste(sep=" ", "<b>Date :</b>",as.character(Mission.Date)),
                                    paste(sep=" ", "<b>Country :</b>", as.character(Target.Country)),
                                    paste(sep=" ", "<b>City :</b>",as.character(Target.City)),
                                    paste(sep =" ", "<b>Bomb Weight :</b>", as.character(Total.Weight..Tons.), "tons"),
                                    paste(sep=" ", "<b>Number of Attacks :</b>",as.character(Missions))),
                       group = df,
                       clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F, 
iconCreateFunction=JS("function (cluster) {var childCount = cluster.getChildCount();  
                                           if (childCount < 50) {  
                                              c = 'rgba(233, 227, 62, 0.8);'
                                           } else if (childCount < 1000) {  
                                              c = 'rgba(255, 140, 0, 0.8);'
                                           } else { 
                                              c = 'rgba(153, 0, 0, 0.8);'
                                           }
                                           return new L.DivIcon({ html: '<div style=\"background-color:'+c+'\"><span>' + childCount + '</span></div>', className: 'marker-cluster', iconSize: new L.Point(80, 80) });
                                          }")),                      
                       labelOptions = labelOptions(noHide = F, direction = 'auto'))
        })
      
      # PURRR
      l2 %>%
        addLayersControl(
          overlayGroups = names(ops.df),
          options = layersControlOptions(collapsed = FALSE)
        )
    })
  })
  
  ###Barplot on conditionnal panel
  output$BarClust <- renderPlot({
    input$mapButtonCluster  #ajout de dépendance au bouton & isolate leaflet
    isolate({
      if(input$Cluster == "Mission"){dta=opsMissions}
      else if(input$Cluster == "Year"){dta=opsYear}
      else{dta=opsDamage}
      
      ggplot(dta)+aes(x=Levels)+geom_bar(stat="count", fill="RoyalBlue4")+
        labs(x="Levels", y="Count", title = "Number of Missions")

    })
  })
  
  
  
  

  
  #############################################################################################################
  ############################################# 5. Visu Elegante ##############################################
  #############################################################################################################
  
  ###Metrics Graphiques
  output$PeriodMissions <- renderMetricsgraphics({
    input$metricGO
    isolate({
      if(input$Period == "Month by Month"){
        mjs_plot(Total.by.Month, Month_Date, y=Missions) %>%
          mjs_labs(x="", y="Number of bombing missions") %>%
          mjs_axis_x(xax_format = "date") %>%
          mjs_axis_y(extended_ticks=TRUE, rug=TRUE) %>%
          mjs_add_marker(as.Date("1944-06-06"), "D-day") %>%
          mjs_line(animate_on_load=TRUE,area=TRUE, color = input$Color, interpolate = input$Type)
      }
      else{
        mjs_plot(Total.by.Year, x=Year, y=Missions) %>%
          mjs_labs(x="", y="Number of missions") %>%
          mjs_axis_y(extended_ticks=TRUE, rug=TRUE) %>%
          mjs_add_marker(1944.432, "D-day") %>%
          mjs_line(animate_on_load=TRUE,area=TRUE, color = input$Color, interpolate = input$Type)
      }
    })
  })
  
  ### Observe pour selection des années
  
  observe({
    if("All" %in% input$tc_annee){
      selected_choices = All_annee[-1] #choisir toute les variables
    }
    else{
      selected_choices = input$tc_annee} #update l'input choisie par l'utilisateur
    updateSelectInput(session, "tc_annee", selected=selected_choices)
  }
  )
  
  output$selected <- renderText({paste(input$tc_annee, collapse=" ,")})
  
  observeEvent(input$Target_country_button, {
    cat("Showing", input$tc_annee)
  })
  
  
  observe({
    if("All" %in% input$t_ops_annee){
      selected_choices = All_annee[-1] #choisir toute les variables
    }
    else{
      selected_choices = input$t_ops_annee} #update l'input choisie par l'utilisateur
    updateSelectInput(session, "t_ops_annee", selected=selected_choices)
  }
  )
  
  output$selected <- renderText({paste(input$t_ops_annee, collapse=" ,")})
  
  observeEvent(input$Theatre_opButton, {
    cat("Showing", input$t_ops_annee)
  })
  
  ###Plotly
  output$TargetCountry <- renderPlotly ({
    input$Target_country_button
    isolate(target_country <- operations %>%
              group_by(Target.Country, Year) %>%
              summarise(Attacks = n()) %>%
              filter(Attacks > input$attak_mini & Year %in% input$tc_annee))
    p <- ggplot(target_country)+aes(x=Target.Country, y=Attacks, fill=Target.Country)+geom_bar(stat="identity")+scale_fill_hue(l=20)+
      labs(x="Country", y= "Total number of attacks", title="Total number of attacks on each country during the WWII") + theme(axis.text.x = element_blank())
    ggplotly(p)
  })
  
  output$Theatre_ops_plotly <- renderPlotly({
    input$Theatre_opButton
    isolate(
      theatre_ops <- theatre_ops %>%
        filter(Year %in% input$t_ops_annee))
    p <- ggplot(theatre_ops)+aes(x=Theater.of.Operations, y=Attacks, fill=Year)+geom_bar(stat = "identity")+scale_fill_hue(l=20)+
      labs(x="Theater of operations", y="Total number of attacks", title="Total number of attacks on each theater of operations during WWII")
    ggplotly(p)
  })
  

  #end of serveur  
}
  
  
  
  