import numpy as np
from mpl_toolkits import mplot3d
import matplotlib.pyplot as plt
plt.rcParams["font.family"] = "Times New Roman"
import matplotlib
import tensorflow as tf
tfd = tf.contrib.distributions
from entropy_estimators import kldiv
from sklearn.naive_bayes import GaussianNB



N = 3000
N_train = int(N * .9)
n_epochs = 200
batchsize = 300
size = 16 
learning_rate = 0.001

beta = 1
latent_dim = 2
n_drive = 3
seed = 24
#latent_fig_row = 20

#np.random.seed(seed)
#tf.random.set_random_seed(seed)

#------------------------------------------------preprocess data----------------------------------------------------- 
#thermodynamic latent space  
path = 'with_distance_matrix/sim_4_10_4_40_expanded'
#path = 'with_distance_matrix/sim_4_10_5_16_expanded'

stage = 'end'
config = np.asarray(np.loadtxt('data/256_spins/' + path + '/config_out_'+stage+'_n_' + str(N) + '_s_256.txt'))
stat = np.asarray(np.loadtxt('data/256_spins/' + path + '/stat_out_'+stage+'_n_' + str(N) + '_s_256.txt'))
field = np.asarray(np.loadtxt('data/256_spins/' + path + '/field_out_'+stage+'_n_' + str(N) + '_s_256.txt'))

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

#get labels for all the actual drives
labels_actual = np.zeros(N)
for i in range(N):
    labels_actual[i] = i%n_drive
labels_actual = labels_actual.astype(int)


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
  
  #Gaussian output
  #return tfd.Independent(tfd.Normal(loc=logit,scale = tf.ones(data_shape)),2)
  
def plot_codes(ax, codes, labels):
  ax.scatter(codes[:, 0], codes[:, 1], s=2, c=labels, alpha=0.1)
  ax.set_aspect('equal')
  ax.set_xlim(codes.min() - .1, codes.max() + .1)
  ax.set_ylim(codes.min() - .1, codes.max() + .1)
  ax.tick_params(
      axis='both', which='both', left='off', bottom='off',
      labelleft='off', labelbottom='off')
      
#-------------------------------------------------define loss------------------------------------------------------
data = tf.placeholder(tf.float32, [None, size, size])
code_generate = tf.placeholder(tf.float32, [None, latent_dim])

make_encoder = tf.make_template('encoder', make_encoder)
make_decoder = tf.make_template('decoder', make_decoder)

# Define the model.
prior = make_prior(code_size=latent_dim)
posterior = make_encoder(data, code_size=latent_dim)
code = posterior.sample()
decoder = make_decoder(code, [size, size]).sample()
generator = make_decoder(code_generate, [size, size]).sample()


# Define the loss.
likelihood = make_decoder(code, [size, size]).log_prob(data)
divergence = tfd.kl_divergence(posterior, prior)
likelihood_loss = tf.reduce_mean(likelihood)
divergence_loss = tf.reduce_mean(divergence)

elbo = tf.reduce_mean(likelihood - beta*divergence)
optimize = tf.train.AdamOptimizer(learning_rate).minimize(-elbo)

##-------------------------------------------------training-----------------------------------------------------

# samples = make_decoder(prior.sample(5), [size, size]).mean()

#code_x_coord = tf.constant(np.linspace(-3,3,10))

#code_generate = tf.stack((code_x_coord,code_x_coord),axis=1)
#generate = make_decoder(code_generate, [size, size]).mean()



kl_loss_train = np.zeros([n_epochs])
kl_loss_test = np.zeros([n_epochs])
rec_loss_train = np.zeros([n_epochs])
rec_loss_test = np.zeros([n_epochs])
total_loss_train = np.zeros([n_epochs])
total_loss_test = np.zeros([n_epochs])

#fig, ax = plt.subplots(nrows=latent_fig_row, ncols=int(n_epochs/latent_fig_row), figsize=(latent_fig_row, int(n_epochs/latent_fig_row)))

