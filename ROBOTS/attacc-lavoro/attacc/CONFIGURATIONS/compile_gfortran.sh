#!/bin/bash
export  YAMBO_LIBS=/home/attacc/SOFTWARE/YAMBO_LIBS/
export  INCLUDEDIR=/usr/include/
export  LIBDIR=/usr/lib/x86_64-linux-gnu/

export BLACS="${YAMBO_LIBS}/lib/libblacs.a ${YAMBO_LIBS}/lib/libblacs_C_init.a ${YAMBO_LIBS}/lib/libblacs_init.a"


./configure FC=gfortran F77=gfortran  --enable-open-mp --enable-par-linalg --enable-hdf5-par-io \
--with-blas-libs="${YAMBO_LIBS}/lib/libblas.a" --with-lapack-libs="${YAMBO_LIBS}/lib/liblapack.a"  --with-fft-libs="${YAMBO_LIBS}/lib/libfftw3.a" \
--with-fft-includedir="${YAMBO_LIBS}/include" \
--with-scalapack-libs="${YAMBO_LIBS}/lib/libscalapack.a" --with-blacs-libs="${BLACS}" \
--with-iotk-path="${YAMBO_LIBS}" --with-libxc-path="${YAMBO_LIBS}" \
--enable-slepc-linalg  --with-petsc-path="${YAMBO_LIBS}" --with-slepc-path="${YAMBO_LIBS}" \
--with-netcdf-path="${YAMBO_LIBS}" --with-netcdff-path="${YAMBO_LIBS}" --with-hdf5-path="${YAMBO_LIBS}" 

