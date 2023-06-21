#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul 16 15:40:33 2019

read_digit: function to take in a file and store it in the same digit format

@author: des0pcm (Peter Matthews)
"""

import matplotlib.image as img
import matplotlib.pyplot as plt
import numpy as np

def read_digit(fname):
    """ read file, and map into an 8x8 format, tightly bounded """
    # First, read the image
    dig_raw = img.imread('marker-2.png')
    
    # dig_raw is an array with 1.0 = white, opposite to svm digits
    dig_raw = 1-dig_raw
    
    dig_flat = dig_raw[:,:,0] # flatten RGBI to R
    
    # now find/shrink boundary of digit
    # assume that digit is on a white background (0ish), and find where this ends
    # Do this by computing sum of each line, normalising, and then find where the image starts
    norm0 = np.sum(dig_flat,0)/max(np.sum(dig_flat,0))
    norm1 = np.sum(dig_flat,1)/max(np.sum(dig_flat,1))
    
    thresh = 0.05 # threshold for image data
    test0 = [*(norm0 > thresh)]   # python wizardry here... array -> list
    idx0_low = test0.index(True) # find the first true
    test0.reverse()
    idx0_high = test0.index(True) # find the last true (by reversing list)
    
    test1 = [*(norm1 > thresh)] # and again the other direction
    idx1_low = test1.index(True)
    test1.reverse()
    idx1_high = test1.index(True)
    
    # Crop
    
    dig_crop = dig_flat[idx1_low:-idx1_high, idx0_low:-idx0_high] # note the swap of indices
        
    #plt.imshow(dig_crop)
    #plt.show()
    
    # scale to an 8x8 object (roughly!)
    dx = int(np.floor(np.shape(dig_crop)[0]/8))
    dy = int(np.floor(np.shape(dig_crop)[1]/8))
    
    dig_out = []
    for x in range(8):
        dig_line = []
        for y in range (8):
            dig_sub = dig_crop[x*dx:(x+1)*dx, y*dy:(y+1)*dy]
            dig_line.append(np.mean(dig_sub))
        dig_out.append(np.asarray(dig_line))
    
    dig_out = np.asarray(dig_out)
    dig_out = dig_out/dig_out.max()
    dig_out = np.floor(16*dig_out) # sci-kit learn digits encoded 0-16
    # return result
    return(dig_out)
    

dig=read_digit('marker-2.png')
plt.imshow(dig)

dig_flat = dig.reshape(1,-1) # flatten matrix into a 1d vector
#classifier.predict(dig_flat) #once classifier has been trained!
