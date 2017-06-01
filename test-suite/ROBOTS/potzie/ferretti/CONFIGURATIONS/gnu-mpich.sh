#!/bin/sh

#
#modules
#
source /opt/modules/init/modules_init.sh
module purge
module load openmpi/intel
module load mkl
#
./configure \
  --with-blas-libs="-L/opt/blas/gnu/lib -lblas" \
  --with-lapack-libs="-L/opt/lapack/3.5.0-gnu/lib -llapack" \
  --with-fft-libs="-L/opt/fftw/3.3.3-gnu/lib/ -lfftw3 -lfftw3_omp" \
  --with-fft-includedir="/opt/fftw/3.3.3-gnu/include" \
  --with-netcdf-path="/opt/netcdf/4.1.3-hdf5-gnu/" \
  --with-hdf5-path="/opt/hdf5/1.8.13-gnu/" \
  --with-libxc-path="/opt/libxc/2.2.2-gnu" \
  --enable-time-profile \
  --enable-open-mp \
  --enable-msgs-comps

