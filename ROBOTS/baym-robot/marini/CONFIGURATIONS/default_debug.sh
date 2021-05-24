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
--enable-time-profile=yes \
--enable-msgs-comps=yes \
--enable-keep-src \
--enable-debug-flags
