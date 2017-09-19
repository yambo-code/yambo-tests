#!/bin/sh
./configure \
--enable-keep-extlibs \
--enable-iotk \
--enable-time-profile \
--enable-msgs-comps \
--enable-open-mp \
--enable-int-linalg \
--enable-par-linalg \
--with-blacs-libs="yes" \
--with-scalapack-libs="yes"
