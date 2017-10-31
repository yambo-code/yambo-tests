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
sub RUN_it{
#
# Report the input file
if($verb ge 2) { &PRINT_input };
#
# CMD line
if ($np==1 or $MPI_CPU_conf[1] eq "serial") {
 $command_line = "$yambo_exec -F yambo.in -J $flags $in_dir_cmd_line $force_serial $log";
}else{
 $command_line = "$mpiexec -np $np $yambo_exec -F yambo.in -J $flags $in_dir_cmd_line  $force_serial $CPU_flag $log";
}
#
# *** RUN ***
$test_start = [gettimeofday];
eval { 
 local $SIG{ALRM} = sub { die "alarm\n" };
 alarm $run_duration;         # schedule alarm 
 if (not $dry_run) {&command("$command_line")};   # launch the yambo job
 alarm 0;                     # cancel the alarm
};
if ($@) {
 die unless $@ eq "alarm\n"; # propagate unexpected errors
}
#
# Clean the RUN
&KILL("$yambo_exec","$ROBOT_string");
#
# Clock update
$test_end   = [gettimeofday]; 
$elapsed = tv_interval($test_start, $test_end);
#
# Check if a wrong CPU conf has been used...
#
$CHECK_error="";
undef  $wrong_cpu_conf;
undef  $empty_worload;
LOG_LOOP: {
 foreach $file (<LOG/l-*>) {
  open $fh, $file or die;
  while (my $line = <$fh>) {
   if ($line =~ /Empty workload/ || $line =~ /n_t_CPU > n_blocks/) { 
    if ($verb) {&MESSAGE("LOG"," Empty workload for some CPU")};
    $empty_worload = 1;
    last LOG_LOOP;
   }
   if ($line =~ /USER parallel structure does not fit the current run parameters/) { 
    $wrong_cpu_conf = 1;
    last LOG_LOOP;
   }
  }
 }
}
#
# Final Report
#
if($empty_workload){
 &MESSAGE("LOG","[WARN: EMPTY workload]");
 return "OK";
}
if($wrong_cpu_conf){
 $CHECK_error="WRONG CPU configuration";
 &RUN_stats("WRONG_CPU_CONF");
 return "FAIL";
}
#
if ($system_error == 0) {
 if ($elapsed > $run_duration) {
  $CHECK_error="FAILED (Runtime above $run_duration secs.)";
  &RUN_stats("NOT_RUN");
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
