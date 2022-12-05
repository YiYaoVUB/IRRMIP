import csv
import numpy as np
import scipy.io as scio
import matplotlib.pyplot as plt
import matplotlib as mpl
import cartopy.feature as cfeature
import cartopy.crs as ccrs
import numpy as np
import time
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib import colors as cls

TSA_dif_dict = scio.loadmat('C:\Research3\\test\\TSA_dif.mat')
TSA_dif = TSA_dif_dict['TSA_dif']

RH2M_dif_dict = scio.loadmat('C:\Research3\\test\\RH2M_dif.mat')
RH2M_dif = RH2M_dif_dict['RH2M_dif']

TSA_dif = TSA_dif.T
RH2M_dif = RH2M_dif.T


f = plt.figure(figsize = (12, 8), dpi=100)  # initiate the figure
#f.subplots_adjust(hspace=0.15, wspace=0.1, left = 0.05, right = 0.95, top = 0.95, bottom = 0.05)
#ax1 = plt.subplot(1, 1, 1, projection=ccrs.PlateCarree())
ax1 = plt.subplot(1, 1, 1)
#ax1.text(0.01,0.92,'a',color='dimgrey',fontsize=12, transform=ax1.transAxes, weight = 'bold')
#ax1.coastlines(linewidth=0.5)
#ax1.add_feature(cfeature.BORDERS, linestyle='-', linewidth=0.5)
#ax1.add_feature(cfeature.OCEAN, color='lightgrey')
cmap='BrBG'
bwr = mpl.cm.get_cmap('BrBG')
colors = [bwr(0.1),bwr(0.2),bwr(0.3),bwr(0.4),bwr(0.5),bwr(0.6),bwr(0.7),bwr(0.8),bwr(0.9)]
cmap_bias1 = mpl.colors.ListedColormap(colors)
bounds = [-0.5, -0.2, -0.1, -0.01, 0.01, 0.1, 0.2, 0.5]
norm_bias1 = mpl.colors.BoundaryNorm(bounds,cmap_bias1.N,extend='both')
#divider = make_axes_locatable(ax1)

data_lon = range(288)
data_lat = range(192)
h = ax1.pcolormesh(data_lon,data_lat,TSA_dif, cmap=cmap_bias1, rasterized=True, norm=norm_bias1)
cbar   = f.colorbar(h, ax=ax1, cmap=cmap,
                               spacing='uniform',
                               orientation='horizontal',
                               extend='both', shrink = 1, pad = 0, aspect = 50)
#cbar.set_label('$\Delta$ LHF ($\mathregular{W/m^2}$)',fontsize = 12)
#ticklabs = cbar.ax.get_xticklabels()
#cbar.ax.set_xticklabels(ticklabs, fontsize=12)
#plt.title('Latent heat flux (IRR - CTL)')

plt.show()