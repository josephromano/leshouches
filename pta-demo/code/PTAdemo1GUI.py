#!/usr/bin/env python
'''
Written by Joseph Romano and Michael Lam
'''

from __future__ import division

import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg#, NavigationToolbar2TkAgg
from matplotlib.figure import Figure
from matplotlib.ticker import *#MultipleLocator, FormatStrFormatter, LogLocator
#from matplotlib.ticker import FormatStrFormatter, MultipleLocator
#from matplotlib.widgets import Slider, Button, RadioButtons

import numpy as np

from recordpulses import *
from playpulses import *
from calpulseperiod import *
from calpulseprofile import *
from caltemplate import *
from foldtimeseries import *
from correlate import *
from calmeasuredTOAs import *
from calexpectedTOAs import *
from calresiduals import *
from detrend import *
from corrvslag import *
from zeropadtimeseries import *

import sys

if sys.version_info[0] < 3:
    import Tkinter as Tk
else:
    import tkinter as Tk

SEPARATOR_COLOR = "#CCCCCC"
WIDTH = 1100
HEIGHT = 720

PLOTWIDTH = 6
PLOTHEIGHT = 3.5

# initialize some global variables
ts1 = np.array([])
ts2 = np.array([])
profile1 = np.array([])
profile2 = np.array([])
residuals1 = np.array([])
residuals2 = np.array([])
dtresiduals1 = np.array([])
dtresiduals2 = np.array([])
errorbars1 = np.array([])
errorbars2 = np.array([])

# default values for periods
T1 = 0.2885
T2 = 0.3261
#T1 = 0.299992
#T2 = 0.499950

root = Tk.Tk()
#root.geometry('+1400+100')
root.geometry('%ix%i+100+100'%(WIDTH,HEIGHT)) #Not sure why grid is failing
root.wm_title("Single-Metronome Pulse Analysis")

var_metronome1filename = Tk.StringVar()
var_metronome2filename = Tk.StringVar()
var_metronome1bpm = Tk.DoubleVar()
var_metronome2bpm = Tk.DoubleVar()
var_T1 = Tk.DoubleVar()
var_T2 = Tk.DoubleVar()
var_T1.set(T1)
var_T2.set(T2)
var_message = Tk.StringVar()

# default values for variables
var_metronome1filename.set("m208a")
var_metronome2filename.set("m184b")
var_metronome1bpm.set(208)
var_metronome2bpm.set(184)

## ----------
## Build primary GUI containers
## ----------

frame_main = Tk.Frame(root)
frame_main.grid(row=0)

label_title = Tk.Label(frame_main,text="Single-Metronome Pulse Analysis")
label_title.grid(row=0)

separator = Tk.Frame(frame_main,width=WIDTH,height=2,bg=SEPARATOR_COLOR,bd=1, relief=Tk.SUNKEN).grid(row=1,pady=2)

frame_plot = Tk.Frame(frame_main) #plotframe contains all of the plots and entries
frame_plot.grid(row=2)

frame_button = Tk.Frame(frame_main) #buttonframe contains the buttons
frame_button.grid(row=3)

separator = Tk.Frame(frame_main,width=WIDTH,height=2,bg=SEPARATOR_COLOR,bd=1, relief=Tk.SUNKEN).grid(row=4,pady=2)

frame_message = Tk.Frame(frame_main) #messageframe for status of calculations
frame_message.grid(row=6)

separator = Tk.Frame(frame_main,width=WIDTH,height=2,bg=SEPARATOR_COLOR,bd=1, relief=Tk.SUNKEN).grid(row=7,pady=2)

## ----------
## Pulse Plots
## ----------


frame_pulse = Tk.Frame(frame_plot)
fig_pulse = Figure(figsize=(PLOTWIDTH,PLOTHEIGHT), dpi=75)
ax_pulse1 = fig_pulse.add_subplot(211) #just for show
ax_pulse2 = fig_pulse.add_subplot(212)

fig_pulse.subplots_adjust(wspace=0.5,left=0.20,bottom=0.20) #left allows enough space for the yaxis label to be read.
canvas_pulse = FigureCanvasTkAgg(fig_pulse, frame_pulse)
canvas_pulse.get_tk_widget().grid(row=0)#,side=Tk.TOP)#,fill='x')
canvas_pulse.show()

canvas_pulse._tkcanvas.grid(row=1)#, fill=Tk.BOTH, expand=1)

frame_pulse.grid(row=0,column=0)


## ----------
## Profile Plots
## ----------


frame_profile = Tk.Frame(frame_plot)
fig_profile = Figure(figsize=(PLOTWIDTH,PLOTHEIGHT), dpi=75)
ax_profile1 = fig_profile.add_subplot(211) #just for show
ax_profile2 = fig_profile.add_subplot(212)

