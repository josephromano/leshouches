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
from correlate import *
from caltemplate import *
from calmeasuredTOAs import *
from calexpectedTOAs import *
from calresiduals import *
from errsinusoid import *
from calcorrcoeff import *
from corrvslag import *
from zeropadtimeseries import *

import sys

if sys.version_info[0] < 3:
    import Tkinter as Tk
else:
    import tkinter as Tk

SEPARATOR_COLOR = "#CCCCCC"
#WIDTH = 1250
WIDTH = 1350
HEIGHT = 680

PLOTWIDTH = 6
PLOTHEIGHT = 3.5

# initialize some global variables
ts = np.array([])
profile1 = np.array([])
profile2 = np.array([])
residuals1 = np.array([])
residuals2 = np.array([])
errorbars1 = np.array([])
errorbars2 = np.array([])
yfit1 = np.array([])
yfit2 = np.array([])

# default values for periods
T1 = 0.2885680
T2 = 0.3260988
#T1 = 0.299991
#T2 = 0.499950

root = Tk.Tk()
#root.geometry('+1400+100')
root.geometry('%ix%i+100+100'%(WIDTH,HEIGHT)) #Not sure why grid is failing
root.wm_title("Double-Metronome Pulse Analysis")

var_timeseriesfilename = Tk.StringVar()
var_profile1filename = Tk.StringVar()
var_profile2filename = Tk.StringVar()
var_T1 = Tk.DoubleVar()
var_T2 = Tk.DoubleVar()
var_amplitude1_est = Tk.DoubleVar()
var_amplitude2_est = Tk.DoubleVar()
var_frequency1_est = Tk.DoubleVar()
var_frequency2_est = Tk.DoubleVar()
var_phase1_est = Tk.DoubleVar()
var_phase2_est = Tk.DoubleVar()
var_offset1_est = Tk.DoubleVar()
var_offset2_est = Tk.DoubleVar()
var_amplitude1_fit = Tk.DoubleVar()
var_amplitude2_fit = Tk.DoubleVar()
var_frequency1_fit = Tk.DoubleVar()
var_frequency2_fit = Tk.DoubleVar()
var_phase1_fit = Tk.DoubleVar()
var_phase2_fit = Tk.DoubleVar()
var_offset1_fit = Tk.DoubleVar()
var_offset2_fit = Tk.DoubleVar()
var_corrcoeff = Tk.DoubleVar()
var_message = Tk.StringVar()

# default values for variables
var_timeseriesfilename.set("m208a184b0")
var_profile1filename.set("m208a_profile")
var_profile2filename.set("m184b_profile")
var_T1.set(T1)
var_T2.set(T2)
var_amplitude1_est.set(100) # microsec
var_frequency1_est.set(0.4)
var_phase1_est.set(0)
var_offset1_est.set(0)
var_amplitude2_est.set(100) # microsec
var_frequency2_est.set(0.4)
var_phase2_est.set(0)
var_offset2_est.set(0)
var_corrcoeff.set(0)

## ----------
## Build primary GUI containers
## ----------

frame_main = Tk.Frame(root)
frame_main.grid(row=0)

label_title = Tk.Label(frame_main,text="Double-Metronome Pulse Analysis")
label_title.grid(row=0)

separator = Tk.Frame(frame_main,width=WIDTH,height=2,bg=SEPARATOR_COLOR,bd=1, relief=Tk.SUNKEN).grid(row=1,pady=2)

frame_plot = Tk.Frame(frame_main) #plotframe contains all of the plots and entries
#frame_plot.grid(row=2)
frame_plot.grid(row=2, sticky='W', padx=2)

separator = Tk.Frame(frame_main,width=WIDTH,height=2,bg=SEPARATOR_COLOR,bd=1, relief=Tk.SUNKEN).grid(row=3,pady=2)

frame_button = Tk.Frame(frame_main) #buttonframe contains the buttons
frame_button.grid(row=4)

separator = Tk.Frame(frame_main,width=WIDTH,height=2,bg=SEPARATOR_COLOR,bd=1, relief=Tk.SUNKEN).grid(row=5,pady=2)

frame_message = Tk.Frame(frame_main) #messageframe for status of calculations
frame_message.grid(row=6)

separator = Tk.Frame(frame_main,width=WIDTH,height=2,bg=SEPARATOR_COLOR,bd=1, relief=Tk.SUNKEN).grid(row=7,pady=2)

## ----------
## Pulse Plots
## ----------