with tf.train.MonitoredSession() as sess:
    for epoch in range(n_epochs):
        feed = {data: config_test.reshape([-1, size, size])}
        rec_loss_test[epoch], kl_loss_test[epoch], total_loss_test[epoch] = sess.run([likelihood_loss,divergence_loss,elbo],feed)               
   
        print('Epoch', epoch, 'elbo', total_loss_test[epoch])

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
        
        #period = int(n_epochs/latent_fig_row)
    
        # if epoch%period==0:        
        #     step = int(epoch/period)
        # 
        # ax[step, epoch%period].set_ylabel('{}'.format(epoch))
        # plot_codes(ax[step, epoch%period], codings_val, labels_actual)
    
    output_config = sess.run([decoder],{data: config.reshape([-1,size,size])})[0]
    
    code_x_coord = np.linspace(-3,3,10)
    code_coord = np.stack((code_x_coord,code_x_coord),axis=1)
    
    generate_config = sess.run([generator],{code_generate: code_coord})[0]
    
    vars = tf.trainable_variables()
    vars_vals = sess.run(vars)

    # printing parameters of graph
    for var, val in zip(vars, vars_vals):
      print(var.name)
     #print(val)

#plt.savefig('outputs/'+'vae_spin glass.pdf', dpi=300, transparent=True, bbox_inches='tight')

magnitization_generate = np.mean(generate_config.reshape([-1,size**2]),axis=1)
#-----------------------gaussian naive bayes classification score---------------------
clf_latent = GaussianNB()
clf_latent.fit(codings_val,labels_actual)
print('latent space classification score = ',np.round(clf_latent.score(codings_val,labels_actual),4))

#-------------------------------------------------plotting code-----------------------------------------------------

idx = np.random.choice(test_index,12)

config_min = -1
config_max = 1

field_labels=[r'$\vec{A}$',r'$\vec{B}$',r'$\vec{C}$']

#plot 12 random examples of validation/reconstruction
plt.figure(figsize=(12,10))
for i in range(6):
    index_l,index_r = idx[2*i], idx[2*i+1]
    #plot a pair on the left
    plt.subplot2grid((12,12), (2*i,0), colspan=2, rowspan=2)   
    plt.imshow(np.reshape(config[index_l],[size,size]), cmap = 'coolwarm', vmin=config_min, vmax=config_max)
    plt.title('True config. '+'#'+str(index_l)+'(Field '+field_labels[labels_actual[index_l]]+')')
    plt.subplot2grid((12,12), (2*i,2), colspan=2, rowspan=2)
    plt.imshow(output_config[index_l], cmap = 'coolwarm', vmin=config_min, vmax=config_max)
    plt.title('Predicted config. '+'#'+str(index_l))
    plt.subplot2grid((12,12), (2*i,4), colspan=2, rowspan=2)
    subtract = np.reshape(config[index_l],[size,size])-output_config[index_l]
    plt.imshow(subtract, cmap = 'coolwarm', vmin=config_min, vmax=config_max)
    plt.title('#'+str(index_l)+'_true-predict')    
    
    #plot another pair on the right
    plt.subplot2grid((12,12), (2*i,6), colspan=2, rowspan=2)   
    plt.imshow(np.reshape(config[index_r],[size,size]), cmap = 'coolwarm', vmin=config_min, vmax=config_max)
    plt.title('True config. '+'#'+str(index_r)+'(Field '+field_labels[labels_actual[index_r]]+')')
    plt.subplot2grid((12,12), (2*i,8), colspan=2, rowspan=2)
    plt.imshow(output_config[index_r], cmap = 'coolwarm', vmin=config_min, vmax=config_max)
    plt.title('Predicted config. '+'#'+str(index_r))
    plt.subplot2grid((12,12), (2*i,10), colspan=2, rowspan=2)
    subtract = np.reshape(config[index_r],[size,size])-output_config[index_r]
    plt.imshow(subtract, cmap = 'coolwarm', vmin=config_min, vmax=config_max)
    plt.title('#'+str(index_r)+'_true-predict')    

plt.tight_layout()
#plt.savefig('outputs/'+'reconstruction.pdf',format='pdf')  
            

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

#plt.savefig('outputs/'+'learning curve.pdf',format='pdf')

