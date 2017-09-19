#!/bin/bash 

source /opt/modules/init/modules_init.sh
MODULEPATH=$MODULEPATH:/scratch/marini/Modules

cd /scratch/marini/yambo-tests/test-suite

#module purge
#module load gnu/yambo_libs
#./driver.pl -tests "hBN/GW-OPTICS" -compile
##./driver.pl -flow validate -report 

module purge
module load openmpi/intel/1.6.5-intel
./driver.pl -flow validate -report -newer 2


