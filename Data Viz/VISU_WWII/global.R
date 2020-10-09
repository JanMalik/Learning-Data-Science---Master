##################################
### Thilbaut Allin & Jan Malik ###
###      25 November 2018      ###
##################################

###################################################################################################
########################################## 0.0 Libraries ##########################################
###################################################################################################

library(ggplot2) # For elegant data visualisation
library(leaflet) # For interactive web maps (JavaScript library)
library(dplyr) # For data manipulation
library(lubridate) # For dealing with dates a little easier : functions year, month...
library(shiny) # For the wab application framework
library(RColorBrewer) # For color brewer palettes
library(metricsgraphics) # For interactive mjs graphics
library(wordcloud)
library(plotly)
library(leaflet.minicharts)
#library(knitr) #kable (création de la legende)
library(purrr) #Pour choix du clustering sur leaflet

#Attention à ça ! 
#setwd("D:/Users/Jan Malik/Studia/Agro/Visu/VISU_WWII")
# getwd()


#######################################################################################################
################################ 0.1 Data set import and Manipulation #################################
#######################################################################################################

### Import Data
operations <- read.csv("operations.csv", sep=",", header=TRUE)

### Format Date
operations$Mission.Date <- as.Date(operations$Mission.Date, format = "%m/%d/%Y")

### Préciser le format numeric de la variable Takeoff latitude (de toute façon on ne la prendra pas en compte....ar trop d'erreurs ect...)
operations$Takeoff.Latitude <- as.numeric(as.character(operations$Takeoff.Latitude))

### Remplacer les NA par des 0 pour le poids en tonne
# Variable qui servira à definir la taille des circles du leaflet (au moins que ces points apparaissent)
operations$Total.Weight..Tons. <- ifelse(is.na(operations$Total.Weight..Tons.) == TRUE, 0, operations$Total.Weight..Tons.)
#Au moins qu'ils apparaissent un peu plus gros (car ^mus de 12.000 vaeurs à zéro) et 0.012 car c'est le min
operations$Total.Weight..Tons. <- ifelse(operations$Total.Weight..Tons. == 0, 0.012, operations$Total.Weight..Tons.)


### Idem pour Target.Priority 
# (si on utilise) pour la taille des circles du leaflet() en mettant 17 pour la priorité car 16 en était le max 
operations$Target.Priority <- ifelse(is.na(operations$Target.Priority)==TRUE, 17, operations$Target.Priority )


### Rettre les mauvaises coordonnes en bien
dfCoord <- operations %>%
  arrange(Target.Longitude)
a <- dfCoord$Target.Longitude[14:18]
dfCoord$Target.Longitude[14:18] <- dfCoord$Target.Latitude[14:18]
dfCoord$Target.Latitude[14:18] <- a
rm(a)
#remettre au 'meme' niveau la longitude des Japan Navy sinon sur la carte ça apparait a l'opposee des autres
dfCoord$Target.Longitude[1:13] <- -1*dfCoord$Target.Longitude[1:13]
dfCoord <- dfCoord %>%
  arrange(-Target.Latitude)
dfCoord$Target.Latitude[1] <- dfCoord$Target.Latitude[1]/100
#Maniupation pour mettre les bonnes coordonnées car pour toutes ces villes toutes les coordonnees sont mauvaises
dfCoord[dfCoord$Target.City == "EMMERICH",]$Target.Latitude <- 51.84
dfCoord[dfCoord$Target.City == "EMMERICH",]$Target.Longitude <- 6.25

dfCoord[dfCoord$Target.City == "LINDEN",]$Target.Longitude <- 10.562161
dfCoord[dfCoord$Target.City == "LINDEN",]$Target.Latitude <- 52.150173

dfCoord[dfCoord$Target.City == "VALKENBURG",]$Target.Longitude <- 5.8320515
dfCoord[dfCoord$Target.City == "VALKENBURG",]$Target.Latitude <- 50.8652306

dfCoord[dfCoord$Target.City == "PAUILLAC",]$Target.Longitude <- -0.7488
dfCoord[dfCoord$Target.City == "PAUILLAC",]$Target.Latitude <- 45.1999

