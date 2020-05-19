#!/usr/bin/tcsh
module purge
module load full-suite/intel/parallel_2019
./driver.pl -flow $1 -report -branch $2 -nice -newer 7 -safe -input