matplotlib.rcParams.update({'font.size': 30})

#plot the latent space
fig = plt.figure(figsize=(10.5,8.5))
labels=[r'$\vec{A}$',r'$\vec{B}$',r'$\vec{C}$']
colors=['indigo','teal','gold']
if latent_dim == 2:
    ax = fig.add_subplot(111)
    for i in range(n_drive):
        label_i = np.where(labels_actual==i)[0]
        ax.scatter(codings_val[label_i,0],codings_val[label_i,1],color=colors[i],label='Field '+labels[i],alpha=0.5) #c=labels_actual,
    plt.xlabel('First latent dimension',fontsize=30)
    plt.ylabel('Second latent dimension',fontsize=30)
plt.legend()#fontsize='large')
plt.savefig('outputs/'+ stage + '_' + str(latent_dim) + 'd_latent.pdf',format='pdf')       
# =============================================================================
# colormap = plt.cm.gist_ncar #nipy_spectral, Set1,Paired  
# colorst = [colormap(i) for i in np.linspace(0, 0.9,len(ax.collections))]       
# for t,j1 in enumerate(ax.collections):
#     j1.set_color(colorst[t])
# =============================================================================


# =============================================================================
# fig, ax = plt.subplots(figsize=(12,10))
# scatter = ax.scatter(codings_val[:,0],codings_val[:,1],c=labels_actual,alpha=0.5)
# #plt.scatter(code_coord[:,0],code_coord[:,1],label = 'latent coordinates used to generate new configuration')
# ax.set_xlabel('First latent dimension',fontsize=30)
# ax.set_ylabel('Second latent dimension',fontsize=30)
# #plt.title('latent space visualization_ABC')
# fig.savefig('outputs/'+'latent space.pdf',format='pdf')
# =============================================================================


#plot the generated configuration
# =============================================================================
# plt.figure(figsize=(12,10))
# for i in range(5):
#     plt.subplot2grid((12,10), (2*i,0), colspan=2, rowspan=2) 
#     plt.imshow(np.reshape(generate_config[2*i],[size,size]), cmap = 'coolwarm', vmin=config_min, vmax=config_max)
#     plt.title('z=' + str(np.round(code_coord[2*i],2)) + ', <M>=' + str(magnitization_generate[2*i]))
#     
#     plt.subplot2grid((12,10), (2*i,6), colspan=2, rowspan=2) 
#     plt.imshow(np.reshape(generate_config[2*i+1],[size,size]), cmap = 'coolwarm', vmin=config_min, vmax=config_max)   
#     plt.title('z='+ str(np.round(code_coord[2*i+1],2)) + ', <M>=' + str(magnitization_generate[2*i+1]))
#     
# plt.tight_layout()
# =============================================================================


#---------------------------------------------code for the thermodynamic quantities histogram/scatter plots--------------------------
#load thermodynamics data
diss_rate = stat[:,0]
int_energy = stat[:,1]
magnitization = stat[:,2]
field_energy = np.einsum('nk,nk->n',config,field)
field_energy_spin = config*field
frac = len(np.where(field_energy_spin.flatten()>0)[0])/(size**2*N)


#labels for the three clusters
label_0 = np.where(labels_actual==0)[0]
label_1 = np.where(labels_actual==1)[0]
label_2 = np.where(labels_actual==2)[0]

#------------------------------dissipation------------------------------
#disregard the 1st peak in dissipation due to applying the same field consecutively 
diss_inds = np.where(diss_rate > 67.5)[0]
diss_0 = np.where(labels_actual[diss_inds]==0)[0]
diss_1 = np.where(labels_actual[diss_inds]==1)[0]
diss_2 = np.where(labels_actual[diss_inds]==2)[0]

#dissipation rate classification score
clf_diss = GaussianNB()
clf_diss.fit((diss_rate[diss_inds]).reshape([-1,1]),labels_actual[diss_inds])
print('dissipation rate classification score = ',np.round(clf_diss.score((diss_rate[diss_inds]).reshape([-1,1]),labels_actual[diss_inds]),4))


