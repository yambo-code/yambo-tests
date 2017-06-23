#!/usr/bin/tcsh
#
source /opt/modules/init/modules_init.csh
#
module purge
module load profile/gnu-ompi
cd yambo/branches/devel-qp-dbs/
make distclean
git pull
~/test-suite/ROBOTS/potzie/marini/CONFIGURATIONS/default.sh
make all
cd /scratch/marini/yambo-tests/test-suite/
./driver.pl -flow validate -report 

#module purge 
#module load profile/intel-ompi
#./driver.pl -flow validate -report 
