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
 #
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
  if (not $mode eq "bench") {&command("rsync --exclude 'ROBOT*' -L -k -r . $ROBOT_wd")};
  #
 }
 chdir($ROBOT_wd);
 #
 &MY_PRINT($stdout, $msg);
 #
 # Check if I need to convert the folder
 if (not -e "CONVERTED") {&RUN_convert_the_SAVE};
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
  &RUN_load_OPENMP_fields;
  if ($cpu_conf_file) {
   $MPI_CPU_conf[1]=$cpu_conf_key;
  }else{
   &RUN_load_LA_fields;
   &RUN_load_PAR_fields;
  }
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
   #
   # Check if extra flags are needed (JOB specific)
   $error=&RUN_user_flags($ir);
   # 
   $N_random_tries=0;
   #
   if ($error =~ "OK") { 
    #
    # Actual run
    $RUN_result=&RUN_it;
    #
    # ...Random PAR and FAILED conf?
    #
    while ($random_parallel and $CHECK_error eq "WRONG CPU configuration" and $N_random_tries<10) { 
     #print "$testname INIT\n";
     &RUN_load_PAR_fields;
     $string=$MPI_CPU_conf[1];
     &command("rm -fr yambo.in LOG r-${testname}* o-${testname}*");
     #print "$testname B\n";
     # Re-Create the input (if any)
     &RUN_load_actions(".input");
     &RUN_setup("before_run");
     $N_random_tries++;
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
    # In case we are running in a different directory (see p2y, RUN_load_conf)
    #
    if ($P2Y) {
     chdir $suite_dir;
     chdir "$TESTS_folder/$testdir/$ROBOT_wd";
    };
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
 &RUN_setup("after_tests_loop");
 #
}
&CWD_go;
#
}
1;
