#!/usr/bin/tcsh
#
set ROBOT=`./driver.pl -i | grep 'host'| awk '{print $5}'`
set USER=`./driver.pl -i | grep 'user'| awk '{print $4}'`
set NLINES=`./driver.pl -i | grep '#'|wc -l`
rm -fr compile_dir

foreach i (`seq 1 $NLINES`)
 set NAME=`./driver.pl -i | grep '#'| sed -n "$i,$i p"| awk '{print $2}'| sed 's/://'`
 set MOD=`./driver.pl -i | grep '#'| sed -n "$i,$i p"| awk '{print $3}'`
 #
 module purge
 module load $MOD
 #
 set MPI="no"
 if ($YAMBO_EXT_LIBS =~ "*MPI-yes*") set MPI="yes"
 set PAR_LINALG="no"
 if ($YAMBO_EXT_LIBS =~ "*PAR_LINALG-yes*") set PAR_LINALG="yes"
 set PAR_IO="no"
 if ($YAMBO_EXT_LIBS =~ "*PAR_IO-yes*") set PAR_IO="yes"
 #
 repeat 100 echo -n "#"
 echo
 echo "Testing" $NAME
 repeat 100 echo -n "#"
 echo
 cat ROBOTS/$ROBOT/$USER/CONFIGURATIONS/base.sh | sed  "s/OPENMP_STRING/yes/g" | \
 sed "s/MPI_STRING/$MPI/g" | sed "s/PAR_LINALG_STRING/$PAR_LINALG/g" | sed "s/PAR_IO_STRING/$PAR_IO/g" > ROBOTS/$ROBOT/$USER/CONFIGURATIONS/running.sh
 ./driver.pl -flow test -branch yoda/develop -module $NAME >& $NAME.log
end
