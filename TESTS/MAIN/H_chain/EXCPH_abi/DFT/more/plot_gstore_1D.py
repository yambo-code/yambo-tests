## 
## Script to read and plot electron-phonon matrix elements of a 1D system from:
## - ABINIT [ABI]
##
from compare_gkkp_functions import *
from read_gstore import AbinitElectronPhononDB

# Read input
Nk_bz,Nk_ibz,Nb,Nm,hatoev,icmtomev,alat,lat,rlat,\
kpts_abi,qpts_abi,elph_abi,titles = read_input("gkkp_input.yaml")

# Read k/q-grids
kpts_abi = get_kpts(kpts_abi,alat)
qpts_abi = get_kpts(qpts_abi,alat)

print("=== Reading elph databases... ===")
aelph = AbinitElectronPhononDB(elph_abi)
print("=== ...Ok. ===")

# Plot structure:
# (i) Plot |g(k,q)|
# (ii) Band and phonon mode indices so far hardcoded below 
nb1,nb2 = [0,1]
nm = 5

g2plt = np.abs(aelph.gkkp[:,:,nm,nb1,nb2])*hatoev

# 2D plot 'kq'
fig, ax = plot_elph_kq(rlat,kpts_abi,qpts_abi,g2plt,titles,plt_cbar=True,logscale=False,marker='s',s=500,edgecolor='black',cmap='viridis')

plt.savefig('g_of_kq_ABI_n%d_m%d_l%d.pdf'%(nb1+1,nb2+1,nm+1))
plt.show()

