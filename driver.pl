#!/usr/bin/perl
#
#        Copyright (C) 2000-2019 the YAMBO team
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
use autodie;
do "config/MODULES.pl";
do "config/TOOLS.pl";
do "config/RULES.pl";
#
# The location of the test-suite directory
$suite_dir=abs_path();
#
# Defaults
#
&SETUP_defaults;
#&UTILS_cpu_usage;
#
# Options list
&UTILS_options;
#
if ($user_tests or $theme or $compile or $flow or $autotest or $update_test) {$RUNNING_suite="yes"};
#
if ($USER_host and -d "ROBOTS/$USER_host") {$host=$USER_host};
#
# Glob available configurations/flows
#
&SETUP_files;
#
my $len= length($kill_me);
if ($len eq 0) {
 $kill_me=`whoami`;
 chomp($kill_me);
}
if ($kill_me){
 if ($ROBOT_id) {
  &KILL_me("driver.pl","perl",$ROBOT_id);
  &KILL_me("yambo",$ROBOT_id);
  &KILL_me("ypp",$ROBOT_id);
 }else{
  &KILL_me("driver.pl","perl");
  &KILL_me("yambo");
  &KILL_me("ypp");
 }
 print "Killing action finalized.\n";
 exit;
}
#
# Post options setups
#
undef $nice;
my $len= length($nice_level);
if ($len eq 1) {$nice_level="19"};
if ($mode eq "bench" or $nice_level) { $run_duration = 24*60*60*7 };
if ($verb ge 2) { $log = "" };
if ($nice_level) {$nice="nice -n"."$nice_level"};
#
my $len= length($backup_logs);
if ($len eq 0) {$backup_logs="yes"};
if ($report) {$backup_logs="yes"};
my $len= length($edit);
if ($len eq 0) {$edit=1};
my $len= length($profile);
if ($len eq 0) {$profile=1};
my $len= length($cron);
if ($len eq 0) {$cron=1};
#
if ($mode eq "tests")    {$TESTS_folder="TESTS/MAIN"};
if ($mode eq "validate") {$TESTS_folder="TESTS/VALIDATE"};
if ($mode eq "cheers")   {$TESTS_folder="TESTS/CHEERS"};
if ($mode eq "bench")    {$TESTS_folder="TESTS/BENCHMARKS"};
if ($mode eq "perturbo") {$TESTS_folder="TESTS/PERTURBO"};
#
# Edit
#
if ($edit and $backup_logs eq "no" and $edit ne 1){
 if ($edit eq "filters" ) {system("vim config/RULES.h"); print "RULES file editing done.\n"; exit;};
 if ($edit eq "modules") {system("vim ROBOTS/$host/$user/MODULES"); print "MODULES file editing done.\n";exit;};
 if ($edit eq "branches") {system("vim ROBOTS/$host/$user/BRANCHES"); print "BRANCHES file editing done.\n";exit;};
 if ($edit eq "flags") {system("vim ROBOTS/$host/$user/FLAGS"); print "FLAGS file editing done.\n";exit;};
 if ($edit =~ /cron/) {system("vim ROBOTS/$host/$user/CRONTAB"); print "CRONTAB file editing done.\n";exit;};
 if (-e "ROBOTS/$host/$user/FLOWS/$edit.pl"){
  system("vim ROBOTS/$host/$user/FLOWS/$edit.pl");
 };
 if (-e "ROBOTS/$host/$user/FLOWS/$edit"){
  system("vim ROBOTS/$host/$user/FLOWS/$edit");
 };
 if (-e "ROBOTS/$host/$user/CPU_CONFIGURATIONS/$edit.cpu"){
  system("vim ROBOTS/$host/$user/CPU_CONFIGURATIONS/$edit.cpu");
 };
 if (-e "ROBOTS/$host/$user/CPU_CONFIGURATIONS/$edit"){
  system("vim ROBOTS/$host/$user/CPU_CONFIGURATIONS/$edit");
 };
 if (-e "ROBOTS/$host/$user/CONFIGURATIONS/$edit.sh"){
  system("vim ROBOTS/$host/$user/CONFIGURATIONS/$edit");
 };
 if (-e "ROBOTS/$host/$user/CONFIGURATIONS/$edit"){
  system("vim ROBOTS/$host/$user/CONFIGURATIONS/$edit");
 };
 print "All editings done.\n";
 exit;
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
 exit "\n";
}
if($help){ 
 &UTILS_robot_info ;
 &UTILS_usage ;
 exit "\n";
};
#
# cron
if ($cron){
 &CRON_driver;
 exit "\n";
}
#
# Show extra files
if($repo_check){ 
 &command("$git status --ignored | $grep -v SAVE | $grep -v GKKP | $grep -v .gz");
 print "Repo check done.\n";
 exit "\n";
};
#
# Download and exit
if($download){ 
 if ($download eq "list") {
  &FTP_list("testing-robots/databases")
 }else{
  &UTILS_download;
  print "Download complete.\n";
  exit;
 }
}
#
# Clean and exit
if ($clean and $backup_logs eq "no" and not $RUNNING_suite){ 
 if (not $ROBOT_id) {print "Cleaning"};
 &UTILS_clean("ALL");
 if (not $ROBOT_id) {&UTILS_clean("BINs")};
 print "... test databases outputs logfiles bin(s)";
 if ($clean > 1) {
  &UTILS_clean("DEEP");
  print "... core databases";
 }
 print "\nCleaning done.\n";
 exit;
};
# List tests and exit
# The -l:s means optional argument to -l: "default"|""|$listtests
#
if (!$listtests                             ) {&UTILS_list_tests("list_all"); exit;};
if ( $listtests and  $listtests !~ "default") {&UTILS_list_tests("$listtests"); exit;};
#
# Failed theme
#
if ($failed) {&UTILS_failed_theme_creator(); exit;};
#
# PHP generation 
#
if ($branch_php) {
 #&PHP_folders_rename(); 
 &PHP_generate(); 
 &PHP_upload();
 print "PHP generation finalized.\n";
 exit;
}
#
# SVN section
#
#Tag broken
if ($tag_test_as_broken)
{
 &command("touch    $TESTS_folder/$tag_test_as_broken/BROKEN");
 &command("$git add $TESTS_folder/$tag_test_as_broken/BROKEN");
 print "TEST tagged as broken.\n";
 exit;
}
if ($upload_test){ &UTILS_upload };
#
# FTP-related actions
if($ftp){ &FTP_it };
#
if (!$RUNNING_suite) {
 if ($ROBOT_id and $backup_logs eq "yes") {
  &UTILS_backup();
  &UTILS_backup_save();
  if ($report){ 
   &PHP_generate(); 
   &PHP_upload();
  }
  print "Backup done.\n";
  exit;
 };
 if (not $backup_logs eq "no") {
  &UTILS_list_backups("list")
 }
 if ($profile and $backup_logs eq "no") {
  &PROFILE_python();
 }
 print "Not running suite. Done.\n";
 exit;
}
#
# RUNNING SECTION
#=================
if ($RUNNING_suite) {
 #
 if ($clean) {
  &UTILS_clean("ALL");
  if ($clean>1) {&UTILS_clean("BINs")};
 }
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
 if (not $no_net) {&command("cd $suite_dir; $git pull")};
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
  print "UPDATE: Test(s) updated\n";
  exit;
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
 exit "\n";
}
#
&COMPILE_find_the_diff("clean");
#
if ( (not $FLOWS_done or not $AT_LEAST_ONE) and not $compile) {
 print "\nDone.\n";
 exit "\n";
}
#
&RUN_global_report("FINAL");
#
close $rlog;
#close $tlog; # This is closed in driver.pm inside the branches loop
close $slog;
close $elog;
close $wlog;
close $ulog;
close $flog;
#
if ($backup_logs eq "yes") {
 &UTILS_backup_save();
 if ($report){ 
  &PHP_generate(); 
  &PHP_upload();
 }
}
#
print "\nDone.\n";
