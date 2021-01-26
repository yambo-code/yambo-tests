
# Local card is Pascal (cc60)

YAMBO_LIBS="/home/sangalli/data/Lavoro/Codici/yambo/yambo-libs"

#mpicc=/opt/pgi/linux86-64-llvm/2019/mpi/openmpi-3.1.3/bin/mpicc
#mpif90=/opt/pgi/linux86-64-llvm/2019/mpi/openmpi-3.1.3/bin/mpif90


mpicc=/opt/pgi/openmpi/bin/mpicc
mpif90=/opt/pgi/openmpi/bin/mpif90

./configure \
--disable-cuda --enable-open-mp \
CPP="gcc -E -P" FPP="gfortran -E -P -cpp" \
CC=pgcc F77=pgfortran FC=pgfortran MPICC=$mpicc MPIFC=$mpif90 \
--enable-keep-src --enable-msgs-comps \
--enable-time-profile --enable-memory-profile \
--enable-int-linalg --enable-open-mp \
--enable-par-linalg --enable-hdf5-par-io \
--with-extlibs-path="$YAMBO_LIBS" 

#--enable-slepc-linalg \
#FCFLAGS="-O2 -fast" \
#CPP="gcc -E -P" FPP="gfortran -E -P -cpp" \
#CPP="cpp -E" FPP="cpp -E -P -ansi" \