plt.figure(figsize=(10.5,8.5))
plt.scatter(codings_val[diss_inds,0],codings_val[diss_inds,1],c=diss_rate[diss_inds],cmap="coolwarm")#,vmin=200,vmax=450)
plt.xlabel('First latent dimension',fontsize=30)
plt.ylabel('Second latent dimension',fontsize=30)
plt.colorbar(label='Power absorbed')


plt.figure(figsize=(10.5,8.5))
plt.scatter(codings_val[:,0],codings_val[:,1],c=magnitization,cmap="coolwarm")#,vmin=-0.10,vmax=0.10)
plt.xlabel('First latent dimension',fontsize=30)
plt.ylabel('Second latent dimension',fontsize=30)
plt.colorbar(label='Magnitization')


#------------------------------------------compare 1st layer weights with spin configurations---------------------------------
w1_value = vars_vals[0]
avg_field_energy_spin = np.average(field_energy_spin,axis=0)
spin_inds = np.argsort(avg_field_energy_spin)  
avg_field_energy_spin = np.reshape(avg_field_energy_spin,(256,1))
avg_expand = np.copy(avg_field_energy_spin)
for i in range(127):
    avg_expand = np.append(avg_expand, avg_field_energy_spin,axis=1)

# =============================================================================
# plt.figure(figsize=(24,20))
# plt.subplot2grid((10,4), (0,0), colspan=3, rowspan=4) 
# plt.imshow((avg_expand[spin_inds]).T,cmap='coolwarm')
# plt.xlabel('spin number sorted by energy')
# plt.ylabel('extended dimension for visualization')
# cbar = plt.colorbar()
# cbar.ax.set_ylabel('average field energy', rotation=270)
# plt.title('average field energy of each spins sorted by spin energy')
# =============================================================================

#plt.subplot2grid((10,4), (5,0), colspan=3, rowspan=4)
plt.figure(figsize=(12,10))
plt.imshow((w1_value[spin_inds]).T,cmap='coolwarm')
plt.colorbar(label='Weight sizes sorted by spin energy')
#plt.title('first layer weights (256x128) ordered by spin energy')
plt.xlabel('Columns of first hidden layer’s weight matrix',fontsize=30)
plt.ylabel('Rows of weight matrix’s first hidden layer',fontsize=30)

plt.show()

# =============================================================================
# cbar = 
# cbar.ax.set_yticklabels(['100','200','300','400','500'])
# cbar.set_label(, rotation=270)
# =============================================================================
#plt.title('latent space color-coded by dissipation rate')

# =============================================================================
# plt.figure()
# plt.hist(diss_rate[diss_inds][diss_0],bins=50,color='indigo')
# plt.hist(diss_rate[diss_inds][diss_1],bins=50,color='teal')
# plt.hist(diss_rate[diss_inds][diss_2],bins=50,color='gold')
# plt.title('dissipation rate histogram')
# 
# #------------------------------magnitization------------------------------

# 
# plt.figure()
# plt.hist(magnitization[label_0],bins=50,color='indigo')
# plt.hist(magnitization[label_1],bins=50,color='teal')
# plt.hist(magnitization[label_2],bins=50,color='gold')
# plt.title('magnitization histogram')
# 
# # plt.figure()
# # latent_radial = np.sqrt(codings_val[:,0]**2,codings_val[:,1]**2)
# # plt.scatter(latent_radial,magnitization)
# 
# #------------------------------internal energy------------------------------
# plt.figure()
# plt.scatter(codings_val[:,0],codings_val[:,1],c=int_energy,cmap="coolwarm")
# plt.xlabel('first latent dimension')
# plt.ylabel('second latent dimension')
# plt.colorbar(label='internal energy')
# plt.title('latent space color-coded by internal energy')
# 
# plt.figure()
# plt.hist(int_energy[label_0],bins=50,color='indigo',alpha=0.8)
# plt.hist(int_energy[label_1],bins=50,color='teal',alpha=0.8)
# plt.hist(int_energy[label_2],bins=50,color='gold',alpha=0.8)
# plt.title('internal energy histogram')
# 
# plt.show()
# =============================================================================






