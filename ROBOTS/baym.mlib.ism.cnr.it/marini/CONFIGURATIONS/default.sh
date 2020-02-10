CONF_LINE="FC=gfortran"
IF_COMPILE=`which ifort`
if [ -e "$IF_COMPILE" ]
then
 CONF_LINE="FC=ifort"
fi
IF_COMPILE=`which pgf90`
if [ -e "$IF_COMPILE" ]
then
 CONF_LINE="FC=pgf90 FPP=gfortran -E -P -cpp"
fi
./configure \
$CONF_LINE \
--with-extlibs-path=$YAMBO_EXT_LIBS \
--enable-memory-profile=yes \
--enable-int-linalg=yes \
--enable-par-linalg=yes \
--enable-time-profile=yes \
--enable-msgs-comps=yes \
--enable-open-mp=yes \
--enable-keep-src \
--with-iotk-libdir=$IOTK_LIB \
--with-iotk-includedir=$IOTK_INCLUDE \
--with-libxc-libdir=$LIBXC_LIB \
--with-libxc-includedir=$LIBXC_INCLUDE \
--with-blas-libs="$BLAS_LIB" \
--with-lapack-libs="$LAPACK_LIB" \
--with-netcdf-libdir=$NETCDF_LIB \
--with-netcdf-includedir=$NETCDF_INCLUDE \
--with-fft-path=$FFT_PATH \
--with-fft-libdir=$FFT_LIB \
--with-fft-includedir=$FFT_INCLUDE \
--with-petsc-libs=$PETSC_LIB \
--with-slepc-libs=$SLEPC_LIB \
--with-blacs-libs="$BLACS_LIB" \
--with-scalapack-libs="$SCALAPACK_LIB"