#! /usr/bin/python3
#
# Run ORNL-4528 MSBR parameter scan in Serpent. This is the main program to write all input decks.
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

import sys
import os
import random
import math
import time

import defs
import ornl4528deck

debug = 1
maxdecks = 0                        # How many decks to run, 0 no limits
sleepevery   = 1e10                 # How often sleep
sleepseconds = 60                   # How long to sleep

ideck = 1                # Case counter
for l in defs.apothems:
#    print("Apothem = ", l)
    hexarea = 2.0 * math.sqrt(3.0) * l**2

    for sf in defs.saltfractions:
        
        r1 = math.sqrt(hexarea*sf/(2.0*math.pi))            # r1 

        for mcrun in range(defs.mcruns):
            r2 = random.uniform( r1 + 0.5, l - 1.5 )

            blanketA0 =  defs.blanketfraction * r1**2 *math.pi  # area of the blanket annular hex
            for relBA in defs.relblanketA:         # loop over relative slit sizes
                blanketarea = blanketA0 * relBA
                l2 = math.sqrt( l**2  - blanketarea / (2.0 * math.sqrt(3.0)) )
                slit = l - l2
            
                r3 = math.sqrt( r1**2 + r2**2 )
                if(l2-r3 < 1.0):                # minimum graphite thickness check
                    continue

                if(debug==5):                               # just print values
                    print(l, sf, slit, relBA, r1, r2, r3)
                    continue
 
                # Make the deck
                s2_deck = ornl4528deck.write_deck(l, sf, relBA, l2, r1, r2, r3)
                
                dirname = defs.jobdir + 'l%05.2f/' % l + 'sf%05.3f/' % sf + 'gr%07.4f/' % r2  + 'b%04.3f/' % relBA
                print(dirname)

                fails = os.system('mkdir -p ' + dirname)
                if fails:
                    print("Could not create directory", dirname, " - trying the next one")
                else:
                    try:
                        fname = dirname + defs.filename
                        f = open(fname, 'w')
                        f.write(s2_deck)
                        f.close()
                    except IOError as e:
                        print("Unable to write to file", fname)
                        print(e)

# disabed qsub              else:         # Do the qsub bit
#                    os.system('cd ' + dirname + ';  qsub ' + defs.qsubcommand)

                ideck += 1
                if (maxdecks != 0 and ideck > maxdecks):
                    sys.exit()

                if not (ideck % sleepevery):                    # zzzz
                    time.sleep(sleepseconds)

print("All done.")

