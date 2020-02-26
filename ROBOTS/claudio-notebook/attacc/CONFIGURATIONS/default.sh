#!/bin/sh
./configure FC=gfortran F77=gfortran  --enable-open-mp \
--with-blas-libs=" -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_gf_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-lapack-libs=" -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_gf_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--with-fft-libs=" -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_gf_lp64.a ${MKLROOT}/lib/intel64/libmkl_sequential.a ${MKLROOT}/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm -ldl" \
--enable-hdf5-par-io \
--with-hdf5-path=/home/attacc/SOFTWARE/HDF5 \
--with-netcdf-path=/home/attacc/SOFTWARE/HDF5 \
--with-iotk-path=/home/attacc/SOFTWARE/IOTK
