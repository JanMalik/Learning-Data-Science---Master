#######################
###    Malik Jan    ###
### 11 October 2018 ###
#######################

import pyspark

#Création du sparkContext
sc = SparkContext.getOrCreate()

#Manipulation de la RDD à partir d'une liste
linesRDD = sc.parallelize(["chien", "chat", "lapin", "cochon", "cheval"])

print(linesRDD.first())
print(linesRDD.collect())
print(linesRDD.count())

#A ne sourtout pas oublier sinon le sparkcontext continue à tourner (chiant pour tout le monde sur le serveur)
sc.stop()
