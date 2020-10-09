# -*- coding: utf-8 -*-
"""
Created on Tue Nov  6 10:40:44 2018

@author: xxx
"""

import pymongo as pym
import pandas as pd
from datetime import datetime


client = pym.MongoClient('hostname', 27017)

# creation database
db = client.beer

#creation collection
beer = db.beer_collection

# importation du csv sous pandas:
beer_data = pd.read_csv("beer_reviews.csv")
 
##print(beer_data.shape)
##pd.options.display.max_columns = beer_data.shape[1]
##print(beer_data.describe())
##print(beer_data.columns)
# converssion de la date

beer_data["review_time"] = beer_data["review_time"].apply(lambda x: datetime.fromtimestamp(x).strftime('%Y-%m-%d'))


## transformation en MongoDB

# exemple de documents :

##doc_ex = {
##'beer_beerid':00000,
##'beer_name':"jan",
##'beer_abv':0, 
##'beer_style':"pale IPA",
##'brewery_id':00000,
##'brewery_name':"brew", 
##'review': [{
##     'review_time':"0000-00-00",
##     'review_overall':0,
##     'review_aroma':0,
##     'review_appearance':0,
##     'review_profilename':"Jan",
##     'review_palate':0,
##     'review_taste':0},
##    {
##     'review_time':"0000-00-00",
##     'review_overall':0,
##     'review_aroma':0,
##     'review_appearance':0,
##     'review_profilename':"Jan",
##     'review_palate':0,
##     'review_taste':0}
##    ]
## }

## boucle pour importer tous les docs

grouped_beer = beer_data.groupby("beer_beerid")
beer_list =[]
j=0
for x in grouped_beer:
    review_list = []
    for i in range(0,x[1].shape[0]):
        review_list.append({
        "review_time" : list(x[1].review_time)[i],
        "review_overall": list(x[1].review_overall)[i],
        "review_aroma" : list(x[1].review_aroma)[i],
        "review_appearance": list(x[1].review_appearance)[i],
        "review_profilename" : list(x[1].review_profilename)[i],
        "review_palate" : list(x[1].review_palate)[i],
        "review_taste" : list(x[1].review_taste)[i]
        })
    
    doc = {'beer_beerid':list(x[1].beer_beerid)[0],
           'beer_name':list(x[1].beer_name)[0],
           'beer_abv':list(x[1].beer_abv)[0], 
           'beer_style':list(x[1].beer_style)[0],
           'brewery_id':list(x[1].brewery_id)[0],
           'brewery_name':list(x[1].brewery_name)[0],
           'review':review_list
            }
    beer_list.append(doc)
    j+=1
    print(j)
        


for x in grouped_beer:
    print(list(x[1].review_time)[0])

#Export to JSON file
import json
with open("data.json", "w") as outfile:
    json.dump(beer_list, outfile)
