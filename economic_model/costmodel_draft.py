#!/usr/bin/python3
# 
# Script to calculate economic paramters of MSiBR model
# Draft version.
#
# Ondrej Chvala, <ochvala@utk.edu>, 2016-09-19
#
import numpy as np
import scipy
import matplotlib.pyplot as plt

# input variables - to be supplied from command line in future
grid_size   = 1e9       # grid max load [W_e]
storage_eff = 0.95      # round-trip thermal storage efficiency
heat_eff    = 0.45      # efficiency of the power conversion W_th -> W_e
solar_fract = 0.95		# solar fraction of peak grid load

# input costs
reactor_costs = 3.0     # [USD/W_thermal]
storage_cost  = 0.1     # [USD/W_thermal]
solar_cost    = 10.0    # [USD/peak_W_electric]

# constants
solar_hour_start =  7.50 # Sun shines from 
solar_hour_end   = 19.50 # Sun shines until
        
# load the 3rd column as work data
gridload = np.loadtxt("dat.csv", usecols=(2,))

# normalize to power load
gridload /= scipy.amax(gridload) # normalized max gridload to 1
gridload *= grid_size            # normalized max gridload to grid_size

# add solar
solargen = np.copy(gridload)   	# create array for solar generation
plantload= np.copy(gridload)    # create array for plant load
for hour in range(0,24):
    if hour <= solar_hour_start or hour >= solar_hour_end: 
        solargen[hour] = 0.0
    else:
        sunphase =  np.pi * \
        (hour - solar_hour_start)/(solar_hour_end -solar_hour_start)
        solargen[hour] = solar_fract * grid_size * np.sin(sunphase)
    plantload[hour] = gridload[hour] - solargen[hour]   # solar load reduces plant load
#    print (hour," ", gridload[hour], solargen[hour], plantload[hour])

# averages for reactor sizing
loadavg = scipy.average(plantload)   # normalized average
loadmax = scipy.amax(plantload)      # normalized max load, equals grid_size

# load variability over the 24 hours
# we need to store half of the variability
loadvar = 0.0
for hourlyload in np.nditer(plantload): 
	loadvar += abs(hourlyload-loadavg)

# output
reactor_thermal_power = loadavg / heat_eff			# [W_th]
thermal_storage_size  = (loadvar/2.0) / storage_eff # [W_th * hours]
generator_size = loadmax	# [We]

print("Reactor power:    {:10.3e} W_th" .format(reactor_thermal_power))
print("Thermal storage:  {:10.3e} W_th * h".format(thermal_storage_size))
print("Generator size:   {:10.3e} W_e".format(generator_size))

# plots
plt.plot(range(24), gridload, label="Grid",  color="darkred",linestyle="-")
plt.plot(range(24), solargen, label="Solar", color="darkorange",linestyle="-") 
plt.plot(range(24), plantload,label="Powerplant", color="blue",linestyle="-")
plt.xlim(-.1, 23.1)
plt.ylim(-.1, 1.05*max(max(gridload),max(solargen)))
plt.title("Example grid with {:4.1f} % PV solar integration".format(100.0*solar_fract))
plt.xlabel("Time [hours]")
plt.ylabel("Power [W]")
plt.legend(loc="best")
plt.xticks([0,4,8,12,16,20])
plt.grid(True)
plt.show()



