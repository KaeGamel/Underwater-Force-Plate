# -*- coding: utf-8 -*-
"""
Created on Fri Nov 27 11:43:37 2020

@author: Kaelyn
"""

import numpy as np
import scipy.linalg

# Read data from file 'filename.csv' 
# (in the same directory that your python process is based)
# Control delimiters, rows, column names with read_csv (see later) 

data=np.loadtxt(open("Calibrations.csv","rb"),delimiter=",")

## Extract the columns
iput= (data[:,0:3])
print("Input", iput)

oput= (data[:,3:6])
print("Ouput", oput)

x = scipy.linalg.lstsq(iput,oput)
print(x)


