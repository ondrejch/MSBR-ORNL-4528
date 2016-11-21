from pylab import *
import matplotlib.pyplot as plt
import numpy as np

font = {'family':'serif','weight':'bold','size':20}

plt.rc('font', **font)
plt.rc('text', usetex=True)

diff = np.loadtxt('difference.txt',unpack=True)

index = np.arange(0,500,0.1)
plt.bar(index,diff,0.1)
plt.xlabel(r'$ \rm Time \ [s]$')
plt.ylabel(r'$ \rm \% \ Difference$')
plt.title(r'$ \rm \Delta \% \ T_{f1}(t) \ - \ Simulink \ vs \ XCOS$')
show()
