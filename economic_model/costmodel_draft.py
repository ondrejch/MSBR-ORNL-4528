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
solar_fract = 0.50		# solar fraction of peak grid load

# input costs
reactor_costs = 3.0     # [USD/W_thermal]
storage_cost  = 0.1     # [USD/W_thermal]
solar_cost    = 10.0    # [USD/peak_W_electric]

# constants
solar_hour_start =  7.50 # Sun shines from 
solar_hour_end   = 18.50 # Sun shines until
        
# load the 3rd column as work data
grid_load = np.loadtxt("dat.csv", usecols=(2,))

# normalize to power load
grid_load /= scipy.amax(grid_load) # normalized max grid_load to 1
grid_load *= grid_size            # normalized max grid_load to grid_size

# add solar
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
        solar_excess[hour] = -1.0*my_reduced_load
		
#    print (hour," ", grid_load[hour], solar_gen[hour], plant_load[hour])

# averages for reactor sizing
load_avg = scipy.average(plant_load)   # normalized average
load_max = scipy.amax(plant_load)      # normalized max load, equals grid_size

# load variability over the 24 hours
# we need to store half of the variability
load_var = 0.0
for hourlyload in np.nditer(plant_load): 
	load_var += abs(hourlyload-load_avg)

# output
reactor_thermal_power = load_avg / heat_eff			# [W_th]
thermal_storage_size  = (load_var/2.0) / storage_eff # [W_th * hours]
generator_size = load_max	# [We]

print("Reactor power:    {:10.3e} W_th" .format(reactor_thermal_power))
print("Thermal storage:  {:10.3e} W_th * h".format(thermal_storage_size))
print("Generator size:   {:10.3e} W_e".format(generator_size))

# plots
plt.plot(range(24), grid_load, label="Grid",  color="darkred",linestyle="-")
plt.plot(range(24), solar_gen, label="Solar", color="darkorange",linestyle="-") 
plt.plot(range(24), plant_load,label="Powerplant", color="blue",linestyle="-")
plt.xlim(-.1, 23.1)
plt.ylim(-.1, 1.05*max(max(grid_load),max(solar_gen)))
plt.title("Example grid with {:4.1f} % PV solar integration".format(100.0*solar_fract))
plt.xlabel("Time [hours]")
plt.ylabel("Power [W]")
plt.legend(loc="best")
plt.xticks([0,4,8,12,16,20])
plt.grid(True)
plt.show()



