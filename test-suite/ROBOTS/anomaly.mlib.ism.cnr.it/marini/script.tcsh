#!/usr/bin/tcsh

cd /home/marini/Yambo/sources/svn/yambo-tests/test-suite

module purge 
module load gcc6/yambo/mpich-3.2/pre_compiled
cd /home/marini/Yambo/sources/svn/yambo-tests/test-suite
./driver.pl -flow minimal -report

module purge 
module load intel/yambo/parallel_2017/pre_compiled
./driver.pl -flow minimal -report 
