#!/usr/bin/tcsh
cd ~/yambo-tests
module purge
module load full-suite/gcc/8.2.0/mpich-3.2.1
./driver.pl -flow validate -report -branch devel-sc -nice -newer 15 -safe -input
