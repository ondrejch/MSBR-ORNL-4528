#!/usr/bin/env python3
# 
# Script to calculate economic parameters of MSiBR model
# Draft version.
#
# Ondrej Chvala, <ochvala@utk.edu>, 2016-09-19
#
import numpy as np
import scipy
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt


def plant_size(
    grid_size   = 1e9, 
    storage_eff = 0.95,
    heat_eff    = 0.45,
    solar_fract = 0.15, 
    do_plots    = 0,
    text_in_fig = 1,
    dir_figures = '.') :
    '''Calculates size of the plants components and related parameters
    Inputs: 
        grid_size   = 1e9   # grid max load [W_e]
        storage_eff = 0.95  # round-trip thermal storage efficiency
        heat_eff    = 0.45  # efficiency of the power conversion W_th -> W_e
        solar_fract = 0.15  # solar fraction of peak grid load
        do_plots    = 0     # make plots or not
        text_in_fig = 1     # add output text to the figure
        dir_figures = '.'   # directory for plots
    Outputs:
        out_text: output text with sizes '''
   
# constants
    solar_hour_start =  7.50 # Sun shines from 
    solar_hour_end   = 18.50 # Sun shines until
        
# hardcoded to remove dependency on another file
    grid_load = np.array([ 16091., 15248., 14836., 14629., 14825., 15944.,
  17230., 17736., 18892., 20392., 21913., 23394., 24676., 25493.,  25946., 
  26024., 25920., 25235., 24245., 24099., 23131., 21516., 19551., 17928.]) 

# normalize to power load
    grid_load /= scipy.amax(grid_load) # normalized max grid_load to 1
    grid_load *= grid_size             # normalized max grid_load to grid_size

# add solar; plant load is difference between grid load and solar generation
    solar_gen   = np.copy(grid_load)    # create array for solar generation
    plant_load  = np.copy(grid_load)    # create array for plant load
    solar_excess= np.copy(grid_load)    # create array for excessive solar
    for hour in range(0,24):
        if hour <= solar_hour_start or hour >= solar_hour_end: 
            solar_gen[hour] = 0.0
        else:
            sun_phase =  np.pi * \
            (hour - solar_hour_start)/(solar_hour_end -solar_hour_start)
            solar_gen[hour] = solar_fract * grid_size * np.sin(sun_phase)
        my_reduced_load = grid_load[hour] - solar_gen[hour]   # solar load reduces plant load
        if my_reduced_load >= 0:
            plant_load[hour]   = my_reduced_load
            solar_excess[hour] = 0.0
        else: 
            plant_load[hour]   = 0.0
            solar_excess[hour] =-1.0*my_reduced_load # count solar excess separately
#       print (hour," ", grid_load[hour], solar_gen[hour], plant_load[hour])

# calculate maximum ramp up rate of the turbine [We/h]
    max_ramp_up_rate = 0.0
    for hour in range(0,23):            # forward differentiation
        my_ramp_rate = (plant_load[hour+1] - plant_load[hour]) / 1.0
        if my_ramp_rate > max_ramp_up_rate:
            max_ramp_up_rate = my_ramp_rate

# averages for reactor sizing
    load_avg = scipy.average(plant_load)    # normalized average [W_e]
    load_max = scipy.amax(plant_load)       # normalized max load, equals grid_size [W_e]

# load variability over the 24 hours
# we need to store half of the variability
    load_var = 0.0                          # [W_e]
    for hourlyload in np.nditer(plant_load): 
        load_var += abs(hourlyload-load_avg)

# output data calculation
    reactor_thermal_power = load_avg / heat_eff             # [W_th]
    thermal_storage_size  = load_var / (2.0*storage_eff*heat_eff) # [W_th * hours]
    turbine_size          = load_max / heat_eff             # [Wt_h]
    generator_size        = load_max                        # [W_e]
    solar_contribution    = sum(solar_gen)/sum(grid_load)   # fraction of solar electricity on the grid

# print output
    out_text ="*** Calculated data ***\n"
    out_text+="For grid size of  {:10.3e} W_e\n"   .format(grid_size)
    out_text+=" reactor power:   {:10.3e} W_th\n"  .format(reactor_thermal_power)
    out_text+=" thermal storage: {:10.3e} W_th*h\n".format(thermal_storage_size)
    out_text+=" turbine size:    {:10.3e} W_th\n"  .format(turbine_size)
    out_text+=" generator size:  {:10.3e} W_e\n"   .format(generator_size)
    out_text+=" maximum ramp up: {:10.3e} W_e/h\n" .format(max_ramp_up_rate)
    out_text+=" solar contribution:  {:6.2f} %"    .format(100.0*solar_contribution)

# plots
    if do_plots :
        fig= plt.figure()        
        ax = fig.add_subplot(111)
        ax.plot(range(24), grid_load, label="Grid load",  color="darkred",   linestyle="-", lw=4)
        ax.plot(range(24), solar_gen, label="Solar",      color="darkorange",linestyle="-", lw=3)
        ax.plot(range(24), plant_load,label="MSiBR plant",color="green",     linestyle="-", lw=3)
        plt.xlim(-.1, 23.1)
        plt.ylim(-.1, 1.05*max(max(grid_load),max(solar_gen)))
        plt.title("Example grid with {:4.1f}% PV solar integration".format(100.0*solar_fract))
        plt.xlabel("Time [hours]")
        plt.ylabel(r"Power [W$_e$]")
        ax.legend(loc="best",fontsize="medium")
        plt.xticks([0,4,8,12,16,20])
        ax.grid(True)
        if text_in_fig :
            plt.text(0.02, 0.02, out_text, horizontalalignment='left', verticalalignment='bottom', \
                transform=ax.transAxes, family="monospace",fontsize="large")
        fig.savefig(dir_figures+"/mygrid.png")   # Write figure into a file instead of displaying it
        plt.close()
    
    out_text = out_text.format(**locals())
    return out_text

if __name__ == '__main__':
    print("This module calculates plant size.")
    input("Press Ctrl+C to quit, or enter else to test it. ")
    print(plant_size())


