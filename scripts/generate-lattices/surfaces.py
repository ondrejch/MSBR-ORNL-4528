#!/usr/bin/python3
#
# Generate surfaces of the MSBR Serpent deck 
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

def write_surfaces(l, l2, r1, r2, r3):
#   print ("l ",l,"  sf ",sf ,"   rs ",r1," ",r2," ",r3)

    surfaces = '''
%______________surface definitions__________________________________
surf 1   hexxc  0.0 0.0 {l} % reflective unit cell boundary
surf 2   hexxc  0.0 0.0 {l2} % graphite boundary
surf 11  cyl    0.0 0.0 {r1} % central fuel channel radius
surf 12  cyl    0.0 0.0 {r2} % inner channel inner radius
surf 13  cyl    0.0 0.0 {r3} % inner channel outer radius
'''
    surfaces = surfaces.format(**locals())
    return surfaces

if __name__ == '__main__':
    print("This module writes surfaces for the MSBR lattice.")
    input("Press Ctrl+C to quit, or enter else to test it.")
    print(write_surfaces(7.0900,6.8262,1.9382,2.8575,3.4528))


