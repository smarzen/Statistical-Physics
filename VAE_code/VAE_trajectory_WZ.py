import os
import sys
import time
import numpy as np
from mpl_toolkits import mplot3d
import matplotlib.pyplot as plt
import tensorflow as tf
tfd = tf.contrib.distributions
from entropy_estimators import kldiv
from sklearn.naive_bayes import GaussianNB
from scipy.spatial import distance

dr = '/n/home13/weishunzhong/thermodynamics/'

N = 5000
n_epochs = 200
N_train = int(N * .9)
batchsize = int(N * .1)
size = 16 
learning_rate = 0.001
beta = 1
latent_dim = 2
seed = 24

np.random.seed(seed)
tf.random.set_random_seed(seed)
t0 = time.time()

#------------------------------------------------preprocess data-----------------------------------------------------
#256 spins

#same initial condition_half strength
path = 'traj_1-2_fixed_IC_with_history/t_' + sys.argv[1]

config = np.asarray(np.loadtxt(dr + 'data/256_spins/' + path + '/config.txt'))
stat = np.asarray(np.loadtxt(dr + 'data/256_spins/' + path + '/stat.txt'))
field = np.asarray(np.loadtxt(dr + 'data/256_spins/' + path + '/field.txt'))

if not os.path.exists('outputs/'+sys.argv[1]):
    os.makedirs('outputs/'+sys.argv[1])
    

#shift -1,1 spins to 0,1 spins
config = (config+1)/2

#index value of training set and test set
tot_index = np.arange(0,N,1)
test_index = np.random.choice(tot_index, N-N_train, replace=False)
mask = np.zeros(tot_index.shape,dtype=bool)
mask[test_index] = True
train_index = tot_index[~mask]

#setting the training set and test set
config_train = config[train_index]
config_test = config[test_index]


#labels_actual = stat[:,-1]
labels_actual = stat[:,-5].astype('int')
n_drive = len(np.unique(labels_actual))
field_history = stat[:,-5:].astype('int')

n_drive = len(np.unique(labels_actual))


#-------------------------------------------------define network-----------------------------------------------------
def make_encoder(data, code_size):
  x = tf.layers.flatten(data)
  x = tf.layers.dense(x, 200, tf.nn.relu)
  x = tf.layers.dense(x, 200, tf.nn.relu)
  loc = tf.layers.dense(x, code_size)
  scale = tf.layers.dense(x, code_size, tf.nn.softplus)
  return tfd.MultivariateNormalDiag(loc, scale)


def make_prior(code_size):
  loc = tf.zeros(code_size)
  scale = tf.ones(code_size)
  return tfd.MultivariateNormalDiag(loc, scale)


def make_decoder(code, data_shape):
  x = code
  x = tf.layers.dense(x, 200, tf.nn.relu)
  x = tf.layers.dense(x, 200, tf.nn.relu)
  logit = tf.layers.dense(x, np.prod(data_shape))
  logit = tf.reshape(logit, [-1] + data_shape)
  
  #Bernoulli output
  return tfd.Independent(tfd.Bernoulli(logit), 2)
  
      
#-------------------------------------------------define loss------------------------------------------------------
data = tf.placeholder(tf.float32, [None, size, size])

make_encoder = tf.make_template('encoder', make_encoder)
make_decoder = tf.make_template('decoder', make_decoder)

# Define the model.
prior = make_prior(code_size=latent_dim)
posterior = make_encoder(data, code_size=latent_dim)
code = posterior.sample(seed=seed)
decoder = make_decoder(code, [size, size]).sample(seed=seed)

# Define the loss.
likelihood = make_decoder(code, [size, size]).log_prob(data)
divergence = tfd.kl_divergence(posterior, prior)
likelihood_loss = tf.reduce_mean(likelihood)
divergence_loss = tf.reduce_mean(divergence)

elbo = tf.reduce_mean(likelihood - beta*divergence)
optimize = tf.train.AdamOptimizer(learning_rate).minimize(-elbo)

##-------------------------------------------------training-----------------------------------------------------

kl_loss_train = np.zeros([n_epochs])
kl_loss_test = np.zeros([n_epochs])
rec_loss_train = np.zeros([n_epochs])
rec_loss_test = np.zeros([n_epochs])
total_loss_train = np.zeros([n_epochs])
total_loss_test = np.zeros([n_epochs])


