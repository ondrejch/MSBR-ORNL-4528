#!/usr/bin/env python3
# 
# Script to calculate economic parameters of MSiBR model
# Draft version.
#
# Ondrej Chvala, <ochvala@utk.edu>, 2016-09-19
#
import argparse
from plant_sizing import plant_size
'''Command line argument parser for the economic model'''

# Command line argument parsing
parser = argparse.ArgumentParser(description='MSiBR economic model.')
parser.add_argument('grid_size', metavar='gridsize', type=float, nargs='?', default=1e9,
    help='Size of the electric grid modelled, default = 1e9 W_e')
parser.add_argument('storage_eff', metavar='storeff', type=float, nargs='?', default=0.95,
    help='Round trip efficiency of thermal storage, default 0.95')
parser.add_argument('heat_eff', metavar='heateff', type=float, nargs='?', default=0.45,
    help='Power conversion efficiency, default = 0.45')
parser.add_argument('solar_fract', metavar='solarfrac', type=float, nargs='?', default=0.15,
    help='Solar fraction of the grid size, default = 0.15')
parser.add_argument('do_plot', metavar='plot', choices=[0,1], nargs='?', default=0,
    help='Write out the PNG of the plot [1|0], default = 0')

# Assign command line arguments
args        = vars(parser.parse_args())
grid_size   = args['grid_size']    # grid max load [W_e]
storage_eff = args['storage_eff']  # round-trip thermal storage efficiency
heat_eff    = args['heat_eff']     # efficiency of the power conversion W_th -> W_e
solar_fract = args['solar_fract']  # solar fraction of peak grid load
do_plot     = args['do_plot']      # make plot or not 1|0 

# Run the model
model_sizes = plant_size(grid_size, storage_eff, heat_eff, solar_fract, do_plot)

# Print output to screen
print(model_sizes)

