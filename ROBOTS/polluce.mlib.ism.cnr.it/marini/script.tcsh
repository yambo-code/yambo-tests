#!/usr/bin/tcsh

cd /scratch/marini/yambo-tests/

if ( "$1" == "down") then
./driver.pl -d all 
endif

if ( "$1" == "clean") then
./driver.pl -c
endif

if ( "$2" == "gf_mpich") then
module purge
module load local/gcc6/yambo/mpich-3.2
endif

if ( "$2" == "gf_openmpi") then
module purge
module load local/gcc6/yambo/openmpi-2.1.0 
endif

if ( "$2" == "intel") then
module purge
module load local/intel/parallel_2017
endif

if ( "$1" == "tests") then
 if ( "$3" == "5" || "$3" == "6" || "$3" == "15" ) then
  ./driver.pl -c -c -flow validate_slepc -report -newer 50 -robot $3 
 else
  ./driver.pl -flow validate -report -robot $3 -c -c -newer 5
 endif
endif
if ( "$1" == "bench") then
 ./driver.pl -flow benchmark -robot $3 -m bench -b -c 
endif
