import numpy as np
import os
import sys
import matplotlib
import matplotlib.pyplot as plt
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
stage = 'end'

#--------------------------------------preprocess dataset-----------------------------------------
t0 = time.time()

config = np.asarray(np.loadtxt(path + '/config_out_'+stage+'_n_3000_s_256.txt'))
config_pert = np.asarray(np.loadtxt(path + '/perturb_config_out_'+stage+'_n_3000_s_256.txt'))

#stat = np.asarray(np.loadtxt(path + '/stat_out_'+stage+'_n_3000_s_256.txt'))
#stat_pert = np.asarray(np.loadtxt(path + '/perturb_stat_out_'+stage+'_n_3000_s_256.txt'))

field = np.asarray(np.loadtxt(path + '/field_out_'+stage+'_n_3000_s_256.txt'))
#field_pert = np.asarray(np.loadtxt(path + '/perturb_field_out_'+stage+'_n_3000_s_256.txt'))

dataset = np.stack((config,field),axis=2)
#dataset_pert = np.stack((config_pert,field_pert),axis=2)

field_energy = np.einsum('nk,nk->n',config,field)

#normalize the data
config_fit = StandardScaler().fit(config)
config_normalized = config_fit.transform(config)
field_fit = StandardScaler().fit(field)
field_normalized = field_fit.transform(field)

config_fit_pert = StandardScaler().fit(config_pert)
config_pert_normalized = config_fit_pert.transform(config_pert)

normalized_dataset = np.stack((config_normalized,field_normalized),axis=2)


#index value of training set and test set
tot_index = np.arange(0,N,1)
test_index = np.random.choice(tot_index, N-N_train, replace=False)
mask = np.zeros(tot_index.shape,dtype=bool)
mask[test_index] = True
train_index = tot_index[~mask]

#setting the training set and test set
samples_train = normalized_dataset[train_index]
samples_test = normalized_dataset[test_index]

#get labels for all the actual drives
actual_sum = np.sum(field,axis=1)
kmeans_actual =  KMeans(n_clusters=n_drive,random_state=0).fit(actual_sum.reshape(-1,1))  
labels_actual = kmeans_actual.labels_

t1 = time.time()
print("time for loading data", t1-t0)
#--------------------------------------define the network-----------------------------------------

#pixel squared inputs and outputs
n_inputs = size ** 2
n_outputs = n_inputs


#number of neurons in each layer
n_hidden1 = 128
n_hidden2 = 64
n_hidden3 = 2
n_hidden4 = 64
n_hidden5 = 128


#activation function
actf= tf.nn.leaky_relu


#pair of input data
X = tf.placeholder(tf.float32, shape=[None, n_inputs])
Y_truth = tf.placeholder(tf.float32, shape=[None, n_inputs])

#initializer
initializer=tf.glorot_normal_initializer()
    
    
#weights and bias
w1=tf.Variable(initializer([n_inputs,n_hidden1]),dtype=tf.float32)
w2=tf.Variable(initializer([n_hidden1,n_hidden2]),dtype=tf.float32)
w3=tf.Variable(initializer([n_hidden2,n_hidden3]),dtype=tf.float32)
w4=tf.Variable(initializer([n_hidden3,n_hidden4]),dtype=tf.float32)
w5=tf.Variable(initializer([n_hidden4,n_hidden5]),dtype=tf.float32)
woutput=tf.Variable(initializer([n_hidden5,n_outputs]),dtype=tf.float32)
    
b1=tf.Variable(tf.zeros(n_hidden1))
b2=tf.Variable(tf.zeros(n_hidden2))
b3=tf.Variable(tf.zeros(n_hidden3))
b4=tf.Variable(tf.zeros(n_hidden4))
b5=tf.Variable(tf.zeros(n_hidden5))
boutput=tf.Variable(tf.zeros(n_outputs))
    
    
#layers of all network
a=1
l1=actf(tf.matmul(X,w1)+b1,alpha=a)
l2=actf(tf.matmul(l1,w2)+b2,alpha=a)
z=actf(tf.matmul(l2,w3)+b3,alpha=a)
l4=actf(tf.matmul(z,w4)+b4,alpha=a)
l5=actf(tf.matmul(l4,w5)+b5,alpha=a)
Y = actf(tf.matmul(l5,woutput)+boutput,alpha=a)


