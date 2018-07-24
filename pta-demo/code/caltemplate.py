from __future__ import division
import numpy as np

def caltemplate(profile, ts):

    '''
    calculate template from pulse profile for time series ts
    '''

    # create template by extending pulse profile to have same length as data
    Nt = len(ts[:,0])
    Nprofile = len(profile[:,0])

    template = np.zeros([Nt,2])
    template[:,0] = ts[:,0]
    template[0:Nprofile,1] = profile[:,1]

    return template
