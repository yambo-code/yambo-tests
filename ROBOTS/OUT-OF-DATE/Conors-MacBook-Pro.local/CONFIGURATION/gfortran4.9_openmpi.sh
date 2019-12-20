#!/bin/sh
./configure FC=/opt/local/bin/gfortran-mp-4.9 \
CPP=/opt/local/bin/cpp-mp-4.9 \
CC=/opt/local/bin/gcc-mp-4.9 \
FCCPP="/opt/local/bin/cpp-mp-4.9 -E -P" \
PFC=mpif90 \
--enable-open-mp \
--enable-keep-extlibs \
--enable-msgs-comps \
--with-libxc-path=/opt/local  \
--with-fft-path=/usr/local/libraries/fftw-3.3.4--gfortran-mp-4.9 \
--with-iotk-path=/usr/local/applications/qe-5.2.1--gfortran-mp-4.9_parallel/iotk \
--with-netcdf-path=/usr/local/libraries/netcdf-4.3.3.1--gcc-mp-4.9 \
--with-hdf5-path=/usr/local/libraries/hdf5-1.8.15--gfortran-mp-4.9 
