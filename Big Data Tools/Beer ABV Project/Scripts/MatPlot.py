################################
### Mallet Oscar & Malik Jan ###
###     21 November 2018     ###
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

#Data set Import
data = pd.read_csv("beer_reviews.csv", nrows=5000)
#Data Manipulation
data = data.drop(["brewery_id"], axis=1)
data = data.drop(["review_time"], axis=1)
data = data.drop(["review_profilename"], axis=1)
data = data.drop(["beer_beerid"], axis=1)
data = data.dropna()

#Data Selection
data = data[['brewery_name', 'beer_style', 'beer_name', 'beer_abv', 'review_appearance', 
             'review_aroma', 'review_palate', 'review_taste', 'review_overall']]
data = data.sort_values(by=['brewery_name', 'beer_style', 'beer_name' , 'beer_abv', 'review_overall'])
data = data.reset_index()
data = data.drop(["index"], axis=1)

#New column : review_average + selection/manipulation
data['review_average'] = data.apply(lambda row: (row["review_overall"] + row["review_aroma"] + 
                                                 row["review_appearance"] + row["review_palate"] + 
                                                 row["review_taste"]) / 5, axis=1)
data = data.drop(data[(data["review_average"] < 1) | (data["review_average"] > 5)].index)



###############################
##### Categorial Plotting #####
###############################



# Plotting categorical variables (average appreciation)
x0 = data["review_overall"]
x1 = data["review_aroma"]
x2 = data["review_appearance"]
x3 = data["review_taste"]
x4 = data["review_palate"]
y = data["beer_abv"]

fig, axs = plt.subplots(1, 3, figsize=(9, 3), sharey=True)
axs[0].bar(y, x0)
axs[1].scatter(y, x0)
axs[2].scatter(x0,y)
fig.suptitle('Categorical Plotting Overall Beer Appreciation')
plt.show()
##
##
##fig, axs = plt.subplots(1, 3, figsize=(9, 3), sharey=True)
##axs[0].bar(x1, y)
##axs[1].scatter(x1, y)
##axs[2].scatter(y,x1)
##fig.suptitle('Categorical Plotting Aroma Beer Appreciation')
##plt.show()
##
##fig, axs = plt.subplots(1, 3, figsize=(9, 3), sharey=True)
##axs[0].bar(x2, y)
##axs[1].scatter(x2, y)
##axs[2].scatter(y,x2)
##fig.suptitle('Categorical Plotting Appearance Beer Appreciation')
##plt.show()
##
##fig, axs = plt.subplots(1, 3, figsize=(9, 3), sharey=True)
##axs[0].bar(x3, y)
##axs[1].scatter(x3, y)
##axs[2].scatter(y,x3)
##fig.suptitle('Categorical Plotting Taste Beer Appreciation')
##plt.show()
##
##fig, axs = plt.subplots(1, 3, figsize=(9, 3), sharey=True)
##axs[0].bar(x4, y)
##axs[1].scatter(x4, y)
##axs[2].scatter(y,x4)
##fig.suptitle('Categorical Plotting Palate Beer Appreciation')
##plt.show()


########################
##### Scatter Hist #####
########################



##import numpy as np
##import matplotlib.pyplot as plt
from matplotlib.ticker import NullFormatter

# x idem
# y idem

nullfmt = NullFormatter()         # no labels

# definitions for the axes
left, width = 0.1, 0.65
bottom, height = 0.1, 0.65
bottom_h = left_h = left + width + 0.02

rect_scatter = [left, bottom, width, height]
rect_histx = [left, bottom_h, width, 0.2]
rect_histy = [left_h, bottom, 0.2, height]

# start with a rectangular Figure
plt.figure(1, figsize=(8, 8))

axScatter = plt.axes(rect_scatter)
axHistx = plt.axes(rect_histx)
axHisty = plt.axes(rect_histy)

# no labels
axHistx.xaxis.set_major_formatter(nullfmt)
axHisty.yaxis.set_major_formatter(nullfmt)

# the scatter plot:
axScatter.scatter(x, y)

# now determine nice limits by hand:
binwidth = 0.25
xymax = max(np.max(np.abs(x)), np.max(np.abs(y)))
lim = (int(xymax/binwidth) + 1) * binwidth

axScatter.set_xlim((0, 5.5))
axScatter.set_ylim((0, 20))

bins = np.arange(-lim, lim + binwidth, binwidth)
axHistx.hist(x, bins=bins)
axHisty.hist(y, bins=bins, orientation='horizontal')

axHistx.set_xlim(axScatter.get_xlim())
axHisty.set_ylim(axScatter.get_ylim())

plt.show()


