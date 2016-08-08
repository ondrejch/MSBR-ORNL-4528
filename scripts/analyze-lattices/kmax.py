#!/usr/bin/python3
#
# Analysis module for MSBR lattice collection. Finds the highest KEFF(l,sf) for given CR
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL
# 
# https://docs.scipy.org/doc/scipy/reference/generated/scipy.interpolate.CloughTocher2DInterpolator.html

import numpy as np
import matplotlib.pyplot as plt
import pickle

from lattice import Lattice
from initlattices import LatticeList

class MaxKforCR:
    'This class finds maximum KEFF for given CR'
    def __init__(self, infile_pickle):
        self.infile_pickle = infile_pickle
        print("Initializing MSBR lattices from file: ", self.infile_pickle)
        fin  = open(self.infile_pickle, "rb")
        self.lats = pickle.load(fin)
        print("The [l,sf] grid is ", len(self.lats.larr), " x ", len(self.lats.sfarr))
        self.kmap   = np.zeros(( len(self.lats.larr), len(self.lats.sfarr) ), dtype='float32' )  # k [l, sf]
        self.r2map  = np.zeros(( len(self.lats.larr), len(self.lats.sfarr) ), dtype='float32' )  # r2 [l, sf]
        self.rel_r2map=np.zeros((len(self.lats.larr), len(self.lats.sfarr) ), dtype='float32' )  # relative r2 [l, sf]
        self.latmap = np.zeros(( len(self.lats.larr), len(self.lats.sfarr) ), dtype='int32'   )  # lattice number [l, sf]
        
    def __repr__(self):
        repr =  "< MaxKforCR object\n"
        repr += "There are %r lattices in the collection\n" % self.lats.nlat
        repr += "The [l,sf] grid is %r x %r >\n" % (len(self.lats.larr), len(self.lats.sfarr))
        return repr       
        
    def calculate_kmap(self, my_cr, extrapolate=1):     # Returns kmap for specific CR
        for i in range(len(self.lats.larr)):            # Loop over hex size l
            for j in range(len(self.lats.sfarr)):       # loop over salt fraction sf
                my_l  = self.lats.larr[i]               
                my_sf = self.lats.sfarr[j]
                # Loop over all lattices at that (l,sf) coordinate
                for my_lat_i in self.lats.find_lattice_numbers(my_l, my_sf):   # List of lattice numbers
                    my_lat   = self.lats.latlist[my_lat_i]                # Find the actual lattice object
                    my_r2    = my_lat.r2
                    my_rel_r2= my_lat.r2/my_lat.l
                    k_my_lat = my_lat.get_k_at_cr(my_cr, extrapolate)
                    #print(my_cr, my_l, my_sf, k_my_lat)
                    if k_my_lat > self.kmap[i,j] :
                        self.kmap[i,j]   = k_my_lat
                        self.latmap[i,j] = my_lat_i
                        self.r2map[i,j]  = my_r2
                        self.rel_r2map[i,j] = my_rel_r2
        return 
       
       
    def plot_kmap(self):
        plt.imshow(self.kmap, cmap='viridis')
        plt.show()
        pass
    
    
    def plot_r2(self):
        plt.imshow(self.r2map, cmap='viridis')
        plt.show()
        pass
    
    def plot_relative_r2(self):
        plt.imshow(self.rel_r2map, cmap='viridis')
        plt.show()
        pass
            

#--------------- Test code ----------------
if __name__ == '__main__':    
    # from kmax import MaxKforCR
    mk = MaxKforCR("/home/ondrejch/msbr-scan/data/run1_nlat_8938.pickle")
    # mk.calculate_kmap(0.95,0)
    
