#
YAMBO_LIBS=/scratch/sangalli/yambo/yambo-libs/
#
./configure FC=gfortran \
--with-extlibs-path=$YAMBO_LIBS \
--enable-netcdf-hdf5 \
--enable-hdf5-par-io \
--enable-keep-src \
--enable-keep-extlibs \
--enable-iotk \
--enable-time-profile \
--enable-memory-profile \
--enable-open-mp \
--enable-msgs-comps \
--enable-int-linalg \
--enable-par-linalg \
--enable-slepc-linalg

