#!/usr/bin/tcsh -m
#
# script.tcsh down
# script.tcsh clean
# script.tcsh compile gf_mpich 3 devel-rt-rotate
# script.tcsh run gf_mpich 3
#
if ( "$1" == "down") then
 cd /home/marini/yambo-tests
 ./driver.pl -kill
 ./driver.pl -d all -force
 exit
endif

if ( "$1" == "clean") then
 cd /home/marini/yambo-tests
 ./driver.pl -c 
 exit
endif

module purge
if ( "$2" == "gf_mpich") then
 module purge
 module load full-suite/gcc/8.2.0/mpich-3.2.1
endif
if ( "$2" == "gf_openmpi") then
 module purge
 module load full-suite/gcc/8.2.0/openmpi-3.1.2
endif
if ( "$2" == "intel") then
 module purge
 module load full-suite/intel/parallel_2018
endif

if ( "$1" == "compile" ) then
 module list
 cd /home/marini/Yambo/master-test-suite
 make distclean
 git checkout $4
 git pull
 /home/marini/yambo-tests/ROBOTS/polluce.mlib.ism.cnr.it/marini/CONFIGURATIONS/default.sh 
 make -j all
 rm -fr bin-precompiled-R$3
 mkdir bin-precompiled-R$3
 cp config/setup bin-precompiled-R$3
 cp bin/* lib/bin/* bin-precompiled-R$3
 exit
endif

if ( "$1" == "run") then
 module list
 cd /home/marini/yambo-tests
 ./driver.pl -c -flow validate -report -robot $3 -nice -newer 100 -safe -keep_bin
endif
