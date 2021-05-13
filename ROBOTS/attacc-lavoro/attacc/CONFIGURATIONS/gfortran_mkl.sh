#!/bin/bash
export  YAMBO_LIBS=/home/attacc/SOFTWARE/YAMBO_LIBS/
export  INCLUDEDIR=/usr/include/
export  LIBDIR=/usr/lib/x86_64-linux-gnu/


./configure FC=gfortran F77=gfortran  --enable-open-mp --enable-par-linalg --enable-hdf5-par-io \
--with-blas-libs="-lblas" --with-lapack-libs="-llapack" \
--with-fft-libs=" -Wl,--start-group    ${LIBDIR}/libmkl_gf_lp64.a ${LIBDIR}/libmkl_sequential.a ${LIBDIR}/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-scalapack-libs=" -Wl,--start-group -lmkl_scalapack_lp64 -lmkl_blacs_openmpi_lp64 ${LIBDIR}/libmkl_sequential.a ${LIBDIR}/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-blacs-libs=" -Wl,--start-group -lmkl_blacs_openmpi_lp64 ${LIBDIR}/libmkl_sequential.a ${LIBDIR}/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-iotk-path="${YAMBO_LIBS}" --with-libxc-path="${YAMBO_LIBS}" \
--with-hdf5-includedir="${INCLUDEDIR}/hdf5/openmpi/" --with-hdf5-libdir="${LIBDIR}/hdf5/openmpi/" \
--with-netcdf-includedir="${INCLUDEDIR}"  --with-netcdf-libdir="${LIBDIR}" \
--with-netcdff-includedir="${INCLUDEDIR}" --with-netcdff-libdir="${LIBDIR}" \
--enable-slepc-linalg --with-petsc-path="${YAMBO_LIBS}" --with-slepc-path="${YAMBO_LIBS}"

