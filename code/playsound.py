from __future__ import division
import numpy as np
import scipy.io.wavfile as wav
import pyaudio
import wave
import sys

def playsound(fileprefix):

    '''
    play recorded sound that was saved to fileprefix.txt file;
    the time-series data is returned as a [Ntx2] array ts
    '''
    
    # parameters
    CHUNK = 1024
    FORMAT = pyaudio.paInt16
    CHANNELS = 1
    RATE = 22500
    deltaT = 1.0/RATE

    # first construct wavfile
    filename = fileprefix + '.txt'
    wavfilename = fileprefix + '.wav'    
    ts = np.loadtxt(filename)
    scaled = np.int16(ts[:,1]/abs(max(ts[:,1])) * 32767)
    wav.write(wavfilename, RATE, scaled)
    
    # instantiate pyaudio
    p = pyaudio.PyAudio()

    # open stream
    stream = p.open(format=FORMAT,
                    channels=CHANNELS,
                    rate=RATE,
                    output=True,
                    frames_per_buffer=CHUNK)
    
    wf = wave.open(wavfilename, 'rb')

    data = wf.readframes(CHUNK)

    while data != '':
        stream.write(data)
        data = wf.readframes(CHUNK)

    stream.stop_stream()
    stream.close()

    p.terminate()

    return ts

