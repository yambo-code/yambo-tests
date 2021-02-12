#!/bin/bash 

MKLROOT=/opt/intel/compilers_and_libraries_2020.0.166/linux/mkl

./configure \
  FC=ifort \
  CC=icc \
  --with-fft-libs="-mkl" \
  --with-blas-libs="-L$MKLROOT -lmkl_intel_lp64  -lmkl_sequential -lmkl_core " \
  --with-lapack-libs="-L$MKLROOT -lmkl_intel_lp64  -lmkl_sequential -lmkl_core " \
  --with-scalapack-libs="-L$MKLROOT -lmkl_scalapack_lp64 " \
  --with-blacs-libs="-L$MKLROOT -lmkl_blacs_intelmpi_lp64 " \
  --with-iotk-path="/opt/iotk/y1.2.2-intel" \
  --with-libxc-path="/opt/libxc/2.2.3-intel" \
  --with-hdf5-path="/opt/hdf5/1.12.0-intel" \
  --with-netcdf-path="/opt/netcdf/4.7.4-hdf5-intel" \
  --with-netcdff-path="/opt/netcdff/4.5.2-hdf5-intel" \
  --enable-open-mp \
  --enable-time-profile \
  --enable-memory-profile \
  --enable-msgs-comps

