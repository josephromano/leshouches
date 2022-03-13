from __future__ import division
import numpy as np
from scipy.stats import norm
import matplotlib.pylab as plt
#import matplotlib.mlab as mlab

def plothistogram(t, y, t1, t2, fileprefix):

    '''
    plot histogram of time-series data between t1 and t2 and save plot to .png file
    '''
    
    filename = fileprefix + '_hist.png'
        
    # find indices for tlow, thigh
    n1 = np.where(t>=t1)[0]
    n2 = np.where(t>=t2)[0]

    # histogram and best fit gaussian of h
    (mu, sigma) = norm.fit(y[n1[0]:n2[0]])
    
    plt.figure()
    plt.rc('text', usetex=True)
    plt.tick_params(labelsize=20)
    n, bins, patches = plt.hist(y[n1[0]:n2[0]], bins=50, density='true')
    z = norm.pdf(bins, mu, sigma)
    l = plt.plot(bins, z, 'r--', linewidth=2)
    plt.xlabel('data', size=22)
    plt.savefig(filename, bbox_inches='tight', dpi=400)
    
    return
