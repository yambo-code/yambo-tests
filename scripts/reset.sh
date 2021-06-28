#!/bin/bash
#
cd /scratch/marini/yambo-tests-robot
./driver.pl -c 2>&1
git checkout master
./driver.pl -kill 2>&1
