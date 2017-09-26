#!/usr/bin/tcsh

cd /home/marini/Yambo/sources/svn/yambo-tests

if ( "$1" == "clean") then
./driver.pl -c
./driver.pl -d all 
endif

if ( "$2" == "gfortran") then
module purge
module load gcc6/yambo/mpich-3.2/pre_compiled
endif

if ( "$2" == "intel") then
module purge
module load intel/yambo/parallel_2017/pre_compiled
endif

if ( "$1" == "run") then
./driver.pl -flow validate -report -robot $3 
#-newer 2
endif