frame_pulse = Tk.Frame(frame_plot)
fig_pulse = Figure(figsize=(PLOTWIDTH,PLOTHEIGHT), dpi=75)
ax_pulse = fig_pulse.add_subplot(111) #just for show

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
## Pulse Data and Profile Filenames Entry Text
## ----------


frame_entry = Tk.Frame(frame_plot)
frame_entry.grid(row=1,column=0)

label_filenames = Tk.Label(frame_entry,text="FILENAMES")
label_filenames.grid(row=0,column=1)

label_timeseriesfilename = Tk.Label(frame_entry,text="Data file:")
label_timeseriesfilename.grid(row=1,column=0)

entry_timeseriesfilename = Tk.Entry(frame_entry,textvariable=var_timeseriesfilename)
entry_timeseriesfilename.grid(row=1,column=1)

label_profile1filename = Tk.Label(frame_entry,text="Profile 1:")
label_profile1filename.grid(row=2,column=0)

entry_profile1filename = Tk.Entry(frame_entry,textvariable=var_profile1filename)
entry_profile1filename.grid(row=2,column=1)

label_T1 = Tk.Label(frame_entry,text="Pulse period [s]:")
label_T1.grid(row=2,column=2)

entry_T1 = Tk.Entry(frame_entry,textvariable=var_T1)
entry_T1.grid(row=2,column=3)

label_profile2filename = Tk.Label(frame_entry,text="Profile 2:")
label_profile2filename.grid(row=3,column=0)

entry_profile2filename = Tk.Entry(frame_entry,textvariable=var_profile2filename)
entry_profile2filename.grid(row=3,column=1)

label_T2 = Tk.Label(frame_entry,text="Pulse period [s]:")
label_T2.grid(row=3,column=2)

entry_T2 = Tk.Entry(frame_entry,textvariable=var_T2)
entry_T2.grid(row=3,column=3)

label_blank = Tk.Label(frame_entry,text=" ")
label_blank.grid(row=4,column=1,columnspan=4)

label_estimates = Tk.Label(frame_entry,text="INITIAL ESTIMATES (1)")
label_estimates.grid(row=5,column=1)

label_fits = Tk.Label(frame_entry,text="BEST-FIT VALUES (1)")
label_fits.grid(row=5,column=2)

label_estimates = Tk.Label(frame_entry,text="INITIAL ESTIMATES (2)")
label_estimates.grid(row=5,column=3)

label_fits = Tk.Label(frame_entry,text="BEST-FIT VALUES (2)")
label_fits.grid(row=5,column=4)

label_amplitude_est = Tk.Label(frame_entry,text="Amp [usec]:")
label_amplitude_est.grid(row=6,column=0)

entry_amplitude1_est = Tk.Entry(frame_entry,textvariable=var_amplitude1_est)
entry_amplitude1_est.grid(row=6,column=1)

entry_amplitude1_fit = Tk.Entry(frame_entry,textvariable=var_amplitude1_fit)
entry_amplitude1_fit.grid(row=6,column=2)

entry_amplitude2_est = Tk.Entry(frame_entry,textvariable=var_amplitude2_est)
entry_amplitude2_est.grid(row=6,column=3)

entry_amplitude2_fit = Tk.Entry(frame_entry,textvariable=var_amplitude2_fit)
entry_amplitude2_fit.grid(row=6,column=4)

label_frequency_est = Tk.Label(frame_entry,text="Freq [Hz]:")
label_frequency_est.grid(row=7,column=0)

entry_frequency1_est = Tk.Entry(frame_entry,textvariable=var_frequency1_est)
entry_frequency1_est.grid(row=7,column=1)

entry_frequency1_fit = Tk.Entry(frame_entry,textvariable=var_frequency1_fit)
entry_frequency1_fit.grid(row=7,column=2)

entry_frequency2_est = Tk.Entry(frame_entry,textvariable=var_frequency2_est)
entry_frequency2_est.grid(row=7,column=3)

entry_frequency2_fit = Tk.Entry(frame_entry,textvariable=var_frequency2_fit)
entry_frequency2_fit.grid(row=7,column=4)

label_phase_est = Tk.Label(frame_entry,text="Phase [rad]:")
label_phase_est.grid(row=8,column=0)

entry_phase1_est = Tk.Entry(frame_entry,textvariable=var_phase1_est)
entry_phase1_est.grid(row=8,column=1)

entry_phase1_fit = Tk.Entry(frame_entry,textvariable=var_phase1_fit)
entry_phase1_fit.grid(row=8,column=2)

