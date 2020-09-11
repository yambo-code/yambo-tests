#!/bin/bash

source /opt/modules/init/modules_init.sh
module purge
module load profile/pgi

export CUDA_VISIBLE_DEVICES=0,1
export OMP_NUM_THREADS=1

./configure \
 FC=pgfortran \
 F77=pgfortran \
 CPP="cpp -E" \
 FPP="pgfortran -Mpreprocess -E" \
 PFC=mpif90 \
 CC=pgcc \
  --with-blas-libs="-lblas" \
  --with-lapack-libs="-llapack" \
  --with-fft-path="/opt/fftw/3.3.6-pgi" \
  --with-iotk-path="/opt/iotk/y1.2.2-pgi" \
  --with-libxc-path="/opt/libxc/2.2.3-pgi" \
  --with-netcdf-path="/opt/netcdf/4.4.1.1-hdf5-pgi" \
  --with-netcdff-path="/opt/netcdff/4.4.4-hdf5-pgi" \
  --with-hdf5-path="/opt/hdf5/1.8.19-pgi" \
  --with-scalapack-libs=" -L/opt/scalapack/2.0.1-openmpi-pgi/lib -lscalapack" \
  --with-blacs-libs=" -L/opt/scalapack/2.0.1-openmpi-pgi/lib -lscalapack" \
  --enable-cuda=cuda10.1,cc70,nollvm \
  --enable-mpi \
  --enable-open-mp \
  --enable-time-profile \
  --enable-memory-profile \
  --enable-msgs-comps


