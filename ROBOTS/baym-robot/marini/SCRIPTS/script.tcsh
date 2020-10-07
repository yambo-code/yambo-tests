#!/usr/bin/tcsh
module purge 
module load gcc-8.3.0/yambo/mpich-3.3.2
./driver.pl -flow  $1 -report -branch $2 -nice -newer 300 -input -safe -host baym-robot
