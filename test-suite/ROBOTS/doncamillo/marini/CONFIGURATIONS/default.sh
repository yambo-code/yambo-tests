#!/bin/bash

./configure \
  FPP="gfortran -E -P -cpp" --enable-par-linalg \
  --with-blas-libs="-lmkl_intel_lp64  -lmkl_sequential -lmkl_core" \
  --with-lapack-libs="-lmkl_intel_lp64  -lmkl_sequential -lmkl_core" \
  --with-fft-libs="-mkl " \
  --enable-time-profile \
  --enable-open-mp \
  --enable-msgs-comps

