#!/usr/bin/python3
#
# Reads lattice data from a text file and writes it out as a pickle for further uses
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL
# 

import pickle
from initlattices import LatticeList

proj_dir      = "/home/ondrejch/msbr-scan/"               # Project directory
indata_fname  = proj_dir + "job1/sorted.j1.data"          # Text data to read
outdata_fname = proj_dir + "data/run1_nlat_8938.pickle"   # Out pickle file name

msbrs = LatticeList()           # Collection holder
msbrs.read_data(indata_fname)   # Read in lattices
msbrs.fit_all_lattices()        # Fit KEFF(relBA) and CR(relBA)

fout = open(outdata_fname,"wb") # Output pickle file
pickle.dump(msbrs,fout)         # Pickle!
fout.close()

print ("All done")
