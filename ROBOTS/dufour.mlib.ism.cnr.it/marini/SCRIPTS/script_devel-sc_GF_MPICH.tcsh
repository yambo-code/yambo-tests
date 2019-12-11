#!/usr/bin/tcsh
cd ~/yambo-tests
module purge
module load full-suite/gcc/8.2.0/mpich-3.2.1
./driver.pl -flow validate -report -branch devel-sc -nice -newer 15 -safe -input
#./driver.pl -tests "Si_bulk/GW-OPTICS all; Si_bulk/PBE0 all; Si_bulk/RT all" -branch devel-sc -keys all -nice -sa
