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
sub RUN_stats{
#
if ("@_" eq "INIT"){
 $test_skipped=0;
 $run_with_failures=0;
 $test_failed=0;
 $test_ok=0;
 $test_not_run=0;
 $missing_db=0;
 $wrong_out=0;
 $ref_not_found=0;
 $out_not_found=0;
 $dir_failed=0;
 $dir_ok=0;
 $whitelist_err=0;
 return;
}
if ("@_" eq "INIT_DIR"){
 $dir_failed=0;
 $dir_ok=0;
 return;
}
if ("@_" eq "REPORT"){
 &MESSAGE("LOG","\n$line");
 my $MSG="\n$r_s"."Tests: FAIL[$run_with_failures"."] ";
 $MSG=$MSG." Checks: FAIL[$test_failed"."] OK[$test_ok"."] NOT RUN [$test_not_run"."] SKIPPED [$test_skipped"."] WHITELISTED [$whitelist_err] $r_e";
 &MESSAGE("LOG","$MSG");
 &MESSAGE("LOG","\n$line");
 $MSG="\nOutputs: FAIL[$wrong_out"."] no REFs[$ref_not_found"."] no OUTs[$out_not_found"."]";
 $MSG=$MSG." DBs: MISSING[$missing_db"."]\n\n";
 &MESSAGE("LOG","$MSG");
 #
 # REPORT
 #
 &MESSAGE("REPORT","\nRUNS_FAIL: $run_with_failures => CHECKS_FAIL: $test_failed & NO RUN: $test_not_run & SKIPS: $test_skipped % WHITELIST: $whitelist_err % OKs: $test_ok");
 if ($test_failed>0) {
  &MESSAGE("REPORT","\nCHECK details:");
  if ($wrong_out>0) {&MESSAGE("REPORT"," $wrong_out wrong output %")};
  if ($ref_not_found>0) {&MESSAGE("REPORT"," $ref_not_found no reference %")};
  if ($out_not_found>0) {&MESSAGE("REPORT"," $out_not_found no output %")};
  if ($missing_db>0) {&MESSAGE("REPORT"," $missing_db no DB")};
 }
 &MESSAGE("REPORT","\n$line");
 return;
}
#
my $err_msg=$testdir."/".$dir_name."  :";
#
if ("@_" eq "ERR_OUT"){
 my $msg = sprintf("%-"."$left_length"."s", "  $run_filename");
 $err_msg=$testdir."/".$dir_name."/".$run_filename."  :";
 if ($CHECK_error =~ /WHITELISTED/) {
  &MESSAGE("LOG","\n"."$msg"."[$r_s WHITELISTED $r_e]");
  if (not $update_test) {$CHECK_error =~ s/\[\>WHITELISTED\<\]/ /};
  &MESSAGE("WHITE","\n"."$err_msg"."$r_s $CHECK_error   $r_e");
  $whitelist_err++;
 }else{
  &MESSAGE("LOG","\n"."$msg"."[$r_s $CHECK_error   $r_e]");
  &MESSAGE("ERROR","\n"."$err_msg"."$r_s $CHECK_error   $r_e");
  $wrong_out++;
  &its_a_fail();
 }
};
if ("@_" eq "ERR_DB"){
 $missing_db++;
 &its_a_fail();
};
if ("@_" eq "NO_REF"){
 my $msg = sprintf("%-"."$left_length"."s", "  $run_filename");
 &MESSAGE("LOG","\n"."$msg"."[$r_s  NO in REFERENCE(s)  $r_e]");
 &MESSAGE("ERROR","\n"."$err_msg"."$r_s  NO $run_filename in REFERENCE(s)  $r_e");
 $ref_not_found++;
 &its_a_fail();
};
if ("@_" eq "NO_OUT"){
 my $msg = sprintf("%-"."$left_length"."s", "  $ref_filename");
 &MESSAGE("LOG","\n"."$msg"."[$r_s  NO in OUTPUT $r_e]");
 &MESSAGE("ERROR","\n"."$err_msg"."$r_s  NO $ref_filename in OUTPUT $r_e");
 $out_not_found++;
 &its_a_fail();
};
if ("@_" eq "DIR_SKIPPED"){
 &MESSAGE("LOG","\n$CHECK_error") if ($verb);
};
if ("@_" eq "NOT_RUN"){
 $test_not_run++;
 &MESSAGE("ERROR","\n"."$err_msg"." $CHECK_error");
 my $msg = sprintf("%-10s", $cpu_conf."] ".$testname);
 &MESSAGE("LOG","\n"."$msg"." $CHECK_error");
 &its_a_fail();
};
if ("@_" eq "SKIPPED"){
 $test_skipped++;
 &MESSAGE("LOG","\n[$r_s $CHECK_error  $r_e]");
};
if ("@_" eq "WRONG_DEP"){
 $test_skipped++;
 &MESSAGE("LOG","[$r_s $CHECK_error  $r_e]");
};
if ("@_" eq "OK"){
 $RUN_result="OK";
 $test_ok++;
 $dir_ok++;
}
}
sub its_a_fail{
 $RUN_result="FAIL";
 $test_failed++;
 $dir_failed++;
 if ($first_in_the_run) {
  $run_with_failures++; 
  undef $first_in_the_run;
  if (!$FAILED_test) {
   &MESSAGE("FAILED","$TESTS_folder/$testdir/$ROBOT_wd\n");
   $FAILED_test="1";
  }
 };
}
1;
