FC_FLAGS_DEBUG="-g -pg -Wall -fcheck=bounds -pedantic -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -O0"
FC_FLAGS_OPTIMIZED="-O3  -mtune=native -Wall -fcheck=bounds" # -std=f95"
FC_FLAGS_LIBS="-O3  -mtune=native" # -std=f95"

./configure \
FCFLAGS="$FC_FLAGS_OPTIMIZED" \
CC=gcc FC=gfortran \
--with-editor="none" \
--enable-open-mp \
--enable-keep-src \
--with-iotk-path="/home/sangalli/data/Lavoro/Codici/pwscf/git_repo/S3DE/iotk/" \
--enable-time-profile --enable-memory-profile \
--enable-hdf5-par-io \
--enable-int-linalg --enable-slepc-linalg \
--with-extlibs-path="/home/sangalli/data/Lavoro/Codici/yambo/yambo-libs/standard"

#--enable-slepc-linalg --enable-par-linalg --enable-int-linalg \
#--enable-netcdf-output \
