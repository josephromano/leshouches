from __future__ import division
import numpy as np

def calresiduals(measuredTOAs, expectedTOAs, uncertainties):

    '''
    calculated timing residuals and error bars from measured TOAs 
    and expected TOAs (the errorbars are just the uncertainities from
    the measured TOAs)

    remove any nans in the measured TOAs
    '''

    # first remove any NaNs in the measured TOAs
    notNaN = ~np.isnan(measuredTOAs)
    measured = measuredTOAs[notNaN]
    expected = expectedTOAs[notNaN]

    # construct time-series of residuals
    N = len(measured)
    residuals = np.zeros([N, 2])
    residuals[:,0] = measured
    residuals[:,1] = measured - expected

    # construct time-series of errorbars from measured TOA uncertainties
    errorbars = np.zeros([N, 2])
    errorbars[:,0] = measured
    errorbars[:,1] = uncertainties[notNaN]

    return residuals, errorbars