with tf.train.MonitoredSession() as sess:
    for epoch in range(n_epochs):
        feed = {data: config_test.reshape([-1, size, size])}
        rec_loss_test[epoch], kl_loss_test[epoch], total_loss_test[epoch] = sess.run([likelihood_loss,divergence_loss,elbo],feed)               
   
        #print('Epoch', epoch, 'elbo', total_loss_test[epoch])

        np.random.shuffle(config_train)  
        N_batch = int(N_train/batchsize)
        
        for i in range(N_batch):
            batch = config_train[i*batchsize:(i+1)*batchsize]
            feed = {data: batch.reshape([-1, size, size])}
            sess.run(optimize, feed)
            
            rec_loss_train[epoch] += sess.run([likelihood_loss],feed)
            kl_loss_train[epoch] += sess.run([divergence_loss],feed)
            total_loss_train[epoch] += sess.run([elbo],feed)
        
        rec_loss_train[epoch] /= N_batch
        kl_loss_train[epoch] /= N_batch
        total_loss_train[epoch] /= N_batch  
        
        codings_val = sess.run([code],{data: config.reshape([-1, size, size])})[0]
    
    
    output_config = sess.run([decoder],{data: config.reshape([-1,size,size])})[0]


#-----------------------gaussian naive bayes classification score---------------------
clf = GaussianNB()
clf.fit(codings_val,labels_actual)
MAP_score = np.round(clf.score(codings_val,labels_actual),4)
print('classification score = ',MAP_score)
predict = clf.predict_proba(codings_val)

#sort the labels in decending order in probability, then add 1 (becasue it was counting from 0) 
sorted_predict = np.argsort(-predict)+1

#calculate hamming distance between predicted history and actual history
hamming_dist_all = np.zeros(N)

for i in range(N):
    hamming_dist_all[i] = distance.hamming(field_history[i],sorted_predict[i])

hamming_dist = np.mean(hamming_dist_all)

#-------------------------------------------------plotting code-----------------------------------------------------

idx = np.random.choice(test_index,12)

config_min = -1
config_max = 1

#plot 12 random examples of validation/reconstruction
plt.figure(figsize=(12,10))
for i in range(6):
    index_l,index_r = idx[2*i], idx[2*i+1]
    #plot a pair on the left
    plt.subplot2grid((12,12), (2*i,0), colspan=2, rowspan=2)   
    plt.imshow(np.reshape(config[index_l],[size,size]), cmap = 'coolwarm', vmin=config_min, vmax=config_max)
    plt.title('#'+str(index_l)+'_true drive:'+str(labels_actual[index_l]))
    plt.subplot2grid((12,12), (2*i,2), colspan=2, rowspan=2)
    plt.imshow(output_config[index_l], cmap = 'coolwarm', vmin=config_min, vmax=config_max)
    plt.title('#'+str(index_l)+'_predicted drive')
    plt.subplot2grid((12,12), (2*i,4), colspan=2, rowspan=2)
    subtract = np.reshape(config[index_l],[size,size])-output_config[index_l]
    plt.imshow(subtract, cmap = 'coolwarm', vmin=config_min/10, vmax=config_max/10)
    plt.title('#'+str(index_l)+'_true-predict')    
    
    #plot another pair on the right
    plt.subplot2grid((12,12), (2*i,6), colspan=2, rowspan=2)   
    plt.imshow(np.reshape(config[index_r],[size,size]), cmap = 'coolwarm', vmin=config_min, vmax=config_max)
    plt.title('#'+str(index_r)+'_true drive:'+str(labels_actual[index_r]))
    plt.subplot2grid((12,12), (2*i,8), colspan=2, rowspan=2)
    plt.imshow(output_config[index_r], cmap = 'coolwarm', vmin=config_min, vmax=config_max)
    plt.title('#'+str(index_r)+'_predict drive')
    plt.subplot2grid((12,12), (2*i,10), colspan=2, rowspan=2)
    subtract = np.reshape(config[index_r],[size,size])-output_config[index_r]
    plt.imshow(subtract, cmap = 'coolwarm', vmin=config_min/10, vmax=config_max/10)
    plt.title('#'+str(index_r)+'_true-predict')    