dfCoord[dfCoord$Target.City == "GREISHEIM",]$Target.Longitude <- 8.5676441	
dfCoord[dfCoord$Target.City == "GREISHEIM",]$Target.Latitude <- 49.861426

dfCoord[dfCoord$Target.City == "VIERZON",]$Target.Longitude <- 2.069791	
dfCoord[dfCoord$Target.City == "VIERZON",]$Target.Latitude <- 47.221438

dfCoord[dfCoord$Target.City == "HOFEN",]$Target.Longitude <- 10.691519	
dfCoord[dfCoord$Target.City == "HOFEN",]$Target.Latitude <- 47.472493

dfCoord[dfCoord$Target.City == "RUMMELSBURG",]$Target.Longitude <- 13.4925
dfCoord[dfCoord$Target.City == "RUMMELSBURG",]$Target.Latitude <- 52.5

dfCoord[dfCoord$Target.City == "WILLEMSOORD",]$Target.Longitude <- 6.058611	
dfCoord[dfCoord$Target.City == "WILLEMSOORD",]$Target.Latitude <- 52.824444

dfCoord[dfCoord$Target.City == "TERSCHELLING",]$Target.Longitude <- 5.31527		
dfCoord[dfCoord$Target.City == "TERSCHELLING",]$Target.Latitude <- 53.391354

dfCoord[dfCoord$Target.City == "EMS",]$Target.Longitude <- 7.71924
dfCoord[dfCoord$Target.City == "EMS",]$Target.Latitude <- 50.3340619

dfCoord[dfCoord$Target.City == "LA BASSEE",]$Target.Longitude <- 2.8081		
dfCoord[dfCoord$Target.City == "LA BASSEE",]$Target.Latitude <- 50.5342

dfCoord[dfCoord$Target.City == "MONDEVILLE",]$Target.Longitude <- -0.32238	
dfCoord[dfCoord$Target.City == "MONDEVILLE",]$Target.Latitude <- 49.17497

dfCoord[dfCoord$Target.City == "OSSUN",]$Target.Longitude <- -0.0253
dfCoord[dfCoord$Target.City == "OSSUN",]$Target.Latitude <- 43.1847

dfCoord[dfCoord$Target.City == "LE CHATELET",]$Target.Longitude <- 0.633242
dfCoord[dfCoord$Target.City == "LE CHATELET",]$Target.Latitude <- 47.131705

dfCoord[dfCoord$Target.City == "LA BELLE",]$Target.Longitude <- 4.7427362
dfCoord[dfCoord$Target.City == "LA BELLE",]$Target.Latitude <- 44.9969293

dfCoord[dfCoord$Target.City == "HEINSBERG",]$Target.Longitude <- 6.1183729
dfCoord[dfCoord$Target.City == "HEINSBERG",]$Target.Latitude <- 51.0600381

dfCoord[dfCoord$Target.City == "SCHWANDORF",]$Target.Longitude <- 12.1091352
dfCoord[dfCoord$Target.City == "SCHWANDORF",]$Target.Latitude <- 49.3198883

dfCoord[dfCoord$Target.City == "LICHTENBERG",]$Target.Longitude <- 11.6731945
dfCoord[dfCoord$Target.City == "LICHTENBERG",]$Target.Latitude <- 50.3824451

dfCoord[dfCoord$Target.City == "RAS EL ALI",]$Target.Longitude <- 9.30861
dfCoord[dfCoord$Target.City == "RAS EL ALI",]$Target.Latitude <- 37.1547

#On prend en compte ses modifications
operations <- dfCoord %>%
  arrange(Mission.Date)
#on efface dfCoord pour libérer de l'espace
rm(dfCoord)

##########################################################################################################
########################################## 0.2 Data Preparation ##########################################
##########################################################################################################


#Du menage! : raccourcir les noms car trop long
operations$Target.Industry <- as.factor(operations$Target.Industry)
Industries <- data.frame(Industry = unique(operations$Target.Industry))

Rail <- filter(operations, Target.Industry == Industries[4,])
Not.Rail <- filter(operations, Target.Industry != Industries[4,])
Rail$Target.Industry <- "RAIL NETWORK"
operations <- rbind(Rail, Not.Rail)
rm(Rail) ; rm(Not.Rail)

