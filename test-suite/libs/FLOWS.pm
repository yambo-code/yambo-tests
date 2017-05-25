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
sub FLOW_load
{
 for $field ( keys %{ $flow[$i] } ) {
  if ( "$field" eq "BRANCH"  ) {$user_branch = $flow[$i]{$field}};
  if ( "$field" eq "CONFIG"  ) {$select_conf_file = $flow[$i]{$field}};
  if ( "$field" eq "ACTIVE"  ) {$active = $flow[$i]{$field}};
  if ( "$field" eq "MPI_CPU" ) {$np_single = $flow[$i]{$field}};
  if ( "$field" eq "SLK_CPU" ) {$nl = $flow[$i]{$field}};
  if ( "$field" eq "THREADS" ) {$nt = $flow[$i]{$field}};
  if ( "$field" eq "TESTS"   ) {$user_tests = $flow[$i]{$field}};
  if ( "$field" eq "KEYS"    ) {$keys = $flow[$i]{$field}};
  if ( "$field" eq "PAR_MODE") {$par_mode = $flow[$i]{$field}};
 }
 if ($user_branch) {
  undef @branches;
  $branches[0]=$user_branch;
 };
 if (not "$select_conf_file" eq "") {$compile="yes"};
 if ($np_single>1) { 
  if ( "$par_mode" eq "default" ) {
   $default_parallel="yes"
  }elsif( "$par_mode" eq "random" ) {
   $random_parallel="yes"
  }
 }
 #
 return "OK";
}
sub FLOW_init
{
 if (-e "ROBOTS/$host/FLOWS/@_.pl") {
  do "ROBOTS/$host/FLOWS/@_.pl";
  if ($#flow<0) {return "FAIL"};
   return "OK";
 }else{
  return "FAIL";
 }
}
sub FLOW_reset
{
if ("@_" eq "ALL") {
 $user_tests="all";
 undef $user_branch;
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
$par_mode="";
undef $default_parallel;
undef $random_parallel;
}
1;
