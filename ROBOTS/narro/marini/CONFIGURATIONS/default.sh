#!/bin/sh
FC=gfortran
#
IF_COMPILE=`which ifort`
if [ -e "$IF_COMPILE" ]
then
 FC=ifort
fi
#
IF_COMPILE=`which pgf90`
if [ -e "$IF_COMPILE" ]
then
 FC=pgf90
fi
./configure \
FC=$FC \
--enable-keep-extlibs \
--enable-iotk \
--enable-memory-profile=yes \
--enable-time-profile \
--enable-msgs-comps \
--enable-int-linalg \
--enable-par-linalg \
--enable-open-mp \
--with-blacs-libs="yes" \
--with-scalapack-libs="yes"
