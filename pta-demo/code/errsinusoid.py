from __future__ import division
import numpy as np
from sinusoid import *

def errsinusoid(p, t, y, err):

    '''
    calculate function to minimize when fitting to a sinusoid plus constant
    
    p - parameters for model sinusoid (A, f, phi, b)
    t - discrete times
    y - array of measeured data
    err - array of error bars on measured data
    '''

    f = (y-sinusoid(p,t))/err 

    return f
