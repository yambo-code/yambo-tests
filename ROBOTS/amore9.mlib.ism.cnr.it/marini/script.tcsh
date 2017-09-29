#!/usr/bin/tcsh

cd /data/marini/yambo-tests/

if ( "$1" == "clean") then
./driver.pl -c
./driver.pl -d all 
endif

if ( "$2" == "gfortran") then
module purge
module load gcc6/yambo/openmpi-2.1.0
#module load gcc6/gcc-6.3.0 gcc6/mpich-3.2 gcc6/QE-6.1
endif

if ( "$2" == "intel") then
module purge
module load intel/yambo/parallel_2017/pre_compiled
#module load intel/composer_xe_12 intel/parallel_2017
endif

if ( "$1" == "run") then
./driver.pl -flow validate -newer 3 -report -robot $3 
endif
