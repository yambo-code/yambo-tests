#!/bin/sh
PW_VER="5.0"
FC="gfortran"
FFTINCLUDE="/opt/fftw-3.3.4/include"
FFTLIB="/opt/fftw-3.3.4/lib"
FFT="none"
PRE_COMP_LIBS="/home/marini/Yambo/yambo/LIBs/gf"
PRE_COMP_INCLUDE="/home/marini/Yambo/yambo/INCLUDEs/gf"
NETCDFLIB="$PRE_COMP_LIBS"
NETCDFINCLUDE="$PRE_COMP_INCLUDE"
BLAS="-L/home/marini/Yambo/yambo/LIBs/gf -lblas"
LAPACK="-llapack"
SCALAPACK="no"
BLACS="no"
OPEN_MP="yes"
#
#common...
#
./configure \
FC=$FC \
--with-p2y-version=$PW_VER \
--enable-iotk \
--with-iotk-libdir=$PRE_COMP_LIBS \
--with-iotk-includedir=$PRE_COMP_INCLUDE \
--with-libxc-libdir=$PRE_COMP_LIBS \
--with-libxc-includedir=$PRE_COMP_INCLUDE \
--with-blas-libs="$BLAS" \
--with-lapack-libs="$LAPACK" \
--enable-memory-profile=yes \
--enable-time-profile=yes \
--with-netcdf-libdir="$NETCDFLIB" \
--with-netcdf-includedir="$NETCDFINCLUDE" \
--with-fft-libs="$FFT" \
--with-fft-libdir="$FFTLIB" \
--with-fft-includedir="$FFTINCLUDE" \
--enable-open-mp=$OPEN_MP \
--with-scalapack-libs="yes" \
--with-blacs-libs="$BLACS" \
--with-scalapack-libs="$SCALAPACK" \
--enable-msgs-comps=yes 