fig_profile.subplots_adjust(wspace=0.5,left=0.20,bottom=0.20) #left allows enough space for the yaxis label to be read.
canvas_profile = FigureCanvasTkAgg(fig_profile, frame_profile)
canvas_profile.get_tk_widget().grid(row=0)#,side=Tk.TOP)#,fill='x')
canvas_profile.show()

canvas_profile._tkcanvas.grid(row=1)#, fill=Tk.BOTH, expand=1)

frame_profile.grid(row=0,column=1)


## ----------
## Pulse Data Filenames Entry Text
## ----------

frame_entry = Tk.Frame(frame_plot)
frame_entry.grid(row=1,column=0)

label_pulse_data_filenames = Tk.Label(frame_entry,text="PULSE DATA FILENAMES")
label_pulse_data_filenames.grid(row=0,column=1)

label_metronome1 = Tk.Label(frame_entry,text="Metronome 1:")
label_metronome1.grid(row=1,column=0)

entry_metronome1 = Tk.Entry(frame_entry,textvariable=var_metronome1filename)
entry_metronome1.grid(row=1,column=1)

label_bpm1 = Tk.Label(frame_entry,text="bpm:")
label_bpm1.grid(row=1,column=2)

entry_bpm1 = Tk.Entry(frame_entry,textvariable=var_metronome1bpm)
entry_bpm1.grid(row=1,column=3)

label_metronome2 = Tk.Label(frame_entry,text="Metronome 2:")
label_metronome2.grid(row=2,column=0)

entry_metronome2 = Tk.Entry(frame_entry,textvariable=var_metronome2filename)
entry_metronome2.grid(row=2,column=1)

label_bpm2 = Tk.Label(frame_entry,text="bpm:")
label_bpm2.grid(row=2,column=2)

entry_bpm2 = Tk.Entry(frame_entry,textvariable=var_metronome2bpm)
entry_bpm2.grid(row=2,column=3)

#label_status = Tk.Label(frame_entry,textvariable=var_status)
#label_status.grid(row=3, column=1)

## ----------
## Residual Plots
## ----------

frame_residual = Tk.Frame(frame_plot)
fig_residual = Figure(figsize=(PLOTWIDTH,PLOTHEIGHT), dpi=75)
ax_residual1 = fig_residual.add_subplot(211) #just for show
ax_residual2 = fig_residual.add_subplot(212)

#fig_residual.subplots_adjust(wspace=0.5,left=0.30,bottom=0.20) #left allows enough space for the yaxis label to be read.
fig_residual.subplots_adjust(wspace=0.5,left=0.20,bottom=0.20) #left allows enough space for the yaxis label to be read.
canvas_residual = FigureCanvasTkAgg(fig_residual, frame_residual)
canvas_residual.get_tk_widget().grid(row=0)#,side=Tk.TOP)#,fill='x')
canvas_residual.show()

canvas_residual._tkcanvas.grid(row=1)#, fill=Tk.BOTH, expand=1)

frame_residual.grid(row=1,column=1)


## ----------
## Drawing Functions 
## (necessary to define commands in buttons)
## ----------


def redraw_axes():
    #ax_residual1.set_xticklabels([])
    #ax_residual1.set_yticklabels([])
    #ax_residual2.set_xticklabels([])
    #ax_residual2.set_yticklabels([])

    # horizontal axes
    ax_pulse2.set_xlabel("time (sec)")
    ax_profile2.set_xlabel("time (sec)")
    ax_residual2.set_xlabel("time (sec)")
    
    # vertical axes
    ax_pulse1.set_ylabel("pulses")
    ax_pulse2.set_ylabel("pulses")
    ax_profile1.set_ylabel("profile")
    ax_profile2.set_ylabel("profile")
    ax_residual1.set_ylabel("residuals ($\mu$s)")
    ax_residual2.set_ylabel("residuals ($\mu$s)")

    canvas_pulse.draw()
    canvas_profile.draw()
    canvas_residual.draw()

def func_record(value=1):

    if value == 1:
        var_message.set("recording data for metronome 1...")
        root.update()

        recordpulses(var_metronome1filename.get()+".txt")

    if value == 2:
        var_message.set("recording data for metronome 2...")
        root.update()

        recordpulses(var_metronome2filename.get()+".txt")

    var_message.set("finished recording data")
    root.update()

