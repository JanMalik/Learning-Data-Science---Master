################################
### Mallet Oscar & Malik Jan ###
###     17 November 2018     ###
################################

#################
##### Preps #####
#################

#Libraries

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import os

from tempfile import TemporaryFile
outfile = TemporaryFile()

###Data set Import
data = pd.read_csv("beer_reviews.csv")
data.head(15)
###Data Manipulation
data = data.drop(["brewery_id"], axis=1)
data = data.drop(["review_time"], axis=1)
data = data.drop(["review_profilename"], axis=1)
data = data.drop(["beer_beerid"], axis=1)
data = data.dropna()
data.info()




###Data Selection
data = data[['beer_style', 'beer_name', 'beer_abv', 'review_appearance', 
             'review_aroma', 'review_palate', 'review_taste', 'review_overall']]
data = data.sort_values(by=['beer_style', 'beer_name' , 'beer_abv', 'review_overall'])
data = data.reset_index()
data = data.drop(["index"], axis=1)
y = data['beer_abv']
plt.hist(y, color='mediumslateblue', histtype= 'barstacked', bins=25, density=True)
plt.suptitle('Beer abv % histogram')
plt.show()




IPA = data[data["beer_style"] == 'American IPA']
IPA = IPA[(IPA["beer_abv"] >= 6) & (IPA["beer_abv"] >= 8)]
data=IPA
data.info()

x0 = data['review_overall']
x1 = data['review_aroma']
x2 = data['review_taste']
x3 = data['review_palate']
x4 = data['review_appearance']
y = data['beer_abv']

labels = ["Alcool %", "Overall", "Aroma", "Taste", "Palate", "Appearance"]
fig, axs = plt.subplots(nrows=3, ncols=2, figsize=(18,8), sharey=True)

bplot_ov = axs[0,0].boxplot(x0, notch=True, vert=True, patch_artist=True)
bplot_ar = axs[0,1].boxplot(x1, notch=True, vert=True, patch_artist=True)
bplot_ta = axs[1,0].boxplot(x2, notch=True, vert=True, patch_artist=True)
bplot_pa = axs[1,1].boxplot(x3, notch=True, vert=True, patch_artist=True)
bplot_ap = axs[2,0].boxplot(x4, notch=True, vert=True, patch_artist=True)
axs[0,1].set_xlabel("Overall")

fig.suptitle('Catégorial Box_plotting of American IPA appreciation')
plt.show()



#Only American IPA : 113162 lignes
AmIPA = data[data["beer_style"]=="American IPA"]
AmIPA.info()

perfect1 = AmIPA[(AmIPA['review_overall'] == 5) | (AmIPA['review_aroma'] == 5) | (AmIPA['review_appearance'] == 5) | (AmIPA['review_palate'] == 5) | (AmIPA['review_taste'] == 5)]
perfect1.info()

perfect = AmIPA[(AmIPA['review_overall'] == 5) & (AmIPA['review_aroma'] == 5) & (AmIPA['review_appearance'] == 5) & (AmIPA['review_palate'] == 5) & (AmIPA['review_taste'] == 5)]
perfect.info()
# New column : review_average + selection/manipulation
AmIPA['review_average'] = AmIPA.apply(lambda row: (row["review_overall"] + row["review_aroma"] + 
                                                row["review_appearance"] + row["review_palate"] + 
                                                row["review_taste"]) / 5, axis=1)
AmIPA = AmIPA.drop(AmIPA[(AmIPA["review_average"] < 1) | (AmIPA["review_average"] > 5)].index)

AmIPA.info()

APA = data[data['beer_style'] == "American Pale Ale (APA)"]
APA.info()


###############################
##### Categorial Plotting #####
###############################

# Plotting categorical variables (average appreciation)
x0 = AmIPA["review_average"]
x1 = perfect["review_overall"]
x2 = perfect["review_aroma"]
x3 = perfect["review_appearance"]
x4 = perfect["review_palate"]
x5 = perfect["review_taste"]
y = APA["beer_abv"]

fig = plt.figure()
plt.boxplot(y, notch=True, vert=True, patch_artist=True)
plt.xlabel('abv')
plt.ylabel('%')
plt.suptitle("Alcool % of APA")
plt.show()


AS = data[data['beer_style'] == "Barrel Aged B.O.R.I.S. Oatmeal Imperial Stout"]
AS.info()
y = AS["beer_abv"]
plt.boxplot(y, notch=True, vert=True, patch_artist=True)
plt.xlabel('abv')
plt.ylabel('%')
plt.suptitle("Alcool % of Barrel Aged B.O.R.I.S. Oatmeal Imperial Stout")
plt.show()

fig.savefig('perfect_boxplot.jpg')
fig, axs = plt.subplots(5, 2, figsize=(18, 12), sharey=True)
axs[0,0].bar(x0, y, label="Average")
axs[0,1].scatter(x0, y)
axs[0,0].bar(x1, y)
axs[0,1].scatter(x1, y)
axs[1,0].bar(x2, y)
axs[1,1].scatter(x2, y)
axs[2,0].bar(x3, y)
axs[2,1].scatter(x3, y)
axs[3,0].bar(x4, y)
axs[3,1].scatter(x4, y)
axs[4,0].bar(x5, y)
axs[4,1].scatter(x5, y)
fig.suptitle('Categorical Scatter_plotting of American IPA Appreciation')
plt.show()

