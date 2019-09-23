#!/usr/bin/tcsh
cd ~/yambo-tests
module purge
module load full-suite/gcc/8.2.0/openmpi-3.1.2
./driver.pl -flow validate -report -branch bug-fixes -nice -newer 15 -safe
