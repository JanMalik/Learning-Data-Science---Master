#######################
###    Malik Jan    ###
### 11 October 2018 ###
#######################

# Libraries

import pyspark
import random

#Création du sparkContext
sc = SparkContext.getOrCreate()

#Manipulation de la RDD à partir d'un fichier
fileRDD = sc.textFile("/data/FileWC.txt")

#Compter le nombre de lignes du fichier
print(str(fileRDD.count()))

#Compter le nombre de lignes contenant elephant
elephantsRDD = fileRDD.filter(lambda a: "elephant" in a)
print("nb de ligne contenant Elephant : "+str(elephantsRDD.count()))

#Compter le nombre d'occurence des mots dans le fichier
#words = fileRDD.flatMap(lambda x: x.split(" "))
#res = words.map(lambda x: (x, 1)).reduceByKey(lambda x,y: x + y)
#motsRDD = res.sortByKey()
#print(motsRDD.collect())
#ou tout en même temps
wordsRDD = fileRDD.flatMap(lambda x: x.split(" ")).map(lambda x: (x, 1)).reduceByKey(lambda x,y: x + y).sortByKey()
print(wordsRDD.collect())


#A ne sourtout pas oublier sinon le sparkcontext continue à tourner (chiant pour tout le monde sur le serveur)
sc.stop()