Utilities <- filter(operations, Target.Industry == Industries[24,])
Not.Utilities <- filter(operations, Target.Industry != Industries[24,])
Utilities$Target.Industry <- "PUBLIC UTILITIES"
operations <- rbind(Utilities, Not.Utilities)
rm(Utilities) ; rm(Not.Utilities)

Steel.Fact <- filter(operations, Target.Industry == Industries[29,])
Not.Steel.Fact <- filter(operations, Target.Industry != Industries[29,])
Steel.Fact$Target.Industry <- "STEEL FACTORIES"
operations <- rbind(Steel.Fact, Not.Steel.Fact)
rm(Steel.Fact); rm(Not.Steel.Fact)

Tugs <- filter(operations, Target.Industry == Industries[48,])
Not.Tugs <- filter(operations, Target.Industry != Industries[48,])
Tugs$Target.Industry <- "TUGS AND BARGES"
operations <- rbind(Tugs, Not.Tugs)
rm(Tugs) ; rm(Not.Tugs)

Tact.Targ <- filter(operations, Target.Industry == Industries[8,])
Not.Tact.Targ <- filter(operations, Target.Industry != Industries[8,])
Tact.Targ$Target.Industry <- "TACTICAL TARGETS"
operations <- rbind(Tact.Targ, Not.Tact.Targ)
rm(Tact.Targ) ; rm(Not.Tact.Targ)

Cities <- filter(operations, Target.Industry == Industries[1,])
Not.Cities <- filter(operations, Target.Industry != Industries[1,])
Cities$Target.Industry <- "URBAN AREAS"
operations <- rbind(Cities, Not.Cities)
rm(Cities) ; rm(Not.Cities)

V.Weap <- filter(operations, Target.Industry == Industries[19,])
Not.V.Weap <- filter(operations, Target.Industry != Industries[19,])
V.Weap$Target.Industry <- "V-WEAPON LAUNCH SITES"
operations <- rbind(V.Weap, Not.V.Weap)
rm(V.Weap) ; rm(Not.V.Weap)

Supply.Dump <- filter(operations, Target.Industry == Industries[7,])
Not.Supply.Dump <- filter(operations, Target.Industry != Industries[7,])
Supply.Dump$Target.Industry <- "SUPPLY DUMP"
operations <- rbind(Supply.Dump, Not.Supply.Dump)
rm(Supply.Dump) ; rm(Not.Supply.Dump)

Transport <- filter(operations, Target.Industry == Industries[16,])
Not.Transport <- filter(operations, Target.Industry != Industries[16,])
Transport$Target.Industry <- "TRANSPORT FACILITIES"
operations <- rbind(Transport, Not.Transport)
rm(Transport) ; rm(Not.Transport)

Aircraft.Fact <- filter(operations, Target.Industry == Industries[15,])
Not.Aircraft.Fact <- filter(operations, Target.Industry != Industries[15,])
Aircraft.Fact$Target.Industry <- "AIRCRAFT FACTORY"
operations <- rbind(Aircraft.Fact, Not.Aircraft.Fact)
rm(Aircraft.Fact); rm(Not.Aircraft.Fact)

rm(Industries)

operations$Target.Industry[operations$Target.Industry == "TACTICAL TARGETS: (UNIDENTIFIED OR NOT LISTED BELOW)"] <- "TACTICAL TARGETS"




##########################################################################################################
########################################### 0.3 Data Creation ############################################
##########################################################################################################



### Par endroit (pour le leaflet Bomb Damage)
Total.by.place <- operations %>% 
  group_by(Mission.Date, Target.City, Target.Country, Target.Longitude, Target.Latitude) %>% 
  summarise(Total.Weight..Tons. = sum(Total.Weight..Tons.), Missions = n())


### Par Target Country pour des Barplots dans leaflet
Total.by.Day.Country <- operations %>%
  group_by(Mission.Date, Target.Country) %>%
  summarise(Missions = n())

