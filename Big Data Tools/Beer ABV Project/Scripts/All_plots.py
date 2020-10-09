################################
### Mallet Oscar & Malik Jan ###
###      30 October 2018     ###
################################

# Packages

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import os

#On va deja travailler sur les 1000 premieres lignes pour tester car sinon c'est trop lourd...
data = pd.read_csv("beer_reviews.csv")
data.head(10)
data.tail(10)

data.info()
data.describe()

#Drop some unnecessary columns for plots
data = data.drop(["brewery_id"], axis=1)
data = data.drop(["review_time"], axis=1)
data = data.drop(["review_profilename"], axis=1)
data = data.drop(["beer_beerid"], axis=1)
data = data.dropna()
data.head()

#Arrange the columns and sort by brewery name
data = data[['brewery_name', 'beer_style', 'beer_name', 'beer_abv', 'review_appearance', 
             'review_aroma', 'review_palate', 'review_taste', 'review_overall']]
data = data.sort_values(by=['brewery_name', 'beer_style', 'beer_name' , 'beer_abv', 'review_overall'])
data = data.reset_index()
data = data.drop(["index"], axis=1)
data.head()

# New column review_average
data['review_average'] = data.apply(lambda row: (row["review_overall"] + row["review_aroma"] + 
                                                 row["review_appearance"] + row["review_palate"] + 
                                                 row["review_taste"]) / 5, axis=1)

data = data.drop(data[(data["review_average"] < 1) | (data["review_average"] > 5)].index)
data.head()


#Scatter pourris average
plt.plot(data['beer_abv'], data['review_average'], 'ro')
plt.xlabel('Alcool %')
plt.ylabel('Average Appreciation')
plt.title('Alcool vs Appreciation in Average')
plt.show()

#Hist sur overall
x = data['review_average']
n, bins, patches = plt.hist(x)
plt.xlabel('Mark')
plt.ylabel('Density')
plt.title('Histogram of Average Appreciations')
plt.show()









#Scatter pourris overall
plt.plot(data['beer_abv'], data['review_overall'], 'ro')
plt.xlabel('Alcool %')
plt.ylabel('Overall Appreciation')
plt.title('Alcool vs Overall Appreciation')
plt.show()

#Scatter pourris BIS
plt.plot(data['review_overall'], data['beer_abv'], 'ro')
plt.xlabel('Appreciation Overrall')
plt.ylabel('Alcool %')
plt.title('Appreciation Overall vs Alcool')
plt.show()

#Scatter pourris aroma
plt.plot(data['beer_abv'], data['review_aroma'], 'ro')
plt.xlabel('Alcool %')
plt.ylabel('Aroma Appreciation')
plt.title('Alcool vs Aroma')
plt.show()

#Scatter pourris appearance
plt.plot(data['beer_abv'], data['review_appearance'], 'ro')
plt.xlabel('Alcool %')
plt.ylabel('Appearance Appreciation')
plt.title('Alcool vs Appearance')
plt.show()

#Scatter pourris palate
plt.plot(data['beer_abv'], data['review_palate'], 'ro')
plt.xlabel('Alcool %')
plt.ylabel('Palate Appreciation')
plt.title('Alcool vs Palate')
plt.show()

#Scatter pourris taste
plt.plot(data['beer_abv'], data['review_taste'], 'ro')
plt.xlabel('Alcool %')
plt.ylabel('Taste Appreciation')
plt.title('Alcool vs Taste')
plt.show()

#Hist sur overall
x = data['review_overall']
n, bins, patches = plt.hist(x)
plt.xlabel('Mark')
plt.ylabel('Density')
plt.title('Histogram of Overall Appreciations')
plt.show()

#Hist sur aroma
x = data['review_aroma']
n, bins, patches = plt.hist(x)
plt.xlabel('Mark')
plt.ylabel('Density')
plt.title('Histogram of Aroma Appreciations')
plt.show()

#Hist sur appearance
x = data['review_appearance']
n, bins, patches = plt.hist(x)
plt.xlabel('Mark')
plt.ylabel('Density')
plt.title('Histogram of Appearance')
plt.show()

#Hist sur palate
x = data['review_palate']
n, bins, patches = plt.hist(x)
plt.xlabel('Mark')
plt.ylabel('Density')
plt.title('Histogram of Palate Appreciations')
plt.show()

#Hist sur taste
x = data['review_taste']
n, bins, patches = plt.hist(x)
plt.xlabel('Mark')
plt.ylabel('Density')
plt.title('Histogram of Taste Appreciations')
plt.show()

#Hist sur abv
x = data['beer_abv']
n, bins, patches = plt.hist(x)
plt.xlabel('Alcool')
plt.ylabel('Density')
plt.title('Histogram of ABV %')
plt.show()



