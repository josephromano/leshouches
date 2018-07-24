from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
from foldtimeseries import *

def calpulseperiod(ts, T):

    '''
    calculate pulse period by maximizing the amplitude of
    the folded data
    
    ts  : time series data
    T   : preliminary guess for pulse period
    '''

    # array of trial periods
    eps = 1e-4
    #Ntrials = 201
    Ntrials = 101
    Tt = np.linspace(T-eps, T+eps, Ntrials)

    # calculate maxima of folded data
    yf_max = np.zeros(Ntrials)
    for ii in range(Ntrials):
        fs = foldtimeseries(ts, Tt[ii])
        yf_max[ii] = np.max(np.abs(fs[:,1]))

    # the folded data has the maximum max value
    ndx = np.argmax(yf_max)
    Tp = Tt[ndx]

    return Tp
