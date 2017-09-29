#!/bin/sh
#--enable-time-profile \
#--enable-memory-profile=yes \
#--enable-open-mp \
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
--enable-keep-extlibs \
--enable-iotk \
--enable-msgs-comps \
--enable-int-linalg \
--enable-par-linalg \
--with-blacs-libs="yes" \
--with-scalapack-libs="yes" \
--with-petsc-libs \
--with-slepc-libs