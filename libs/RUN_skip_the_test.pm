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
sub RUN_skip_the_test{
$message="OK";
$CHECK_error=" ";
#
if ( "@_" eq "DIR" ){
 #
 # Projects
 #
 $ANY=&ANY_project;
 if ($project eq "nopj" ) {
  if ( $ANY eq "YES" ) {$message=" skipped (PJ-restricted)"};
 } elsif ($project ne "all") {
  if (-e "PL" && $project !~ /pl/) { $message=" skipped (wrong PJ)"};
  if (-e "NL" && $project !~ /nl/) {$message=" skipped (wrong PJ)"};
  if (-e "NL" && $Yambo_precision !~ /double/) {$message=" skipped (yambo SP compile)"};
  if (-e "NL" && not $do_NL_tests ) {$message=" skipped (wrong BRANCH)"};
  if (-e "QED" && $project !~ /qed/) {$message=" skipped (wrong PJ)"};
  if (-e "RT" && $project !~ /rt/) {$message=" skipped (wrong PJ)"};
  if (-e "ELPH" && $project !~ /elph/) {$message=" skipped (wrong PJ)"};
  if (-e "SC" && $project !~ /sc/) {$message=" skipped (wrong PJ)"};
  if (-e "MAGNETIC" && $project !~ /magnetic/) {$message=" skipped (wrong PJ)"};
  if (-e "KERR" && $project !~ /kerr/) {$message=" skipped (wrong PJ)"};
  if (-e "P2Y" && $project !~ /p2y/) {$message=" skipped (wrong PJ)"};
  if (-e "A2Y" && $project !~ /a2y/) {$message=" skipped (wrong PJ)"};
  if (-e "A2Y" && not $do_A2Y_tests) {$message=" skipped (wrong BRANCH)"};
  if ( $ANY eq "NO" and $project !~ /nopj/) {$message=" skipped (running only $project tests)"};
  #
 }
 if ($is_GPL) {
  if (( -e "SC" or -e "MAGNETIC" or -e "QED" or -e "PL" or -e "NO_GPL") ) {$message=" skipped (GPL-PJ-restricted)"};
 }
 if (!-e "SAVE/ns.db1" and !-e "SAVE_backup/ns.db1" and not (-e "P2Y" or -e "A2Y")) { $message=" skipped (missing CORE databases)"};
 if (-e "BROKEN" and ! $force) {$message=" (broken)"};
 if (-e "PARALLEL_2" && $np>2   ) {$message=" skipped (Too many CPUs)"};
 if (-e "PARALLEL_4" && $np>4   ) {$message=" skipped (Too many CPUs)"};
 if (-e "PARALLEL_8" && $np>8   ) {$message=" skipped (Too many CPUs)"};
 if (-e "PARALLEL_16" && $np>16 ) {$message=" skipped (Too many CPUs)"};
 if (-e "THREADS_8"   && $nt>8  ) {$message=" skipped (Too many Threads)"};
 if (-e "HARD" and $project !~ /hard/) {$message= " skipped (H)"};
}
#
if ( "@_" eq "INPUT") {
 #
 # EXE
 #
 if(! $yambo_exec eq ''){
  my @exe= split(/\s+/,$yambo_exec);  # Split 1 or more spaces
  if(! -x "@exe[0]"){ 
   $CHECK_error = " skipped (missing @exe[0])";
   &RUN_stats("SKIPPED");
   return "FAIL";
  }
 }
 #
 # SLEPC tests only if SLEPC is linked
 if ($testname =~ m/SLEPC/ && not $BUILD =~ /SLEPC/) { 
  my $msg = sprintf("%-"."$left_length"."s", "$testname");
  $CHECK_error= $msg." skipped (SLEPC test but SLEPC is not linked)";
  &RUN_stats("SKIPPED");
  return "FAIL";
 };
 #
 # p2y HDF5 tests only if p2y compiled with HDF5 support
 if ($testname =~ m/HDF5/ && not $BUILD =~ /HDF5/) { 
  my $msg = sprintf("%-"."$left_length"."s", "$testname");
  $CHECK_error= $msg." skipped (p2y HDF5 test but HDF5 is not linked)";
  &RUN_stats("SKIPPED");
  return "FAIL";
 };
 #
 # Tests with Covariant dipoles are broken in parallel
 if ($testname =~ m/Covariant/ && $np>1 && $PAR_covariant eq "no") { 
  my $msg = sprintf("%-"."$left_length"."s", "$testname");
  $CHECK_error= $msg." skipped (Covariant test not working in parallel)";
  &RUN_stats("SKIPPED");
  return "FAIL";
 };
 #
 # Magnetic Tests are broken in parallel
 if ($testdir =~ m/MAGNETIC/ && $np>1) { 
  my $msg = sprintf("%-"."$left_length"."s", "$testname");
  $CHECK_error= $msg." skipped (MAGNETIC tests not working in parallel)";
  &RUN_stats("SKIPPED");
  return "FAIL";
 };
 #
 # Features
 #
 if (not $features[0] eq "all"){
  $found=&RUN_feature("setup");
  if ($found eq "1" ) {return "OK"};
  LOOP: for (my $if=0; $if<=$#features ; $if++){
   if ($features[$if] eq "hf"){
    $found=&RUN_feature("HF_and_locXC");
   }
   if ($features[$if] eq "rpa"){
    $found=&RUN_feature("optics");
    if ($found eq "YES") {$found=&RUN_feature("chi")};
   }
   if ($features[$if] eq "gw"){
    $found=&RUN_feature("gw");
   }
   if ($features[$if] eq "bse"){
    $found=&RUN_feature("bse em1s");
   }
   if ($found eq "0") { 
    my $msg = sprintf("%-"."$left_length"."s", "$testname");
    $CHECK_error = $msg." skipped (no keyword $features[$if] (or related) found)";
    &RUN_stats("SKIPPED");
    $CHECK_error="";
    return "FAIL";
   }
  }
 }
 #
}
#
if ( "@_" eq "PAR_CONF") {
 if ($Nr eq 0) { 
  my $msg = sprintf("%-"."$left_length"."s", "$testname");
  $CHECK_error= $msg." skipped (unable to define parallel configuration)";
  &RUN_stats("ERROR_CPU_CONF");
  return "NO_PAR_CONF";
 };
}
#
if ("$message" !~ "OK"){
 $CHECK_error="$message";
 &RUN_stats("DIR_SKIPPED");
 return "DIR_SKIPPED";
}
return "OK";
#
}
sub ANY_project{
 if (-e "KERR" or -e "RT" or -e "ELPH" or -e "SC" or -e "MAGNETIC" or -e "QED" or -e "PL" or -e "NL" or -e "P2Y" or -e "A2Y" )  {
  return "YES";
 }else{
  return "NO";
 }
}
1;
