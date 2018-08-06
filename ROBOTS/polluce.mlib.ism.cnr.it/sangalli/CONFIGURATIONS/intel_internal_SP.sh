#
module load intel/composer_xe_12
module load intel/parallel_2017
#
YAMBO_LIBS=/scratch/sangalli/yambo/yambo-libs/
#
./configure FC=ifort \
--with-extlibs-path=$YAMBO_LIBS \
--enable-keep-src \
--enable-keep-extlibs \
--enable-iotk \
--enable-time-profile \
--enable-memory-profile \
--enable-open-mp \
--enable-msgs-comps \
--enable-int-linalg \
--enable-par-linalg \
--enable-keep-src \
--with-petsc-libs \
--with-slepc-libs 

