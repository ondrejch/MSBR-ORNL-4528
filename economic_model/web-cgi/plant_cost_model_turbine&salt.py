import os
import numpy as np
salt_opt = int(input('Enter the type of salt you want to use: '))
salt_matrix = [['  salt type', ' index', ' composition', '  price [kg/m^3]'],
               ['LiF-BeF2-UF4', '  1', '  .63-.366-.004    ',       3774.6],
               ['LiF-BeF2-UF4', '  2', '  .636-.362-.0022  ',    1936.95],
               ['LiF-BeF2-UF4', '  3', '  .636-.366-.004    ',     869.4],
               ['LiF-BeF2-UF4', '  4','   .67-.18-.15      ',        522.4],
               ['LiF-BeF2-ThF4', ' 5','    .71-.02-.027     ',       2324],
               ['LiF-BeF2-ThF4', ' 6','    .63-.366-.004  ',    11776.44],
               ['LiF-BeF2-ThF4', ' 7','    .63-.366-.004    ',      34.37],
               ['LiF-BeF2-ThF4', ' 8','     .389-.611       ',          709.89],
               ['  NaBF4-NaF', '   S9', '      .92-.08         ',        2068],
               ['  NaBF4-NaF', '  10', '     .389-.611       '   ,         2095]]

os.linesep


print(np.matrix(salt_matrix))

#salt_price = salt_matrix(int(salt_opt), int(salt_opt+3))
if salt_opt == 1:
   salt_price = 3774.6
   print 'salt unit price is : ',salt_price

if salt_opt == 2:
   salt_price = 1936.95
   print 'salt unit price is : ',salt_price

if salt_opt == 3:
   salt_price = 869.4
   print 'salt unit price is : ',salt_price

if salt_opt == 4:
   salt_price = 869.4
   print 'salt unit price is : ',salt_price

if salt_opt == 5:
   salt_price = 522.4
   print 'salt unit price is : ',salt_price

if salt_opt == 6:
   salt_price = 1177.64
   print 'salt unit price is : ',salt_price

if salt_opt == 7:
   salt_price = 809.6
   print 'salt unit price is : ',salt_price

if salt_opt == 8:
   salt_price = 709.89
   print('salt unit price is : ',salt_price)

if salt_opt == 9:
   salt_price = 2068
   print('salt unit price is : ',salt_price)

if salt_opt == 10:
   salt_price = 2095
   print('salt unit price is : ',salt_price)



if salt_opt > 10 or salt_opt <1:
    import sys
    sys.exit("must enter the index that is available in the table")

vol_salt = input('Enter your salt volumn [m^3]')
tot_salt = salt_price * vol_salt

turbine_matrix = [['index', '  company',      '      model',    '     price [kg/m^3]'],
                  ['  1',     '    siemens',     '     SST-800     ',        1.55e7],
                  ['  2',     '    siemens',   '   SST-900       ',       1.85e7],
                  ['  3',      '    Doosan',      '      MTD50        ',         1.02e6],
                  ['  4',        '      GE',     '      9F 3-series   ',      1.5e7],
                  ['  5',        '      GE',     '      9F 5-series   ',      1.75e7],
                  ['  6',       '     DTEC',      '       GMB2550r     ',      8.5e6]]


print(np.matrix(turbine_matrix))

turbine_opt = int(input('Enter the turbine you desire to use: '))
if turbine_opt == 1:
   turbine_price = 1.55e7
   print'turbine price is : ',turbine_price

if turbine_opt == 2:
   turbine_price = 1.85e7
   print 'turbine price is : ',turbine_price

if turbine_opt == 3:
   turbine_price = 1.02e6
   print ' turbine price is : ',turbine_price

if turbine_opt == 4:
   turbine_price = 1.5e7
   print 'turbine price is : ',turbine_price

if turbine_opt == 5:
   turbine_price = 1.75e7
   print 'turbine price is : ',turbine_price

if turbine_opt == 6:
   turbine_price = 8.5e6
   print 'turbine price is : ',turbine_price




if turbine_opt > 6 or turbine_opt <1:
    import sys
    sys.exit("must enter the index that is available in the table")

tot = turbine_price + tot_salt
print 'facility cost is ', tot, 'dollars'
