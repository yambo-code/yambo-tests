#!/bin/bash
export  YAMBO_LIBS=/home/attacc/SOFTWARE/YAMBO_LIBS/
export  MKLROOT=/usr/lib/x86_64-linux-gnu/

./configure FC=gfortran F77=gfortran  --enable-open-mp --enable-par-linalg --enable-hdf5-par-io --enable-slepc-linalg \
--with-blas-libs=" -Wl,--start-group ${MKLROOT}/libmkl_gf_lp64.a ${MKLROOT}/libmkl_sequential.a ${MKLROOT}/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-lapack-libs=" -Wl,--start-group ${MKLROOT}/libmkl_gf_lp64.a ${MKLROOT}/libmkl_sequential.a ${MKLROOT}/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-fft-libs=" -Wl,--start-group ${MKLROOT}/libmkl_gf_lp64.a ${MKLROOT}/libmkl_sequential.a ${MKLROOT}/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-scalapack-libs=" -Wl,--start-group -lmkl_scalapack_lp64 -lmkl_blacs_openmpi_lp64 ${MKLROOT}/libmkl_sequential.a ${MKLROOT}/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-blacs-libs=" -Wl,--start-group -lmkl_blacs_openmpi_lp64 ${MKLROOT}/libmkl_sequential.a ${MKLROOT}/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-iotk-path=${YAMBO_LIBS} --with-libxc-path=${YAMBO_LIBS} --with-slepc-path=${YAMBO_LIBS} --with-petsc-path=${YAMBO_LIBS} \
--with-hdf5-path=${YAMBO_LIBS} --with-netcdf-path=${YAMBO_LIBS} --with-netcdff-path=${YAMBO_LIBS} 

