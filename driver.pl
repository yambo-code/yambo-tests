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
# The location of the test-suite directory
$suite_dir=abs_path();
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
# Post options setups
#
if ($verb ge 2) { $log = "" };
my $len= length($backup_logs);
if ($len eq 0) {$backup_logs="yes"};
if (($report or $profile) and $len eq 0) {$backup_logs="yes"};
if ($mode eq "bench")    {$TESTS_folder="TESTS/BENCHMARKS"};
if ($mode eq "perturbo") {$TESTS_folder="TESTS/PERTURBO"};
#
# Edit
#
if ($edit and not $edit eq "backup"){
 if ($edit eq "filters" ) {system("vim config/RULES.h");die;};
 if ($edit eq "branches") {system("vim ROBOTS/$host/$user/BRANCHES");die;};
 if ($edit eq "flags") {system("vim ROBOTS/$host/$user/FLAGS");die;};
 if (-e "ROBOTS/$host/$user/FLOWS/$edit.pl"){
  system("vim ROBOTS/$host/$user/FLOWS/$edit.pl");
 };
 if (-e "ROBOTS/$host/$user/CPU_CONFIGURATIONS/$edit.cpu"){
  system("vim ROBOTS/$host/$user/CPU_CONFIGURATIONS/$edit.cpu");
 };
 if (-e "ROBOTS/$host/$user/CONFIGURATIONS/$edit.sh"){
  system("vim ROBOTS/$host/$user/CONFIGURATIONS/$edit.sh");
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
# help
if($info){ 
 &UTILS_robot_info ;
 die "\n";
}
if($help){ 
 &UTILS_robot_info ;
 &UTILS_usage ;
 die "\n";
};
#
# Show extra files
if($repo_check){ 
 &command("$git status --ignored | grep -v SAVE | grep -v GKKP | grep -v .gz");
 die "\n";
};
#
# Download and exit
if($download){ 
 if ($download eq "list") {
  &FTP_list("testing-robots/databases")
 }else{
  &UTILS_download;
  die "Download complete.\n";
 }
}
#
# Clean and exit
if($clean and $backup_logs eq "no"){ 
 print "Cleaning";
 &UTILS_clean("ALL");
 &UTILS_clean("BINs");
 print "... test databases outputs logfiles bin(s)";
 if ($clean > 1) {
  &UTILS_clean("DEEP");
  print "... core databases";
 }
 die "\n";
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
# PHP generation 
#
if ($php) {
 #&PHP_folders_rename(); 
 &PHP_generate(); 
 &PHP_upload();
 die;
}
#
# SVN section
#
#Tag broken
if ($tag_test_as_broken)
{
 &command("touch    $TESTS_folder/$tag_test_as_broken/BROKEN");
 &command("$git add $TESTS_folder/$tag_test_as_broken/BROKEN");
 die;
}
if ($upload_test){ &UTILS_upload };
#
# FTP-related actions
if($ftp){ &FTP_it };
if($upload){ &FTP_upload_it("$upload","testing-robots/databases") };
#
if ($user_tests or $theme or $compile or $flow or $autotest or $update_test) {$RUNNING_suite="yes"};
#
if (!$RUNNING_suite) {
 if (not $backup_logs eq "no" or $profile) {&UTILS_list_backups("list")};
 die;
}
#
# RUNNING SECTION
#=================
if ($RUNNING_suite) {
 #
 # Array to avoid double configure of branches
 #
 undef @BRANCH_is_correctly_compiled;
 #
 # Robot ID definition
 #
 if ($ROBOT_id) {
  $ROBOT_wd="ROBOT_Nr_".$ROBOT_id;
  $ROBOT_string="R".$ROBOT_id;
  if (-e "$suite_dir/$ROBOT_wd") {die "\n ROBOT #$ROBOT_id already running"};
  &command("touch $suite_dir/$ROBOT_wd");
  $find_the_diff="find_the_diff_$ROBOT_string";
 }else{
  foreach my $i_ROBOT (1...100) {
   $ROBOT_wd="ROBOT_Nr_".$i_ROBOT;
   $ROBOT_string="R".$i_ROBOT;
   if (not -e "$suite_dir/$ROBOT_wd") {
    &command("touch $suite_dir/$ROBOT_wd");
    $find_the_diff="find_the_diff_$ROBOT_string";
    last;
   }
  }
 }
 #
 # Global Report
 #
 &RUN_global_report("INIT");
 #
 if (! $dry_run) {&command("cd $suite_dir; $git pull")};
 #
 &SETUP_branch("load_the_branches");
 #
 if ($user_tests or $theme or $compile) {
  #
  if ($cpu_conf_file) { &CPU_CONF_setup }; 
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
    if ($cpu_conf_file) { &CPU_CONF_setup }; 
    &driver();
    $FLOWS_done++;
   };
   #
   #
  }
  #
 }
 #
 if ($update_test){
  &UTILS_update;
  $upload_test=$update_test;
  &UTILS_upload;
  die;
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
&COMPILE_find_the_diff("clean");
#
if (not $FLOWS_done or not $AT_LEAST_ONE) {
 print "\nDone.\n";
 die "\n";
}
#
&RUN_global_report("FINAL");
#
close $rlog;
close $tlog;
close $elog;
close $wlog;
close $flog;
#
if ($DATA_backup_file) {
 if ($backup_logs eq "yes") {
  &UTILS_backup_save();
  if ($report){ 
   &PHP_generate(); 
   &PHP_upload();
   #&UTILS_commit();
  }
 }
}
#
print "\nDone.\n";
die "\n";
