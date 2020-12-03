# Available cc options:
#    cc20            Compile for compute capability 2.0
#    cc30            Compile for compute capability 3.0
#    cc35            Compile for compute capability 3.5
#    cc50            Compile for compute capability 5.0
#    cc60            Compile for compute capability 6.0
#    cc70            Compile for compute capability 7.0
#
# check your card at https://en.wikipedia.org/wiki/CUDA#GPUs_supported
#
# cc20  for Fermi cards
# cc30 / cc35  for Kepler cards (eg K20, K40, K80)
# cc50  for Maxwell cards
# cc60  for Pascal cards (eg P100)
# cc70  for Volta  cards (eg V100)
# cc75  for Turing cards
# cc80  for Ampere cards

# Local card is Turing (cc75)
# Local PGI compiler is /opt/pgi/linux86-64/19.4
# Local CUDA library is /opt/pgi/linux86-64/2019/cuda/10.1


YAMBO_LIBS="/data/shared/yambo-libs/std-netcdf"

#mpicc=/opt/pgi/linux86-64/2019/mpi/openmpi-3.1.3/bin/mpicc
#mpif90=/opt/pgi/linux86-64/2019/mpi/openmpi-3.1.3/bin/mpif90

#mpicc=/opt/pgi/openmpi/bin/mpicc
#mpif90=/opt/pgi/openmpi/bin/mpif90

mpicc="mpicc"
mpif90="mpif90"

./configure \
--enable-cuda="cuda10.1,cc75" --enable-open-mp  \
CPP="gcc -E -P" FPP="gfortran -E -P -cpp" \
CC=pgcc F77=pgfortran FC=pgfortran MPICC=$mpicc MPIFC=$mpif90 \
FCFLAGS="-O2 -Munroll -Mnoframe -Mdalign -Mbackslash -fast" \
--enable-keep-src --enable-msgs-comps \
--enable-time-profile --enable-memory-profile \
--enable-int-linalg --enable-open-mp \
--enable-par-linalg --enable-slepc-linalg \
--with-extlibs-path="$YAMBO_LIBS" 

#--enable-slepc-linalg \
#CPP="gcc -E -P" FPP="gfortran -E -P -cpp" \
#CPP="cpp -E" FPP="cpp -E -P -ansi" \

