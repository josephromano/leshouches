from __future__ import division
import numpy as np
import matplotlib.pylab as plt

def plotsignalsignaltimeseries(t, s1, s2, t1, t2, fileprefix):

    '''
    plot two signal components between t1 and t2 and save plot to .png file
    '''
    
    filename = fileprefix + '.png'
        
    # find indices for tlow, thigh
    n1 = np.where(t>=t1)[0]
    n2 = np.where(t>=t2)[0]
    
    plt.figure()
    plt.rc('text', usetex=True)
    plt.tick_params(labelsize=20)
    plt.plot(t[n1[0]:n2[0]], s1[n1[0]:n2[0]], color='r')
    plt.plot(t[n1[0]:n2[0]], s2[n1[0]:n2[0]], color='g')
        
    # set symmetric ylimits if both positive and negative
    axes = plt.gca()
    y1, y2 = axes.get_ylim()
    if y1<0. and y2>0.:
        ymin = -max(np.abs(y1),np.abs(y2))
        ymax =  max(np.abs(y1),np.abs(y2))
        axes.set_ylim([ymin, ymax])
    
    plt.xlabel('time (s)', size=22)
    plt.ylabel('data', size=22)
    plt.legend(['signal 1', 'signal 2'])
    plt.savefig(filename, bbox_inches='tight', dpi=400)
    
    return
