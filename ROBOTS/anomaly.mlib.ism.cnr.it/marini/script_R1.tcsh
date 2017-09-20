#!/usr/bin/tcsh

cd /home/marini/Yambo/sources/svn/yambo-tests

module purge 
module load gcc6/yambo/mpich-3.2/pre_compiled

./driver.pl -c
#./driver.pl -d all
./driver.pl -flow minimal 
#-report
