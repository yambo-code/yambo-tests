#!/usr/bin/perl
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
use lib ".";
do "config/MODULES.pl";
do "config/TOOLS.pl";
#
# Defaults
#
&SETUP_defaults;
#
# Options list
&UTILS_options;
#
if ($kill_me){
 &command("pkill yambo");
 &command("pkill ypp");
 &command("pkill driver.pl");
 die;
}
#
if ($report) {$backup_logs="yes"};
#
if ($edit){
 if ($edit eq "filters" ) {system("vim config/RULES.h");die;};
 if ($edit eq "branches") {system("vim ROBOTS/$host/$user/BRANCHES");die;};
 if ($edit eq "flags") {system("vim ROBOTS/$host/$user/FLAGS");die;};
 if (-e "ROBOTS/$host/$user/FLOWS/$edit.pl"){
  system("vim ROBOTS/$host/$user/FLOWS/$edit.pl");
 };
 die;
}
#
# Check, if STDOUT is a terminal. If not, not ANSI sequences are emitted.
if(-t STDOUT) {
 $color_start{blue}="\033[34m";
 $color_end{blue}="\033[0m";
 $color_start{red}="\033[31m";
 $color_end{red}="\033[0m";
 $color_start{green}="\033[32m";
 $color_end{green}="\033[0m";
}
#
# The location of the test-suite directory
$suite_dir=abs_path();
#
# help
if($help){ 
 &UTILS_usage ;
 die "\n";
};
#
# Show extra files
if($svn_check){ 
 &command("svn st | grep -v -e 'ns.' -e 'ndb.' -e '.tar' -e '_backup' -e 'MODULES.pl' -e 'TOOLS.pl' -e 'configure.ac' -e 'config.status'");
 die "\n";
};
#
# Download and exit
if($download){ 
 if ($download eq "list") {
  &FTP_list("testing-robots/databases")
 }else{
  &UTILS_download
 }
}
#
# Clean and exit
if($clean){ 
 print "Cleaning...\n";
 &UTILS_clean("ALL");
 &UTILS_clean("BINs");
 die "Test databases/outputs and local logfiles removed.\n";
};
# List tests and exit
# The -l:s means optional argument to -l: "default"|""|$listtests
#
if (!$listtests                             ) {&UTILS_list_tests("list_all"); die;};
if ( $listtests and  $listtests !~ "default") {&UTILS_list_tests("$listtests"); die;};
#
# Failed theme
#
if ($failed) {&UTILS_failed_theme_creator(); die;};
#
# SVN section
#
#Tag broken
if ($tag_test_as_broken)
{
 &command("touch ./tests/$tag_test_as_broken/BROKEN");
 &command("svn add ./tests/$tag_test_as_broken/BROKEN");
 die;
}
if ($update_test){
 &UTILS_update;
 &UTILS_clean("ALL");
 die;
}
#
if ($upload_test){ &UTILS_upload };
#
# FTP-related actions
if($ftp){ &FTP_it };
if($upload){ &FTP_upload_it("$upload","testing-robots/databases") };
#
if ($user_tests or $theme or $compile or $flow or $autotest) {$RUNNING_suite="yes"};
#
# Post-Run backup
#
if ($backup_logs and !$RUNNING_suite) {
 &UTILS_backup();
 &UTILS_backup_save();
 if ($report){ 
  &UTILS_commit();
  &UTILS_backup_upload();
 }
 die;
}
#
# RUNNING SECTION
#=================
if ($RUNNING_suite) {
 #
 &UTILS_clean("ALL");
 #
 # Global Report
 &RUN_global_report("INIT");
 #
 if (! $dry_run) {&command("cd $suite_dir; svn up")};
 #
 if ($user_tests or $theme or $compile) {
  #
  &driver();
  #
  $FLOWS_done++;
  #
 }
 #
 if ($flow) {
  #
  my $ERROR=&FLOW_init($flow);
  #
  if ( "$ERROR" eq "FAIL" ) {
   print "FLOW $flow not found/corrupted";
   die "\n";
  }
  #
  &FLOW_reset("ALL");
  #
  for $i ( 0 .. $#flow ) {
   #
   &FLOW_reset("PARTIAL");
   #
   my $ERROR=&FLOW_load();
   #
   if ("$active" eq "yes" and "$ERROR" eq "OK" ) 
   {
    &driver();
    $FLOWS_done++;
   };
   #
   #
  }
  #
 }
 #
 if ($autotest) {
  #
  &FLOW_reset("ALL");
  #
  if ($compile) {
   $select_conf_file="default.sh";
   $compile="yes";
  }else{
   $compile="no";
  }
  #
  $user_tests="hBN/GW-OPTICS 01_init 02_HF";
  #
  &driver();
  #
 }
}else{ 
 print "Tests string missing"; 
 die "\n";
}
#
&UTILS_clean("BINs");
#
&COMPILE_find_the_diff("clean");
#
if (not $FLOWS_done or not $AT_LEAST_ONE) {
 print "\nDone.\n";
 die "\n";
}
#
&RUN_global_report("FINAL");
#
if ($DATA_backup_file) {
 if ($backup_logs) {
  &UTILS_backup_save();
 }
 if ($report){ 
  &UTILS_commit();
  &UTILS_backup_upload();
 }
}
close $rlog;
close $tlog;
close $elog;
close $wlog;
#
print "\nDone.\n";
die "\n";
#
#
