#!/usr/bin/perl
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
sub RUN_wait_and_kill{
#
# DS: New implementation of alarm using fork
#     This avoids leaving defunct processes and need to call KILL
my $pid = fork();
if ($pid) {
  if (eval{
    local $SIG{ALRM} = sub {
      kill KILL => -$pid;
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
  if (not $safe_mode) {setpgrp(0,0)};
  if (not $dry_run) {&command("$command_line")};   # launch the yambo job
  #print "After run \n";
  exit;
}
}
#
sub RUN_wait_and_kill_TIME_out{
use Time::Out qw(timeout) ;
timeout $run_duration => sub{
 $system_error=system($command_line)
};
if ($@){
 print "$INPUT_file timed-out\n";
}
}
1;
