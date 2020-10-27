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
sub RUN_driver{
#
$RUN_driver_base_path=abs_path();
#
# Loop over test directories
$numtests = @input_tests_list; # Number of elements
$count_tests=0;
$max_admitted_fails=1000;
#
&RUN_setup("INIT");
#
&RUN_global_report("TITLE");
#
LOOP_DIRS: foreach my $testline (@input_tests_list) {
 #
 chdir($RUN_driver_base_path);
 #
 chdir("$TESTS_folder");
 #
 &RUN_stats("INIT_DIR");
 #
 $count_tests++;
 my @dummy = split(/\s+/,$testline);
 $testdir = $dummy[0];
 shift(@dummy);
 @inputs=sort @dummy;
 $material=(split(/\//,$testdir))[0];
 $yambo_exec="";
 #
 my $msg=sprintf(" > $b_s [%3s/%3s] %-55s $b_e ",$count_tests,$numtests,$testdir."$cpu_global_conf");
 #
 &MESSAGE("LOG","\n$line");
 &MESSAGE("LOG","\n$b_s $testdir-$branch-$cpu_global_conf $b_e");
 &MESSAGE("LOG","\n$line");
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
 &UTILS_INPUT_folder;
 #
 $error=&RUN_skip_the_test("DIR");
 if ($error !~ "OK") { 
  &RUN_setup("after_tests_loop");
  $CHECK_error=" skipped (missing CORE databases)";
  &RUN_stats("DIR_SKIPPED");
  next LOOP_DIRS;
 };
 #
 if ($mode eq "bench") { $input_folder = "../$input_folder" };
 if (not -e "$ROBOT_wd") { 
  #
  &command("mkdir $ROBOT_wd");
  #
  # Folder mirrored preparation (only for tests)
  #
  if (not $mode eq "bench") {
   &command("rsync --exclude 'ROBOT*' -L -k -r . $ROBOT_wd");
   foreach $testname (@inputs) { 
     if (not -f "$ROBOT_wd/$input_folder/$testname" and -f "$ROBOT_wd/INPUTS/$testname" and not $is_GPL ) 
     {
       &MY_PRINT($stdout, "loading INPUTS for : $testname not found in $input_folder \n") if ($verb);
       &CWD_save;
       chdir("INPUTS");
       foreach $in_file (<$testname*>)
       {
         if (not -f "../$ROBOT_wd/$input_folder/$in_file"){ &command("cp $in_file ../$ROBOT_wd/$input_folder/")};
       }
       &CWD_go;
     }
   }
  };
  #
 }
 chdir($ROBOT_wd);
 #
 &MY_PRINT($stdout, $msg);
 &MY_PRINT($rlog,   $msg);
 #
 # Check if I need to convert the folder
 if (-e "CONVERTED") {next};
 if (not -e "CONVERTED") {&RUN_convert_the_SAVE};
 #
 # Loop over each test file
 LOOP_INPUTS: foreach $testname (@inputs) {
  #
  if( $test_with_fails > $max_admitted_fails ) {
    $CHECK_error=" skipped (too many fails)";
    &RUN_stats("TOO_MANY_FAILS");
    next LOOP_INPUTS;
  }
  if (not -f "$input_folder/$testname" and $is_GPL ) {next LOOP_INPUTS;}
  #
  &MY_PRINT($stdout, "\nRunning input: $testname\n") if ($verb);
  #
  # Do actions and create the input (if any)
  #&RUN_load_actions(".actions");
  &RUN_load_actions(".input");
  #
  # Input file dump
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
  &RUN_load_OPENMP_fields;
  if ($cpu_conf_file) {
   $MPI_CPU_conf[1]=$cpu_conf_key;
  }else{
   &RUN_load_LA_fields;
   &RUN_load_PAR_fields;
  }
  #
  $error=&RUN_skip_the_test("PAR_CONF");
  if ($error !~ "OK") { 
   &MY_PRINT($stdout, "ERROR: $CHECK_error\n") if ($verb);
   next LOOP_INPUTS;
  };
  #
  undef $LAST_COMPLETED_RUN;
  #
  # Do the actual run!
  LOOP: for ($ir=1; $ir<=$Nr ; $ir++){
   #
   $fails_in_the_run="0";
   $test_ok_action="INCREASE";
   #
   # Re-Create the input (if any)
   &RUN_load_actions(".input");
   #
   if ($cpu_conf_file) {
    $string=$cpu_conf_key;
   }else{
    $string=$MPI_CPU_conf[$ir];
   }
   #
   &RUN_setup("before_run");
   &RUN_load_actions(".actions");
   #
   # Check if extra flags are needed (JOB specific)
   $error=&RUN_user_flags($ir);
   #
   $N_random_tries=0;
   #
   if ($error =~ "OK") { 
    #
    # Use the tool itself to generate the input file
    if ($check_input_generation) {
      $INFILE_CHECK=&RUN_input_file_test;
    }
    #
    # Actual run
    $RUN_result=&RUN_it;
    #
    # ...Random PAR and FAILED conf?
    #
    while ($random_parallel and $CHECK_error eq "WRONG CPU configuration" and $N_random_tries<$MAX_RANDOM_PAR_TRIES) { 
     $test_ok_action="INCREASE";
     #print "$testname INIT\n";
     &RUN_load_PAR_fields;
     $string=$MPI_CPU_conf[1];
     &command("rm -fr yambo.in LOG r-${testname}* o-${testname}*");
     #print "$testname $ir B\n";
     # Re-Create the input (if any)
     &RUN_load_actions(".input");
     &RUN_setup("before_run");
     &RUN_load_actions(".actions");
     $N_random_tries++;
     #
     $RUN_result=&RUN_it;
     #print "$testname CHECK_error $CHECK_error\n";
    }
    #
    # Check
    if ($RUN_result =~ "OK") {
     if ($update_test) {
      &CHECK_driver;
     }elsif(not $mode eq "bench"){
      &CHECK_driver;
     }
    }
    #
    if ($check_input_generation and -f $INPUT_file) {
     my $msg = sprintf("%-"."$left_length"."s", "  $INPUT_file");
     &MESSAGE("LOG","\n"."$msg"."[$g_s  $INFILE_CHECK  $g_e]");
    }
    #
    &RUN_setup("after_run");
    #
   }else{
    if( $error =~ "FAIL" ) {$CHECK_error="Source-Run FAILED";};
    if( $error =~ "SKIP" ) {$CHECK_error="Source-Run SKIPPED";};
    &RUN_stats("WRONG_DEP");
   }
   #
   &command("rm -f yambo.in BASE_input");
   #
  }
  #
  if ($check_input_generation and $update_test) { &UPDATE_action("INPUT")};
  if (not $update_test) {&RUN_setup("after_par_loop")};
  #
 } # End loop on input files
 #
 if (not $update_test) {&RUN_setup("after_tests_loop")};
 #
}
chdir($RUN_driver_base_path);
#
}
1;
