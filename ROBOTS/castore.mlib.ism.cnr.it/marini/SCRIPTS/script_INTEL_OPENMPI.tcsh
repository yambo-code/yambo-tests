#!/usr/bin/tcsh
cd yambo-tests
module purge
module load full-suite/intel/parallel_2019
./driver.pl -flow validate -report -branch $1 -nice -newer 7 -input
