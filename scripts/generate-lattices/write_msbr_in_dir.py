#! /usr/bin/python3
#
# Generate full ORNL-4528 MSBR Serpent input deck based on the job directory
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

import sys
import os
import re
import math

import defs
import ornl4528deck

debug = 0                       # Verbosity level

mypath = str.strip(os.getcwd()) # Get the current path

(_l, _sf, _r2, _relBA) = str.split(re.sub("[a-zA-Z]","", re.sub("^.*l", "l", mypath)),"/") # Parse path into lattice parameters

l     = float(_l)               # Conver to numbers
sf    = float(_sf)
r2    = float(_r2)
relBA = float(_relBA)

hexarea     = 2.0 * math.sqrt(3.0) * l**2           # Area of the lattice [cm2]
r1          = math.sqrt(hexarea*sf/(2.0*math.pi))   # r1 
blanketA0   = defs.blanketfraction * r1**2 *math.pi # Area of the blanket annular hex
blanketarea = blanketA0 * relBA                     # Absolute blanket area
l2 = math.sqrt( l**2  - blanketarea / (2.0 * math.sqrt(3.0)) ) # Apothem of the graphite hex
slit = l - l2                                       # Blanket width

r3 = math.sqrt( r1**2 + r2**2 )
if l2-r3 < 1.0 :                # minimum graphite thickness check
    print("Err: Minimum graphite thickness check < 1 cm, no deck written")
    sys.exit(-1)

if debug==5 :                               # just print values
    print(l, sf, slit, relBA, r1, r2, r3)
    sys.exit(0)
 
# Make the deck
s2_deck = ornl4528deck.write_deck(l, sf, relBA, l2, r1, r2, r3)

# Write the deck
fname = defs.filename
f = open(fname, 'w')
f.write(s2_deck)
f.close()

print("All done.")
