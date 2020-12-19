#
#        Copyright (C) 2000-2020 the YAMBO team
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
 &command("find . -type d -empty | xargs rm -fr");
 if ($ROBOT_id) 
 {
  @rob_to_clean=split(/-/, $ROBOT_id);
  if ( scalar @rob_to_clean == 1 ) {&ROBOT_clean($rob_to_clean[0]);}
  foreach $rob ($rob_to_clean[0]..$rob_to_clean[1]){
    &ROBOT_clean($rob);
  }
 }elsif ($user_branch){
  foreach $log (<LOG*>){
   if ($log =~ /$user_branch/)
   {
    $ROBOT_id=(split('-',$log))[1];
    $ROBOT_id=~ s/R//g;
    &ROBOT_clean($ROBOT_id);
   };
  }
 }else{
  &command("find . -name '*R[0-9]*' -type f | xargs rm -fr");
  &command("find $TESTS_folder -name 'ROBOT_*' -o -name '*-R[0-9]*' -type d | $grep -v $hostname | xargs rm -fr");
  &command("$git ls-files --others --exclude-standard | $grep -v $hostname | grep -v MODULES.pl | grep -v TOOLS.pl | xargs rm -fr");
  &command("rm -f outputs_and_reports_ALL-* *compile*log *config*log");
 }
 &command("rm -f scripts/find_the_diff/Makefile");
};
#
# CORE
if("@_" eq "CORE") {
 &command("$git status --ignored | $grep -e '/ns.' -e '/ndb.' | xargs rm -fr");
 &command("find . -type d -empty | xargs rm -fr");
};
#
# TARGZ
if("@_" eq "TARGZ") {
 &command("$git status --ignored | $grep -e '.tar.gz' | xargs rm -fr");
 &command("find . -type d -empty | xargs rm -fr");
};
#
# TARGZ
if("@_" eq "DFT") {
 &command("$git status --ignored | $grep -e 'WFK.nc' | xargs rm -fr");
 &command("$git status --ignored | $grep -e 'QEX' | xargs rm -fr");
 &command("find . -type d -empty | xargs rm -fr");
};
#
# BINs
if("@_" eq "BINs" ) {
 &LOAD_branches;
 for $ib ( 0 .. $#branches ) {
  $branchdir =@branches[$ib];
  foreach $conf_file (<ROBOTS/$host/$user/CONFIGURATIONS/*>){
   $conf_file = (split(/\//, $conf_file))[-1];
   $conf_bin  = "$suite_dir/bin-$conf_file-$FC_kind";
   if ($ROBOT_id) {$conf_bin  = "$suite_dir/bin-$conf_file-*R$ROBOT_id"};
   &command("rm -fr $conf_bin* $suite_dir/bin-precompiled*");
  }
 }
}
}
sub ROBOT_clean
{
 $ID = shift;
 print "Cleaning ROBOT #".$ID."\n";
 $cmd="find $TESTS_folder -name 'ROBOT_Nr_$ID' -o -name 'R$ID' -type d | $grep -v $hostname | grep    MAIN | xargs rm -fr";
 &command("$cmd");
 $cmd="find $TESTS_folder -name 'ROBOT_Nr_$ID' -o -name 'R$ID' -type d | $grep -v $hostname | grep -v MAIN | xargs rm -fr";
 &command("$cmd");
 $cmd="$git ls-files --others --exclude-standard | $grep -e 'ROBOT_Nr_$ID/' | $grep -v $hostname |  xargs rm -f";
 &command("$cmd");
 &command("rm -f outputs_and_reports_ALL-R$ID.* ROBOT_Nr_$ID scripts/find_the_diff/find_the_diff_R$ID");
 &command("rm -f *R${ID}-*.log");
}
1;
