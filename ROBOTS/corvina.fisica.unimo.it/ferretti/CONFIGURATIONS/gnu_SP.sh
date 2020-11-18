#!/bin/bash

#source /opt/modules/init/modules_init.sh
#module purge
#module load profile/gnu
#
#export OMP_NUM_THREADS=1

./configure \
  --with-fft-path="/opt/fftw/3.3.6-gnu" \
  --with-iotk-path="/opt/iotk/y1.2.2-gnu" \
  --with-libxc-path="/opt/libxc/2.2.3-gnu" \
  --with-netcdf-path="/opt/netcdf/4.4.1.1-hdf5-gnu" \
  --with-netcdff-path="/opt/netcdff/4.4.4-gnu" \
  --with-hdf5-path="/opt/hdf5/1.8.18-gnu" \
  --with-blas-libs=" -lblas" \
  --with-lapack-libs=" -llapack" \
  --with-scalapack-libs=" -L/opt/scalapack/2.0.1-openmpi-gnu/lib -lscalapack" \
  --with-blacs-libs=" -L/opt/scalapack/2.0.1-openmpi-gnu/lib -lscalapack" \
  --enable-open-mp \
  --enable-time-profile \
  --enable-memory-profile \
  --enable-msgs-comps

