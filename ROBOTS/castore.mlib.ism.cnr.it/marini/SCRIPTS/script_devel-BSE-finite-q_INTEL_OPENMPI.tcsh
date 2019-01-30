#!/usr/bin/tcsh
cd /scratch/marini/yambo-tests
module purge
module load full-suite/intel/openmpi-3.1.0
./driver.pl -flow validate -report -branch devel-BSE-finite-q -nice -newer 100 -safe
