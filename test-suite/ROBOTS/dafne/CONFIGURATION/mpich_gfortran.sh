./configure \
F90=gfortran \
PFC=mpif90 \
FCFLAGS="-O3 -mtune=native" \
--enable-msgs-comps \
--enable-time-profile \
--enable-netcdf-hdf5 \
--enable-open-mp \
--with-iotk-path=/usr/local/applications/quantumESPRESSO/5.1.1/gfortran--4.8.2/iotk \
--with-p2y-version=5.0 \
--with-libxc-path=/usr/local/libraries/libxc/2.0.3/gfortran--4.8.4 \
--with-netcdf-libdir=/usr/local/libraries/netcdf/4.1.3/gfortran--4.8.2/lib/ \
--with-netcdf-includedir=/usr/local/libraries/netcdf/4.1.3/gfortran--4.8.2/include 
