#!/usr/bin/tcsh
#
set temp=(`getopt -s tcsh -o m:b:pilh -- $argv:q`)
if ($? != 0) then 
  echo "Terminating..." >/dev/stderr
  exit 1
endif
eval set argv=\($temp:q\)
#
set mpi="no"
set par_io="no"
set par_lib="no"
set branch=`git rev-parse --abbrev-ref HEAD`
#
while (1)
	switch($1:q)
	case -p:
		set mpi="yes";
 		shift 
		breaksw;
	case -i:
		set par_io="yes";
 		shift 
		breaksw;
	case -l:
		set par_lib="yes";
 		shift 
		breaksw;
	case -m:
		if ($2:q != "") then
 		  set module=$2:q
		endif
		shift; shift
		breaksw
	case -b:
		if ($2:q != "") then
 		  set branch=$2:q
		endif
		shift; shift
		breaksw
	case -h:
                echo $0 "\t-p : parallel (optional)"
                echo    "\t\t\t\t-i : parallel I/O (optional)"
                echo    "\t\t\t\t-l : parallel linear algebra (optional)"
                echo    "\t\t\t\t-m : specific module (optional)"
                echo    "\t\t\t\t-b : branch (optional)"
		exit
	case --:
		shift
		break
	default:
		echo "No option!" ; exit 1
	endsw
end

set ROBOT=`./driver.pl -i | grep 'host'| awk '{print $5}'`
set USER=`./driver.pl -i | grep 'user'| awk '{print $4}'`
set NLINES=`./driver.pl -i | grep '#'|wc -l`
rm -fr compile_dir

foreach i (`seq 1 $NLINES`)
 #
 set NAME=`./driver.pl -i | grep '#'| sed -n "$i,$i p"| awk '{print $2}'| sed 's/://'`
 set MOD_string=`./driver.pl -i | grep '#'| sed -n "$i,$i p"`
 if ( $?module ) then
   if ( $NAME != $module ) continue
 endif
 #
 module purge
 foreach MOD ($MOD_string)
  if ($MOD =~ "#*") continue
  if ($MOD =~ "*:") continue
  module load $MOD
 end
 #
 repeat 100 echo -n "#"
 echo
 echo "Testing $NAME - MPI($mpi) - PAR_IO($par_io) - PAR_LIB($par_lib)"
 repeat 100 echo -n "#"
 echo
 cat ROBOTS/$ROBOT/$USER/CONFIGURATIONS/base.sh | sed  "s/OPENMP_STRING/yes/g" | \
 sed "s/MPI_STRING/$mpi/g" | sed "s/PAR_LINALG_STRING/$par_lib/g" | sed "s/PAR_IO_STRING/$par_io/g" > ROBOTS/$ROBOT/$USER/CONFIGURATIONS/running.sh
 ./scripts/launcher.tcsh -y $branch -m $NAME -f ext-libs >& ${NAME}_MPI_${mpi}_PAR_IO_${par_io}_PAR_LIB_${par_lib}.log
end
