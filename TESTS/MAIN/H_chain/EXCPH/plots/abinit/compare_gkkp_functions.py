## 
## Script to compare electron-phonon matrix elements between:
## - QE with symmetries [qes]
## - QE without symmetries [qen]
## - ABINIT [ABI]
##
#from yambopy import *
#from yambopy.plot.plotting import BZ_hexagon, shifted_grids_2D
import matplotlib.pyplot as plt
import numpy as np
import yaml

def read_input(inp_file):
    # Get input data from yaml file in dictionary form
    stream = open(inp_file, 'r')
    dictionary = yaml.safe_load(stream)
    stream.close()
    # Transform input data in shape used by the code
    Nk_bz = dictionary['Nk_bz']
    Nk_ibz = dictionary['Nk_ibz']
    Nb = dictionary['Nb']
    Nm = dictionary['Nm']
    hatoev = dictionary['hatoev']
    icmtomev = dictionary['icmtomev']
    alat = np.array( dictionary['alat'] )
    lat = np.array( dictionary['lat'] )
    rlat = np.array( dictionary['rlat'] )
    kpts_abi  = dictionary['kpts_abi']
    qpts_abi  = dictionary['qpts_abi']
    elph_abi  = dictionary['elph_abi']
    titles    = dictionary['titles']

    return Nk_bz,Nk_ibz,Nb,Nm,hatoev,icmtomev,alat,lat,rlat,\
           kpts_abi,qpts_abi,elph_abi,titles

def get_kpts(grid_file,alat):
    kpts = np.loadtxt(grid_file)
    kpts = np.array([ k/alat for k in kpts ])
    return kpts

def plot_elph_kq(rlat,kpts,qpts,data,title,plt_show=False,plt_cbar=False,logscale=False,**kwargs):
    """ All plot layout parameters are custom for H-chain single plot
    """
    from mpl_toolkits.axes_grid1 import make_axes_locatable
    import matplotlib.colors as clrs
    # Global plot stuff

    fig, ax = plt.subplots(1, 1)
    fig.set_size_inches(4.5,4.5)
    if plt_cbar:
        if 'cmap' in kwargs.keys(): color_map = plt.get_cmap(kwargs['cmap'])
        else:                       color_map = plt.get_cmap('viridis')
    ax.set_xlim(-0.12,0.12)
    ax.set_ylim(-0.12,0.12)
    ax.set_ylabel('Q-axis')
    ax.set_xlabel('K-axis')
    ax.set_aspect('equal')
    ax.set_title(title)

    # Plot 2D mesh (k_x -> x, q_x -> y)
    x,y = np.meshgrid(kpts[:,0],qpts[:,0])

    if logscale: plot=ax.scatter(x,y,c=data, norm=clrs.LogNorm(),**kwargs)
    else: plot=ax.scatter(x,y,c=data,**kwargs)

    if plt_cbar:
        divider = make_axes_locatable(ax)
        cax = divider.append_axes("right", size="8%", pad=0.05)
        plt.colorbar(plot, cax=cax)

    plt.tight_layout()
    if plt_show: plt.show()

    return fig, ax
