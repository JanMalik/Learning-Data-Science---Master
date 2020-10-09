#######################
###    Malik Jan    ###
### 11 October 2018 ###
#######################

# Libraries

import pyspark

#Création du sparkContext
sc = SparkContext.getOrCreate()

#Manipulation de la RDD à partir d'un csv ; séparation par la virgule
lines = sc.textFile("/data/crimes_chicago_2012_2015.csv")
crimesRDD = lines.map(lambda x: x.split(","))

#Compter le nombre de crime par années
BestanneesRDD = crimesRDD.map(lambda x: (x[5],1)).reduceByKey(lambda x,y :x+y).sortByKey()
print(BestanneesRDD.first())

anneesRDD = crimesRDD.map(lambda x: (x[5],1)).reduceByKey(lambda x,y :x+y)
print("Le nombre de crimes par année est : " + str(anneesRDD.collect()))

#Copter les lignes ayant véhicules
vehiculeRDD = crimesRDD.map(lambda row: "VEHICULE" in row[1]) 
print(vehiculeRDD.count())

#Determiner le district le plus dangereux
districtRDD = crimesRDD.map(lambda x: (x[4],1)).reduceByKey(lambda x,y :x+y)
dang=districtRDD.sortBy(lambda row : row[1], ascending=False).first()
print("Le district le plus dangeureux est "+str(dang))

sc.stop()