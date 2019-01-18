#!/usr/bin/tcsh
cd /data/marini/yambo-tests
module purge
module load full-suite/gcc/8.2.0/mpich-3.2.1
./driver.pl -flow validate -report -branch devel-rt-rotate -nice -newer 100 -safe
