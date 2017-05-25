#!/bin/sh
NETCDFLIB="/opt/netcdf/lib"
NETCDFINCLUDE="/opt/netcdf/include"
MKL_dir="-L$MKL_lib"
MKL_seq_libs="-lmkl_core -lmkl_intel_lp64 -lmkl_sequential"
MKL_th_libs="-lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -openmp"
./configure \
   FC=ifort --enable-iotk --with-blas-libs="$MKL_dir $MKL_seq_libs" --with-lapack-libs="$MKL_dir $MKL_seq_libs" --with-mpi=yes  --enable-msgs-comps=yes --enable-time-profile=yes \
   --with-fft-libs="-mkl" --with-netcdf-libdir="$NETCDFLIB" --with-netcdf-includedir="$NETCDFINCLUDE"  --enable-open-mp=yes