def func_playback(value=1):

    if value == 1:
        global ts1

        var_message.set("playing back recorded data for metronome 1...")
        root.update()

        ts1 = playpulses(var_metronome1filename.get()+".txt")
        ax_pulse1.cla()
        ax_pulse1.plot(ts1[:,0], ts1[:,1])
        redraw_axes()

        var_message.set("finished playback of recorded data")
        root.update()

        return ts1

    if value == 2:
        global ts2

        var_message.set("playing back recorded data for metronome 2...")
        root.update()

        ts2 = playpulses(var_metronome2filename.get()+".txt")
        ax_pulse2.cla()
        ax_pulse2.plot(ts2[:,0], ts2[:,1])
        redraw_axes()

        var_message.set("finished playback of recorded data")
        root.update()

        return ts2

def func_calprofile(value=1):

    if value == 1:
        global ts1, profile1

        # get default period from text entry box
        T1 = np.float(var_T1.get())

        var_message.set("calculating pulse period and profile of metronome 1...")
        root.update()

        try:
            profile1 = np.loadtxt(var_metronome1filename.get()+"_profile.txt")
        except:
            [profile1, T1] = calpulseprofile(ts1, var_metronome1bpm.get())        
            print 'T1 = ', T1, 'sec'
            var_T1.set(T1)
            # write pulse profile to file
            outfile1 = var_metronome1filename.get()+"_profile.txt"
            np.savetxt(outfile1, profile1)

        # plot pulse profile
        ax_profile1.cla()
        ax_profile1.plot(profile1[:,0], profile1[:,1])
        redraw_axes()

        # write pulse profile to file
        outfile1 = var_metronome1filename.get()+"_profile.txt"
        np.savetxt(outfile1, profile1)

    if value == 2:
        global ts2, profile2

        # get default period from text entry box
        T2 = np.float(var_T2.get())

        var_message.set("calculating pulse period and profile of metronome 2...")
        root.update()

        try:
            profile2 = np.loadtxt(var_metronome2filename.get()+"_profile.txt")
        except:
            [profile2, T2] = calpulseprofile(ts2, var_metronome2bpm.get())        
            print 'T2 = ', T2, 'sec'
            var_T2.set(T2)
            # write pulse profile to file
            outfile2 = var_metronome2filename.get()+"_profile.txt"
            np.savetxt(outfile2, profile2)

        # plot pulse profile
        ax_profile2.cla()
        ax_profile2.plot(profile2[:,0], profile2[:,1])
        redraw_axes()

        # write pulse profile to file
        outfile2 = var_metronome2filename.get()+"_profile.txt"
        np.savetxt(outfile2, profile2)

    var_message.set("finished calculating pulse period and profile")
    root.update()

def func_calresiduals(value=1):

    if value == 1:
        global ts1, profile1, residuals1, errorbars1

        # get period from text entry box
        T1 = np.float(var_T1.get())

        var_message.set("calculating residuals for metronome 1...")
        root.update()

        template1 = caltemplate(profile1, ts1)
        [measuredTOAs1, uncertainties1, n01] = calmeasuredTOAs(ts1, template1, T1)
        Np1 = len(measuredTOAs1)
        expectedTOAs1 = calexpectedTOAs(measuredTOAs1[n01-1], n01, Np1, T1)
        [residuals1, errorbars1] = calresiduals(measuredTOAs1, expectedTOAs1, uncertainties1)

        # plot residuals
        ax_residual1.cla()
        ax_residual1.plot(residuals1[:,0], 1.e6*residuals1[:,1], 'b*')
        redraw_axes()

    if value == 2:
        global ts2, profile2, residuals2, errorbars2

        # get period from text entry box
        T2 = np.float(var_T2.get())

        var_message.set("calculating residuals for metronome 2...")
        root.update()

        template2 = caltemplate(profile2, ts2)
        [measuredTOAs2, uncertainties2, n02] = calmeasuredTOAs(ts2, template2, T2)
        Np2 = len(measuredTOAs2)
        expectedTOAs2 = calexpectedTOAs(measuredTOAs2[n02-1], n02, Np2, T2)
        [residuals2, errorbars2] = calresiduals(measuredTOAs2, expectedTOAs2, uncertainties2)

        # plot residuals
        ax_residual2.cla()
        ax_residual2.plot(residuals2[:,0], 1.e6*residuals2[:,1], 'b*')
        redraw_axes()

    var_message.set("finished calculating residuals")
    root.update()
    
