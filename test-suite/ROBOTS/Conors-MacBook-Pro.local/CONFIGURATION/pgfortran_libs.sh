#!/bin/bash
#module load compilers/pgi
#FC_FLAGS_DEBUG="-O0 -Mbackslash"
#FC_FLAGS_OPTIMIZED="-O2 -fast -Munroll -Mnoframe -Mdalign -Mbackslash"
#FC_FLAGS_BASIC="-D__PGI" \
./configure FC=pgfortran --with-mpi-libs="" \
       CC=pgcc \
       CPP="/opt/local/bin/cpp-mp-4.9 -E -P -D_PGI" \
       FCCPP="/opt/local/bin/cpp-mp-4.9 -E -P" \
	--enable-msgs-comps \
        --enable-open-mp \
	--with-p2y-version=5.0 \
        --with-netcdf-path=/usr/local/libraries/netcdf-4.1.3--pgi-15.10 \
        --with-netcdf-libdir=/usr/local/libraries/netcdf-4.1.3--pgi-15.10/lib \
        --with-netcdf-includedir=/usr/local/libraries/netcdf-4.1.3--pgi-15.10/include \
        --with-libxc-libdir=/usr/local/libraries/libxc-2.0.3--pgi-15.10/lib \
        --with-libxc-includedir=/usr/local/libraries/libxc-2.0.3--pgi-15.10/include \
        --with-iotk-path=/Users/cdhogan/Research/Codes/espresso/espresso-5.2.1/iotk 

