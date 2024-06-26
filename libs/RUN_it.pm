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
sub RUN_it{
#
# Report the input file
if($verb ge 2) { &PRINT_input };
#
my $CPU_cmd= " ";
if ($yambo_running) {$CPU_cmd=$CPU_flag};
#
# MPI off?
#
my $mpi_off_flag=" ";
if ($mpi_is_off){
 if ( not $is_NEW_driver) {$mpi_off_flag="-M"}
 if (     $is_NEW_driver) {$mpi_off_flag="-nompi"}
}
#
# CMD line
#
if ($mpiexec) {
 $command_line = "$nice $mpiexec -np $np $yambo_exec $INPUT_option $INPUT_file $flags $in_dir_cmd_line $CPU_cmd $log";
}else{
 $command_line = "$nice $yambo_exec $mpi_off_flag $INPUT_option $INPUT_file $flags $in_dir_cmd_line $log";
}
#
# *** RUN ***
$test_start = [gettimeofday];
#
&RUN_wait_and_kill();
#
# Clock update
$test_end   = [gettimeofday]; 
$elapsed = tv_interval($test_start, $test_end);
#
# Keep track that at least one job was run
#
$AT_LEAST_ONE="yes";
#
# Check if a wrong CPU conf has been used...
#
$CHECK_error="";
undef $wrong_cpu_conf;
undef $empty_worload;
LOG_LOOP: {
 foreach $file (<LOG/l-*>) {
  open $fh, $file or die;
  while (my $line = <$fh>) {
   if ($line =~ /Empty workload/ || $line =~ /n_t_CPU > n_blocks/) { 
    if ($verb and not $empty_worload) {&MESSAGE("LOG"," Empty workload for some CPU")};
    $empty_worload = 1;
   }
   if ($line =~ /USER parallel structure does not fit the current run parameters/) { $wrong_cpu_conf = 1; }
   if ($line =~ /Impossible to define an appropriate parallel structure/)          { $wrong_cpu_conf = 1; }
   if ($line =~ /DIPOLES Parallelization over v bands not accepted/)               { $wrong_cpu_conf = 1; }
  }
 }
}
#
# Final Report
#
if($wrong_cpu_conf){
 if( $N_random_tries < $MAX_RANDOM_PAR_TRIES){ $CHECK_error="WRONG CPU configuration"; &RUN_stats("WRONG_CPU_CONF"); }
 if( $N_random_tries== $MAX_RANDOM_PAR_TRIES){ $CHECK_error="FAILED CPU configuration"; &RUN_stats("ERROR_CPU_CONF"); }
 return "FAIL";
}elsif($empty_workload){
 &MESSAGE("LOG","[WARN: EMPTY workload]");
 return "OK";
}
#
if ($system_error == 0) {
 if ($elapsed > $run_duration) {
  $CHECK_error="FAILED (Runtime above $run_duration secs.)";
  &RUN_stats("RUNTIME");
  return "FAIL";
 }else{
  my $msg = sprintf("%8.1f", $elapsed);
  &MESSAGE("LOG",$msg."s");
 }
}elsif ($system_error == 256) {
 # This happens because perl returns a 16 bit value, with the exit code in the higher 8 bits
 # If not properly converted, this is equal to the value multipliued by 256
 # So 256 is error code 1, e.g. EPERM /* Operation not permitted *
 my $msg = sprintf("%8.1f", $elapsed);
 &MESSAGE("LOG",$msg."s [WARNING Exit Code 256, EPERM /* Operation not permitted */]");
}else{
 $CHECK_error="FAILED (exit code $system_error)";
 &RUN_stats("NOT_RUN");
 return "FAIL";
};
#
$LAST_COMPLETED_RUN=$dir_name;
return "OK";
}
#
sub RUN_wait_and_kill{
#
# DS: New implementation of alarm using fork
#     This avoids leaving defunct processes and need to call KILL
#
my $pid = fork();
if ($pid) {
  #print "Forked pid $pid";
  if (eval{
    local $SIG{ALRM} = sub {
      kill KILL => -$pid;
      my $kill_cmd="pkill $testname ";
      KILL => -$pid;
      &command("$kill_cmd");
      die "TIMEOUT!\n";
    };
    alarm($run_duration);
    waitpid($pid, 0);
    alarm(0);
    return 1;
  }) {
    #print "Run completed.\n";
  } else {
    die($@) if $@ ne "TIMEOUT!\n";
    #print "Run timed out.\n";
    waitpid($pid, 0);
    #print "Child $pid after waiting .\n";
  }
} else {
  #print "Run started $command_line.\n";
  if ($unsafe_mode) {setpgrp(0,0)};
  if (not $dry_run) {&command("$command_line")};   # launch the yambo job
  #print "After run \n";
  exit;
}
}
1;
