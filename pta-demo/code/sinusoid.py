from __future__ import division
import numpy as np

def sinusoid(p,t):

    '''
    calculate sine function plus constant offset in y
    
    p - parameters (A, f, phi, b)
    t - discrete times
    '''

    y = p[0]*np.sin(2*np.pi*p[1]*t+p[2]) + p[3] 

    return y
