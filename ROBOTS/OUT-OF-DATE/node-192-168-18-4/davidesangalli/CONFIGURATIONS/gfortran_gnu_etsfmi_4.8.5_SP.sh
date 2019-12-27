#/bin/bash

FC_FLAGS_debug="-O0 -fcheck=bounds,do,mem,pointer,recursion -g -pg -Wuninitialized"
UF_LAGS_debug="-O0 -fcheck=bounds,do,mem,pointer,recursion -g -pg -Wuninitialized"
#FC_FLAGS_fast="-O3 -g -pg -fbounds-check -ffast-math -funroll-loops --param max-unroll-times=4 -msse2 -mtune=native"
FC_FLAGS_fast="-O3 -fbounds-check -ffast-math -funroll-loops -mtune=native"
UF_FLAGS_fast=""
FC_FLAGS=$FC_FLAGS_fast
UF_FLAGS=$UF_FLAGS_fast
local_libs="${HOME}/libs/compiled/gnu_etsfmi_4.8.5"
yambo_libs="${HOME}/libs/compiled/yambo_extlibs"
install_path="${HOME}/Codici/bin/yambo/"
#netcdf_link="-lnetcdff -lnetcdf -lhdf5hl_fortran -lhdf5_fortran  -lhdf5_hl -lhdf5 -lz"
#
PWSCF_LIB="${HOME}/Codici/quantum-espresso/qe-6.0/iotk/"
ABINIT_LIB=""
#
./configure CC=gcc CXX=gcc FC=gfortran F77=gfortran MPICC=mpicc MPIFC=mpifort \
FCFLAGS="$FC_FLAGS" UFFLAGS="$UF_FLAGS" FFLAGS="$FCFLAG" \
--enable-keep-src --enable-iotk --enable-msgs-comps --enable-memory-profile --enable-slepc-linalg --enable-par-linalg \
--with-extlibs-path="$yambo_libs" \
--with-blas-libs="-L$local_libs/blas -lblas" \
--with-lapack-libs="-L$local_libs/lapack -llapack" \
--with-netcdf-path="$local_libs/netcdf" \
--with-iotk-path="$PWSCF_LIB" \
--with-libxc-path="$local_libs/libxc/" \
--with-fft-path="$local_libs/fftw/"
