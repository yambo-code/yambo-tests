#!/usr/bin/tcsh
cd /scratch/marini/yambo-tests
module purge
module load full-suite/intel/openmpi-3.1.0
./driver.pl -flow validate -report -branch bug-fixes -nice -newer 7 -safe