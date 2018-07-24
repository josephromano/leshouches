from __future__ import division
import numpy as np
import pyaudio
import matplotlib.pyplot as plt
import time

def recordpulses(filename):

    '''
    record data from metronomes and save to .txt file
    '''

    # parameters
    CHUNK = 1024
    FORMAT = pyaudio.paInt16
    CHANNELS = 1
    RATE = 22050
    RECORD_SECONDS = 8    
    deltaT = 1.0/RATE
   
    print("start recording")

    # get ready to start recording
    #var = raw_input('hit any key to start recording ')
    time.sleep(1)

    # instantiate pyaudio
    p = pyaudio.PyAudio()

    # open stream
    stream = p.open(format=FORMAT,
                    channels=CHANNELS,
                    rate=RATE,
                    input=True,
                    frames_per_buffer=CHUNK)
    
    
    # read in data
    frames = []
    
    for ii in range(0, int(RATE / CHUNK * RECORD_SECONDS)): 
        data = stream.read(CHUNK)
        frames.append(data)
                
    print("done recording")

    # stop stream
    stream.stop_stream()
    stream.close()
    
    # close pyaudio
    p.terminate()

    # convert frames to array
    signal = b''.join(frames)
    signal = np.fromstring(signal,'Int16')
    signal = np.array(signal)
    signal_max = np.max(np.abs(signal))
    signal = signal/signal_max
    
    # save timeseries data to file
    Nt = len(signal)
    
    ts = np.zeros([Nt,2])
    ts[:,0] = np.linspace(0, (Nt-1)*deltaT, Nt)
    ts[:,1] = signal
    
    np.savetxt(filename, ts)

    # plot for diagnostic purposes
    #plt.figure()
    #plt.plot(ts[:,0], ts[:,1], lw=2, color='b')
    #plt.xlabel('time (sec)');

    return

