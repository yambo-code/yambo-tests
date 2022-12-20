import numpy as np
from netCDF4 import Dataset

class AbinitElectronPhononDB():
    """
    Python class to read GSTORE dbs from abinit
    """

    def __init__(self,filename):

        # Open database
        try: 
            database_general = Dataset(filename)
            database = database_general['gqk_spin1']
        except: 
            raise FileNotFoundError("error opening %s in AbinitElectronPhononDB"%filename)

        # Read DB dimensions
        self.nb = database.dimensions['nb'].size
        self.nm = database_general.dimensions['natom3'].size
        self.nq = database.dimensions['glob_nq'].size
        self.nk = database.dimensions['glob_nk'].size

        # Read DB
        self.gkkp = np.zeros([self.nq,self.nk,self.nm,self.nb,self.nb],dtype=np.complex64)
        gstore = database.variables['gvals'][:]
        self.gkkp = gstore[:,:,:,:,:,0]+1j*gstore[:,:,:,:,:,1]
        database_general.close()

        if np.isnan(self.gkkp).any(): print('[WARNING] NaN values detected in elph database.')

if __name__ == "__main__":

    fnm = "ABInosym/hbn_elpho_GSTORE.nc"
    agkkp = AbinitElectronPhononDB(fnm)
    print(agkkp.gkkp.shape)

