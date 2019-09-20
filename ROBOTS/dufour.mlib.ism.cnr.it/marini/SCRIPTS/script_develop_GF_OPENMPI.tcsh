#!/usr/bin/tcsh
cd ~/yambo-tests
module purge
module load full-suite/gcc/8.2.0/openmpi-3.1.2
#./driver.pl -flow validate -report -branch develop -nice -newer 7 -safe -input
./driver.pl -flow validate -report -branch develop -newer 7 -safe -input

