#!/bin/bash
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
FCFLAGS="-O2 -q64 -qstrict -qsuffix=f=f" \
CFLAGS=-q64 \
--enable-msgs-comps \
--with-mpi-libs=no \
--enable-bluegene \
--with-iotk-path=/fermi/home/userexternal/chogan00/Codes/espresso/5.0.1/bin_frontend/iotk \
--with-p2y-version=5.0 \
--with-netcdf-libs="-L/cineca/prod/libraries/front-end-netcdf/4.1.3/front-end-xl--1.0/lib  -L/cineca/prod/libraries/front-end-hdf5/1.8.9_ser/front-end-xl--1.0/lib -L/cineca/prod/libraries/front-end-zlib/1.2.7/front-end-xl--1.0/lib -L/cineca/prod/libraries/front-end-szip/2.1/front-end-xl--1.0/lib -lnetcdff -lnetcdf  -lhdf5_hl -lm -lcurl -lhdf5 -lsz" \
--with-netcdf-includedir=/cineca/prod/libraries/front-end-netcdf/4.1.3/front-end-xl--1.0/include \
--with-blas-libs="-L/cineca/prod/libraries/front-end-blas/2007/front-end-xl--1.0/lib -lblas" \
--with-lapack-libs="-L/cineca/prod/libraries/front-end-lapack/3.4.1/front-end-xl--1.0/lib -llapack" 
#--with-openmp \
