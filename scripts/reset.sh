#!/bin/bash
#
cd /scratch/marini/yambo-tests-robot
rm -fr compile_dir
./driver.pl -b -c 2>&1
./driver.pl -c 2>&1
git checkout develop
cd ROBOTS
git checkout master
cd ..
./driver.pl -kill 2>&1
