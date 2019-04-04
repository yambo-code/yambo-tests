#!/usr/bin/tcsh
cd /scratch/marini/yambo-tests
module purge
module load full-suite/gcc/8.2.0/openmpi-3.1.2
./driver.pl -flow validate -report -branch devel-BSE-finite-q -nice -newer 7 -safe
