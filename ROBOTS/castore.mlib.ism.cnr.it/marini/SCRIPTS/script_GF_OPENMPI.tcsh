#!/usr/bin/tcsh
cd yambo-tests
module purge
module load full-suite/gcc/8.2.0/openmpi-3.1.2
./driver.pl -flow validate -report -branch $1 -nice -newer 7 -input
