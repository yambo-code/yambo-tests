#!/bin/bash
module purge
module load bgq-xl/1.0p
./configure \
  FC=mpixlf90_r \
  PFC=mpixlf90_r \
  F77=mpixlf77_r \
  CPP="gcc -E" \
  FCFLAGS="-O0 -qsmp=omp:noauto -q64 -qstrict -qsuffix=f=f -C -qflttrap -qhalt=s" \
  CFLAGS=-q64 \
  --enable-msgs-comps \
  --enable-bluegene \
  --enable-open-mp \
  --enable-time-profile \
  --enable-iotk \
  --enable-etsf-io 
