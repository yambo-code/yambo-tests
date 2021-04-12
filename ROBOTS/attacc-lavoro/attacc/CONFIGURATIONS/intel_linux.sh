#!/bin/bash
source /opt/intel/oneapi/setvars.sh
export MKL_LIBS="-Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -liomp5 -lpthread -lm -ldl"
export MKL_INCLUDE="-I${MKLROOT}/include"
export MKL_SCALAPACK=" ${MKLROOT}/lib/intel64/libmkl_scalapack_lp64.a -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_blacs_intelmpi_lp64.a -Wl,--end-group -liomp5 -lpthread -lm -ldl"

export  YAMBO_LIBS=/home/attacc/SOFTWARE/YAMBO_LIBS_INTEL

./configure FC=mpiifort F77=mpiifort  --enable-open-mp --enable-par-linalg --enable-hdf5-par-io \
--with-blas-libs="$MKL_LIBS" --with-lapack-libs="$MKL_LAPACK" \
--with-fft-libs="$MKL_LIBS" --with-fft-includedir="$MKL_INCLUDE" \
--with-scalapack-libs="$MKL_SCALAPACK" --with-blacs-libs="$MKL_SCALAPACK" \
--with-iotk-path="${YAMBO_LIBS}" --with-libxc-path="${YAMBO_LIBS}" \
--with-hdf5-path="${YAMBO_LIBS}" --with-netcdf-path="${YAMBO_LIBS}" --with-netcdff-path="${YAMBO_LIBS}" \
--enable-slepc-linalg  --with-petsc-path="${YAMBO_LIBS}" --with-slepc-path="${YAMBO_LIBS}"

