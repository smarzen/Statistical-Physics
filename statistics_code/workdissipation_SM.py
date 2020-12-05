import numpy as np
import os
import sys
import matplotlib
import matplotlib.pyplot as pl
import tensorflow as tf
from sklearn.preprocessing import StandardScaler
from random import randint
import cv2
import gc
import time
from scipy.optimize import minimize
from sklearn.cluster import MeanShift, estimate_bandwidth
from sklearn.cluster import KMeans

#parameters
N = 3000
batchsize = 900
N_train = int(N * .9)
size = 16
n_epochs = 300
learning_rate = 0.005
reg_scale = 0.001
n_drive = 3

path = 'sim_4_10_4_40_expanded/'
#'sim_4_10_5_16_expanded/'
stage1 = 'end'
stage2 = 'end'
# change 'end' to 'beg' if want to see how accuracy improves as the spins learn the drive

#--------------------------------------preprocess dataset--------------------------------------

stat = np.asarray(np.loadtxt(path + 'stat_out_'+stage1+'_n_3000_s_256.txt'))
stat_pert = np.asarray(np.loadtxt(path + 'perturb_stat_out_'+stage2+'_n_3000_s_256.txt'))

wdiss_unpert = np.diff(stat[:,0])
wdiss_pert = np.diff(stat_pert)

#field = np.asarray(np.loadtxt(path + '/field_out_'+stage+'_n_3000_s_256.txt'))
#field_pert = np.asarray(np.loadtxt(path + '/perturb_field_out_'+stage+'_n_3000_s_256.txt'))

# novelty detection

# 1. get the density of stat

# Parzen window estimates
hs = np.power(3,np.linspace(-5,2,20))
pseudo_likelihoods = []
# choose the right h
for h in hs:
	# compute pseudolikelihood
	foo = 0
	for j in range(len(wdiss_unpert)):
		new_xs = np.hstack([wdiss_unpert[:j],wdiss_unpert[j+1:]])
		# calculate estimate of density at xs[j]
		foo += np.log(np.mean(np.exp(-(new_xs-wdiss_unpert[j])**2/2/h)/np.sqrt(2*np.pi*h)))
	pseudo_likelihoods.append(foo)
ind = np.argmax(pseudo_likelihoods)
h = hs[ind]
#
# now to calculate ts_test
phi_orig = 0*wdiss_unpert
phi_pert = 0*wdiss_pert
for i in range(len(wdiss_unpert)):
	phi_orig[i] = np.mean(np.exp(-(wdiss_unpert-wdiss_unpert[i])**2/2/h)/np.sqrt(2*np.pi*h))
for i in range(len(wdiss_pert)):
	phi_pert[i] = np.mean(np.exp(-(wdiss_unpert-wdiss_pert[i])**2/2/h)/np.sqrt(2*np.pi*h))

thresholds = np.unique(np.hstack((phi_orig,phi_pert)))
TPR2 = np.zeros(len(thresholds))
FPR2 = np.zeros(len(thresholds))
for i in range(len(thresholds)):
	TPR2[i] = np.sum(phi_pert<thresholds[i])/len(phi_pert)
	FPR2[i] = np.sum(phi_orig<thresholds[i])/len(phi_orig)

#pl.plot(FPR2,TPR2)
#pl.show()
