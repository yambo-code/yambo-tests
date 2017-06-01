#!/bin/bash -x

#
# flags
#
flags=$*

#
# modules
#
source /opt/modules/init/modules_init.sh
module purge
module load profile/gnu-ompi
#
conf_file=gnu-ompi.sh

#
# svn
#
cd /scratch/ferretti/yambo-tests
svn up
cd /scratch/ferretti/yambo-tests/test-suite

#
# compiling
#
./driver.pl -compile -conf $conf_file $flags

#
# running
#
./driver.pl -flow simple -conf $conf_file $flags


