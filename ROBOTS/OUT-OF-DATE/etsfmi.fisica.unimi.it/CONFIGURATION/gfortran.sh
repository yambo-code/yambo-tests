#/bin/bash

FC_FLAGS_debug="-O0 -fcheck=bounds,do,mem,pointer,recursion -g -pg -Wuninitialized"
UF_LAGS_debug="-O0 -fcheck=bounds,do,mem,pointer,recursion -g -pg -Wuninitialized"
FC_FLAGS_fast="-O3 -g -pg -ffast-math -funroll-loops --param max-unroll-times=4 -msse2 -mtune=native"
UF_FLAGS_fast=""
FC_FLAGS=$FC_FLAGS_fast
UF_FLAGS=$UF_FLAGS_fast
PWSCF_LIB="/users/sangalli/Codici/Quantum-Espresso/svn_espresso/iotk/"
ABINIT_LIB=""
#
./configure CC=gcc CXX=gcc FC=gfortran F77=gfortran MPICC=mpicc MPIF90=mpif90\
FCFLAGS="$FC_FLAGS" --enable-msgs-comps=yes  \
--enable-netcdf-LFS --enable-time-profile=yes \
--with-p2y-version=5.0 \
--enable-keep-extlibs \
--with-blas-libs="-L$local_libs/atlas_gfortran_gcc_4.6/lib/ -lcblas -lf77blas -latlas" \
--with-lapack-libs="-L$local_libs/atlas_gfortran_gcc_4.6/lib/ -llapack -latlas -lf77blas $local_libs/lapack-3.3.1/lapack.a" \
--with-blacs-libs --with-scalapack-libs \
--with-mpi-root=/users/davidesangalli/libs/compiled/gnu_etsfmi_4.4.7/openmpi

