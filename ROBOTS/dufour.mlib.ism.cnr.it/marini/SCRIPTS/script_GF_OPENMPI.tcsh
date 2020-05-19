#!/usr/bin/tcsh
module purge
module load full-suite/gcc/8.2.0/openmpi-3.1.2
./driver.pl -flow $1 -report -branch $2 -nice -newer 7 -input
