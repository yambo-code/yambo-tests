#!/bin/sh

if [ -e Makefile ] ; then make distclean ; fi

export FC=pgf90
export CC=pgcc
export CPP="cpp -E -P"
export FPP="pgf90 -Mpreprocess -E"
MKLROOT=/opt/intel/mkl/lib/intel64/

./configure \
  --with-blas-libs="-L$MKLROOT -lmkl_intel_lp64  -lmkl_sequential -lmkl_core" \
  --with-lapack-libs="-L$MKLROOT -lmkl_intel_lp64  -lmkl_sequential -lmkl_core" \
  --enable-time-profile \
  --enable-open-mp \
  --enable-msgs-comps 


#  --enable-internal-fftqe \
