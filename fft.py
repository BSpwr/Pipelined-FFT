import numpy as np
import matplotlib.pyplot as plt
import scipy.fftpack

# Real:

x = [0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009, 0.010, 0.011, 0.012, 0.013, 0.014, 0.015, 0.016]
print (np.fft.fft(x))