#layers of decoder network
latent_input = tf.placeholder(tf.float32, shape=[None, n_hidden3])
l4_new =actf(tf.matmul(latent_input,w4)+b4,alpha=a)
l5_new =actf(tf.matmul(l4_new,w5)+b5,alpha=a)
Y_new = actf(tf.matmul(l5_new,woutput)+boutput,alpha=a)
    
        
#define the loss function
reconstruction_loss = tf.reduce_sum(tf.reduce_mean(tf.square(Y - Y_truth),axis=0))
params = tf.trainable_variables()     #get all the trainable parameters
reg_losses = tf.multiply(tf.add_n([ tf.nn.l2_loss(v) for v in params ]), reg_scale)     #regularization loss that encourages sparsity
loss = tf.add(reconstruction_loss, reg_losses)
    
    
#define the optimizer
optimizer = tf.train.AdamOptimizer(learning_rate)
training_op = optimizer.minimize(loss)


#initialize the losses
rec_loss_train = np.zeros([n_epochs])
total_loss_train = np.zeros([n_epochs])
label_correctness = np.zeros([n_epochs])

with tf.Session() as sess:

    init = tf.global_variables_initializer()
    init.run()
    
    for epoch in  range(n_epochs):
        
        ti_0 = time.time()
        np.random.shuffle(samples_train)
        
        N_batch = int(N_train/batchsize)
        
        for i in range(N_batch):
            batch = samples_train[i*batchsize:(i+1)*batchsize]
            batch_config = batch[:,:,0]
            batch_field = batch[:,:,1]
            
            sess.run(training_op, feed_dict={X: batch_config, Y_truth: batch_field}) 
           
        
        rec_loss_train[epoch] = reconstruction_loss.eval(feed_dict={X: samples_test[:,:,0], Y_truth: samples_test[:,:,1]})
        total_loss_train[epoch] = loss.eval(feed_dict={X: samples_test[:,:,0], Y_truth: samples_test[:,:,1]}) 
        
        #get the prediction at current epoch
        outputs_val = Y.eval(feed_dict={X: normalized_dataset[:,:,0]})
        output_field = field_fit.inverse_transform(outputs_val)
        output_field = np.reshape(output_field,[N,size,size])
        
        predict = np.reshape(output_field,[N,size*size])
        predict_sum = np.sum(predict,axis=1)
        
        #get the label at current epoch
        kmeans_predict = KMeans(n_clusters=n_drive,random_state=0).fit(predict_sum.reshape(-1,1))
        labels_predict = kmeans_predict.labels_
        wrong_label = len(np.where(labels_predict!=labels_actual)[0])
        label_correctness[epoch] = float(wrong_label)/N
        ti_f = time.time()
        print('epoch = ' + str(epoch) + ', time =', ti_f-ti_0)
    
    #latent variable z's values        
    codings_val = z.eval(feed_dict={X: normalized_dataset[:,:,0]})
    codings_pert = z.eval(feed_dict={X: config_pert_normalized})
    
    #output values
    outputs_val = Y.eval(feed_dict={X: normalized_dataset[:,:,0]})
    outputs_pert = Y.eval(feed_dict={X: config_pert_normalized})

#--------------------------------------------transform the images back------------------------------------------------   
output_field = field_fit.inverse_transform(outputs_val)
output_field = np.reshape(output_field,[N,size,size])

output_field_pert = field_fit.inverse_transform(outputs_pert)
output_field_pert = np.reshape(output_field_pert,[N,size,size])

t5 = time.time()

print('time of training', t5 - t1)

#-------------------------------------------------------labels----------------------------------------------------------

#get the predicted labels for the driving fields

# predict = np.reshape(output_field,[N,size*size])
# predict_sum = np.sum(predict,axis=1)

# kmeans_predict = KMeans(n_clusters=n_drive,random_state=0).fit(predict_sum.reshape(-1,1))
# labels_predict = kmeans_predict.labels_


# #-------------------------------------------------------plotting--------------------------------------------------------

