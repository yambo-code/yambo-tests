#
#        Copyright (C) 2000-2017 the YAMBO team
#              http://www.yambo-code.org
#
# Authors (see AUTHORS file for details): AM
#
# Based on the original driver written by CH
#
# This file is distributed under the terms of the GNU
# General Public License. You can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation;
# either version 2, or (at your option) any later version.
#
# This program is distributed in the hope that it will
# be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 59 Temple Place - Suite 330,Boston,
#
sub UTILS_clean{
#
# RESTORE
if ("@_" eq "RESTORE") {
 &CWD_save;
 chdir("$suite_dir/$TESTS_folder");
 DIR_LOOP: foreach $dir (<*>,<*/*>,<*/*/*>,<*/*/*/*>,<*/*/*/*/*>) {      # Glob all files
   if ( -d $dir."/SAVE_old" ) { 
    chdir("$dir");
    &RUN_restore_the_SAVE( ) ;
    chdir("$suite_dir/$TESTS_folder");
   }
 }
 &CWD_go;
}
#
# ALL
if("@_" eq "ALL") {
 if ($ROBOT_id) 
 {
  $cmd="$git ls-files --others --exclude-standard | grep -e R$ROBOT_id. -e ROBOT_Nr_$ROBOT_id -e LOG_$ROBOT_id | grep -v $hostname |  xargs rm -f";
  &command("$cmd");
  $cmd="find . -name 'ROBOT_Nr_$ROBOT_id' -o -name 'R$ROBOT_id' -type d | grep -v $hostname | xargs rm -fr";
  &command("$cmd");
  &command("rm -f outputs_and_reports_ALL-$ROBOT_string*");
  &command("rm -f DATABASES-$ROBOT_string*");
  &command("rm -f R${ROBOT_id}*.log");
 }else{
  &command("$git ls-files --others --exclude-standard | grep -v $hostname | xargs rm -fr");
  &command("find . -name 'ROBOT_*' -o -name '*-R*' -type d | grep -v $hostname | xargs rm -fr");
  &command("rm -f outputs_and_reports_ALL-* *compile*log *config*log");
 }
 &command("rm -f scripts/find_the_diff/Makefile");
};
#
# DEEP
if("@_" eq "DEEP") {
 &command("$git status --ignored | grep -e '/ns.' -e '/ndb.' | xargs rm -fr");
};
#
# BINs
if("@_" eq "BINs" ) {
 &LOAD_branches;
 for $ib ( 0 .. $#branches ) {
  $branchdir =@branches[$ib];
  foreach $conf_file (<ROBOTS/$host/$user/CONFIGURATIONS/*>){
   $conf_file = (split(/\//, $conf_file))[-1];
   $conf_bin  = "$branchdir/bin-$conf_file-$FC_kind";
   if ($ROBOT_id) {$conf_bin  = "$branchdir/bin-$conf_file-$FC_kind-$ROBOT_string"};
   &command("rm -fr $conf_bin* $branchdir/bin-precompiled*");
  }
 }
}
}
1;
