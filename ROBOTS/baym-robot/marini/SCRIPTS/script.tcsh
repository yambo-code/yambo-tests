#!/usr/bin/tcsh
#./driver.pl -flow  $1 -report -branch $2 -nice -newer 300 -input -safe -host baym-robot -module GF_MPICH
./driver.pl -flow  $1 -branch $2 -safe -host baym-robot -module GF_MPICH -v

