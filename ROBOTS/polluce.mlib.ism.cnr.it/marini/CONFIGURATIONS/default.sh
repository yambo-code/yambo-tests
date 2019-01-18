#!/bin/sh
CONF_LINE="FC=gfortran"
IF_COMPILE=`which ifort`
if [ -e "$IF_COMPILE" ]
then
CONF_LINE="FC=ifort MPICC=mpiicc"
fi
IF_COMPILE=`which pgf90`
if [ -e "$IF_COMPILE" ]
then
 CONF_LINE="FC=pgf90 FPP=gfortran -E -P -cpp"
fi
MORE_LINES=" "
if [ $# -gt 0 ]
then
 MORE_LINES="$1"
fi
./configure \
$CONF_LINE \
--with-extlibs-path=$YAMBO_EXT_LIBS \
--enable-keep-extlibs \
--enable-time-profile \
--enable-memory-profile \
--enable-open-mp \
--enable-msgs-comps \
--enable-int-linalg \
--enable-par-linalg \
--enable-keep-src \
--enable-slepc-linalg \
--enable-hdf5-compression \
--enable-hdf5-p2y-support $MORE_LINES
