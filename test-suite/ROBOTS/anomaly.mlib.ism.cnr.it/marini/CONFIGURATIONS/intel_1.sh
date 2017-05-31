#!/bin/sh
NETCDFLIB="/opt/netcdf-4.0.1_IFORT_12/lib"
NETCDFINCLUDE="/opt/netcdf-4.0.1_IFORT_12/include"
MKL_dir="-L$MKL_lib"
MKL_seq_libs="-lmkl_core -lmkl_intel_lp64 -lmkl_sequential"
MKL_th_libs="-lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -openmp"
./configure \
FC=ifort \
--enable-keep-extlibs \
--enable-iotk \
--with-iotk-libdir=/home/marini/Yambo/yambo/LIBs/ifort12 \
--with-iotk-includedir=/home/marini/Yambo/yambo/INCLUDEs/ifort12 \
--with-libxc-libdir=home/marini/Yambo/yambo/LIBs/ifort12 \
--with-libxc-includedir=/home/marini/Yambo/yambo/INCLUDEs/ifort12 \
--with-blas-libs="$MKL_dir $MKL_seq_libs" \
--with-lapack-libs="$MKL_dir $MKL_seq_libs" \
--enable-time-profile=yes \
--enable-msgs-comps=yes \
--enable-open-mp=yes \
--with-netcdf-libdir="$NETCDFLIB" \
--with-netcdf-includedir="$NETCDFINCLUDE" \
--with-fft-libs="-mkl"
