from __future__ import division
import numpy as np

def corrvslag(x, y, norm):

    '''
    calculate correlation C(tau) for two time-series x, y,
    doing the calculation in the frequency domain.
    
    norm - normalization factor
    '''

    # extract relevant time-domain quantities
    deltaT = x[1,0]-x[0,0]
    N = len(x[:,0])
    deltaF = 1.0/(N*deltaT)

    # fourier transform time series
    xtilde = deltaT * np.fft.fft(x[:,1])
    ytilde = deltaT * np.fft.fft(y[:,1])

    # calculate correlation as a function of lag C(tau)
    C = N * deltaF * np.fft.ifft(xtilde * np.conj(ytilde))
    C = np.real(C) # take real part to avoid imag component from round-off 
    C = norm*C;
 
    return C
