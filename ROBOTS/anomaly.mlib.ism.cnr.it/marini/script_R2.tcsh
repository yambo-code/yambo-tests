#!/usr/bin/tcsh

cd /home/marini/Yambo/sources/svn/yambo-tests

module purge 
module load intel/yambo/parallel_2017/pre_compiled

./driver.pl -flow minimal 
#-report
