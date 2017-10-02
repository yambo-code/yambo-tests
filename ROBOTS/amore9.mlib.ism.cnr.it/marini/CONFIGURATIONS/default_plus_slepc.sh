#!/bin/sh
CONF_LINE="FC=gfortran --with-extlibs-path=/data/marini/LIBS"
IF_COMPILE=`which ifort`
if [ -e "$IF_COMPILE" ]
then
CONF_LINE="FC=ifort --with-extlibs-path=/data/marini/LIBS"
fi
IF_COMPILE=`which pgf90`
if [ -e "$IF_COMPILE" ]
then
 CONF_LINE="FC=pgf90 FPP=gfortran -E -P -cpp"
fi
./configure \
$CONF_LINE \
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
