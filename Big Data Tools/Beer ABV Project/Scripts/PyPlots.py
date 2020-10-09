################################
### Mallet Oscar & Malik Jan ###
###     16 November 2018     ###
################################

#### Point clasique ####

##import matplotlib.pyplot as plt
##plt.plot([1,2,3,4])
##plt.ylabel('some numbers')
##plt.show()


##### Hist densite simple ####

##import numpy as np
##import matplotlib.pyplot as plt
##
### Fixing random state for reproducibility
##np.random.seed(19680801)
##
##mu, sigma = 100, 15
##x = mu + sigma * np.random.randn(10000)
##
### the histogram of the data
##n, bins, patches = plt.hist(x, 50, normed=1, facecolor='g', alpha=0.75)
##
##
##plt.xlabel('Smarts')
##plt.ylabel('Probability')
##plt.title('Histogram of IQ')
##plt.text(60, .025, r'$\mu=100,\ \sigma=15$')
##plt.axis([40, 160, 0, 0.03])
##plt.grid(True)
##plt.show()

#### EventPlot ####

import matplotlib.pyplot as plt
import numpy as np
import matplotlib
matplotlib.rcParams['font.size'] = 8.0

# Fixing random state for reproducibility
np.random.seed(19680801)


# create random data
data1 = np.random.random([6, 50])

# set different colors for each set of positions
colors1 = np.array([[1, 0, 0],
                    [0, 1, 0],
                    [0, 0, 1],
                    [1, 1, 0],
                    [1, 0, 1],
                    [0, 1, 1]])

# set different line properties for each set of positions
# note that some overlap
lineoffsets1 = np.array([-15, -3, 1, 1.5, 6, 10])
linelengths1 = [5, 2, 1, 1, 3, 1.5]

fig, axs = plt.subplots(2, 2)

# create a horizontal plot
axs[0, 0].eventplot(data1, colors=colors1, lineoffsets=lineoffsets1,
                    linelengths=linelengths1)

# create a vertical plot
axs[1, 0].eventplot(data1, colors=colors1, lineoffsets=lineoffsets1,
                    linelengths=linelengths1, orientation='vertical')

# create another set of random data.
# the gamma distribution is only used fo aesthetic purposes
data2 = np.random.gamma(4, size=[60, 50])

# use individual values for the parameters this time
# these values will be used for all data sets (except lineoffsets2, which
# sets the increment between each data set in this usage)
colors2 = [[0, 0, 0]]
lineoffsets2 = 1
linelengths2 = 1

# create a horizontal plot
axs[0, 1].eventplot(data2, colors=colors2, lineoffsets=lineoffsets2,
                    linelengths=linelengths2)


# create a vertical plot
axs[1, 1].eventplot(data2, colors=colors2, lineoffsets=lineoffsets2,
                    linelengths=linelengths2, orientation='vertical')

plt.show()
