#!/bin/sh
FC_FLAGS_DEBUG="-g -pg -Wall -fbounds-check -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -Wuninitialized -O0"
FC_FLAGS_OPTIMIZED="-O3 -mtune=native -Wall -fbounds-check -Wuninitialized"
FC_FLAGS_BASIC="-O3 -mtune=native -C" \
./configure FC=/opt/local/bin/gfortran-mp-4.9 \
	CPP=/opt/local/bin/cpp-mp-4.9 \
	CC=/opt/local/bin/gcc-mp-4.9 \
	FCCPP="/opt/local/bin/cpp-mp-4.9 -E -P" \
	FCFLAGS="$FC_FLAGS_DEBUG" \
	--enable-keep-extlibs \
	--without-mpi-libs \
	--enable-msgs-comps \
	--with-libxc-path=/opt/local \
	--with-iotk-path=/usr/local/applications/qe-5.2.1--gfortran-mp-4.9_serial/iotk \
	--with-netcdf-path=/usr/local/libraries/netcdf-4.3.3.1--gcc-mp-4.9 \
	--with-hdf5-path=/usr/local/libraries/hdf5-1.8.15--gfortran-mp-4.9 \
	--with-fft-path=/usr/local/libraries/fftw-3.3.4--gfortran-mp-4.9 
