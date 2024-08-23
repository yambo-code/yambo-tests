#! /bin/tcsh -f
#
# command line parsing
#----------------------
#
set temp=(`getopt -s tcsh -o e:i:l:h --long efield:,integrator:,lowintapprox: -- $argv:q`)
if ($? != 0) then 
  echo "Terminating..." >/dev/stderr
  exit 1
endif

eval set argv=\($temp:q\)
#
set low="none"
set integrator="euler"
#
while (1)
	switch($1:q)
	case -e:
	case --efield:
 		set efield=$2:q
		shift; shift
		breaksw
	case -i:
	case --integrator:
 		set integrator=$2:q
		shift; shift
		breaksw
	case -l:
	case --lowintapprox:
 		set low=$2:q
		shift; shift
		breaksw
	case -h:
                echo " "
		echo "do.tcsh -e [efield] -i [integrator=RK2/RK4/HEUN/EULER] -l [EXPn,INV,INVACC,EXPnACC,INVDIAGO]"
		echo " "
		echo "Note that INV is alternative to EULER"
		echo " "
                exit 
	case --:
		shift
		break
	endsw
end

cat base.in | sed -r "s/INT/$integrator/g" | sed -r "s/EFIELD/$efield/g" | sed -r "s/SLOW/$low/g" > yambo.in

yambo_rt -J INTEGRATORS/$efield/$integrator/$low/rt,02_collisions_sex
