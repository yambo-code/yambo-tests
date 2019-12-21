#!/bin/sh
FC_FLAGS_DEBUG="-g -pg -Wall -fbounds-check -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -Wuninitialized -O0"
FC_FLAGS_OPTIMIZED="-O3 -mtune=native -Wall -fbounds-check -Wuninitialized"
FC_FLAGS_BASIC="-O3 -mtune=native -C" \
./configure \
FC=gfortran \
FCFLAGS="$FC_FLAGS_DEBUG" \
--enable-msgs-comps \
--enable-time-profile \
--enable-netcdf-hdf5 \
--with-libxc-path=/usr/local/libraries/libxc/2.0.3/gfortran--4.8.4 \
--with-iotk-path=/usr/local/applications/quantumESPRESSO/5.1.1/gfortran--4.8.2/iotk \
--with-p2y-version=5.0 \
--with-netcdf-libdir=/usr/local/libraries/netcdf/4.1.3/gfortran--4.8.2/lib/ \
--with-netcdf-includedir=/usr/local/libraries/netcdf/4.1.3/gfortran--4.8.2/include