### Triage des inconnues pour les pays (barplots ect...)
Total.by.Day.Country <-Total.by.Day.Country[Total.by.Day.Country$Target.Country != "UNKNOWN OR NOT INDICATED",] 
Total.by.Day.Country <-Total.by.Day.Country[Total.by.Day.Country$Target.Country != "UNKNOWN",] 
Total.by.Day.Country <-Total.by.Day.Country[Total.by.Day.Country$Target.Country != "",] 

###Nombre de mission (années/mois/jours) avec dplyr
#création nouvelle variable mois et année
operations <- operations %>% 
  mutate(Month = format(Mission.Date, "%Y-%m")) %>%
  mutate(Year = format(Mission.Date, "%Y"))

Total.by.Day <- operations %>% 
  group_by(Mission.Date) %>% 
  summarise(Missions = n())

Total.by.Month <- operations %>%
  group_by(Month) %>%
  summarise(Missions = n())

Total.by.Month <- Total.by.Month %>%
  mutate(Month_Date = paste(sep="-", Month, "01"))
Total.by.Month$Month_Date <- as.Date(Total.by.Month$Month_Date, format="%Y-%m-%d") #pour les graphics mjs

Total.by.Year <- operations %>%
  group_by(Year) %>%
  summarise(Missions = n())




###############################################################################################################
############################################ 2&3&4 Leaflets ###################################################
###############################################################################################################


### fond gris (addTiles)
tilesURL <- "http://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer/tile/{z}/{y}/{x}"


### Pour le Barplot

Missions.By.Industrie <- operations %>% 
  group_by(Target.Industry) %>% 
  summarise(Raided = n()) %>% 
  mutate(Proportion = round(Raided/sum(Raided),4)) 
Missions.By.Industrie <- Missions.By.Industrie[order(-Missions.By.Industrie$Raided),]


#Pour la palette de couleur en fnction du nombre d'attaque
Total.by.place <- Total.by.place %>%
  mutate(Missions_Levels = cut(Missions, breaks=c(0,1,5,10,50, 100,324),  labels = c("1", "2 - 5", "6 - 10", "11 - 50", "51 - 100",  "101 - 324")))


# pal <- colorFactor(palette = "Reds", levels =
#                      levels(Total.by.place$Missions_Levels))

#manuel : à changer les couleurs
pal <- colorFactor(palette = c("#E9E33E", "#D17C27", "#FF8C00", "#F11212", "#BB0000"), 
                   levels = levels(Total.by.place$Missions_Levels))


### Leaflet Clusters

#Clustering sur niveaux de Missions (certes répétition mais pas même levels et pas même légende)
opsMissions <- Total.by.place %>%
  mutate(Levels = cut(Missions, breaks=c(0,3,10,100,324),  labels = c("1 - 3", "4 - 10", "11 - 100", "+ 101")))
colnames(opsMissions)[4:5]<- c("long", "lat")

#Sur niveau de Year"
opsYear <- Total.by.place %>%
  mutate(Levels = cut(year(Mission.Date), breaks=c(0,1939,1940,1941,1942,1943,1944,1945),  labels = c("1939", "1940", "1941", "1942", "1943", "1944", "1945")))
colnames(opsYear)[4:5]<- c("long", "lat")

#Sur niveau de Weight..Tons
opsDamage <- Total.by.place %>%
  mutate(Levels = cut(Total.Weight..Tons., breaks=c(0,10,100,1000,10000, 20000),  labels = c("0 - 10", "11 - 100", "101 - 1000", "1001 - 10000", "+ 10001")))
colnames(opsDamage)[4:5]<- c("long", "lat")


# 'Basemap' 
l <- leaflet() %>% addTiles(tilesURL)






################################################################################################################
########################################### 5 Visu Elegante ####################################################
################################################################################################################

### SelectInput multiple avec All en observe

All_annee <- c("All", "1939", "1940", "1941", "1942", "1943", "1944", "1945")

### pour les Plotly
target_country <- operations %>%
  group_by(Target.Country) %>%
  summarise(Attacks = n()) %>%
  filter(Attacks > 3000)

theatre_ops <- operations %>%
  group_by(Theater.of.Operations, Year) %>%
  summarise(Attacks = n())

theatre_ops <- theatre_ops[-c(1:6 ,11:15, 23),] #car "N.A.s"
