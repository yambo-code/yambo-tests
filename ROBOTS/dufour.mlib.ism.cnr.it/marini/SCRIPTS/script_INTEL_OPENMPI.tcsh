#!/usr/bin/tcsh
module purge
module load full-suite/intel/parallel_2019
./driver.pl -flow validate -report -branch $1 -nice -newer 7 -safe -input