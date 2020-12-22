FC_FLAGS_DEBUG="-g -pg -Wall -fcheck=all -pedantic -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -O0"
FC_FLAGS_OPTIMIZED="-O3  -mtune=native -Wall -fcheck=bounds" # -std=f95"
FC_FLAGS_LIBS="-O3  -mtune=native" # -std=f95"

./configure \
FCFLAGS="$FC_FLAGS_OPTIMIZED" \
CC=gcc FC=gfortran \
--disable-mpi \
--enable-open-mp \
--enable-keep-src \
--enable-time-profile --enable-memory-profile \
--enable-slepc-linalg --enable-par-linalg \
--with-extlibs-path="/home/sangalli/data/Lavoro/Codici/yambo/yambo-libs/standard"
