from __future__ import division
import numpy as np

def correlate(tau, x, y, norm):

    '''
    calculate correlation C(tau) for two time-series x, y,
    doing the calculation in the frequency domain.
    
    norm - normalization factor
    '''

    # extract relevant time-domain quantities
    deltaT = x[1,0]-x[0,0]
    N = len(x[:,0])
    deltaF = 1.0/(N*deltaT)

    # calculate discrete frequencies 
    fNyq = 1.0/(2*deltaT)
    if ( np.mod(N,2)== 0 ):
        numFreqs = N/2 - 1
    else:
        numFreqs = (N-1)/2

    # discrete positive frequencies
    fp = np.linspace(deltaF, numFreqs*deltaF, numFreqs)

    # discrete frequencies (including zero and negative frequencies
    if ( np.mod(N,2)== 0 ):
        a = np.hstack( (np.array([0.]), fp) )
        b = np.hstack( (np.array([-fNyq]), np.flipud(-fp)) )
        f = np.hstack( (a, b) )
    else:
        f = np.hstack( (np.hstack(((np.array([0.]),fp))), np.flipud(-fp)) )

    # fourier transform time series
    xtilde = deltaT * np.fft.fft(x[:,1])
    ytilde = deltaT * np.fft.fft(y[:,1])

    # calculate correlation C(tau)
    phase= np.exp(np.sqrt(-1+0j)*2*np.pi*f*tau)
    C = np.sum(deltaF * phase * xtilde * np.conj(ytilde))
    C = np.real(C) # take real part to avoid imag component from round-off
    C = norm*C  # normalize

    ## if tau corresponded to a bin, could use ifft routine C(tau)=D[ndx]
    #D = N * deltaF * np.fft.ifft(xtilde * np.conj(ytilde))
    #D = np.real(D) # take real part to avoid imag component from round-off 
    #ndx = np.int(tau/deltaT)
    #print C, D[ndx]
    
    return C
