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
sub FLOW_load
{
 for $field ( keys %{ $flow[$i] } ) {
  if ( "$field" eq "BRANCH"  ) {$flow_branch = $flow[$i]{$field}};
  if ( "$field" eq "CONFIG"  ) {$select_conf_file = $flow[$i]{$field}};
  if ( "$field" eq "ACTIVE"  ) {$active = $flow[$i]{$field}};
  if ( "$field" eq "MPI_CPU" ) {$np_single = $flow[$i]{$field}};
  if ( "$field" eq "SLK_CPU" ) {$nl = $flow[$i]{$field}};
  if ( "$field" eq "THREADS" ) {$nt = $flow[$i]{$field}};
  if ( "$field" eq "TESTS"   ) {$user_tests = $flow[$i]{$field}};
  if ( "$field" eq "KEYS"    ) {$keys = $flow[$i]{$field}};
  if ( "$field" eq "PAR_MODE") {$par_mode = $flow[$i]{$field}};
  if ( "$field" eq "CPU_CONF") {$cpu_conf_file = $flow[$i]{$field}};
 }
 if ($flow_branch) {
  undef @branches;
  ($branches[0],$branch_identity[0]) = split(/ /, $flow_branch);
 };
 if (not "$select_conf_file" eq "") {$compile="yes"};
 if ($np_single>1) { 
  if ( "$par_mode" eq "default" ) {
   $default_parallel="yes"
  }elsif( "$par_mode" eq "random" ) {
   $random_parallel="yes"
  }
 }
 if ($cpu_conf_file) 
 {
 }
 return "OK";
}
sub FLOW_init
{
 my $FLOW_file;
 if (-e "ROBOTS/$host/$user/FLOWS/@_.pl") {
  $FLOW_file="ROBOTS/$host/$user/FLOWS/@_.pl";
 }elsif (-e "ROBOTS/$host/$user/FLOWS/@_") {
  $FLOW_file="ROBOTS/$host/$user/FLOWS/@_";
 }else{
  return "NOT_FOUND";
 }
 do "$FLOW_file";
 if ($#flow<0) {return "FAIL"};
 return "OK";
}
sub FLOW_reset
{
if ("@_" eq "ALL") {
 $user_tests="all";
 undef $flow_branch;
 undef $keys;
 undef $compile;
 undef $select_conf_file;
 $active="no";
}
undef $openmp_is_off;
undef $np_min;
undef $np_max;
undef $np_single;
undef $nt;
undef $nl;
undef $cpu_conf_file;
$par_mode="";
undef $default_parallel;
undef $random_parallel;
}
1;
