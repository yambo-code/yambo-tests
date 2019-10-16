#!/usr/bin/tcsh
cd ~/yambo-tests
module purge
module load full-suite/intel/openmpi-3.1.0
./driver.pl -flow validate -report -branch devel-sc -nice -newer 15 -safe -input