plt.tight_layout()
plt.savefig('outputs/'+ sys.argv[1] +'/reconstruction.png',format='png')  
            

#plot learning curves
rec_loss_train_avg = np.mean(rec_loss_train[-50:])
tot_loss_train_avg = np.mean(total_loss_train[-50:])

rec_loss_test_avg = np.mean(rec_loss_test[-50:])
tot_loss_test_avg = np.mean(total_loss_test[-50:])


plt.figure(figsize=(12,10))
plt.subplot2grid((6,4), (0,0), colspan=2, rowspan=2) 
plt.plot(total_loss_train)
plt.title("total loss on training set")
plt.axis([0,n_epochs,0,2*tot_loss_train_avg])
plt.subplot2grid((6,4), (0,2), colspan=2, rowspan=2) 
plt.plot(total_loss_test)
plt.title("total loss on test set")
plt.axis([0,n_epochs,0,2*tot_loss_test_avg])

plt.subplot2grid((6,4), (2,0), colspan=2, rowspan=2) 
plt.plot(rec_loss_train)
plt.axis([0,n_epochs,0,2*rec_loss_train_avg])
plt.title("reconstruction loss on training set")
plt.subplot2grid((6,4), (2,2), colspan=2, rowspan=2) 
plt.plot(rec_loss_test)
plt.axis([0,n_epochs,0,2*rec_loss_test_avg])
plt.title("reconstruction loss on test set")

plt.tight_layout()

plt.savefig('outputs/'+sys.argv[1]+'/learning curve.png',format='png')


#plot the latent space
fig = plt.figure()

if latent_dim == 2:
    ax = fig.add_subplot(111)
    for i in range(n_drive):
        label_i = np.where(labels_actual==i+1)[0]
        ax.scatter(codings_val[label_i,0],codings_val[label_i,1],label=str(i),alpha=0.1) #c=labels_actual,
    plt.xlabel('first latent dimension')
    plt.ylabel('second latent dimension')
    plt.axis([-4,4,-4,4])


if latent_dim ==3:
    ax = plt.axes(projection='3d')
    for i in range(n_drive):
        label_i = np.where(labels_actual==i+1)[0]
        ax.scatter(codings_val[label_i,0],codings_val[label_i,1],codings_val[label_i,2],label=str(i),alpha=0.1)


colormap = plt.cm.gist_ncar #nipy_spectral, Set1,Paired  
colorst = [colormap(i) for i in np.linspace(0, 0.9,len(ax.collections))]       
for t,j1 in enumerate(ax.collections):
    j1.set_color(colorst[t])

#ax.legend(fontsize='small')
plt.title('latent space visualization_t='+sys.argv[1])
plt.savefig('outputs/'+sys.argv[1] + '/' + str(latent_dim) + 'd_latent.png',format='png')


#---------------------------------------------code for the thermodynamic quantities histogram/scatter plots--------------------------
#load thermodynamics data
diss_rate = stat[:,-2]
int_energy = stat[:,2]
magnitization = stat[:,3]
field_energy = np.einsum('nk,nk->n',config,field)


#------------------------------dissipation------------------------------
plt.figure()
for i in range(n_drive):
    label_i = np.where(labels_actual==i)[0]
    plt.hist(diss_rate[label_i],label = str(i),alpha=0.5)
plt.title('dissipation rate histogram')
plt.legend()
plt.savefig('outputs/'+sys.argv[1] +'/diss-rate_hist.png',format='png')

#dissipation rate classification score
clf_diss = GaussianNB()
clf_diss.fit((diss_rate).reshape([-1,1]),labels_actual)
diss_score = np.round(clf_diss.score((diss_rate).reshape([-1,1]),labels_actual),4)
print('dissipation rate classification score = ',diss_score)

scores = np.zeros([3])
scores[0] = MAP_score
scores[1] = diss_score
scores[2] = hamming_dist
np.save('outputs/'+sys.argv[1]+'/'+sys.argv[1]+'_scores',scores)


t1 = time.time()

print('total runtime of code is: ' + str(np.round(t1-t0,2)) + 's')
