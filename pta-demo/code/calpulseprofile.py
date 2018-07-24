from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
from calpulseperiod import * 
from foldtimeseries import * 

def calpulseprofile(ts, bpm):

    '''
    calculate pulse profile by folding pulse time series
    '''

    # calculated pulse period
    Tp = calpulseperiod(ts, 60/bpm)

    # fold time series using calculated period
    fs = foldtimeseries(ts, Tp)
    tf = fs[:,0]
    yf = fs[:,1]

    # initialize profile time-series
    Nf = len(yf)
    profile = np.zeros([Nf,2]) 

    # first make sure that max of profile is in [0, Tp/2]
    Nby2 = np.int(np.floor(Nf/2))-1
    ndx = np.argmax(yf)
    if ndx > Nby2:
        temp = np.concatenate((yf[Nby2:Nf], yf[0:Nby2]),0)
        yf = temp

    # now start profile just before threshold and normalize
    thresh = 0.2
    indices = np.argwhere(np.abs(yf)>thresh)
    ind0 = indices[0][0]
    ndx = max(ind0-1, 0)
    #ndx = max(indices[0]-1, 0)[0]

    profile[:,0] = tf
    profile[:,1] = np.concatenate((yf[ndx:Nf],yf[0:ndx]),0) / np.max(np.abs(yf))

    return profile, Tp