# idx = np.random.choice(test_index,12)

# field_min = np.min(field)
# field_max = np.max(field)

# #plot 12 random examples of validation/reconstruction
# drive_labels = ['A','B','C'] #,'D','E','F']

# plt.figure(figsize=(12,10))
# for i in range(6):
#     index_l,index_r = idx[2*i], idx[2*i+1]
#     #plot a pair on the left
#     plt.subplot2grid((12,12), (2*i,0), colspan=2, rowspan=2)   
#     plt.imshow(np.reshape(field[index_l],[size,size]), cmap = 'coolwarm', vmin=field_min, vmax=field_max)
#     plt.title('#'+str(index_l)+'_true drive:'+drive_labels[labels_actual[index_l]])
#     plt.subplot2grid((12,12), (2*i,2), colspan=2, rowspan=2)
#     plt.imshow(output_field[index_l], cmap = 'coolwarm', vmin=field_min, vmax=field_max)
#     plt.title('#'+str(index_l)+'_predicted drive:'+drive_labels[labels_predict[index_l]])
#     plt.subplot2grid((12,12), (2*i,4), colspan=2, rowspan=2)
#     subtract = np.reshape(field[index_l],[size,size])-output_field[index_l]
#     plt.imshow(subtract, cmap = 'coolwarm', vmin=field_min/10, vmax=field_max/10)
#     plt.title('#'+str(index_l)+'_true-predict')    
    
#     #plot another pair on the right
#     plt.subplot2grid((12,12), (2*i,6), colspan=2, rowspan=2)   
#     plt.imshow(np.reshape(field[index_r],[size,size]), cmap = 'coolwarm', vmin=field_min, vmax=field_max)
#     plt.title('#'+str(index_r)+'_true drive:'+drive_labels[labels_actual[index_r]])
#     plt.subplot2grid((12,12), (2*i,8), colspan=2, rowspan=2)
#     plt.imshow(output_field[index_r], cmap = 'coolwarm', vmin=field_min, vmax=field_max)
#     plt.title('#'+str(index_r)+'_predict drive:'+drive_labels[labels_predict[index_r]])
#     plt.subplot2grid((12,12), (2*i,10), colspan=2, rowspan=2)
#     subtract = np.reshape(field[index_r],[size,size])-output_field[index_r]
#     plt.imshow(subtract, cmap = 'coolwarm', vmin=field_min/10, vmax=field_max/10)
#     plt.title('#'+str(index_r)+'_true-predict')    

# plt.tight_layout()
# plt.savefig('outputs/'+'reconstruction.png',format='png')  
            

# #plot the learning curve
# rec_loss = np.mean(rec_loss_train[-50:])
# tot_loss = np.mean(total_loss_train[-50:])

# plt.figure(figsize=(12,10))
# plt.subplot2grid((6,4), (0,0), colspan=2, rowspan=2) 
# plt.plot(total_loss_train)
# plt.title("total loss over epoches")
# plt.axis([0,n_epochs,0,2*tot_loss])
# plt.subplot2grid((6,4), (2,0), colspan=2, rowspan=2) 
# plt.plot(rec_loss_train)
# plt.axis([0,n_epochs,0,2*rec_loss])
# plt.title("reconstruction loss over epoches")
# plt.subplot2grid((6,4), (4,0), colspan=2, rowspan=2) 
# plt.plot(label_correctness)
# plt.title("percentage of wrong labels")
# plt.tight_layout()

# plt.savefig('outputs/'+'learning curve.png',format='png')


# print("rec loss is "+ str(rec_loss) + ", tot loss is " + str(tot_loss))

# #plot the latent space
# plt.figure()
# plt.scatter(codings_val[:,0],codings_val[:,1],c=labels_actual)
# #plt.scatter(codings_pert[:,0],codings_pert[:,1],color='red')
# plt.title('latent space visualization')
# plt.savefig('outputs/'+'latent space.png',format='png')

#---------------------------------------------code for the field energy histogram/scatter plots--------------------------
#plot the scatter sum of predicted drives
#plt.scatter(np.arange(0,len(predict_sum),1),predict_sum,c=labels_predict)

