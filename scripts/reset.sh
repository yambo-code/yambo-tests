#!/bin/bash
#
cd /scratch/marini/yambo-tests-robot
./driver.pl -kill 2>&1
./driver.pl -c 2>&1
git checkout master
