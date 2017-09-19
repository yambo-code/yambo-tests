#!/usr/bin/tcsh

cd /home/marini/Yambo/test-suite/

module purge 
module load gcc6/gcc-6.3.0 gcc6/mpich-3.2
./driver.pl -flow validate -report -newer 2

module purge 
module load intel/composer_xe_12 intel/parallel_2017
./driver.pl -flow validate -report -newer 2
