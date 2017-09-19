#ifort 12.0.0 + mpich
#+FC_FLAGS_DEBUG="-g -pg -Wall -fbounds-check -fbacktrace -fdump-core -fdump-parse-tree -fno-automatic -Wuninitialized -O0"
#FC_FLAGS_OPTIMIZED="-O3 -mtune=native -Wall -fbounds-check -Wuninitialized"
#FC_FLAGS_BASIC="-O3 -mtune=native -C" \
#FCFLAGS="$FC_FLAGS_BASIC" \
#source /scratch2/cdhogan/intel2016/compiler/bin/compilervars.sh intel64
./configure \
FC=ifort \
PFC=mpif90 \
--enable-msgs-comps \
--enable-time-profile \
--enable-open-mp \
--with-iotk-path=/usr/local/applications/quantumESPRESSO/5.1.1/mpich-ifort--16.0.0/iotk
