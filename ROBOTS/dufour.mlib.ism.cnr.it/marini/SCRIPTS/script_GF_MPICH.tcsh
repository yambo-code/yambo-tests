#!/usr/bin/tcsh
module purge
module load full-suite/gcc/8.2.0/mpich-3.2.1
./driver.pl -flow validate -report -branch $1 -nice -newer 7 -safe -input
#./driver.pl -flow failed_devel-sc -branch $1 -nice -newer 7 -safe -input