#Visu of top 15
data.dataframeName = 'beer_reviews_bis.csv'
def visualization_function_1(name, condition, ax_left, ax_right):
    
    unique_names = data[name].unique()
    length = len(unique_names)
    rev_aver = np.zeros(length)
    count = np.zeros(length, dtype=np.int32)
    
    for _, row in data.iterrows():
        idx = np.where(unique_names == row[name])
        rev_aver[idx] += row["review_average"]
        count[idx] += 1
  
    for i in range(length):
        if count[i] > condition:
            rev_aver[i] /= count[i]
        else:
            rev_aver[i] = 1
            
    zipped_left  = sorted(zip(unique_names, rev_aver), key=lambda x: x[1], reverse=True)
    names_left   = [zipped_left[i][0] for i in range(length)]
    sorted_score = [zipped_left[i][1] for i in range(length)]
    
    zipped_right = sorted(zip(unique_names, count), key=lambda x: x[1], reverse=True)
    names_right  = [zipped_right[i][0] for i in range(length)]
    sorted_count = [zipped_right[i][1] for i in range(length)]
    
    sns.barplot(sorted_score[:15], names_left[:15], ax=ax_left)
    ax_left.set_xlim(3, 5)
    ax_left.set_xlabel("Scores of review_average")
    # limit the length of names
    ax_left.set_yticklabels([i.get_text()[:17] + "..." if len(i.get_text()) > 17 else i.get_text() 
                             for i in ax_left.get_yticklabels()])
    
    sns.barplot(sorted_count[:15], names_right[:15], ax=ax_right).set_title(name)
    ax_right.set_xlabel("Total number of drinks")
    # limit the length of names
    ax_right.set_yticklabels([i.get_text()[:17] + "..." if len(i.get_text()) > 17 else i.get_text() 
                              for i in ax_right.get_yticklabels()])

sns.set(rc={"axes.grid": True})
fig, axs = plt.subplots(ncols=2, nrows=3, figsize=[16, 24])
fig.subplots_adjust(wspace=0.4)

visualization_function_1("brewery_name", 5, axs[0, 0], axs[0, 1])
visualization_function_1("beer_style", 5, axs[1, 0], axs[1, 1])
visualization_function_1("beer_name", 5, axs[2, 0], axs[2, 1])

axs[0, 0].set_title("The best quality Breweries")
axs[0, 1].set_title("Breweries that produce the most drinks")

axs[1, 0].set_title("The best styles of beer")
axs[1, 1].set_title("The most popular styles of beer")

axs[2, 0].set_title("The best quality beer")
axs[2, 1].set_title("The most popular beer");


plt.show()

def plotPerColumnDistribution(df, nGraphShown, nGraphPerRow):
    nunique = df.nunique()
    df = df[[col for col in df if nunique[col] > 1 and nunique[col] < 50]] # For displaying purposes, pick columns that have between 1 and 50 unique values
    nRow, nCol = df.shape
    columnNames = list(df)
    nGraphRow = (nCol + nGraphPerRow - 1) / nGraphPerRow
    plt.figure(num = None, figsize = (6 * nGraphPerRow, 8 * nGraphRow), dpi = 80, facecolor = 'w', edgecolor = 'k')
    for i in range(min(nCol, nGraphShown)):
        plt.subplot(nGraphRow, nGraphPerRow, i + 1)
        columnDf = df.iloc[:, i]
        if (not np.issubdtype(type(columnDf.iloc[0]), np.number)):
            valueCounts = columnDf.value_counts()
            valueCounts.plot.bar()
        else:
            columnDf.hist()
        plt.ylabel('counts')
        plt.xticks(rotation = 90)
        plt.title(f'{columnNames[i]} (column {i})')
    plt.tight_layout(pad = 1.0, w_pad = 1.0, h_pad = 1.0)
    plt.show()

# Correlation matrix
def plotCorrelationMatrix(df, graphWidth):
    filename = df.dataframeName
    df = df.dropna('columns') # drop columns with NaN
    df = df[[col for col in df if df[col].nunique() > 1]] # keep columns where there are more than 1 unique values
    if df.shape[1] < 2:
        print(f'No correlation plots shown: The number of non-NaN or constant columns ({df.shape[1]}) is less than 2')
        return
    corr = df.corr()
    plt.figure(num=None, figsize=(graphWidth, graphWidth), dpi=80, facecolor='w', edgecolor='k')
    corrMat = plt.matshow(corr, fignum = 1)
    plt.xticks(range(len(corr.columns)), corr.columns, rotation=90)
    plt.yticks(range(len(corr.columns)), corr.columns)
    plt.gca().xaxis.tick_bottom()
    plt.colorbar(corrMat)
    plt.title(f'Correlation Matrix for {filename}', fontsize=15)
    plt.show()

# Scatter and density plots
def plotScatterMatrix(df, plotSize, textSize):
    df = df.select_dtypes(include =[np.number]) # keep only numerical columns
    # Remove rows and columns that would lead to df being singular
    df = df.dropna('columns')
    df = df[[col for col in df if df[col].nunique() > 1]] # keep columns where there are more than 1 unique values
    columnNames = list(df)
    if len(columnNames) > 10: # reduce the number of columns for matrix inversion of kernel density plots
        columnNames = columnNames[:10]
    df = df[columnNames]
    ax = pd.plotting.scatter_matrix(df, alpha=0.75, figsize=[plotSize, plotSize], diagonal='kde')
    corrs = df.corr().values
    for i, j in zip(*plt.np.triu_indices_from(ax, k = 1)):
        ax[i, j].annotate('Corr. coef = %.3f' % corrs[i, j], (0.8, 0.2), xycoords='axes fraction', ha='center', va='center', size=textSize)
    plt.suptitle('Scatter and Density Plot')
    plt.show()


plotPerColumnDistribution(data, 10, 5)
plotCorrelationMatrix(data, 12)
plotScatterMatrix(data, 15, 2)


