#!/bin/bash
. /fermi/prod/environment/module/3.1.6/none/init/bash
module purge
module load profile/front-end
module load front-end-blas/2007--front-end-xl--1.0              
module load front-end-hdf5/1.8.9_ser--front-end-xl--1.0         
module load front-end-lapack/3.4.1--front-end-xl--1.0           
module load front-end-netcdf/4.1.3--front-end-xl--1.0           
module load front-end-szip/2.1--front-end-xl--1.0               
module load front-end-zlib/1.2.7--front-end-xl--1.0             
module load front-end-xl/1.0
./configure \
FC=xlf90_r \
F77=xlf_r \
CC=xlc_r \
CPP="gcc -E" \
FCFLAGS="-O0 -q64 -qstrict -qsuffix=f=f -C -g -qflttrap -qsigtrap -qhalt=s" \
CFLAGS=-q64 \
--enable-msgs-comps \
--with-mpi-libs=no \
--enable-bluegene \
--with-p2y-version=5.0 
