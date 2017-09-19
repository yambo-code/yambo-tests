#ifort 12.0.0
#FC_FLAGS_DEBUG="-g -pg -Wall -fbounds-check -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -Wuninitialized -O0"
#FC_FLAGS_OPTIMIZED="-O3 -mtune=native -Wall -fbounds-check -Wuninitialized"
#FC_FLAGS_BASIC="-O3 -mtune=native -C" \
#FCFLAGS="$FC_FLAGS_BASIC" \
./configure \
FC=ifort \
--enable-msgs-comps \
--enable-time-profile \
--without-mpi-libs \
--enable-open-mp

