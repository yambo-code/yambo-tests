FC_FLAGS_DEBUG="-g -pg -Wall -fcheck=all -pedantic -fbacktrace -fdump-core -fdump-parse-tree -O0"
FC_FLAGS_OPTIMIZED="-O3  -mtune=native -Wall -fcheck=bounds" # -std=f95"
FC_FLAGS_LIBS="-O3  -mtune=native" # -std=f95"

#YAMBO_LIBS="/data/shared/yambo-libs/test-lapack/"
YAMBO_LIBS="/data/shared/yambo-libs/new-libxc/"


./configure cc=gcc F77=gfortran FC=gfortran MPIFC=mpifort MPIF77=mpif77 MPICC=mpicc FCFLAGS="$FC_FLAGS_OPTIMIZED" \
--enable-keep-src --enable-iotk --enable-msgs-comps  --enable-time-profile --enable-hdf5-par-io \
--enable-int-linalg --enable-par-linalg --enable-slepc-linalg --enable-open-mp \
--with-extlibs-path="$YAMBO_LIBS"

#--enable-par-linalg --enable-int-linalg --enable-slepc-linalg --enable-open-mp \