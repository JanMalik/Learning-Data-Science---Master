###############################
### Bryan Jacob & Jan Malik ###
###      03 March 2018      ###
###############################

library(tidyverse)
library(leaflet)
library(ggmap)
library(maps)
library(shiny)
#install.packages("wesanderson")
library(wesanderson) #pour la couleur

dataEquipSportLoisir <- read_csv2("data/equip_sport_loisir.csv", locale = locale(encoding = "UTF8"))[-c(1:3)] %>%
  group_by(`Département`) %>%
  summarise_each(funs(sum))
#Importation des données BPE de l'INSEE (Disponible sur https://www.insee.fr/fr/statistiques/1893257ésommaire=2044564&q=BPE)
#et regroupement par département

coordDepartement <- read_csv("data/dep_coord.csv", locale = locale(encoding = "UTF8"))
#Coordonnées des départements

popDepartement <- read_csv2("data/population_dep.csv", col_types = cols(POPULATION = col_double()))
#Population des départements

licencesDepartement <- read_csv2("data/licences_2015.csv", locale = locale(encoding = "UTF-8")) %>% 
  select(-X1)
#Nombre de licenciés au sein d'une fédération par département (Disponible sur https://www.data.gouv.fr/fr/datasets/recensement-des-licences-par-federation-sportive-et-par-commune/)

dataComplet <- coordDepartement %>% 
  inner_join(popDepartement, by =c("NUM" = "DEP")) %>%
  inner_join(dataEquipSportLoisir, by = c("NUM" = "Département")) %>%
  inner_join(licencesDepartement, by = c("NUM" = "DEP")) %>%
  rename("Département" = "DEP", "Numéro du département" = "NUM", "Latitude" = "LAT", "Longitude" = "LON", "Population (2016)" = "POPULATION", "Nombre de licenciés (2015)" = "nb_linc")
#Jointure de tous ces fichiers au sein d'une méme table

#Extraction de la table compléte en plusieurs tables selon les catégories pour ensuite silplifier les codes de type ggplot2(geom_...) du premier onglet : les graphiques descriptifs

`Dep` <- dataComplet[,1:2]
`Bassin de natation` <- cbind(Dep, dataComplet[-1][,5:8]) 
`Boulodrome` <- cbind(Dep, dataComplet[-1][,9:12])
`Tennis` <- cbind(Dep, dataComplet[-1][,13:16])
`équipement de cyclisme` <- cbind(Dep, dataComplet[-1][,17:20])
`Domaine skiable` <- cbind(Dep, dataComplet[-1][,21:24])
`Centre équestre` <- cbind(Dep, dataComplet[-1][,25:28])
`Athlétisme` <- cbind(Dep, dataComplet[-1][,29:32])
`Terrain de golf` <- cbind(Dep, dataComplet[-1][,33:36])
`Parcours sportif/santé` <- cbind(Dep, dataComplet[-1][,37:40])
`Sports de glace` <- cbind(Dep, dataComplet[-1][,41:44])
`Plateaux et terrains de jeux extérieurs` <- cbind(Dep, dataComplet[-1][,45:48])
`Salles spécialisées` <- cbind(Dep, dataComplet[-1][,49:52])
`Terrains de grands jeux` <- cbind(Dep, dataComplet[-1][,53:56])
`Salles de combat` <- cbind(Dep, dataComplet[-1][,57:60])
`Salles non spécialisées` <- cbind(Dep, dataComplet[-1][,61:64])
`Roller-Skate-Vélo bicross ou freestyle` <- cbind(Dep, dataComplet[-1][,65:68])
`Sports nautiques` <- cbind(Dep, dataComplet[-1][,69:72])
`Bowling` <- cbind(Dep, dataComplet[-1][,73:76])
`Salles de remise en forme` <- cbind(Dep, dataComplet[-1][,77:80])
`Salles multisports (gymnase)` <- cbind(Dep, dataComplet[-1][,81:84])
`Baignade aménagée` <- cbind(Dep, dataComplet[-1][,85:86])
`Mouillage` <- cbind(Dep, dataComplet[-1][,87:88])
`Boucle de randonnée` <- cbind(Dep, dataComplet[-1][,89:90])
`Théétre` <- cbind(Dep, dataComplet[-1][,91:92])
`Cinéma` <- cbind(Dep, dataComplet[-1][,93:94])
`Musée` <- cbind(Dep, dataComplet[-1][,95])
`Conservatoire` <- cbind(Dep, dataComplet[-1][,96])

depFrance <- map(database="france", fill = FALSE)
depFrance <- as_tibble(data.frame(Longitude=depFrance$x,Latitude=depFrance$y))
#Stockage des frontiéres des départements au sein d'une table

dataRegLineaire <- dataComplet[, -c(1,2,3,4,5)]
regLineaire <- lm(data = dataRegLineaire, `Nombre de licenciés (2015)` ~ .-1)
vecteurPValue <- unname(coef(summary(regLineaire))[,4])
while (TRUE %in% (vecteurPValue>=0.025)) {
  index <- which(vecteurPValue == max(vecteurPValue))
  dataRegLineaire <- dataRegLineaire[, -index]
  regLineaire <- lm(data = dataRegLineaire, `Nombre de licenciés (2015)` ~ .-1)
  vecteurPValue <- unname(coef(summary(regLineaire))[,4])
}
#On enléve é chaque fois la variable la moins significative, et on recalcule les estimateurs jusqu'é que toutes les variables soient
#significatives au seuil de 0,025

dataRegLineaire <- dataRegLineaire[, -c(1,2,15,16)]
regLineaire <- lm(data = dataRegLineaire, `Nombre de licenciés (2015)`~.)
#Meilleur régression linéaire par validation croisée é dix blocs
dataRegLineaire <- cbind(dataRegLineaire, Prediction = regLineaire$fitted.values)