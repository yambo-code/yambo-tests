export FC=ifort
export F77=ifort
export CC=icc
export LOCALLIB=/data/myrta/local
export MKLLIB='/opt/intel/mkl/lib/intel64/'
export MKLS="-L$MKLLIB -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread"
export IOTK="/data/myrta/Src/espresso-5.2.0/iotk/"
export LIBXC="/data/myrta/Src/libxc/"
./configure --with-p2y-version=5.2 --with-iotk-path=$IOTK --with-netcdf-path=$LOCALLIB --with-libxc-path=$LIBXC --with-blas-libs="$MKLS" --with-lapack-libs="$MKLS"  --with-fft-libs="$MKLS" --enable-openmpi --enable-open-mp
