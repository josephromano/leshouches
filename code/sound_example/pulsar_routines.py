from __future__ import division
import numpy as np

def calculate_klm(theta, phi):
    
    '''
    calculate k,l,m unit vectors given an array of theta, phi values for different GW directions
    output:  khat, lhat, mhat are each 3xN arrays
    '''
    
    # first convert theta, phi into individual arrays, even if individual floats
    theta = np.ravel(theta)
    phi = np.ravel(phi)
    
    khat = np.array([-np.sin(theta)*np.cos(phi), -np.sin(theta)*np.sin(phi), -np.cos(theta)])
    lhat = np.array([np.sin(phi), -np.cos(phi), np.zeros_like(theta)])
    mhat = np.array([-np.cos(theta)*np.cos(phi), -np.cos(theta)*np.sin(phi), np.sin(theta)])
    
    return khat, lhat, mhat

def calculate_phat(theta, phi):
    
    '''
    calculate unit vector phat_I given an array of theta, phi for different pulsar directions   
    output:  phat is a 3xN array
    '''
    
    # first convert theta, phi into individual arrays, even if individual floats
    theta = np.ravel(theta)
    phi = np.ravel(phi)
    
    phat = np.array([np.sin(theta)*np.cos(phi), np.sin(theta)*np.sin(phi), np.cos(theta)])
    
    return phat

def calculate_EpEc(theta, phi):
    
    '''
    calculate e^+_{ab}(k), e^x_{ab}(k) polarization tensors    
    output: ep, ec are each 3x3xN arrays
    '''

    khat, lhat, mhat = calculate_klm(theta, phi)
          
    ep = np.einsum('ij, kj->ikj', lhat, lhat) - np.einsum('ij, kj->ikj', mhat, mhat)
    ec = np.einsum('ij, kj->ikj', lhat, mhat) + np.einsum('ij, kj->ikj', mhat, lhat)
    
    return ep, ec

def calculate_Dab(theta_p, phi_p, theta_gw, phi_gw):
    
    '''
    calculate "detector" tensor D_I^{ab}(k) = (1/2) p_I^a p_I^b/(1 + p_I.k)
    
    output: Dab is a 3x3xN_pxN_gw array
    '''
    
    phat = calculate_phat(theta_p, phi_p)
    khat, lhat, mhat = calculate_klm(theta_gw, phi_gw)

    num = 0.5*np.einsum('ij, kj->ikj', phat, phat)
    den = 1+ np.einsum('ij, il->jl', phat, khat)
    Dab = num[:,:,:,np.newaxis]/den[np.newaxis, np.newaxis, :, :] 
    
    return Dab

def calculate_FpFc(theta_p, phi_p, theta_gw, phi_gw):
    
    '''
    calculate F_I^+(k)=D_I^{ab}(k)e^+_{ab}(k), F_I^x(k)=D_I^{ab}(k)e^x_{ab}(k)
    (detector response ignorning pulsar term and 1/(i 2pi f))
    
    output: Fp, Fc are each N_p x N_gw arrays
    '''
    
    ep, ec = calculate_EpEc(theta_gw, phi_gw)
    Dab = calculate_Dab(theta_p, phi_p, theta_gw, phi_gw)
        
    Fp = np.einsum('ijkl, ijl->kl', Dab, ep)
    Fc = np.einsum('ijkl, ijl->kl', Dab, ec)
        
    return Fp, Fc

def calculate_Fss(theta_p, phi_p, theta_gw, phi_gw):
    
    '''
    calculate the sky repsone squared and summed |F_I^+(k)|^2 + |F_I^x(k)|^2
    
    output: Fss is an Np x Ngw array
    '''
    
    Fp, Fc = calculate_FpFc(theta_p, phi_p, theta_gw, phi_gw)
    Fss = np.einsum('ij, ij->ij', Fp, Fp) + np.einsum('ij, ij->ij', Fc, Fc)
    
    return Fss



