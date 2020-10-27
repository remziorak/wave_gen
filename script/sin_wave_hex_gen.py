#! /usr/bin/python

from __future__ import print_function
import numpy as np


end_of_line = 0
for t in np.linspace(0, np.pi/2, 64):
	print('X"'  +   hex(int((round((np.sin(t)*127.0 + 128)))))[2:].zfill(2) + '",', end="\t" )
	end_of_line += 1 
	if end_of_line == 10:
		print("")
		end_of_line = 0
