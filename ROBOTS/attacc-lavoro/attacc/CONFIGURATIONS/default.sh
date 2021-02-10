#!/bin/sh
source /opt/intel/bin/compilervars.sh -arch intel64 -platform linux
export  YAMBO_LIBS=/home/attacc/SOFTWARE/YAMBO_LIBS/
./configure FC=gfortran F77=gfortran  --enable-open-mp --enable-par-linalg --enable-hdf5-par-io --enable-slepc-linalg \
--with-blas-libs=" -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_gf_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-lapack-libs=" -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_gf_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-fft-libs=" -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_gf_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-scalapack-libs=" -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_scalapack_lp64.a ${MKLROOT}/lib/intel64/libmkl_blacs_openmpi_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_co
re.a -Wl,--end-group -lpthread -lm -ldl" \
--with-blacs-libs=" -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_blacs_openmpi_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-hdf5-path=${YAMBO_LIBS} --with-netcdf-path=${YAMBO_LIBS} --with-netcdff-path=${YAMBO_LIBS} --with-iotk-path=${YAMBO_LIBS} --with-libxc-path=${YAMBO_LIBS} --with-slepc-path=${YAMBO_LIBS} --with-petsc-path=${YA
MBO_LIBS}

