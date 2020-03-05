#!/usr/bin/tcsh
cd /home/marini/Yambo/sources/git/yambo-tests
module purge
module load gcc-6.3.0/mpich-3.3.2
module load gcc-6.3.0/yambo/mpich-3.3.2
./driver.pl -tests all -input -key all -v -v
#./driver.pl -flow validate -report -branch devel-rt-rotate -nice -newer 100 -safe

