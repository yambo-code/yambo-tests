#!/bin/bash 

source /opt/modules/init/modules_init.sh
MODULEPATH=$MODULEPATH:/scratch/marini/Modules

#module purge
#module load gnu/yambo_libs
#cd /scratch/marini/yambo-tests/test-suite
#./driver.pl -tests "hBN/GW-OPTICS" -compile
##./driver.pl -flow validate -report -keep_dbs

module purge
module load openmpi/intel/1.6.5-intel
cd /scratch/marini/yambo-tests/test-suite
./driver.pl -flow validate -report -keep_dbs

