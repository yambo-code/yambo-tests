#FC_FLAGS_DEBUG="-g -pg -Wall -fbounds-check -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -O0"
FC_FLAGS_DEBUG="-g -pg -Wall -fcheck=all -pedantic -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -O0"
FC_FLAGS_OPTIMIZED="-O3  -mtune=native -Wall -fcheck=bounds" # -std=f95"
FC_FLAGS_LIBS="-O3  -mtune=native" # -std=f95"

YAMBO_LIBS="/home/sangalli/data/Lavoro/libraries/yambo_libs_all/"
LOCAL_LIBS="/home/sangalli/data/Lavoro/libraries/local/"
ABINIT_LIB="/data/sangalli/Lavoro/Codici/abinit/git_repository/compile_master_etsfio/fallbacks/exports/"
PW_LIB="/data/sangalli/Lavoro/Codici/pwscf/git_repository/iotk_hide/"
PW_VER=5.0
FFTWLIB="/usr/lib/x86_64-linux-gnu/"
#USEINTERNAL="--with-internal-fft=fftw --enable-3d-fft"
#PW_LIB="/data/sangalli/Lavoro/Codici/pwscf/pw_patched/espresso-4.0.5/iotk"
#PW_VER=4.0
#mpikind=mpich
mpikind=openmpi

mpicc="/opt/pgi/linux86-64/19.10/mpi/openmpi-3.1.3/bin/mpicc"
mpifort="/opt/pgi/linux86-64/19.10/mpi/openmpi-3.1.3/bin/mpifort"

# Local card is Kepler (cc35)

./configure \
--disable-cuda \
CPP="gcc -E -P" FPP="gfortran -E -P -cpp" \
CC=pgcc F77=pgfortran FC=pgfortran MPICC=$mpicc MPIFC=$mpifort \
FCFLAGS="-O2 -fast" \
--enable-keep-src --enable-iotk --enable-msgs-comps  --enable-time-profile \
--enable-open-mp --enable-memory-profile \
--enable-int-linalg --enable-par-linalg --enable-slepc-linalg \
--with-extlibs-path="$YAMBO_LIBS" 

#MPIFC=mpifort.$mpikind MPIF77=mpif77.$mpikind MPICC=mpicc.$mpikind FCFLAGS="$FC_FLAGS_OPTIMIZED" \
#CPP="gcc -E -P" FPP="gfortran -E -P -cpp" \
#CPP="cpp -E" FPP="gfortran -E -P -cpp" \

#!/bin/bash

. /etc/profile.d/modules.sh
export MODULEPATH=/nfs/data/modulefiles:/usr/share/modules/modulefiles:/opt/modules

module purge
module load pgi/pgi/2019
module load pgi/openmpi/3.1.3
module list


YAMBO_LIBS="/home/sangalli/data/Lavoro/Codici/yambo/yambo-libs/"

# Local card is Kepler (cc35)

#mpicc="/opt/pgi/linux86-64/19.10/mpi/openmpi-3.1.3/bin/mpicc"
#mpifort="/opt/pgi/linux86-64/19.10/mpi/openmpi-3.1.3/bin/mpifort"

./configure \
--disable-cuda \
CPP="gcc -E -P" FPP="gfortran -E -P -cpp" \
CC=pgcc F77=pgfortran FC=pgfortran MPICC=$mpicc MPIFC=$mpifort \
FCFLAGS="-O2 -fast" \
--enable-keep-src --enable-iotk --enable-msgs-comps  --enable-time-profile \
--enable-open-mp --enable-memory-profile \
--enable-int-linalg --enable-par-linalg --enable-slepc-linalg \
--with-extlibs-path="$YAMBO_LIBS" 
