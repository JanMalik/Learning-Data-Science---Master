###############################
### Bryan Jacob & Jan Malik ###
###      03 March 2018      ###
###############################

server <- function(input, output, session) {
  #Triage des tables en mode décroissant pour selectionner les 4 départements dans les variables sont les plus grandes 
  output$map1 <- renderPlot({
    if (input$Test=="Départements les mieux équipés"){
      tri <- dataComplet[,c("Département",input$colonneDes)]
      names(tri) <- c("DEP", "Col2")
      tri <- tri[order(-tri$Col2),]
      ggplot(tri[1:4,])+aes(x=DEP, y=Col2, fill=DEP)+geom_bar(stat="identity")+labs(x="Départements", y="Quantité", title="Départements les mieux déservis")+scale_fill_manual(values = wes_palette("GrandBudapest1"))
    }#distribution représentée par un graphiques dit de type "violon"
    else if (input$Test=="Distribution continue par quartile de la variable"){
      if (input$colonneDes =="Musée"||input$colonneDes == "Conservatoire"){
        print(0)
      }#les catégories musée et conservatoire ne présentent que une variable chaqu'une donc tracé ce type de graphiques n'est pas possible : on choisie donc de ne rien afficher
      else{
        table_violin <- get(input$colonneDes)
        table_violin <- within(table_violin, quartile <- as.integer(cut(table_violin[,4], quantile(table_violin[,4], probs=0:4/4), include.lowest=TRUE)))
        ggplot(table_violin)+aes(x=quartile, y=get(input$colonneDes), group=quartile)+labs(x="Quartile du nombre d'équipements", y="Quantité", title="Répartition de la variable selon les quartiles")+geom_violin(fill=wes_palette(n=1,"GrandBudapest1"), color=wes_palette(n=1,"GrandBudapest1"))
      }
    }
    else if(input$Test=="Densité de la variable"){
      ggplot(get(input$colonneDes))+ aes(x=get(input$colonneDes)) +labs(y="Densité de la variable") + geom_density(color=wes_palette(n=1,"GrandBudapest1"), kernel="gaussian", fill=wes_palette(n=1,"GrandBudapest1"))+labs(x=input$colonneDes, y="Densité", title="Densité de la variable")
    }
    else if(input$Test=="Distribution discréte par quartile de la variable"){
      if (input$colonneDes =="Musée"||input$colonneDes == "Conservatoire"){
        print(0)
      }
      else{
        table_jitter <- get(input$colonneDes)
        table_jitter <- within(table_jitter, quartile <- as.integer(cut(table_jitter[,4], quantile(table_jitter[,4], probs=0:4/4), include.lowest=TRUE)))
        ggplot(table_jitter)+aes(x=quartile, y=get(input$colonneDes))+labs(y="Quantité", x="Quartile du nombre d'équipements", title="Répartition de tout type d'aires de freestyle selon le nombre d'équipements couverts")+geom_jitter(color=wes_palette(n=1,"GrandBudapest1"), size=4)+stat_summary(fun.y=mean, geom="point", shape=18,size=6, color="royalblue4")+stat_summary(fun.y=median, geom="point", shape=18,size=6, color="red")
      }
    }
    else if(input$Test=="Distribution bivariée de variables"){
      if (input$colonneDes =="Musée"||input$colonneDes == "Conservatoire"){
        print(0)
      }
      else{
        table_hex <- get(input$colonneDes)
        ggplot(table_hex)+aes(x=get(input$colonneDes), y=table_hex[,4])+labs(title="Distribution bivariée", x=input$colonneDes, y=colnames(table_hex)[4], fill="Quantité")+geom_hex(size=25)+scale_fill_continuous(low="yellow", high="red") #représentatoin é l'aide d'hexagon de couleurs plus ou moins intenses.
      }
    }
    else if(input$Test=="Nuage de points"){
      if (input$colonneDes =="Musée"||input$colonneDes == "Conservatoire"){
        print(0)
      }
      else{
        table_lm <- get(input$colonneDes)
        ggplot(table_lm)+aes(x=get(input$colonneDes), y=table_lm[,4])+labs(x=input$colonneDes, y=colnames(table_lm)[4], title="Nuage des points du nombre d'équipements")+geom_point(color=wes_palette(n=1,"GrandBudapest1"), size=5)+geom_smooth(se=FALSE)
      } 
    }#nuage de points classiques avec une courbe de prédiction é l'aide de la fonction geom_smooth et de la method par défault
  }, height = 700, width = 1000)
  
  output$mymap <- renderLeaflet({ #Définition d'une map leaflet dans un output avec renderLeafet
    x <- dataComplet[, c(input$colonne, "Département", "Numéro du département", "Longitude", "Latitude", "Population (2016)")]
    #Création d'une table temporaire avec les informations que l'on souhaite conserver
    pal <- colorNumeric(palette = "RdYlBu", domain = x[, input$colonne]/x[, "Population (2016)"]*100000)
    #Définition d'une palette de couleur pour la densité 
    n <- leaflet(data = x) %>% addTiles() %>%
      addPolylines(data = depFrance, lng=~Longitude, lat=~Latitude, color = "black", weight = 2) %>%
      addCircles(lng = ~Longitude, lat = ~Latitude, weight = 1,
                 radius = ~sqrt(get(input$colonne)) * 35000/sqrt(mean(get(input$colonne))),
                 popup = ~paste(sep = "<br/>",
                                paste(sep =" ", "<b>Département:</b>", `Département`),
                                paste(sep =" ", "<b>Numéro du département:</b>", `Numéro du département`),
                                paste(sep =" ", "<b>Population (2016):</b>", format(`Population (2016)`, big.mark = " ")),
                                paste(sep =" ", "<b>Quantité de l'élément sélectionné:</b>", format(get(input$colonne), big.mark = " ")),
                                paste(sep =" ", "<b>Densité (pour 100 000 hab):</b>", format(round((get(input$colonne)/`Population (2016)`*100000), 2), big.mark = " "))
                 ),
                 color = ~pal(get(input$colonne)/`Population (2016)`*100000),
                 fillOpacity = 0.9,
                 stroke = TRUE
      ) %>%
      addLegend(pal = pal, values = ~(get(input$colonne)/`Population (2016)`*100000), title = paste(sep ="<br/>", "Densité de la variable par", "département (pour 100 000 hab)"))
    #Définition et options du leaflet
  })
  output$meanLeaflet <- renderText({
    format(round(mean(as_vector(dataComplet[, input$colonne])),2), big.mark = " ")
  })
  #Stockage de la moyenne dans un output
  output$sdLeaflet <- renderText({
    format(round(sd(as_vector(dataComplet[, input$colonne])),2), big.mark = " ")
  })
  #Stockage de l'écart-type dans un output
  output$maxLeaflet <- renderText({
    format(round(max(as_vector(dataComplet[, input$colonne])),2), big.mark = " ")
  })
  #Stockage du maximum dans un output
  output$minLeaflet <- renderText({
    format(round(min(as_vector(dataComplet[, input$colonne])),2), big.mark = " ")
  })
  #Stockage du minimum dans un output
  output$densLeaflet <- renderText({
    format(round(sum(as_vector(dataComplet[, input$colonne]))/sum(as_vector(dataComplet$`Population (2016)`))*100000,2), big.mark = " ")
    #Stockage de la densité moyenne dans un output
  })
  output$minDensLeaflet <- renderText({
    format(round(min(dataComplet[, input$colonne]/dataComplet$`Population (2016)`)*100000,2), big.mark = " ")
  })
  #Stockage de la densité minimale dans un output
  output$maxDensLeaflet <- renderText({
    format(round(max(dataComplet[, input$colonne]/dataComplet$`Population (2016)`)*100000,2), big.mark = " ")
  })
  #Stockage de la densité maximale dans un output
  
  output$pointPlot <- renderPlot({
    ggplot(data = dataRegLineaire) + aes(x=get(input$colonneTest), y=`Nombre de licenciés (2015)`) + geom_point() + geom_smooth(method='lm',formula=y~x) + geom_point(data=dataRegLineaire, aes(x=get(input$colonneTest), y=`Prediction`), colour="red") + geom_segment(data=dataRegLineaire, aes(x = get(input$colonneTest), y = `Nombre de licenciés (2015)`, xend = get(input$colonneTest), yend = `Prediction`),colour="blue",alpha=0.5) + xlab(input$colonneTest) + ylab("Valeur réelle et prédite du nombre de licenciés") + ggtitle(paste("Nombre de licenciés réel et prédit par rapport é la variable '", input$colonneTest, "'", sep="")) + theme(plot.title = element_text(hjust = 0.5, face="bold"))
    #Définition du graphique de la régression linéaire dans un output
  }, height = 700, width = 1000)
  
  output$coeff <- renderText({
    format(round(regLineaire$coefficients[match(input$colonneTest, names(dataRegLineaire))+1],2),big.mark = " ")
  })
  #Stockage du coefficient de la régression linéaire dans un output
  output$sdCoeff <- renderText({
    format(round(unname(coef(summary(regLineaire))[,2])[match(input$colonneTest, names(dataRegLineaire))+1],2),big.mark = " ")
  })
  #Stockage de l'écart-type du coefficient de la régression linéaire dans un output
  output$statCoeff <- renderText({
    format(round(unname(coef(summary(regLineaire))[,3])[match(input$colonneTest, names(dataRegLineaire))+1],2),big.mark = " ")
  })
  #Stockage de la statistique de Fisher du coefficient de la régression linéaire dans un output
  output$pvalCoeff <- renderText({
    format(round(unname(coef(summary(regLineaire))[,4])[match(input$colonneTest, names(dataRegLineaire))+1],2),big.mark = " ")
  })
  #Stockage de la P_value du coefficient de la régression linéaire dans un output
  output$boxPlotReg <- renderPlot({
    ggplot(data = dataRegLineaire) + aes(x = "", y = get(input$colonneTest)) + geom_boxplot(fill="#56B4E9") + coord_flip() + ylab(paste(sep = " ", "Nombre de", input$colonneTest)) + xlab(input$colonneTest) + ggtitle(paste(sep=" ","Répartition du nombre de", input$colonneTest, "par département")) + theme(plot.title = element_text(hjust = 0.5, face="bold"))
  })
  #Définition d'une boîte à moustache pour la variable sélectionnée
}