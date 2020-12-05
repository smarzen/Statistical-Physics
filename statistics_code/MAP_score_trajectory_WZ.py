import os, os.path
import numpy as np
import matplotlib
# Force matplotlib to not use any Xwindows backend.
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from scipy import stats
import imageio


dr = os.getcwd()
runs = 300

scores = np.zeros([runs,2])
#-------------------------------------setup the indices----------------------------------------
inds = set(np.arange(1,runs,1))
latent_imgs = []

for r in inds:
    scores[r] = np.load(dr+'/outputs/'+str(r)+'/'+str(r)+'_scores.npy')
    img_name = dr+'/outputs/'+str(r)+'/2d_latent.png'
    latent_imgs.append(imageio.imread(img_name))

imageio.mimsave('latent_evolution.gif', latent_imgs)
    
#plot MAP scores
#plt.figure(figsize=(12,10))
plt.plot(scores[1:,0],label='latent score')
plt.plot(scores[1:,1],label='dissipation score')
plt.xlabel('t')
plt.ylabel('MAP score')
#plt.title('comparision between latent and dissipation scores')
plt.legend()
plt.savefig('compare_scores.pdf',format='pdf')




