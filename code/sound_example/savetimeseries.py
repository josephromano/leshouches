from __future__ import division
import numpy as np

def savetimeseries(t, y, fileprefix):
    
    '''
    save timeseries data to file
    '''

    filename = fileprefix + '.txt'
    N = len(t)
    ts = np.zeros([N,2])
    ts[:,0] = t
    ts[:,1] = y
    np.savetxt(filename, ts)

    return
