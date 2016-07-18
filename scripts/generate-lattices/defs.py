#!/usr/bin/python3
#
# Constatns for MSBR lattice scoping
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

import numpy as np

qsubcommand       = "/home/ondrejch/msbr-scan/scripts/generate-lattices/qsub.sh"    # Location of qsub.sh script
jobdir            = "/home/ondrejch/msbr-scan/jobX/"		                    # Where to run the jobs
filename          = "msbr.inp"		        # Deck file name
xsectionlibrary   = "09c"			# Cross section library 

mcruns          = 20                            # How many runs per hex size choise
apothems        = np.arange( 16.5, 20.1,  0.5)  # Hex sizes to scan [cm *10]
saltfractions   = np.arange(0.04, 0.20 ,0.01) 	# FSFs in percent
blanketfraction = 1.06923                       # Blanket area over one fuel salt ring area used for slit size calculation
relblanketA     = np.linspace(0.8, 1.2, 21) 	# Blanket salt areas to probe relative to the predicted fraction above


if __name__ == '__main__':
	print ("This module contains contants for MSR lattice parameter scan.")
