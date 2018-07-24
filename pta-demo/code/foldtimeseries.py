from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats

def foldtimeseries(ts, T):

    '''
    fold timeseries ts by period T
    '''

    # extract initial time and deltaT
    t0 = ts[0,0]
    Nt = len(ts[:,0])
    deltaT = ts[1,0]-ts[0,0]

    # fold data by period T using mod(.,T) function
    ps = np.zeros([Nt,2])
    ps[:,0] = np.mod(ts[:,0]-t0, T)
    ps[:,1] = ts[:,1]

    # sort folded data 
    ndx = np.argsort(ps[:,0])
    ps[:,0] = ps[ndx,0]
    ps[:,1] = ps[ndx,1]

    # bin folded data 
    tbin = deltaT
    Nbins = int(np.floor(T/tbin)+1)
    fs = np.zeros([Nbins,2])
    fs[:,0] = np.linspace(0, tbin*(Nbins-1), Nbins) 

    jj = 0
    for ii in range(Nbins):

        # calculate bin boundaries
        tlow = fs[ii,0]-tbin/2
        thigh = fs[ii,0]+tbin/2

        # check that jj is in range
        if jj > Nt-1:
            break

        # average together values in bin 
        temp = 0
        counter = 0 # counts number of averages
        while (tlow<=ps[jj,0] and ps[jj,0]<thigh):
            temp = temp + ps[jj,1]
            counter = counter+1
            jj = jj+1

            # check that jj is in range
            if jj > Nt-1:
                break

        # check if while condition was never satisfied
        if counter==0: 
            fs[ii,1] = 0
        else:
            fs[ii,1] = temp/counter

    return fs

