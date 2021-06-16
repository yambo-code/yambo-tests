#!/bin/bash
export PATH="$PATH:/opt/nvidia/hpc_sdk/Linux_x86_64/2021/compilers/bin:/opt/nvidia/bin/:/opt/nvidia/hpc_sdk/Linux_x86_64/21.5/cuda/bin"
export LD_LIBRARY_PATH="LD_LIBRARY_PATH:/opt/nvidia/hpc_sdk/Linux_x86_64/2021/compilers/lib:/opt/nvidia/hpc_sdk/Linux_x86_64/21.5/cuda/11.3/targets/x86_64-linux/lib:/opt/nvidia/lib/:/opt/nvidia/hpc_sdk/Linux_x86_64/21.5/cuda/lib64/"
export  YAMBO_LIBS=/home/attacc/SOFTWARE/YAMBO_LIBS_NVFORTRAN/
export  INCLUDEDIR="/opt/nvidia/include/:/opt/nvidia/hpc_sdk/Linux_x86_64/2021/compilers/include"
export  BLACS="${YAMBO_LIBS}/lib/libblacs.a ${YAMBO_LIBS}/lib/libblacs_C_init.a ${YAMBO_LIBS}/lib/libblacs_init.a"
export  NVIDIA_DIR="/opt/nvidia/hpc_sdk/Linux_x86_64/2021/math_libs/lib64/"

./configure FC=nvfortran F77=nvfortran  CC=nvc CPP="gcc -E -P" FPP="gfortran -E -P -cpp" \
--enable-open-mp --enable-par-linalg --enable-hdf5-par-io  \
--with-blas-libs="${YAMBO_LIBS}/lib/libblas.a" --with-lapack-libs="${YAMBO_LIBS}/lib/liblapack.a" \
--with-fft-libs="${YAMBO_LIBS}/lib/libfftw3.a" \
--with-extlibs-path="${YAMBO_LIBS}" \
--with-fft-includedir="${YAMBO_LIBS}/include" \
--with-scalapack-libs="${YAMBO_LIBS}/lib/libscalapack.a" --with-blacs-libs="${BLACS}" \
--with-iotk-path="${YAMBO_LIBS}" --with-libxc-path="${YAMBO_LIBS}" \
--with-netcdf-path="${YAMBO_LIBS}" --with-netcdff-path="${YAMBO_LIBS}" --with-hdf5-path="${YAMBO_LIBS}" 

