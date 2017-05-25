#!/bin/bash -x
#
#modules
#
source /opt/modules/init/modules_init.sh
module purge
module load profile/gnu-ompi
#
conf_file=gnu-ompi.sh
#
#svn
cd /scratch/buildbot/yambo-devel
svn up
cd /scratch/buildbot/yambo-devel/branches/test-suite
#
#select which tests
list="all"
#
##download
#./run_me.pl -d $list
#
#compile+serial
./run_me.pl -u -compile -m $list -conf $conf_file
#
#serial
./run_me.pl -u -openmp_is_off -m $list -conf $conf_file
#
#pure openmp
./run_me.pl -u -nt 8 -m $list -conf $conf_file
#
#pure MPI
./run_me.pl -u -np 4 -def_par -openmp_is_off -m $list -conf $conf_file
#
#MPI+openmp
./run_me.pl -u -np 4 -def_par -nt 2 -m $list -conf $conf_file
#
#MPI+openmp+parallelization cycle
./run_me.pl -u -np 4 -nt 2 -m $list -conf $conf_file


