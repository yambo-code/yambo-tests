#!/bin/bash -x
#
#modules
#
source /opt/modules/init/modules_init.sh
module purge
module load openmpi/intel
module load mkl
#
#svn
cd /scratch/buildbot/yambo-devel
svn up
cd /scratch/buildbot/yambo-devel/branches/test-suite

#
# Select which tests
#
tests="-theme basic -e"
#tests="-tests all -e"
project="-p any"
#download and compile
upload=" "
download="no"
compile="yes"
#SERIAL
serial="yes"
#MPI
mpi="yes"
mpicycle="no"
#OPENMP
no_openmp_flag="-openmp_is_off"
openmp="yes"
mpiopenmp="yes"


#
# Download
#
if [ "$download" = "yes" ] ; then
./run_me.pl -d all
fi
#
# compile
#
if [ "$compile" = "yes" ] ; then
./run_me.pl $upload -compile $project
fi
#
# serial 
#
if [ "$serial" = "yes" ] ; then
./run_me.pl $upload $no_openmp_flag $tests $project
fi
#
# pure openmp
#
if [ "$openmp" = "yes" ] ; then
./run_me.pl $upload -nt 12 $tests $project
fi
#
# pure MPI
#
if [ "$mpi" = "yes" ] ; then
./run_me.pl $upload -np 12 -def_par $no_openmp_flag $tests $project
fi
#
# MPI+openmp
#
if [ "$mpiopenmp" = "yes" ] ; then
./run_me.pl $upload -np 3 -def_par -nt 4 $tests $project
fi
#
# MPI+parallelization cycle
#
if [ "$mpicycle" = "yes" ] ; then
./run_me.pl $upload -np 4 -nt 3  $tests $project
fi

