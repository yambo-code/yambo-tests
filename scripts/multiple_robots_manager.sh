#!/bin/bash

usage() { 
	echo "Usage: $0 [ -r ID (optional)] [ -i(install) -b(oot) -k(ill) -c(onf) -c(l)ean -(u)pdate -(p)ause/unpause -h ] " 1>&2 
}

message(){
 echo -e "${RED}$1${NC}"
}

repeat(){
 for i in {1..90}; do echo -en "${RED}$1${NC}"; done
 echo
}
clone() { 
 local RD=`pwd`
 cd $INSTALL_dir
 git clone $INSTALL_repo $INSTALL_goal
 cd $INSTALL_goal
 git pull
 git submodule init
 git submodule update --merge --remote
 git pull
 cd $RD
}

# Get the options
while getopts "r:icklubhp" option; do
   case $option in
      r) user_ID=$OPTARG;;
      i) INSTALL=1;;
      u) UPDATE=1;;
      b) BOOT=1;;
      k) KILL=1;;
      c) CONF=1;;
      l) CLEAN=1;;
      h) HELP=1;;
      p) PAUSE=1;;
   esac
done
#
robot=`hostnamectl | grep Static | grep -oE '[^ ]+$'`
CD=`pwd`
me=`whoami`
RED='\033[0;31m'
NC='\033[0m' 
#
# Help
if [ ! -z $HELP ]; then
  usage
  exit
fi
#
if [ ! -z $user_ID ] && [ ! -d test.$user_ID ] ; then mkdir test.$user_ID; fi
#
for test in test.* ; do
 ID=`echo $test | sed s/test.//`
 PID=`pgrep -f $robot.$ID`
 if  [ ! -z $user_ID ] ; then
   if [ ! $user_ID == $ID ]; then  continue; fi
 fi
 #
 # Update 
 #
 if [ ! -z $PAUSE ] ; then
  STOP_file="yambo-testing/stop_${robot}.$ID"
  if [ -f ~/$STOP_file ] ; then 
   rm -f ~/$STOP_file
  else
   touch ~/$STOP_file
  fi
 fi
 #
 # Update 
 #
 if [ ! -z $UPDATE ] ; then
  cd $test
  git pull
  git submodule init
  git submodule update --merge --remote
  git pull
  cd ..
 fi
 #
 # Clean 
 #
 if [ ! -z $CLEAN ] ; then
  cd $test
  ./driver.pl -c
  rm -fr compile_dir
  cd ..
 fi
 #
 # Install
 #
 if [ ! -z $INSTALL ] ; then
  if [ ! -f sources/gpl/master.$ID/configure ]; then
   repeat "="
   message "Cloning master.$ID (GPL)..."
   repeat "="
   INSTALL_dir="$CD/sources/gpl"
   INSTALL_goal="master.$ID"
   INSTALL_repo="git@github.com:yambo-code/yambo.git"
   clone
  fi
  if [ ! -f sources/devel/master.$ID/configure ]; then
   repeat "="
   message "Cloning master.$ID (DEVEL)..."
   repeat "="
   INSTALL_dir="$CD/sources/devel"
   INSTALL_goal="master.$ID"
   INSTALL_repo="git@github.com:yambo-code/yambo-devel.git"
   clone
  fi
  if [ ! -f test.$ID/configure ]; then
   repeat "="
   message "Cloning test.$ID..."
   repeat "="
   INSTALL_dir="$CD"
   INSTALL_goal="test.$ID"
   INSTALL_repo="git@github.com:yambo-code/yambo-tests.git"
   clone
  fi
  continue
 fi
 cd $test
 #
 # Conf
 if [ ! -z $CONF ] ; then
  if [ ! -d ROBOTS/$robot.$ID ] ; then NEW=1; fi 
  repeat "="
  message "Configuring $robot.$ID"
  repeat "="
  git pull
  git submodule update --merge --remote
  echo "./configure --with-yambo=$CD/sources/gpl/master.$ID --with-host=$robot.$ID"
  ./configure --with-yambo=$CD/sources/gpl/master.$ID --with-host=$robot.$ID
  if [ ! -z $NEW ]; then
   repeat "="
   message "Cloning $robot.1 => $robot.$ID" 
   repeat "="
   cd ROBOTS/$robot.$ID/$me/
   for fold in CONFIGURATIONS CPU_CONFIGURATIONS CRONTAB MODULES; do
    rm -fr $fold
    ln -s ../../$robot.1/$me/$fold .
   done
   cd ../../../
   if [ -f ../test.1/.running_robot.pl ]; then
     cat ../test.1/.running_robot.pl | sed s/$robot.1/$robot.$ID/ > .running_robot.pl
   fi
  fi
  cat ROBOTS/$robot.$ID/$me/BRANCHES | sed s/gpl/REPO/ > ROBOTS/$robot.$ID/$me/BRANCHES.base
 fi
 #
 # Boot
 if [ ! -z $BOOT ] && [ -z $PID ] ; then
  repeat "="
  message "Booting $robot.$ID"
  repeat "="
  ./scripts/launch_the_robot.sh
 fi
 #
 # Kill 
 if [ ! -z $KILL ] && [ ! -z $PID ] ; then
  repeat "="
  message "Killing $robot.$ID with PID "$PID
  repeat "="
  kill $PID
 fi
 #
 cd ..
done
#
