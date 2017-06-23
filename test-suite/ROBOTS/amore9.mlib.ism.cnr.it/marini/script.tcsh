#!/usr/bin/tcsh

cd /home/marini/yambo/test-suite/

module purge 
module load intel/composer_xe_12 intel/parallel_2017
rehash
./driver.pl -flow validate -report 

module purge 
module load gcc6/gcc-6.3.0 gcc6/mpich-3.2
./driver.pl -flow validate -report
