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
sub RUN_driver{
#
&CWD_save;
#
# Loop over test directories
$numtests = @input_tests_list; # Number of elements
$count_tests=0;
#
&RUN_setup("INIT");
#
&RUN_global_report("TITLE");
#
LOOP_DIRS: foreach my $testline (@input_tests_list) {
 #
 &CWD_go;
 chdir("$TESTS_folder");
 #
 &RUN_stats("INIT_DIR");
 #
 $count_tests++;
 @inputs = split(/\s+/,$testline);
 $testdir = shift(@inputs); 
 my @material_pieces = split(/\//,$testdir);
 $material=$material_pieces[0];
 $yambo_exec="";
 #
 my $msg=sprintf(" > $b_s [%-3s/%-3s] %-20s $b_e ",$count_tests,$numtests,$testdir."$cpu_global_conf");
 #
 if (!-d $testdir){
   if ($verb){
    &MY_PRINT($stdout, $msg);
    &MY_PRINT($stdout, " missing $testdir. Skipping");
   }
   next LOOP_DIRS;
 }
 chdir($testdir);
 #
 # Folder mirrored preparation
 #
 if (not -e "$ROBOT_wd") {
  &command("mkdir $ROBOT_wd");
  &command("rsync --exclude 'ROBOT*' -L -k -r . $ROBOT_wd");
 }
 chdir($ROBOT_wd);
 #
 $input_folder = "INPUTS";
 if ($is_GPL and -d "INPUTS-GPL"){ $input_folder = "INPUTS-GPL"}
 #
 $error=&RUN_skip_the_test("DIR");
 if ($error !~ "OK") { 
  &RUN_setup("after_tests_loop");
  next LOOP_DIRS;
 };
 #
 &MY_PRINT($stdout, $msg);
 #
 &MESSAGE("LOG","\n$line");
 &MESSAGE("LOG","\n$b_s $testdir-$branch-$cpu_global_conf $b_e");
 &MESSAGE("LOG","\n$line");
 #
 # Check if I need to convert the folder
 &RUN_convert_the_SAVE;
 #
 # Loop over each test file
 LOOP_INPUTS: foreach $testname (@inputs) {
  #
  &MY_PRINT($stdout, "\nRunning input: $testname\n") if ($verb);
  #
  # Do actions and create the input (if any)
  &RUN_load_actions(".actions");
  &RUN_load_actions(".input");
  #
  # Input file dump
  #
  &RUN_input_load;
  #
  # Runlevels
  &RUN_get_runlevels;
  #
  # EXE for this runlevel
  &RUN_executables;
  #
  $error=&RUN_skip_the_test("INPUT");
  if ($error !~ "OK") { 
   &MY_PRINT($stdout, "ERROR: $CHECK_error\n") if ($verb);
   next LOOP_INPUTS;
  };
  #
  # Overwrite specific options from .conf for this input file
  &RUN_load_conf;
  if ($skip_this_test) {next LOOP_INPUTS};
  #
  # Prepare the input file
  &RUN_load_PAR_fields;
  #
  # Do the actual run!
  LOOP: for ($ir=1; $ir<=$Nr ; $ir++){
   #
   $first_in_the_run="1";
   #
   # Re-Create the input (if any)
   &RUN_load_actions(".input");
   #
   $string=$RUN_spec[$ir];
   #
   &RUN_setup("before_run");
   #
   # Check if extra flags are needed (JOB specific)
   $error=&RUN_user_flags($ir);
   if ($error =~ "OK") { 
    #
    # Actual run
    $RUN_result=&RUN_it;
    #
    # Check
    if ($RUN_result =~ "OK"){&CHECK_driver};
    #
    &RUN_setup("after_run");
    #
   }else{
    $CHECK_error="Source-Run FAILED";
    &RUN_stats("WRONG_DEP");
   }
   #
   &command("rm -f yambo.in");
   #
  }
  #
 } # End loop on input files
 #
 if (!$freeze) {&RUN_restore_the_SAVE( )};
 #
 &RUN_setup("after_tests_loop");
 #
}
&CWD_go;
#
}
1;
