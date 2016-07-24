from initlattices import LatticeList
msbrs = LatticeList()
msbrs.read_data("/home/ondrejch/msbr-scan/job1/testdata")
msbrs.fit_all_lattices()
msbrs.latlist[23].plot()


from initlattices import LatticeList
msbrs = LatticeList()
msbrs.read_data("/home/ondrejch/msbr-scan/job1/sorted.j1.data")
msbrs.fit_all_lattices()

import pickle
fout = open("latdump.pickle","wb")
pickle.dump(msbrs,fout)


import pickle
fin = open("run1_nlat_8938.pickle","rb")
msbrs=pickle.load(fin)


import matplotlib.pyplot as plt
import numpy as np

crarr = np.linspace(0.9, 1.0, 11)   
np.meshgrid(crarr, msbrs.larr, msbrs.sfarr)
#https://docs.scipy.org/doc/scipy-0.14.0/reference/generated/scipy.interpolate.griddata.html

from kmax import MaxKforCR
mk = MaxKforCR("run1_nlat_8938.pickle")

# -----------------------------------------------

from initlattices import LatticeList
msbrs = LatticeList()
msbrs.read_data("/home/ondrejch/msbr-scan/job4_1/sorted.j4_1.data")
msbrs.fit_all_lattices()
msbrs.latlist[1123].plot()
msbrs.check_chi2s()
import pickle
fout = open("/home/ondrejch/msbr-scan/job4_1/latdump.pickle","wb")
pickle.dump(msbrs,fout)
