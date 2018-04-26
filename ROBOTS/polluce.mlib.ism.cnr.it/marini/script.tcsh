#!/usr/bin/tcsh

cd /scratch/marini/yambo-tests/

if ( "$1" == "down") then
#./driver.pl -kill
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
module load local/intel/parallel_2017/pre_compiled
endif

if ( "$1" == "tests") then
 if ( "$3" == "28" || "$3" == "29" || "$3" == "30" ) then
 ./driver.pl -c -c -flow validate_dp -report -robot $3 -nice -newer 100
 else
 ./driver.pl -c -c -flow validate    -report -robot $3 -nice -newer 100
 endif
endif
#
if ( "$1" == "bench") then
 ./driver.pl -flow benchmark -robot $3 -m bench -b -c -c -nice
endif
