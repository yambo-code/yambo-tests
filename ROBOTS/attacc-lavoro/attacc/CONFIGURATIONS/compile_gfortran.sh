#!/bin/bash
export  YAMBO_LIBS=/home/attacc/SOFTWARE/YAMBO_LIBS/
export  INCLUDEDIR=/usr/include/
export  LIBDIR=/usr/lib/x86_64-linux-gnu/


./configure FC=gfortran F77=gfortran  --enable-open-mp --enable-par-linalg --enable-hdf5-par-io \
--with-blas-libs="-lblas" --with-lapack-libs="-llapack"  --with-fft-libs=" -lfftw3" \
--with-scalapack-libs="-L${LIBDIR} -lscalapack-openmpi" --with-blacs-libs="-L${LIBDIR} -lscalapack-openmpi" \
--with-iotk-path="${YAMBO_LIBS}" --with-libxc-path="${YAMBO_LIBS}" \
--with-hdf5-includedir="${INCLUDEDIR}/hdf5/openmpi/" --with-hdf5-libdir="${LIBDIR}/hdf5/openmpi/" \
--with-netcdf-includedir="${INCLUDEDIR}"  --with-netcdf-libdir="${LIBDIR}" \
--with-netcdff-includedir="${INCLUDEDIR}" --with-netcdff-libdir="${LIBDIR}" \
--enable-slepc-linalg --with-petsc-path="${YAMBO_LIBS}" --with-slepc-path="${YAMBO_LIBS}"

