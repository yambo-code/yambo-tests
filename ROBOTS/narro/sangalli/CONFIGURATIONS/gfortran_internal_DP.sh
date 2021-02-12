#FC_FLAGS_DEBUG="-g -pg -Wall -fbounds-check -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -O0"
FC_FLAGS_DEBUG="-g -pg -Wall -fcheck=all -pedantic -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -O0"
FC_FLAGS_OPTIMIZED="-O3  -mtune=native -Wall -fcheck=bounds" # -std=f95"
FC_FLAGS_LIBS="-O3  -mtune=native" # -std=f95"

YAMBO_LIBS="/home/sangalli/data/Lavoro/Codici/yambo/yambo-libs/"

. /etc/profile.d/modules.sh
export MODULEPATH=/nfs/data/modulefiles:/usr/share/modules/modulefiles:/opt/modules

module purge
module load gcc/9.1.0/gcc-9.1.0
module load gcc/9.1.0/openmpi-4.0.0
module list


./configure cc=gcc F77=gfortran FC=gfortran MPIFC=mpifort MPIF77=mpif77 MPICC=mpicc FCFLAGS="$FC_FLAGS_OPTIMIZED" \
--enable-dp --enable-keep-src --enable-iotk  --enable-etsf-io --enable-msgs-comps  --enable-time-profile --enable-memory-profile \
--enable-par-linalg --enable-int-linalg --enable-slepc-linalg --enable-open-mp \
--with-extlibs-path="$YAMBO_LIBS" 


