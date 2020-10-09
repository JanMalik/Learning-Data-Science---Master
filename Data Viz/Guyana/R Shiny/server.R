#######################
###    Jan Malik    ###
### 7 November 2018 ###
#######################

library(shiny)
library(maptools)
library(sp)
library(rgdal)
library(leaflet)


src_contour <- readShapeLines("data/contour_guyane.shp")
proj4string(src_contour) <- CRS("+init=epsg:2972")
src_wgs84 <- spTransform(src_contour, CRS("+proj=longlat +datum=WGS84"))

src_orp <- readShapePoints("data/orpaillage_hors_contraintes.shp")
orp <- data.frame(longi=src_orp$LON, lati=src_orp$LAT, texte=src_orp$STATUT)
orp <- orp[-which(is.na(orp$texte)),]


shinyServer(function(input, output, session) {
  output$mymap <- renderLeaflet({
    map <- leaflet(orp)
    map <- setView(map, lng=-54, lat=4, zoom=7)
    map <- addProviderTiles(map, providers$OpenStreetMap)
    map <- addMarkers(map, lng=~longi, lat=~lati, label=~texte)
    map <- addPolylines(map, data=src_wgs84)
  })
  
})
