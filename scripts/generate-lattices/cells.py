#!/usr/bin/python3
#
# Generate cells of MSBR Serpent deck
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

def write_cells():
	'''Function to write cell cards for Serpent input deck.
	Outputs:
		cells:		String containing cell cards'''
	
	cells = '''
%______________cell definitions_____________________________________
cell 11  0  FLiBeU    -11      % inner fuel channel
cell 31  0  graphite   11 -12  % recursive sleeve
cell 12  0  FLiBeU     12 -13  % outer fuel channel
cell 30  0  graphite   13 -2   % moderator block section
cell 20  0  FLiBeTh     2 -1   % blanket region
cell 99  0  outside     1      % graveyard  
'''
	cells = cells.format(**locals())
	return cells

if __name__ == '__main__':
	print("This module writes cells for the MSBR lattice.")
	input("Press Ctrl+C to quit, or enter else to test it. ")
	print (write_cells())


