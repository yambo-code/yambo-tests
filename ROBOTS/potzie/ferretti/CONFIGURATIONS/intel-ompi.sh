#!/bin/sh
MKL_seq_libs="-lmkl_core -lmkl_intel_lp64 -lmkl_sequential"
MKL_th_libs="-lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -openmp"

if [ -e Makefile ] ; then make distclean ; fi

./configure \
  --with-blas-libs="$MKL_seq_libs" \
  --with-lapack-libs="$MKL_seq_libs" \
  --with-scalapack-libs="-L/opt/scalapack/2.0.1-openmpi-intel/lib/ -lscalapack" \
  --with-blacs-libs="-L/opt/blacs/1.1-openmpi-intel/lib -lblacs" \
  --with-fft-libs="-L/opt/fftw/3.3.0-intel/lib/ -lfftw3 -lfftw3_omp" \
  --with-fft-includedir="/opt/fftw/3.3.0-intel/include" \
  --with-netcdf-libs="-L/opt/netcdf/4.1.3-hdf5-intel/ -lnetcdff -lnetcdf" \
  --with-hdf5-libs="-L/opt/hdf5/1.8.13-intel/lib/ -lhdf5_fortran -lhdf5_hl -lhdf5 -L/opt/zlib/1.2.8-intel/lib -lz" \
  --with-libxc-path="/opt/libxc/2.2.2-intel" \
  --enable-time-profile \
  --enable-open-mp \
  --enable-msgs-comps

