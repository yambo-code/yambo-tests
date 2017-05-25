#!/bin/sh
FC_FLAGS_DEBUG="-g -pg -Wall -fbounds-check -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -Wuninitialized -O0"
FC_FLAGS_OPTIMIZED="-O3 -mtune=native -Wall -fbounds-check -Wuninitialized"

ABINIT_LIB="/data/sangalli/Lavoro/Codici/abinit/abinit-7.4.1/compiled_abi_etsf/fallbacks/exports/"
PW_LIB="/data/sangalli/Lavoro/Codici/pwscf/svn_repository/iotk/"
PW_VER=5.0
FFTWLIB="/usr/lib/x86_64-linux-gnu/"
#USEINTERNAL="--with-internal-fft=fftw --enable-3d-fft"
#PW_LIB="/data/sangalli/Lavoro/Codici/pwscf/pw_patched/espresso-4.0.5/iotk"
#PW_VER=4.0

./configure FCFLAGS="$FC_FLAGS_DEBUG" \
--enable-keep-src --enable-openmpi  --enable-iotk  --enable-etsf-io --enable-netcdf  \
--with-p2y=$PW_VER  --with-iotk-path="$PW_LIB" \
--with-blas-libs="-lblas" --with-lapack-libs="-llapack" \
--with-netcdf-path="/usr/" \
--with-fft-path="$FFTWLIB" $USEINTERNAL \
--with-etsf-io-path="$ABINIT_LIB" \
--with-hdf5-libs="-lhdf5_fortran -lhdf5_hl -lhdf5 -lcurl -lz" 
#--enable-open-mp
#--enable-netcdf-hdf5
#--with-scalapack="-L/usr/lib/libscalapack-openmpi.a"
