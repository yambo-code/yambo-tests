#!/usr/bin/tcsh

source /opt/modules/init/modules_init.csh

cd /scratch/marini/yambo-tests/test-suite/

module purge
module load profile/gnu-ompi
./driver.pl -flow validate 
#./driver.pl -flow validate -report -keep_dbs

#module purge 
#module load profile/intel-ompi
#./driver.pl -flow validate -report -keep_dbs 
