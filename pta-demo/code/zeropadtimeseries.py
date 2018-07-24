from __future__ import division
import numpy as np

def zeropadtimeseries(x, T):

    '''
    zero pad the time-series x by duration T 
    to nearest power of 2    
    '''

    ######################
    # special case: no zero-padding if T=0
    if T==0:
	y = x
	return y

    ######################
    # normal case

    # extract relevant time-domain quantities
    deltaT = x[1,0]-x[0,0]
    N = len(x[:,0])

    # determine number of bins for zero-padding
    dN = int(np.floor(T/deltaT))

    # number of samples for zero-padded timeseries
    Nz = N+dN

    # extend Nz to nearest power of two
    np2 = int(np.ceil(np.log2(Nz)))
    Nz = 2**np2

    # construct zero-padded time-series
    y = np.zeros([Nz,2])
    y[:,0] = np.linspace(0, (Nz-1)*deltaT, Nz)
    y[0:N,1] = x[:,1] 

    return y
