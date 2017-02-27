import os
import numpy as np

print ('SALT TYPE TABLE')
print ('')
salt_matrix = [['  Salt Type', ' Index', ' Composition', '  Price [$/m^3]'],
               ['                                                         '],
               ['LiF-BeF2-UF4' '      1' '      .63-.366-.004    ',       3774.6],
               ['LiF-BeF2-UF4' '      2' '      .636-.362-.0022  ',    1936.95],
               ['LiF-BeF2-UF4' '      3' '      .636-.366-.004   ',     869.4],
               ['LiF-BeF2-UF4' '      4''      .67-.18-.15      ',        522.4],
               ['LiF-BeF2-ThF4' '     5''      .71-.02-.027     ',       2324],
               ['LiF-BeF2-ThF4' '     6''      .63-.366-.004    ',    11776.44],
               ['LiF-BeF2-ThF4' '     7''      .63-.366-.004    ',      34.37],
               ['LiF-BeF2-ThF4' '     8''      .389-.611        ',          709.89],
               ['  NaBF4-NaF' '       9' '      .92-.08          ',        2068],
               ['  NaBF4-NaF' '       10' '     .389-.611        '   ,         2095]]

print(np.matrix(salt_matrix))
print ('')
salt_opt = int(input('Enter the type of salt you want to use: '))



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
    sys.exit("must enter the index that is available in the table(input the index of the salt)")

print ('')
vol_salt = input('Enter your salt volumn [m^3]')
tot_salt = salt_price * vol_salt
print ('')

print ('SALT coolant Table')
print ('')
salt_matrix = [['  coolant Type', ' Index', ' Composition', '  Price [$/m^3]'],
               ['AHTR candidate coolant salts            ],                                                  '],
               ['NaF-KF-ZrF4' '        1' '      4-27-69              ',            11700],
               ['LiF-NaF-KF' '         2' '      29-12-59             ',          24100],
               ['LiF-NaF-BeF2' '       3' '      24-46-30             ',        35000],
               ['LiF-BeF2' '           4''      53-47                ',           52200],
               ['other industrial salts'],
               ['NaNO3-NaNO2-KNO3' '   5''      7-48-45              ',            570],
               ['NaF-NaBF4' '          6''      8-92                 ',              1500],
               ['LiCL-KCL' '           7''      59-41                ',            1800],
               ['Very low-vapor coolants               '],
               ['Pb' '                 8''      1                    ',                 720],
               [' Pb-Bi' '             9' '      1                    ',             74400],
               ['  Bi' '               10' '     1                    '   ,                129000]]

print(np.matrix(salt_matrix))
print ('')
coolant_opt = int(input('Enter the type of coolant you want to use(input index): '))



#salt_price = salt_matrix(int(salt_opt), int(salt_opt+3))
if coolant_opt == 1:
   coolant_price = 11700
   print 'coolant unit price is : ',coolant_price

if coolant_opt == 2:
   coolant_price = 24100
   print 'coolant unit price is : ',coolant_price

if coolant_opt == 3:
   coolant_price = 35000
   print 'coolant unit price is : ',coolant_price

if coolant_opt == 4:
   coolant_price = 52200
   print 'coolant unit price is : ',coolant_price

if coolant_opt == 5:
   coolant_price = 570
   print 'coolant unit price is : ',coolant_price

if coolant_opt == 6:
   coolant_price = 1500
   print 'coolant unit price is : ',coolant_price

if coolant_opt == 7:
   coolant_price = 1800
   print 'coolant unit price is : ',coolant_price

if coolant_opt == 8:
   coolant_price = 720
   print('coolant unit price is : ',coolant_price)

if coolant_opt == 9:
   coolant_price = 74400
   print('coolant unit price is : ',coolant_price)

if coolant_opt == 10:
   coolant_price = 129000
   print('coolant unit price is : ',coolant_price)



if coolant_opt > 10 or coolant_opt <1:
    import sys
    sys.exit("must enter the index that is available in the table(input the index of the coolant)")

print ('')
vol_coolant = input('Enter your coolant volumn [m^3]')
tot_coolant = coolant_price * vol_coolant
print ('')

turbine_matrix = [['index' '  company'      '      model',    '     price [$/m^3]'],
                  ['  1'     '    siemens'     '     SST-800     ',        1.55e7],
                  ['  2'     '    siemens'   '   SST-900       ',       1.85e7],
                  ['  3'      '    Doosan'      '      MTD50        ',         1.02e6],
                  ['  4'        '      GE'     '      9F 3-series   ',      1.5e7],
                  ['  5'        '      GE'     '      9F 5-series   ',      1.75e7],
                  ['  6'       '     DTEC'      '       GMB2550r     ',      8.5e6]]


print ('Turbine TABLE')
print ('')
print(np.matrix(turbine_matrix))
print ('')

turbine_opt = int(input('Enter the turbine you desire to use (input the index of the turbine you want): '))

if turbine_opt >= 7 or turbine_opt <1:
    import sys
    sys.exit("must enter the index that is available in the table")

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

tot = turbine_price + tot_salt + tot_coolant
print 'facility flat cost witout loan: ', tot, 'dollars'

loan_opt = int(input('pay in full ? Enter 1 for calculating cost with interest rate, or press other key to quit) '))

if loan_opt == 1:
    loan_amount = int(input('Enter how much to loan: '))
    r_hundred = float(input('Enter the annual interest rate: '))
    r = r_hundred/100.0

    print r_hundred
    print r

    n = float(input('Enter the number of times that interest is compounded per year: '))
    t = float(input('Enter the number of years the money is invested or borrowed for: '))

    term_num = n*t               # how many terms of loan
    term_rate = r/n              # interest rate for each term

    term_payment = float((((1+term_rate)**term_num)*term_rate) /(((1+term_rate)**term_num)-1)*loan_amount)    # payment for each term
    loan_payment = term_payment *term_num                                                                     # total payment of loan (interest + loan amount)
    loan_cost = (tot-loan_amount) + loan_payment                                                              # total cost with loan
    print 'facility real cost is: ', loan_cost, 'dollars'

else:
    exit


# put table 18 from the last year(done)
# hitec boiling pt = 816 deg C
# resource for the turbine price
# get generator
# A = P (1 + r/n) ^ (nt)



