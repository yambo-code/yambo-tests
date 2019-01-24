#!/usr/bin/tcsh
cd /data/marini/yambo-tests
module purge
module load full-suite/intel/parallel_2018
./driver.pl -flow validate -report -branch devel-rt-rotate -nice -newer 100 -safe