# #plot the field energy histogram
# label_0 = np.where(labels_predict==0)[0]
# label_1 = np.where(labels_predict==1)[0]
# label_2 = np.where(labels_predict==2)[0]

# 
# plt.figure()
# plt.hist(field_energy[label_0],bins=50,color='indigo')
# plt.hist(field_energy[label_1],bins=50,color='teal')
# plt.hist(field_energy[label_2],bins=50,color='gold')
# 
# #plot the field energy scatter plot
# time_label = np.linspace(-1,1,N)
# time_label_0 = time_label[label_0]
# time_label_1 = time_label[label_1]
# time_label_2 = time_label[label_2]
# 
# plt.figure()
# plt.scatter(np.arange(0,len(label_0),1),field_energy[label_0],c=time_label_0, cmap = 'Purples')
# plt.scatter(np.arange(0,len(label_1),1),field_energy[label_1],c=time_label_1, cmap = 'Greens')
# plt.scatter(np.arange(0,len(label_2),1),field_energy[label_2],c=time_label_2, cmap = 'Wistia')

        
# plt.show()

# #### Novelty detection

# ks = np.arange(1,10)
# BICs = np.zeros(len(ks))
# for i in range(len(ks)):
#     k = ks[i]
#     kmeans_latent = KMeans(n_clusters=k,random_state=0).fit(codings_val)
#     labels_latent = kmeans_latent.labels_
#     # get cluster centers
#     for j in range(k):
#         mu = np.mean(codings_val[labels_latent==j,:],0)
#         sigmaj = np.mean((codings_val[labels_latent==j,:]-mu)**2)
#         Nj = np.sum(labels_latent==j)
#         logL += Nj*np.log(sigmaj)
#     BICs[i] = 6*k*np.log(N) + 2*logL

# need to just input the correct number of fields

k = 3
mus = []
Sigmas = []
for j in range(k):
    inds = labels_actual==j
    mu = np.mean(codings_val[inds,:],0)
    mus.append(mu)
    Sigma = np.dot((codings_val[inds,:]-mu).T,codings_val[inds,:]-mu)/np.sum(inds)
    Sigmas.append(Sigma)

# codigs_pert
rhos = []
for i in range(len(codings_pert)):
    # figure out which cluster is most likely
    rho = -np.inf; jtrue = -1
    for j in range(k):
        Q = np.dot(np.linalg.inv(Sigmas[j]),codings_pert[i,:]-mus[j])
        Q = np.sum((codings_pert[i,:]-mus[j])*Q)
        rho_new = (-Q/2)-np.log(np.sqrt(np.linalg.det(2*np.pi*Sigmas[j])))
        if rho_new>rho:
            jtrue = j
            rho = rho_new
    rhos.append(rho)

rhos_val = []
for i in range(len(codings_val)):
    # figure out which cluster is most likely
    rho = -np.inf; jtrue = -1
    for j in range(k):
        Q = np.dot(np.linalg.inv(Sigmas[j]),codings_val[i,:]-mus[j])
        Q = np.sum((codings_val[i,:]-mus[j])*Q)
        rho_new = (-Q/2)-np.log(np.sqrt(np.linalg.det(2*np.pi*Sigmas[j])))
        if rho_new>rho:
            jtrue = j
            rho = rho_new
    rhos_val.append(rho)

thresholds = np.sort(np.hstack((np.unique(rhos),np.unique(rhos_val))))
FPR = np.zeros(len(thresholds))
TPR = np.zeros(len(thresholds))
for i in range(len(thresholds)):
    num_pert = np.sum(rhos<thresholds[i])
    num_val = np.sum(rhos_val<thresholds[i])
    TPR[i] = num_pert/len(rhos)
    FPR[i] = num_val/len(rhos_val)

plt.rc('text', usetex=True)
plt.rc('font', size=16)

plt.plot(FPR2,TPR2,'-k',label='Work dissipation')
plt.plot(FPR,TPR,'--',label='Autoencoder')
plt.xlabel('False positive rate',size=20)
plt.ylabel('True positive rate',size=20)
plt.savefig('ROCs_2.pdf',bbox_inches='tight')
plt.show()

# get ROC curve for dissipation rate

