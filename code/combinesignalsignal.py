from __future__ import division
import numpy as np
from savetimeseries import *

def combinesignalsignal(signalfile1, signalfile2, A1, A2, fileprefix):

    '''
    combine signal + signal from two signal data files, writing combined data to fileprefix.txt
    '''
    
    ts = np.loadtxt(signalfile1)
    t = ts[:,0]
    s1 = A1 * ts[:,1]
    
    ts = np.loadtxt(signalfile2)
    t = ts[:,0]
    s2 = A2 * ts[:,1]

    d = s1 + s2
    
    savetimeseries(t, d, fileprefix)
    
    return t, d, s1, s2
