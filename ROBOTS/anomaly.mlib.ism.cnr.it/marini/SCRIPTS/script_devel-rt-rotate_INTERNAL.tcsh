#!/usr/bin/tcsh
cd /home/marini/Yambo/sources/git/yambo-tests
module purge
module load gcc-6.3.0/mpich-3.2.1
module load gcc-6.3.0/yambo/mpich-3.2.1
./driver.pl -flow validate -report -branch devel-rt-rotate -nice -newer 100 -safe
