#######################
###    Malik Jan    ###
### 11 October 2018 ###
#######################

# Libraries

import pyspark

sc = SparkContext.getOrCreate()


#Preparation des données
lines = sc.textFile("/data/sentiments.tsv")
sRDD = lines.map(lambda x: x.split("\t"))
#Afficher les 5 premières lignes
print(sRDD.take(5))
print("---------------------")
#Nombre de lignes
print("Le nombre de lignes est :" + str(sRDD.count()))
print("---------------------")


#Nmb de commentaires positifs (3&4) et négatifs (0&1)
positif =sRDD.filter(lambda x: (x[3] == '4') | (x[3] == '3'))
print("Nombres de commentaires positifs :" +str(positif.count()))
print("---------------------")
negatif =sRDD.filter(lambda x: (x[3] == '0') | (x[3] == '1'))
print("Nombres de commentaires negatifs :" +str(negatif.count()))
print("---------------------")

#Compter occurence des mots
word_count = sRDD.flatMap(lambda x : x[2].split(" ")).map(lambda x : (x,1)).reduceByKey(lambda x,y : x+y)
print("Words")
print("---------------------")
print(word_count.take(10)) #get top 10



sc.stop()