def func_detrendresiduals(value=1):

    if value == 1:
        global residuals1, errorbars1, dtresiduals1

        # get period from text entry box
        T1 = np.float(var_T1.get())

        [dtresiduals1, b, m] = detrend(residuals1, errorbars1);
        N1 = len(residuals1[:,0])
        T1_new = T1 + m*(residuals1[-1,0]-residuals1[0,0])/(N1-1)
        var_T1.set(T1_new)

        # plot residuals
        ax_residual1.cla()
        ax_residual1.plot(dtresiduals1[:,0], 1.e6*dtresiduals1[:,1], 'b*')
        redraw_axes()

    if value == 2:
        global residuals2, errorbars2, dtresiduals2

        # get period from text entry box
        T2 = np.float(var_T2.get())

        [dtresiduals2, b, m] = detrend(residuals2, errorbars2);
        N2 = len(residuals2[:,0])
        T2_new = T2 + m*(residuals2[-1,0]-residuals2[0,0])/(N2-1)
        var_T2.set(T2_new)

        # plot residuals
        ax_residual2.cla()
        ax_residual2.plot(dtresiduals2[:,0], 1.e6*dtresiduals2[:,1], 'b*')
        redraw_axes()


## ----------
## Buttons
## ----------


label_metronome1 = Tk.Label(frame_button,text="Metronome 1:") #rename this something different?
label_metronome1.grid(row=0,column=0)

button_record1 = Tk.Button(frame_button,text="Record pulses",command=lambda: func_record(value=1))
button_record1.grid(row=0,column=1)

button_playback1 = Tk.Button(frame_button,text="Playback pulses",command=lambda: func_playback(value=1))
button_playback1.grid(row=0,column=2)

button_calprofile1 = Tk.Button(frame_button,text="Calculate profile",command=lambda: func_calprofile(value=1))
button_calprofile1.grid(row=0,column=3)
#label_T1 = Tk.Label(frame_button,textvariable=var_T1)
#label_T1.grid(row=1,column=3)

label_T1 = Tk.Label(frame_button,text="Pulse period [s]:")
label_T1.grid(row=0,column=4)

entry_T1 = Tk.Entry(frame_button,textvariable=var_T1)
entry_T1.grid(row=0,column=5)

button_calresiduals1 = Tk.Button(frame_button,text="Calculate residuals",command=lambda: func_calresiduals(value=1))
button_calresiduals1.grid(row=0,column=6)

button_detrendresiduals1 = Tk.Button(frame_button,text="Detrend residuals",command=lambda: func_detrendresiduals(value=1))
button_detrendresiduals1.grid(row=0,column=7)

#########
label_metronome2 = Tk.Label(frame_button,text="Metronome 2:") #rename this something different?
label_metronome2.grid(row=1,column=0)

button_record2 = Tk.Button(frame_button,text="Record pulses",command=lambda: func_record(value=2))
button_record2.grid(row=1,column=1)

button_playback2 = Tk.Button(frame_button,text="Playback pulses",command=lambda: func_playback(value=2))
button_playback2.grid(row=1,column=2)

button_calprofile2 = Tk.Button(frame_button,text="Calculate profile",command=lambda: func_calprofile(value=2))
button_calprofile2.grid(row=1,column=3)
#label_T2 = Tk.Label(frame_button,textvariable=var_T2)
#label_T2.grid(row=3,column=3)

label_T2 = Tk.Label(frame_button,text="Pulse period [s]:")
label_T2.grid(row=1,column=4)

entry_T2 = Tk.Entry(frame_button,textvariable=var_T2)
entry_T2.grid(row=1,column=5)

button_calresiduals2 = Tk.Button(frame_button,text="Calculate residuals",command=lambda: func_calresiduals(value=2))
button_calresiduals2.grid(row=1,column=6)

button_detrendresiduals2 = Tk.Button(frame_button,text="Detrend residuals",command=lambda: func_detrendresiduals(value=2))
button_detrendresiduals2.grid(row=1,column=7)

## ----------
## Messages
## ----------

label_status = Tk.Label(frame_message,text="Status of calculations:")
label_status.grid(row=0)

label_message = Tk.Label(frame_message,textvariable=var_message)
label_message.grid(row=1)


redraw_axes()


def destroy(event):
    sys.exit()


## Bindings
#root.bind("<Return>",superdo)
root.bind("<Escape>", destroy)
root.bind("<Control-q>", destroy)
#root.bind("<F1>",lambda event: popup_about())
#root.bind("<F2>",lambda event: popup_commands())
#root.bind("<F3>",lambda event: popup_equations())
root.bind("<F10>",destroy)


menubar = Tk.Menu(root)

filemenu = Tk.Menu(menubar, tearoff=0)
filemenu.add_command(label="Exit",accelerator="Esc", command=root.quit)
menubar.add_cascade(label="File", menu=filemenu)

#helpmenu = Tk.Menu(menubar, tearoff=0)
#helpmenu.add_command(label="About",accelerator="F1", command=popup_about)
#helpmenu.add_command(label="Commands",accelerator="F2", command=popup_commands)
#menubar.add_cascade(label="Help", menu=helpmenu)

# display the menu
root.config(menu=menubar)

root.mainloop()

