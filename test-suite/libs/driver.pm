#$system_command = "svn commit -F $upload/ERROR-$upload";!/usr/bin/perl
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
sub driver{
#
# LOG dir and ncdpump...
&SETUP_keys;
#
# Basic Setup
&SETUP("BASIC");
#
# DEFINE input_folder
#
if ($is_GPL eq "no" ){ $input_folder = "INPUTS"; }
if ($is_GPL eq "yes"){ $input_folder = "INPUTS-GPL"; }
#
# Tests input
&UTILS_get_inputs_tests_list;
#
my $AT_LEAST_ONE="no";
#---------------------------#
# Loop on BRANCHES
#---------------------------#
#
my @running_branches=@branches;
#
LOOP_BRANCH: foreach $branchdir (@running_branches) {
 #
 chomp($branchdir);
 #
 # Stats
 &RUN_stats("INIT");
 #
 $error=&SETUP_branch( );
 if ($error eq "FAIL") {next LOOP_BRANCH};
 #
 #-------------------------------#
 # Loop on CONFIGURATIONS 
 #-------------------------------#
 $precompiled_is_run="";
 LOOP_CONF: foreach $conf_path (<ROBOTS/$host/$user/CONFIGURATIONS/*>){
  #
  # Basic Setup
  &SETUP("DIR");
  #
  $error=&SETUP_configuration( );
  if ($error eq "FAIL") {next LOOP_CONF};
  #
  # find_the_diff
  &COMPILE_find_the_diff("compile");
  #
  # Run the input file generation tests in Inputs testdir
  if ($check_input_generation) { &RUN_input_file_test };
  #
  &RUN_logs;
  #
  foreach $np (@NP_set) {
   #
   &UTILS_clean("SAVEs");
   #
   &RUN_driver;
   #
   $AT_LEAST_ONE="yes";
   #
   $reduced_log="yes";
   #
  }
  #
  # Report total passes/failures
  &RUN_stats("REPORT");
  # 
  &RUN_global_report("RUNTIME");
  # 
  # Files closing
  close $tlog;
  #
  if ($backup_logs){ &UTILS_backup };
  #
 } # End LOOP_CONF configurations
 # 
 &MY_PRINT($stdout,"\n$line");
}; # End loop on BRANCHES
#
chdir("$suite_dir");
#
}
1;
