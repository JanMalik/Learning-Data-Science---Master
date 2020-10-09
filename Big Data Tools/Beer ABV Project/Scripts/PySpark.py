################################
### Mallet Oscar & Malik Jan ###
###     21 November 2018     ###
################################

import pyspark
sc = SparkContext.getOrCreate()
lines = sc.textFile("beer_reviews.csv")
beer_RDD = lines.map(lambda x: x.split(","))


# 1) selectionner les American IPA:
AmIPA_RDD = beer_RDD.filter(lambda a: a[7] in "American IPA")


# Compter le nombre de American IPA dont le taux d'alcool est > à 5:
#beer_abv_RDD = (AmIPA_RDD
#.filter(lambda a : a[11].replace('.','',1).isdigit() and float(a[11])>5 )
#.map(lambda x :(x[11],1))
#.reduceByKey(lambda x,y : x+y))
                                                                    
#print(beer_abv_RDD.sortBy(lambda row : float(row[0]), ascending=False).collect())

# Quelles sont les bières qui ont le plus de review ?

#print((AmIPA_RDD
#.map(lambda x: (x[12],1))
#.reduceByKey(lambda x,y: x+y)).sortBy(lambda row : row[1], ascending=False).take(10))


# Quelles sont les meilleures bières en moyenne
moyenne_RDD = (AmIPA_RDD
.filter(lambda a : a[3].replace('.','',1).isdigit() and float(a[3])<=5.0 and a[11].replace('.','',1).isdigit())
.map(lambda x: (x[12],[x[3],1]))
.reduceByKey(lambda x,y: [float(x[0])+float(y[0]),x[1]+y[1]])
.map(lambda x: (x[0],float(x[1][0])/float(x[1][1]))))
#print(moyenne_RDD.take(10))

## Moyenne de taux d'alcool sur les bières les mieux notées:


alcool_zip = (AmIPA_RDD
              .filter(lambda a : a[3].replace('.','',1).isdigit() and float(a[3])<=5.0 and a[11].replace('.','',1).isdigit())
              .map(lambda x: (x[12],x[11])))
rdd_join = moyenne_RDD.join(alcool_zip).distinct() 
#print(rdd_join.sortBy(lambda row : row[1][0], ascending=False).take(10))

print(rdd_join.map(lambda x : (round(x[1][0],1),[x[1][1],1])).reduceByKey(lambda x,y:[float(x[0])+float(y[0]),x[1]+y[1]]).map(lambda x: (x[0],float(x[1][0])/float(x[1][1]))).sortBy(lambda row : row[0], ascending=False).collect())

sc.stop()