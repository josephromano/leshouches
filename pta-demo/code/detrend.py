from __future__ import division
import numpy as np
import scipy.linalg as linalg

def detrend(ts, errors):
    
    '''
    detrend a time-series by removing least squares linear fit

    b = best fit y-intercept
    m = best fit slope
    '''
    
    N = len(ts[:,0])

    # mapping matrix (from b,m to time-series values)
    M = np.zeros([N, 2])
    M[:,0] = np.ones(N) 
    M[:,1] = ts[:,0]
    Mt = M.T

    # covariance matrix
    C = np.zeros([N, N])
    C = np.diag(errors[:,0]**2,0)
    Cinv = linalg.inv(C)

    # max-likelihood solution for y-intercept, slope
    aML =  np.dot(np.dot(np.dot(linalg.inv(np.dot(np.dot(Mt,Cinv),M)),Mt),Cinv),ts[:,1]);
    b = aML[0]
    m = aML[1]

    # best fit line
    fit = b + m*ts[:,0]

    # detrended time-series
    dts = np.zeros([N,2])
    dts[:,0] = ts[:,0];
    dts[:,1] = ts[:,1] - fit
 
    return dts, b, m

