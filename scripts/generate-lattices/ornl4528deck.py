#!/usr/bin/python3
#
# Generate ORNL-4528-like MSBR Serpent deck
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

import defs
import materials
import cells
import surfaces

def write_deck(l, sf, relblanket, l2, r1, r2, r3):
	# Header
	output = '''\
set title "ORNL MSBR unit cell, l {l}, sf {sf}, relBA {relblanket}, radii {r1} {r2} {r3}"

'''
	# Surfaces
	output += surfaces.write_surfaces(l, l2, r1, r2, r3)

	# Cells
	output += cells.write_cells()

	# Materials
	output += materials.write_materials(defs.xsectionlibrary)

	# Data cards
	data_cards = '''
%______________data cards___________________________________________
% Boundary condition
set bc 3

% Neutron population and criticality cycles
set pop 10000 100 40 % 10000 neutrons, 100 active, 40 inactive cycles

% Data Libraries
set acelib "sss_endfb7u.sssdir"
set declib "sss_endfb7.dec"
set nfylib "sss_endfb7.nfy"

% Analog reaction rate
set arr 2
'''
	output += data_cards

	# Plots
	plot_cards = '''
% Plots
plot 3 1500 1500
% mesh 3 1500 1500
'''
	output += plot_cards

	output = output.format(**locals())
	return output

if __name__ == '__main__':
	print("This module writes the deck of the MSBR lattice.")
	input("Press Ctrl+C to quit, or enter else to test it. ")
	print(write_deck(7.0644,0.2382,1.0,6.9,1.9050,2.8575,3.4528))


