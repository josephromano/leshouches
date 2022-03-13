from __future__ import division
import numpy as np
import matplotlib.pylab as plt
import scipy
from scipy import signal

def plotpowerspectrum(t, y, t1, t2, Fs, fileprefix):

    '''
    plot powerspectrum of time-series data between t1 and t2 and save plot to .png file
    '''
    
    filename = fileprefix + '_powerspectrum.png'
        
    # find indices for tlow, thigh
    n1 = np.where(t>=t1)[0]
    n2 = np.where(t>=t2)[0]
 
    # calculate welch estimate of power spectrum
    N = n2[0]-n1[0]+1;
    seglength = np.int(N/8.)
    f, P = scipy.signal.welch(y[n1[0]:n2[0]], fs=Fs, window='hanning', nperseg=seglength)
    
    # plot power spectrum
    plt.figure()
    plt.rc('text', usetex=True)
    plt.tick_params(labelsize=20)
    plt.loglog(f, P, linewidth=2)
    plt.xlabel('frequency (Hz)', size=22)
    plt.ylabel('power spectral density (1/Hz)', size=22)
    plt.grid(True)
    plt.savefig(filename, bbox_inches='tight', dpi=400)
    
    return
