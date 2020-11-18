#!/usr/bin/bash
#
profile=$1
flow=$2
branch=$3

source /opt/modules/init/modules_init.sh
module purge 
module load profile/$profile

./driver.pl -flow  $flow -report -branch $branch -nice -newer 300 -input -safe -host corvina
