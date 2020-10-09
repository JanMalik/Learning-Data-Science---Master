#######################
###    Malik Jan    ###
### 03 October 2018 ###
#######################

# Libraries

import pymongo
from pymongo import MongoClient
import pprint
import datetime

#########
### 1 ###
#########

#
client=MongoClient('mongodb://malik:malikM18@nnnnnnnnnnbnbbbbb.....', #FALSE here
                   authsource='malikdb')


db = client.malikdb

food = db.food

result = food.find() #return plusieurs documents

#
for elem in result :
   pprint.pprint(elem)
# très long, ça donne un dictionnaire
    
#
print(food.find({'name':'Ihop'}).count())

#
pprint.pprint(food.find_one({'name':'Ihop'}))

#
Ihop_address = food.find({'name':'Ihop'}, {'address':1})
for elem in Ihop_address :
  pprint.pprint(elem)

#
new_resto = {'address':{'building':'4341',
                       'coord':[-73.819460, 40.889179],
                       'street':'Malik Boulevard',
                       'zipcode':'10475'},
            'borough':'Brooklyn',
            'cuisine':'Polish Dishes',
            'grade':[{'date':datetime.datetime.utcnow(),
                       'grade':'A',
                       'score':30},
                      {'date':datetime.datetime.utcnow(),
                       'grade':'B', 'score':24}],
            'name':'Lolipop',
            'restaurant_id':'1513513256430254654656023254'}
result = food.insert_one(new_resto)
pprint.pprint(food.find_one({'name':'Lolipop'}))

#
new_restoS = [{'address':{'building':'4341',
                       'coord':[-73.819469, 40.889184],
                       'street':'Malik Boulevard',
                       'zipcode':'10475'},
            'borough':'Brooklyn',
            'cuisine':'Polish Dishes',
            'grade':[{'date':datetime.datetime.utcnow(),
                       'grade':'A',
                       'score':39},
                      {'date':datetime.datetime.utcnow(),
                       'grade':'C', 'score':12}],
            'name':'Palony Kurczak',
            'restaurant_id':'15135164351352546546560232'},
             {'address':{'building':'4341',
                       'coord':[-73.819460, 40.889184],
                       'street':'Malik Boulevard',
                       'zipcode':'10475'},
            'borough':'Brooklyn',
            'cuisine':'Polish Dishes',
            'grade':[{'date':datetime.datetime.utcnow(),
                       'grade':'A',
                       'score':30},
                      {'date':datetime.datetime.utcnow(),
                       'grade':'A', 'score':34}],
            'name':'U Zbyszka',
            'restaurant_id':'1513513258468468654656023254'}]
result = food.insert_many(new_restoS)
print(food.find({'cuisine':'Polish Dishes'}).count())


#########
### 2 ###
#########

### Où aller manger ? ###

print("Where do you want to brunch, you hippie !")
continuer=True
while continuer == True :
     borough = input("Sir, please enter the bourough where you deisre to brunch : ")
     cuisine = input("Sir, what type of cuisine you'd like to contemplate (don't choose Indian food because it's hmmmm...to hot for a hippie) : ")
     note = input("Dear Sir, please choose the grade of the restaurants (A, B, ...) --- CHOOSE A ! : ")
     res = food.find({'borough':borough, 'cuisine':cuisine, 'grades.grade':note},{'address':1, 'name':1,'_id':0})

     for elem in res :
        pprint.pprint(elem)

     rep = input("Sir, are the restaurants at your please, or do you want to find other ones (I'm sure you wan't to find another one, you hippie) ? ('Yes' or 'No')")

     if rep=='No':
        continuer=False
     elif rep=='Yes' :
        continuer=True
     else :
        print("please enter a valid answer (don't understand the hippie language) : ")

print("Thx baby, XoXo")
      

### Quartier à choisir ###

import matplotlib
import pandas

res = food.agregate([
    {"$unwind":"$grades"},
    {'$group':{
        '_id':'$restaurant_id',
        'quartier':{'$first':'$borough'},
        'moy':{'$avg':'$grades.score'},
        }}
    ])

test = DataFrame(list(res))
test.head()
test.boxplot(column='moy', by='quartier')