entry_phase2_est = Tk.Entry(frame_entry,textvariable=var_phase2_est)
entry_phase2_est.grid(row=8,column=3)

entry_phase2_fit = Tk.Entry(frame_entry,textvariable=var_phase2_fit)
entry_phase2_fit.grid(row=8,column=4)

label_phase_est = Tk.Label(frame_entry,text="Offset [usec]:")
label_phase_est.grid(row=9,column=0)

entry_phase1_est = Tk.Entry(frame_entry,textvariable=var_offset1_est)
entry_phase1_est.grid(row=9,column=1)

entry_phase1_fit = Tk.Entry(frame_entry,textvariable=var_offset1_fit)
entry_phase1_fit.grid(row=9,column=2)

entry_phase2_est = Tk.Entry(frame_entry,textvariable=var_offset2_est)
entry_phase2_est.grid(row=9,column=3)

entry_phase2_fit = Tk.Entry(frame_entry,textvariable=var_offset2_fit)
entry_phase2_fit.grid(row=9,column=4)


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
    # horizontal axes
    ax_pulse.set_xlabel("time (sec)")
    ax_profile2.set_xlabel("time (sec)")
    ax_residual2.set_xlabel("time (sec)")
    
    # vertical axes
    ax_pulse.set_ylabel("pulses")
    ax_profile1.set_ylabel("profile")
    ax_profile2.set_ylabel("profile")
    ax_residual1.set_ylabel("residuals ($\mu$s)")
    ax_residual2.set_ylabel("residuals ($\mu$s)")

    canvas_pulse.draw()
    canvas_profile.draw()
    canvas_residual.draw()

#########################

def func_record():
    var_message.set("recording data...")
    root.update()

    recordpulses(var_timeseriesfilename.get()+".txt")

    var_message.set("finished recording data")
    root.update()

def func_playback():

    var_message.set("playing back recorded data...")
    root.update()

    global ts
    ts = playpulses(var_timeseriesfilename.get()+".txt")
    ax_pulse.cla()
    ax_pulse.plot(ts[:,0], ts[:,1])
    redraw_axes()

    var_message.set("finished playback of recorded data")
    root.update()

    return ts

def func_loadprofiles():

    global profile1, profile2

    # load profiles
    profile1 = np.loadtxt(var_profile1filename.get()+".txt")
    profile2 = np.loadtxt(var_profile2filename.get()+".txt")

    # plot profiles
    ax_profile1.cla()
    ax_profile1.plot(profile1[:,0], profile1[:,1])
    redraw_axes()

    ax_profile2.cla()
    ax_profile2.plot(profile2[:,0], profile2[:,1])
    redraw_axes()

    return profile1, profile2

def func_calresiduals():

    global ts, residuals1, residuals2, errorbars1, errorbars2

    # get period from text entry boxes
    T1 = np.float(var_T1.get())
    T2 = np.float(var_T2.get())

    # calculate residuals
    var_message.set("calculating residuals for metronome 1...")
    root.update()

    template1 = caltemplate(profile1, ts)
    [measuredTOAs1, uncertainties1, n01] = calmeasuredTOAs(ts, template1, T1)
    Np1 = len(measuredTOAs1)
    expectedTOAs1 = calexpectedTOAs(measuredTOAs1[n01-1], n01, Np1, T1)
    [residuals1, errorbars1] = calresiduals(measuredTOAs1, expectedTOAs1, uncertainties1)

    # plot residuals
    ax_residual1.cla()
    ax_residual1.errorbar(residuals1[:,0], 1.e6*residuals1[:,1], 1.e6*errorbars1[:,1], fmt='.')
    redraw_axes()

    # calculate residuals
    var_message.set("calculating residuals for metronome 2...")
    root.update()

    template2 = caltemplate(profile2, ts)
    [measuredTOAs2, uncertainties2, n02] = calmeasuredTOAs(ts, template2, T2)
    Np2 = len(measuredTOAs2)
    expectedTOAs2 = calexpectedTOAs(measuredTOAs2[n02-1], n02, Np2, T2)
    [residuals2, errorbars2] = calresiduals(measuredTOAs2, expectedTOAs2, uncertainties2)

    # plot residuals
    ax_residual2.cla()
    ax_residual2.errorbar(residuals2[:,0], 1.e6*residuals2[:,1], 1.e6*errorbars2[:,1], fmt='.')
    redraw_axes()

    var_message.set("finished calculation of residuals")
    root.update()