#############################
####### Custom Boxplots #####
#############################



reviews_data = data[["review_average", "review_overall", "review_aroma", "review_taste", "review_palate", "review_appearance"]]
labels = ["Average", "Overall", "Aroma", "Taste", "Palate", "Appearance"]
fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(9, 4))

# rectangular box plot
bplot1 = axes[0].boxplot(reviews_data["review_average"],
                         vert=True,  # vertical box alignment
                         patch_artist=True)  # fill with color
##                         labels=labels)  # will be used to label x-ticks
axes[0].set_title('Rectangular box plot')

# notch shape box plot
bplot2 = axes[1].boxplot(reviews_data["review_average"],
                         notch=True,  # notch shape
                         vert=True,  # vertical box alignment
                         patch_artist=True)  # fill with color
##                         labels=labels)  # will be used to label x-ticks
axes[1].set_title('Notched box plot')

# fill with colors
colors = ['pink', 'lightblue', 'lightgreen', 'green', 'blue', 'red']
for bplot in (bplot1, bplot2):
    for patch, color in zip(bplot['boxes'], colors):
        patch.set_facecolor(color)

# adding horizontal grid lines
for ax in axes:
    ax.yaxis.grid(True)
    ax.set_xlabel('Six separates descriptors')
    ax.set_ylabel('Observed reviews')

plt.show()



############################
#######Pie Chart Polar #####
############################
##
###Probablement pas besoin
##
### Fixing random state for reproducibility
##np.random.seed(19680801)
##
### Compute pie slices
##N = 20
##theta = np.linspace(0.0, 2 * np.pi, N, endpoint=False)
##radii = 10 * np.random.rand(N)
##width = np.pi / 4 * np.random.rand(N)
##
##ax = plt.subplot(111, projection='polar')
##bars = ax.bar(theta, radii, width=width, bottom=0.0)
##
### Use custom colors and opacity
##for r, bar in zip(radii, bars):
##    bar.set_facecolor(plt.cm.viridis(r / 10.))
##    bar.set_alpha(0.5)
##
##
##
###########################
####### Scatter Polar #####
###########################
##
##
##
### Fixing random state for reproducibility
##np.random.seed(19680801)
##
### Compute areas and colors
##N = 150
##r = 2 * np.random.rand(N)
##theta = 2 * np.pi * np.random.rand(N)
##area = 200 * r**2
##colors = theta
##
##fig = plt.figure()
##ax = fig.add_subplot(111, projection='polar')
##c = ax.scatter(theta, r, c=colors, s=area, cmap='hsv', alpha=0.75)
##plt.show()
##
##
##
##################################
####### Scatter Polar offset #####
##################################
##
##
##
###Fixing random state for reproducibility
##np.random.seed(19680801)
##
##
###Compute areas and colors
##N = 150
##r = 2 * np.random.rand(N)
##theta = 2 * np.pi * np.random.rand(N)
##area = 200 * r**2
##colors = theta
##
##fig = plt.figure()
##ax = fig.add_subplot(111, polar=True)
##c = ax.scatter(theta, r, c=colors, s=area, cmap='hsv', alpha=0.75)
##
##ax.set_rorigin(-2.5)
##ax.set_theta_zero_location('W', offset=10)
##
##
##
#########################
####### Transoofset #####
#########################
##
##
##
##import matplotlib.pyplot as plt
##import matplotlib.transforms as mtransforms
##import numpy as np
##
##
##xs = data["review_average"]
##ys = data["beer_abv"]
##
##fig = plt.figure(figsize=(5, 10))
##ax = plt.subplot(2, 1, 1)
##
### If we want the same offset for each text instance,
### we only need to make one transform.  To get the
### transform argument to offset_copy, we need to make the axes
### first; the subplot command above is one way to do this.
##trans_offset = mtransforms.offset_copy(ax.transData, fig=fig,
##                                       x=0.05, y=0.10, units='inches')
##
##for x, y in zip(xs, ys):
##    plt.plot((x,), (y,), 'ro')
##    plt.text(x, y, '%d, %d' % (int(x), int(y)), transform=trans_offset)
##
##
### offset_copy works for polar plots also.
##ax = plt.subplot(2, 1, 2, projection='polar')
##
##trans_offset = mtransforms.offset_copy(ax.transData, fig=fig,
##                                       y=6, units='dots')
##
##for x, y in zip(xs, ys):
##    plt.polar((x,), (y,), 'ro')
##    plt.text(x, y, '%d, %d' % (int(x), int(y)),
##             transform=trans_offset,
##             horizontalalignment='center',
##             verticalalignment='bottom')
##
##plt.show()
##
##
