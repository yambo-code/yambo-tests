#!/bin/sh
./configure \
--enable-keep-extlibs \
--enable-iotk \
--enable-time-profile \
--enable-msgs-comps \
--enable-open-mp \
--with-blacs-libs="yes" \
--with-scalapack-libs="yes"
