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

./configure cc=gcc F77=gfortran FC=gfortran MPIFC=mpifort.$mpikind MPIF77=mpif77.$mpikind MPICC=mpicc.$mpikind FCFLAGS="$FC_FLAGS_OPTIMIZED" \
--enable-keep-src --enable-iotk  --enable-etsf-io --enable-msgs-comps  --enable-time-profile \
--enable-par-linalg --enable-int-linalg --enable-slepc-linalg --enable-open-mp \
--enable-netcdf-hdf5 --enable-hdf5-par-io \
--with-extlibs-path="$YAMBO_LIBS" 
#--with-fft-libs="-lfftw3" \
#--with-blas-libs="/usr/lib/atlas-base/atlas/libblas.a" \
#--with-lapack-libs="/usr/lib/atlas-base/atlas/liblapack.a" \
#--with-blacs-libs="-lblacs-openmpi -lblacsCinit-openmpi" \
#--with-scalapack-libs="-lscalapack-openmpi" \
#--with-slepc-libs="-lslepc_complex" --with-slepc-incs="-I/usr/lib/slepcdir/3.6.1/x86_64-linux-gnu-complex/include/" \
#--with-petsc-libs="-lpetsc_complex" --with-petsc-incs="-I/usr/lib/petscdir/3.6.2/x86_64-linux-gnu-complex/include/ -I/usr/lib/openmpi/include/" 

#--with-iotk-path="$PW_LIB" \
#--with-etsf-io-path="$ABINIT_LIB" \

#--with-blas-libs="/usr/lib/atlas-base/atlas/libblas.a" \
#--with-lapack-libs="/usr/lib/atlas-base/atlas/liblapack.a" \

#--with-netcdf-path="/usr"
#--with-scalapack-libs="/usr/lib/libscalapack-openmpi.a" \
#--with-blacs-libs="/usr/lib/libblacsCinit-openmpi.a /usr/lib/libblacs-openmpi.a"
#--with-blas-libs="-latlas" --with-lapack-libs="-latlas" --with-slatec-libs="-latlas" \
#--with-hdf5-libdir="/usr/lib/x86_64-linux-gnu/"
#--with-hdf5-libs="-lhdf5_fortran -lhdf5_hl -lhdf5 -lcurl -lz" 
#--enable-open-mp
#--enable-netcdf-hdf5
#--with-scalapack="-L/usr/lib/libscalapack-openmpi.a"


