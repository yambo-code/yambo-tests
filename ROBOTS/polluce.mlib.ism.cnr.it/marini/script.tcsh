#!/usr/bin/tcsh

cd /scratch/marini/yambo-tests/

if ( "$1" == "clean") then
./driver.pl -c
./driver.pl -d all 
endif

if ( "$2" == "gfortran") then
module purge
module load gcc6/gcc-6.3.0 gcc6/mpich-3.2  
endif

if ( "$2" == "intel") then
module purge
module load intel/composer_xe_12 intel/parallel_2017
endif

if ( "$1" == "run") then
 if ( "$3" == "5" || "$3" == "6" ) then
  ./driver.pl -flow validate_slepc -report -newer 3 -robot $3 
 else
  ./driver.pl -flow validate -report -newer 3 -robot $3 
 endif
endif
