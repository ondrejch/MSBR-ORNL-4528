#!/usr/bin/python3
#
# Generate materials for the MSBR Serpent deck
# Ondrej Chvala, ochvala@utk.edu
# 2016-07-16
# GNU/GPL

def write_materials(lib):
	'''Function to write material cards for Serpent input deck.
	Inputs: 
		lib:	String containing the neutron cross section library
				to use (e.g., {lib}).
	Outputs:
		mats:	String containing the material cards'''

	mats = '''
%______________material definitions_________________________________
% LiF-BeF2-UF4 (68.5-31.3-0.2 mole%)
mat FLiBeU -2.0129362 tmp 973.0
rgb 130 32 144
  3006.{lib}  -0.00000621   %  Li
  3007.{lib}  -0.14496063   %  Li
  9019.{lib}  -0.75588073   %  F
  4009.{lib}  -0.08508749   %  Be
 92233.{lib}  -0.01265301   %  U
 92234.{lib}  -0.00141193   %  U

% LiF-BeF2-ThF4-PaF4 (71.0-2.0-27.0-0.0 mole%)
mat FLiBeTh -4.39764 tmp 973.
rgb 0 157 254 
 3006.{lib}   -0.000243     %  Li6
 3007.{lib}   -4.855845     %  Li7
40090.{lib}   -0.175712     %  Be9
 9019.{lib}  -33.892970     %  F19
90232.{lib}  -61.052512     %  Th232
91233.{lib}   -0.022718     %  Pa233

%  NUCLEAR GRAPHITE: Natural concentration of carbon
%  DENSITY: 1.82 G/CC
mat graphite -1.82 moder graph 6000 tmp 973
rgb 130 130 130
%rgb 255 255 255
6000.{lib} 1
%  THERMAL SCATTERING LIBRARY FOR GRAPHITE
therm graph gre7.08t
'''
	mats = mats.format(**locals())
	return mats

if __name__ == '__main__':
	print("This module writes materials for the MSBR lattice.")
	input("Press Ctrl+C to quit, or enter else to test it. ")
	print(write_materials('09c'))


