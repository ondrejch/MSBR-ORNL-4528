#!/usr/bin/python3
#
# Analysis module for MSBR lattice akin to ORNL-4528
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

import math
from array import array
from scipy.optimize import curve_fit
import numpy as np
import matplotlib.pyplot as plt

class Lattice:
    'MSBR lattice object'    
    def __init__(self, l, sf, r2):      # Constructor
# Lattice parameters
        self.l          = l             # Hex lattice size [cm]
        self.sf         = sf            # Fuel salt fraction inside the inner channel [cm]
        self.r2         = r2            # Inner dimater of the outer channel [cm]
# Arrays hold CR and KEFF dependency on blanket size
        self.relBA      = array('d')    # Relative blanket fraction
#       self.l2         = array('d')    # Graphite hex size [cm]
        self.KEFF       = array('d')    # ANALYTICAL_KEFF
        self.KEFFerr    = array('d')    # ANALYTICAL_KEFF Error
        self.CR         = array('d')    # CONVERSION_RATIO
        self.CRerr      = array('d')    # CONVERSION_RATIO Error
        self.fit_done   = False         # Fit flag
        self.KEFF_fit_p = [1.0, -1.0, 0.1]  # Fit parametrs
        self.CR_fit_p   = [1.0,  1.0]
        self.KEFF_chi2  = -0.1          # Reduced \Chi^2 of the fit
        self.CR_chi2    = -0.1

    def __repr__(self):
        repr = "< Lattice object\n"
        repr += "Hex size: %5.2f" % self.l +" cm, salt fraction: %5.3f" % self.sf + ", r2: %7.4f" % self.r2 +" cm\n"
        for i, rba in enumerate(self.relBA):
            repr += " %2d " % i + ": %4.3f \t" % rba + " %6.4f " % self.KEFF[i] + " +- %6.4f " % self.KEFFerr[i] + \
            "\t%6.4f " % self.CR[i] + " +- %6.4f\n"  % self.CRerr[i]
        if self.fit_done :
            repr += self.get_fit_results()
        repr += ">"
        return repr
        
    def hexarea(self):                  # Area of the lattice [cm2]
        return 2.0 * math.sqrt(3.0) * self.l**2

    def r1(self):                       # Inner channel radius [cm]
        return math.sqrt(self.hexarea()*self.sf/(2.0*math.pi))

    def r3(self):                       # Outer channel outer radius [cm]
        return math.sqrt( self.r1()**2 + self.r2**2 )

    def exists(self, l, sf, r2):        # Has this lattice been already created?
        return (self.l ==  l) and (self.sf == sf) and (self.r2 == r2)


    def addblanket(self, relBA, KEFF, KEFFerr, CR, CRerr): # Add specific blanket size & results
        self.relBA.append(relBA)
        self.KEFF.append(KEFF)
        self.KEFFerr.append(KEFFerr)
        self.CR.append(CR)
        self.CRerr.append(CRerr)
        return

    def plot(self):
        if len(self.KEFF)<2 :
            print("Error, needs at least 2 blanket configurations to plot!")
            return -1

        # Plot data points
        plt.errorbar(self.relBA,self.KEFF,self.KEFFerr, color="red",  marker="+", ls="none")
        plt.errorbar(self.relBA,self.CR,  self.CRerr,   color="blue", marker="+", ls="none")
        plt.title("Lattice size: %5.2f" % self.l +" cm, sf: %5.3f" % self.sf + ", r2: %7.4f" % self.r2 +" cm")
        plt.xlabel("relative blanket fraction")
        plt.ylabel(r"k$_{eff}$ red, CR blue")
        plt.grid(True)

        if self.fit_done :      # Plot fit lines 
            x = np.linspace(min(self.relBA), max(self.relBA ), num=200, endpoint=True)
            plt.plot(x, self.eval_fit_k(x), color="#ee3030", ls="-", \
                label="p0 = %6.4f" % self.KEFF_fit_p[0] + ", p1 = %6.4f" % self.KEFF_fit_p[1] + \
                ", p2 = %6.4f" % self.KEFF_fit_p[2]) 
            plt.plot(x, self.eval_fit_cr(x),color="#3030ee", ls="-", \
                label="p0 = %6.4f" % self.CR_fit_p[0] + ", p1 = %6.4f" % self.CR_fit_p[1] )

        plt.legend(loc="best", fontsize="medium", title="Parameters of the polynomial fits")
        plt.show()
        return
        

    def fit_f_k(self, x, p0, p1, p2):   # Fit function for Lattice.fit() of KEFF
        return p2*x**2 + p1*x + p0

    def eval_fit_k(self, x):            # Returns k-fit value
        if self.fit_done :
            return self.fit_f_k(x, self.KEFF_fit_p[0], self.KEFF_fit_p[1],self.KEFF_fit_p[2])
        else:
            return -1

    def fit_f_cr(self, x, p0, p1):      # Fit function for Lattice.fit() of CR
        return p1*x + p0

    def eval_fit_cr(self, x):           # Returns cr-fit value
        if self.fit_done :
            return self.fit_f_cr(x, self.CR_fit_p[0], self.CR_fit_p[1])
        else:
            return -1

    def get_max_fit_k_times_CR(self):
        'Get max k*CR and x position'
        if not self.fit_done:
            return (-1,-1)
        xx = np.linspace(0.8,1.3,101)
        fom_max = -1.0
        xx_max  = -1.0
        for x in xx:
            k = self.eval_fit_k(x)
            cr= self.eval_fit_cr(x)
            if(k>1.0 and cr>0.95):
                fom_max = k*cr
                xx_max  = x
        return (fom_max, xx_max)

    def fit(self):                      # Fit CR(relBA) and KEFF(relBA) 
        if len(self.KEFF)<4 :
            print("Error, needs at least 4 blanket configurations for the fit!")
            return -1
        
        # Fit KEFF
        result_k = curve_fit(self.fit_f_k, np.array(self.relBA), np.array(self.KEFF), p0=self.KEFF_fit_p, \
            sigma=np.array(self.KEFFerr), absolute_sigma=True, epsfcn=0.0001, full_output=True )
        self.KEFF_fit_p = result_k[0]
        # Get reduced chi2
        self.KEFF_chi2 = (result_k[2]['fvec']**2).sum() / (len(result_k[2]['fvec'])-len(result_k[0]))  
        
        # Fit CR
        result_cr = curve_fit(self.fit_f_cr, np.array(self.relBA), np.array(self.CR), p0=self.CR_fit_p, \
            sigma=np.array(self.CRerr), absolute_sigma=True, epsfcn=0.0001, full_output=True )
        self.CR_fit_p = result_cr[0]
        # Get reduced chi2
        self.CR_chi2  = (result_cr[2]['fvec']**2).sum() / (len(result_cr[2]['fvec'])-len(result_cr[0]))
        self.fit_done = True
        return
    
    def get_k_at_cr(self, cr, extrapolate=1):   # Find KEFF corresponding to particular CR using fits
        if self.fit_done :                      # extrapolate=1|0: do|not use extrapolated relBAs
            # Find relBA for the required CR from the fit
            my_relBA = (cr - self.CR_fit_p[0]) / self.CR_fit_p[1]
            if  my_relBA < min(self.relBA) or my_relBA > max(self.relBA) :  # Extrapolation warning
                print("Wrn, lat [%5.2f" % self.l +", %5.3f" % self.sf + ", %09.6f ] " % self.r2, \
                      "relBA for CR= ", cr, "is %7.4f" % my_relBA," - out of interp. range!")
                if not extrapolate:
                    return -0.1
            return self.eval_fit_k(my_relBA)    # Return corresponding KEFF based on fit functions
        else:
            print("Error, no fit data found for lat [%5.2f" % self.l +", %5.3f" % self.sf + \
                   ", %09.6f ]" % self.r2)
            return -1

        
    def get_fit_results(self):                # Print the fit data
        repr = ""
        if self.fit_done :
            repr += "KEFF\n"
            repr += "p0 = %r, p1 = %r, p2 = %r\n" % (self.KEFF_fit_p[0], self.KEFF_fit_p[1], self.KEFF_fit_p[2])
            repr += "chi2 = %r\n" % self.KEFF_chi2
            repr += "CR\n"
            repr += "p0 =  %r, p1 = %r\n" % (self.CR_fit_p[0], self.CR_fit_p[1])
            repr += "chi2 = %r\n" % self.CR_chi2
        else:
            repr += "Error, the lattice was not fitted!\n"
        return repr

 # --------------- test code ----------------
if __name__ == '__main__':
    print("This module contains MSBR lattice object and methods.")
    input("Press Ctrl+C to quit, or enter else to test it. ")
    msbr = Lattice(7.0900, 0.135548, 2.8575)
    print("Hex area: ", msbr.hexarea())
    print("r1: ", msbr.r1())
    print("r3: ", msbr.r3())
    print("Is this the same lattice? [y]", msbr.exists(7.0900, 0.135548, 2.8575) )
    print("Is this the same lattice? [n]", msbr.exists(7.0900, 0.135548, 2.8576) )
    msbr.printme()


