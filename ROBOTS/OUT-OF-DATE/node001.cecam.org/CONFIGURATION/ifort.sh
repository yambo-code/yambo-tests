NETCDF_PATH="/nfs_home/tutoadmin/Yambo/code/libs/netcdf-4.0.1/2015_ifort"
LIBXC_PATH="/nfs_home/tutoadmin/Yambo/code/libs/libxc-2.1.2/2015_ifort"
ETSFIO_PATH="/nfs_home/tutoadmin/Yambo/code/abinit/abinit-7.10.4/compile_ifort/fallbacks/exports/"
MKL_PATH="/opt/intel/mkl/10.0.1.014/"
FFT_PATH="/opt/fftw-3.2.2/intel-10.1.015/"
IOTK_PATH="/nfs_home/tutoadmin/Yambo/code/QuantumEspresso/espresso-5.1.2_ifort/iotk"
PW_VER="5.0"

./configure FC=ifort F77=ifort PFC=mpif90 CC=gcc \
--enable-keep-src --enable-openmpi --enable-open-mp --enable-iotk --enable-netcdf \
--with-p2y-version=$PW_VER --with-iotk-path=$IOTK_PATH \
--with-netcdf-path=$NETCDF_PATH \
--with-fft-libs="-L$FFT_PATH/lib -lfftw3" \
--with-libxc-path=$LIBXC_PATH \
--with-blas-libs="-L$MKL_PATH/lib/em64t/ -lmkl_intel_lp64  -lmkl_sequential -lmkl_core" \
--with-lapack-libs="-L$MKL_PATH/lib/em64t/ -lmkl_intel_lp64  -lmkl_sequential -lmkl_core" \
--with-etsf-io-path="$ETSFIO_PATH"

