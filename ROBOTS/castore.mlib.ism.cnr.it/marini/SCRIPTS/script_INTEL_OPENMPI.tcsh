#!/usr/bin/tcsh
cd yambo-tests
module purge
module load full-suite/intel/openmpi-3.1.0
./driver.pl -flow validate -report -branch $1 -nice -newer 7 -safe -input