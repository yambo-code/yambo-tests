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
sub RUN_it{
#
# Report the input file
if($verb ge 2) { &PRINT_input };
#
my $CPU_cmd= " ";
if ($yambo_running) {$CPU_cmd=$CPU_flag};
#
# CMD line
if ($np==1 or $MPI_CPU_conf[1] eq "serial") {
 $command_line = "$nice $yambo_exec -F $INPUT_file $flags $in_dir_cmd_line $force_serial $log";
}else{
 $command_line = "$nice $mpiexec -np $np $yambo_exec -F $INPUT_file $flags $in_dir_cmd_line $force_serial $CPU_cmd $log";
}
#
# *** RUN ***
$test_start = [gettimeofday];
#
# DS: New implementation of alarm using form
#     This avoids leving defunct processes and need to call KILL
#
$pid = fork;
#
if ($pid > 0){
  eval{
    local $SIG{ALRM} = sub {kill 9, -$pid;};
    alarm $run_duration;
    waitpid($pid, 0);
    alarm 0;
  };
}
elsif ($pid == 0){
    setpgrp(0,0);
    if (not $dry_run) {&command("$command_line")};   # launch the yambo job
    exit(0);
}
if ($@) {
 die unless $@ eq "alarm\n"; # propagate unexpected errors
}
#
# Clock update
$test_end   = [gettimeofday]; 
$elapsed = tv_interval($test_start, $test_end);
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
   if ($line =~ /USER parallel structure does not fit the current run parameters/) { 
    $wrong_cpu_conf = 1;
   }
  }
 }
}
#
# Final Report
#
if($wrong_cpu_conf){
 if( $N_random_tries < 10){ $CHECK_error="WRONG CPU configuration"; &RUN_stats("WRONG_CPU_CONF"); }
 if( $N_random_tries== 10){ $CHECK_error="FAILED CPU configuration"; &RUN_stats("ERROR_CPU_CONF"); }
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
}else{
 $CHECK_error="FAILED (exit code $system_error)";
 &RUN_stats("NOT_RUN");
 return "FAIL";
};
#
$LAST_COMPLETED_RUN=$dir_name;
return "OK";
}
1;
