#!/bin/bash
#
cd /scratch/marini/yambo-tests-robot
rm -fr compile_dir
./driver.pl -b -c 2>&1
./driver.pl -c 2>&1
git checkout develop
./driver.pl -kill 2>&1
