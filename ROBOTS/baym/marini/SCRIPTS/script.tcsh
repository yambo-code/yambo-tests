#!/usr/bin/tcsh
cd /home/marini/Yambo/sources/git/yambo-tests
module purge 
module load gcc-8.3.0/yambo/mpich-3.3.2
module load yambo/branches/devel-andreaM
./driver.pl -flow  $1 -report -branch $2 -nice -newer 300 -input -safe
