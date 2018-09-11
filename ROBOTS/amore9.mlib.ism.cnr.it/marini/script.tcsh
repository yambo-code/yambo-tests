#!/usr/bin/tcsh

cd /data/marini/yambo-tests/

if ( "$1" == "down") then
./driver.pl -d all -force
endif

if ( "$1" == "clean") then
./driver.pl -c
endif

if ( "$2" == "gf_mpich") then
module purge
module load gcc8/gcc-8.1.0  gcc8/mpich-3.2.1 yambo/defaults gcc8/yambo/mpich-3.2.1
endif

if ( "$2" == "gf_openmpi") then
module purge
module load gcc8/gcc-8.1.0 gcc8/openmpi-3.1.0 yambo/defaults gcc8/yambo/openmpi-3.1.0
endif

if ( "$2" == "intel") then
module purge
module load intel/composer_xe_12 intel/parallel_2018 yambo/defaults intel/yambo/parallel_2018
endif

if ( "$1" == "tests") then
# if ( "$3" == "5" || "$3" == "6" || "$3" == "15" ) then
  ./driver.pl -flow validate_slepc -report -newer 3 -robot $3 -c -c -nice -safe
# else
#  ./driver.pl -flow validate_slepc -report -robot $3 -c -c -nice
# endif
endif
if ( "$1" == "bench") then
 ./driver.pl -flow benchmark -robot $3 -m bench -profile -b -c -c -nice -safe
endif
