#!/usr/bin/python3
#
# Analysis module for MSBR lattice akin to ORNL-4528
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

from array import array
import matplotlib.pyplot as plt

from lattice import Lattice

beep_every  = 100        # Print something every beep_ever lattices read
debug       =   1        # Verbosity level

class LatticeList:
    'Collection of MSBR lattices'
    def __init__(self):                 # Constructor
        self.infilename = ""            # Input data file name - merged done.out files
        self.nlat       = 0             # How many lattices are read
        self.larr       = array('d')    # Array of imported hex sizes
        self.sfarr      = array('d')    # Array of imported salt fractions
        self.latlist    = []            # List of imported lattices
        print ("New MSBR lattice collection created!")


    def read_data(self, infilename, maxnlat=0):     # Read lattices from the input file
        self.infilename = infilename                # Input data file name - merged done.out files 
        with open(self.infilename) as datafile:
            print("Reading from file: ", self.infilename)

            for line in datafile:
                (_cr, _crerr, _k, _kerr, _l, _sf, _relba, _r1, _r2, _r3) = line.rstrip("\n").split()
                cr    = float(_cr)      # Convert to numbers
                crerr = float(_crerr)
                k     = float(_k)                
                kerr  = float(_kerr)                
                l     = float(_l)
                sf    = float(_sf)
                relba = float(_relba)
                #r1    = float(_r1)
                r2    = float(_r2)
                #r3    = float(_r3)
                kerr  = kerr  * k       # Absolute errors
                crerr = crerr * cr

                # Check if this lattice already exists in the list
                lat_i = self.lat_exists(l, sf, r2)
                if not lat_i: 
                    self.latlist.append( Lattice(l, sf, r2) ) # If not, create new one
                    if self.larr.count(l)  ==0 :   # Is this new hex size?
                        self.larr.append(l)
                    if self.sfarr.count(sf)==0 :   # Is this new salt fraction?
                        self.sfarr.append(sf)

                    self.latlist[self.nlat].addblanket(relba, k, kerr, cr, crerr) # Add neutronic data for blanket relBA
                    if debug>3 :
                        print(self.nlat, l, sf, r2, relba, k, kerr, cr, crerr)

                    self.nlat = self.nlat + 1       # Increase latticeindex
                    if debug>0 and not (self.nlat % beep_every) :       # Heartbeat output
                        print(" read in ",self.nlat," lattices")

                else:                               # If the lattice exists, check for relBA
                    if self.latlist[lat_i].relBA.count(relba)==0 :
                        self.latlist[lat_i].addblanket(relba, k, kerr, cr, crerr) # add new blanket & neutronics data
                    if debug>4 :
                        print(lat_i,"            ",relba, k, kerr, cr, crerr)

                if maxnlat != 0 and self.nlat == maxnlat : # Exit of max number of lattices was read
                    return 1
        return 


    def find_lattice_numbers(self, l, sf):     # Find all lattice IDs with l & sf
        found_lattice_numbers = []
        for lat_i in range(self.nlat):
            if self.latlist[lat_i].l == l and self.latlist[lat_i].sf == sf :
                found_lattice_numbers.append(lat_i)
        if len(found_lattice_numbers)>0 :
            return found_lattice_numbers
        else:
            return -1

    def find_lattices(self, l, sf):     # Find all lattices with l & sf
        found_lattices = []
        for lat in self.latlist:
            if lat.l == l and lat.sf == sf :
                found_lattices.append(lat)
        if len(found_lattices)>0:
            return found_lattices
        else:
            return -1


    def lat_exists(self, l, sf, r2):    # Did we already read this lattice in?
        lattice_found = 0               # TODO: implement this more efficiently.
        for lat_i in range(self.nlat):
            if self.latlist[lat_i].exists(l, sf, r2) :
                lattice_found = lat_i
        return lattice_found            # Returns lattice's index


    def print_lattice(self, l, sf, r2): # Print lattice with specified parameters
        lat_i = self.lat_exists(l, sf, r2)
        if lat_i :
            self.print_lattice_n(lat_i)
        else:
            print("Lattice [ %05.2f" % l + " %05.3f" % sf + " %07.4f" % r2 + " ] does not exist")
        return 
            

    def print_lattice_n(self,lat_i):          # Prints nth lattice
        print ("Lattice # ",lat_i)
        self.latlist[lat_i].printme()
        return

    
    def print_lattices(self, l, sf):        # Print all lattices with l & sf
        found_lattice_numbers = []
        for lat_i in range(self.nlat):
            if self.latlist[lat_i].l == l and self.latlist[lat_i].sf == sf :
                found_lattice_numbers.append(lat_i)

        if len(found_lattice_numbers)>0 :                  # Print header if we have output
            print(" i  lat#   l[cm]    sf   r2")
        for i, lat_i in enumerate(found_lattice_numbers):  # Print output
            print(" %2d " % i + "%5d " % lat_i + \
            "  %05.2f " % self.latlist[lat_i].l + "  %05.3f " % self.latlist[lat_i].sf + "  %7.4f" % self.latlist[lat_i].r2 )
        return


    def fit_all_lattices(self):             # Runs fit() method for all lattices in the list
        for mylat in self.latlist:
            mylat.fit()
        return
    

    def check_chi2s(self):                  # Check \Chi^2 values of the fit
        chi2_k  = []
        chi2_cr = []
        for mylat in self.latlist:
            chi2_k.append(mylat.KEFF_chi2)
            chi2_cr.append(mylat.CR_chi2)
        
        n_hist_bins = max(5, self.nlat // 40)   # Number of histogram bins
        plt.figure(1)
        plt.subplot(211)
        #plt.xlabel("\chi^2")
        plt.title(r"Histogram of $\chi^2$ of KEFF fit")
        plt.hist(chi2_k, n_hist_bins, normed=0, facecolor='red', alpha=0.75)
        
        plt.subplot(212)

        plt.title(r"Histogram of $\chi^2$ of CR fit")
        plt.xlabel(r"reduced $\chi^2$")
        plt.hist(chi2_cr, n_hist_bins, normed=0, facecolor='blue', alpha=0.75)
        plt.show()
        return


# --------------- Test code ----------------
if __name__ == '__main__':
    print("This module loads and initializes list of MSBR lattices.")
    input("Press Ctrl+C to quit, or enter else to test it. ")
    msbrs = LatticeList()
    msbrs.read_data("/home/ondrejch/msbr-scan/job1/testdata")
    msbrs.print_lattice(100)
    msbrs.latlist[100].fit()
    msbrs.latlist[100].print_fit()

