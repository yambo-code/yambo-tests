#!/bin/sh
MKLROOT=/opt/intel/12.1.5/mkl/lib/intel64/
MKL_seq_libs="-L$MKLROOT -lmkl_core -lmkl_intel_lp64 -lmkl_sequential"
MKL_th_libs="-L$MKLROOT -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -openmp"

./configure \
  --with-blas-libs="$MKL_seq_libs" \
  --with-lapack-libs="$MKL_seq_libs" \
  --with-fft-path="/opt/fftw/3.3.3-intel/" \
  --with-netcdf-path="/opt/netcdf/4.3.3.1-hdf5-intel/" \
  --with-hdf5-path="/opt/hdf5/1.8.13-intel/" \
  --with-libxc-path="/opt/libxc/2.2.3-intel" \
  --enable-time-profile \
  --enable-open-mp \
  --enable-msgs-comps

