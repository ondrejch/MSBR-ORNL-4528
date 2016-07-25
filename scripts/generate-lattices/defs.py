#!/usr/bin/python3
#
# Constatns for MSBR lattice scoping
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

import numpy as np
import platform

jobnumber         = 'jobX/'			# Job directory tree 
filename          = "msbr.inp"		# Deck file name
xsectionlibrary   = "09c"			# Cross section library 

apothems        = np.arange( 6.0, 20.1,  0.5)   # Hex sizes to scan [cm *10]
saltfractions   = np.arange(0.04, 0.20 ,0.01) 	# FSFs in percent
blanketfraction = 1.06923                       # Blanket area over one fuel salt ring area used for slit size calculation
relblanketA     = np.linspace(0.8, 1.3, 31) 	# Blanket salt areas to probe relative to the predicted fraction above
r2sizes         = np.linspace(0.0, 1.0 ,21)     # Sampling of r2

if 'necluster' in platform.node() :
	qsubcommand = "/home/ondrejch/msbr-scan/scripts/generate-lattices/qsub.sh" # Location of qsub.sh script
	jobdir      = "/home/ondrejch/msbr-scan/" + jobnumber		               # Where to run the jobs
elif 'sigma' in platform.node() :
	qsubcommand = "/data/home/ochvala/play/scripts/qsub.sh"
	jobdir      = "/lustre/scratch/ochvala/" + jobnumber
else:
	qsubcommand = "/bin/false"
	jobdir      = "/tmp/" + jobnumber


if __name__ == '__main__':
	print("This module contains contants for MSR lattice parameter scan.")
	print("	Jobdir: ", jobdir) 
