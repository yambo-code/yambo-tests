#
#        Copyright (C) 2000-2018 the YAMBO team
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
# Tests input
#
undef $AT_LEAST_ONE;
#---------------------------#
# Loop on BRANCHES
#---------------------------#
#
LOOP_BRANCH: for $ib ( 0 .. $#branches ) {
 #
 $branchdir =@branches[$ib];
 $branch_id =@branch_identity[$ib];
 #
 # Stats
 &RUN_stats("INIT");
 #
 $error=&SETUP_branch( );
 if ($error eq "FAIL") {next LOOP_BRANCH};
 #
 if (not @branch_robot[$ib] eq "" ) {
  if (not @branch_robot[$ib] eq $ROBOT_string) 
  {
   &MY_PRINT($stdout, "\n Branch is assigned to robot Nr.@branch_robot[$ib] while current Robot is $ROBOT_string.\n") if ($verb);
   next LOOP_BRANCH;
  }
 }
 #
 # Test List
 &UTILS_get_inputs_tests_list;
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
  $error=&SOURCE_driver( );
  if ($error eq "FAIL") {next LOOP_CONF};
  #
  # MSGs
  #
  &UTILS_title($stdout);
  &MY_PRINT($stdout, "\n$line");
  #
  # find_the_diff
  &COMPILE_find_the_diff("compile");
  &COMPILE_find_the_diff("clean");
  #
  # Run the input file generation tests in Inputs testdir
  if ($check_input_generation) { &RUN_input_file_test };
  #
  &RUN_logs;
  #
  foreach $np (@NP_set) {
   #
   &RUN_driver;
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
  if ($backup_logs eq "yes"){ &UTILS_backup };
  #
 } # End LOOP_CONF configurations
 # 
 &MY_PRINT($stdout,"\n$line");
 #
}; # End loop on BRANCHES
#
chdir("$suite_dir");
#
}
1;
