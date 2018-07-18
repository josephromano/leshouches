from __future__ import division
import numpy as np
from savetimeseries import *

def combinesignalnoise(signalfile, noisefile, A, fileprefix):

    '''
    combine signal + noise from signal and noise data files, writing combined data to fileprefix.txt
    '''
    
    ts = np.loadtxt(signalfile)
    t = ts[:,0]
    s = A*ts[:,1]
    
    ts = np.loadtxt(noisefile)
    t = ts[:,0]
    n = ts[:,1]

    d = s + n
    
    savetimeseries(t, d, fileprefix)
    
    return t, d, s, n
