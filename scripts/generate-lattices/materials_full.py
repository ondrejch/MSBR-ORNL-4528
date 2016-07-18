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
				to use (e.g., 09c).
	Outputs:
		mats:	String containing the material cards'''

	mats = '''
%______________material definitions_________________________________
% LiF-BeF2-UF4 (68.5-31.3-0.2 mole%)
mat FLiBeU -1.93600 tmp 973.
rgb 130 32 144
 3006.{lib}  -0.000725 % Li-6
 3007.{lib} -14.495960 % Li-7
 4009.{lib}  -8.508748 % Be-9
 9019.{lib} -75.588074 % F-19
92233.{lib}  -1.265844 % U-233
92234.{lib}  -0.140649 % U-234

% LiF-BeF2-ThF4-PaF4 (71.0-2.0-27.0-0.0 mole%)
mat FLiBeTh -4.39764 tmp 973.
rgb 0 157 254
 3006.{lib}  -0.000243 % Li-6
 3007.{lib}  -4.855845 % Li-7
 4009.{lib}  -0.175712 % Be-9
 9019.{lib} -33.892970 % F-19
90232.{lib} -61.052512 % Th-232
91233.{lib}  -0.022718 % Pa-233

%  NUCLEAR GRAPHITE: Natural concentration of carbon
%  DENSITY: 1.82 G/CC
mat graphite -1.82 moder graph 6000 tmp 973
rgb 130 130 130
%rgb 255 255 255
6000.{lib} 1
%  THERMAL SCATTERING LIBRARY FOR GRAPHITE
therm graph gre7.08t

%  HELIUM: gas due to alpha particles
%  DENSITY: 54.19 E-6 g/cc
mat he -54.19E-6 tmp 973
rgb 0 255 16
2004.{lib} 1

% CONTROL ROD: NATURAL BORON at 900K
% DENSITY: 2.3 g/cc
% MELT TEMP: 2076C or 2349.15K
% 19.9 B10 and 80.1 B11
mat absorber -2.3 tmp 973
rgb 74 74 74
5010.{lib} -0.199
5011.{lib} -0.801

%  TODO: Hastelloy
mat hastelloy -8.86 tmp 973
rgb 250 170 170
 28058.{lib}  -0.472120   %  Ni
 28060.{lib}  -0.181860   %  Ni
 28061.{lib}  -0.007905   %  Ni
 28062.{lib}  -0.025206   %  Ni
 28064.{lib}  -0.006419   %  Ni
 42100.{lib}  -0.015408   %  Mo
 42092.{lib}  -0.023744   %  Mo
 42094.{lib}  -0.014800   %  Mo
 42095.{lib}  -0.025472   %  Mo
 42096.{lib}  -0.026688   %  Mo
 42097.{lib}  -0.015280   %  Mo
 42098.{lib}  -0.038608   %  Mo
 24050.{lib}  -0.003041   %  Cr
 24052.{lib}  -0.058652   %  Cr
 24053.{lib}  -0.006651   %  Cr
 24054.{lib}  -0.001656   %  Cr
 26054.{lib}  -0.002923   %  Fe
 26056.{lib}  -0.045877   %  Fe
 26057.{lib}  -0.001059   %  Fe
 26058.{lib}  -0.000141   %  Fe
 14028.{lib}  -0.009223   %  Si
 14029.{lib}  -0.000468   %  Si
 14030.{lib}  -0.000309   %  Si
 25055.{lib}  -0.008000   %  Mn
 74182.{lib}  -0.001325   %  W
 74183.{lib}  -0.000715   %  W
 74184.{lib}  -0.001532   %  W
 74186.{lib}  -0.001422   %  W
 29063.{lib}  -0.002421   %  Cu
 29065.{lib}  -0.001079   %  Cu
'''
	mats = mats.format(**locals())
	return mats

if __name__ == '__main__':
	print("This module writes materials for the MSBR core.")
	input("Press Ctrl+C to quit, or enter else to test it.")
	print(write_materials('09c'))


