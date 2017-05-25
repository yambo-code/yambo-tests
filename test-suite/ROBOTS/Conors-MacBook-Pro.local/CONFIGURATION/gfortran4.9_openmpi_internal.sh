#!/bin/sh
./configure FC=/opt/local/bin/gfortran-mp-4.9 \
CPP=/opt/local/bin/cpp-mp-4.9 \
CC=/opt/local/bin/gcc-mp-4.9 \
FCCPP="/opt/local/bin/cpp-mp-4.9 -E -P" \
PFC=mpif90 \
--enable-openmpi \
--enable-open-mp \
--enable-keep-extlibs \
--enable-msgs-comps \
--with-iotk-path=/usr/local/applications/qe-5.2.1--gfortran-mp-4.9_parallel/iotk 