def func_fitsinusoid():

    global residuals1, residuals2, errorbars1, errorbars2, yfit1, yfit2

    # load initial estimate of parameters
    pars1 = np.zeros(4)
    pars1[0] = 1.0e-6*var_amplitude1_est.get()
    pars1[1] = var_frequency1_est.get()
    pars1[2] = var_phase1_est.get()
    pars1[3] = 1.0e-6*var_offset1_est.get()

    # fit sinusoid with constant offset to residuals
    pfit1, pcov1, infodict, message, ier = \
    opt.leastsq(errsinusoid, pars1, args=(residuals1[:,0], residuals1[:,1], errorbars1[:,1]), full_output=1)

    # fill best-fit values of parameters
    var_amplitude1_fit.set(1.0e6*pfit1[0])
    var_frequency1_fit.set(pfit1[1])
    var_phase1_fit.set(pfit1[2])
    var_offset1_fit.set(1.0e6*pfit1[3])

    # best-fit sinusoid
    tfit = np.linspace(0, max(residuals1[-1,0], residuals2[-1,0]), 1024)
    yfit1 = pfit1[0]*np.sin(2*np.pi*pfit1[1]*tfit + pfit1[2])

    # constant offset
    N = len(residuals1[:,0])
    offset1 = pfit1[3]*np.ones(N)

    # plot residuals with constant removed and with best-fit sinusoid
    ax_residual1.cla()
    ax_residual1.errorbar(residuals1[:,0], 1.e6*(residuals1[:,1]-offset1), 1.e6*errorbars1[:,1], fmt='.')
    ax_residual1.plot(tfit, 1.e6*yfit1, 'r-')
    redraw_axes()

    ############
    # load initial estimate of parameters
    pars2 = np.zeros(4)
    pars2[0] = 1.0e-6*var_amplitude2_est.get()
    pars2[1] = var_frequency2_est.get()
    pars2[2] = var_phase2_est.get()
    pars2[3] = 1.0e-6*var_offset2_est.get()

    # fit sinusoid with constant offset to residuals
    pfit2, pcov2, infodict, message, ier = \
    opt.leastsq(errsinusoid, pars2, args=(residuals2[:,0], residuals2[:,1], errorbars2[:,1]), full_output=1)

    # fill best-fit values of parameters
    var_amplitude2_fit.set(1.0e6*pfit2[0])
    var_frequency2_fit.set(pfit2[1])
    var_phase2_fit.set(pfit2[2])
    var_offset2_fit.set(1.0e6*pfit2[3])

    # best-fit sinusoid
    tfit = np.linspace(0, max(residuals1[-1,0], residuals2[-1,0]), 1024)
    yfit2 = pfit2[0]*np.sin(2*np.pi*pfit2[1]*tfit + pfit2[2])

    # constant offset
    N = len(residuals2[:,0])
    offset2 = pfit2[3]*np.ones(N)

    # plot residuals with constant removed and with best-fit sinusoid
    ax_residual2.cla()
    ax_residual2.errorbar(residuals2[:,0], 1.e6*(residuals2[:,1]-offset2), 1.e6*errorbars2[:,1], fmt='.')
    ax_residual2.plot(tfit, 1.e6*yfit2, 'r-')
    redraw_axes()

    return yfit1, yfit2


def func_calcorrcoeff():

    global yfit1, yfit2

    rhox, rhoy, rhoxy = calcorrcoeff(yfit1, yfit2)
    var_corrcoeff.set(rhoxy)

## ----------
## Buttons
## ----------

button_record = Tk.Button(frame_button,text="Record pulses",command=lambda: func_record())
button_record.grid(row=0,column=0)

button_playback = Tk.Button(frame_button,text="Playback pulses",command=lambda: func_playback())
button_playback.grid(row=0,column=1)

button_loadprofiles = Tk.Button(frame_button,text="Load pulse profiles",command=lambda: func_loadprofiles())
button_loadprofiles.grid(row=0,column=2)

button_calresiduals = Tk.Button(frame_button,text="Calculate residuals",command=lambda: func_calresiduals())
button_calresiduals.grid(row=0,column=3)

button_fitsinusoids = Tk.Button(frame_button,text="Fit sinusoids & remove offsets",command=lambda: func_fitsinusoid())
button_fitsinusoids.grid(row=0,column=4)

button_calcorrcoeff = Tk.Button(frame_button,text="Calculate corr coeff",command=lambda: func_calcorrcoeff())
button_calcorrcoeff.grid(row=0,column=5)

entry_calcorrcoeff = Tk.Entry(frame_button,textvariable=var_corrcoeff)
entry_calcorrcoeff.grid(row=0,column=6)

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

