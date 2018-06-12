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
sub RUN_stats{
#
if ("@_" eq "INIT"){
 #
 # Whole test
 #
 $test_skipped=0;
 $test_not_run=0;
 $test_with_fails=0;
 $test_ok=0;
 #
 # Single check for eack test
 #
 $check_failed=0;
 $check_ok=0;
 $check_whitelisted=0;
 #
 # Reason of the fail
 #
 $missing_db=0;
 $wrong_out=0;
 $ref_not_found=0;
 $out_not_found=0;
 #
 $dir_failed=0;
 $dir_ok=0;
 return;
}
if ("@_" eq "INIT_DIR"){
 $dir_failed=0;
 $dir_ok=0;
 return;
}
if ("@_" eq "REPORT"){
 &MESSAGE("LOG","\n$line");
 my $MSG="\n$r_s"."Tests: FAIL[$test_with_fails"."] SUCCESSFUL[$test_ok"."] NO RUN[$test_not_run"."] SKIPS[$test_skipped"."] $r_e";
 &MESSAGE("LOG","$MSG");
 &MESSAGE("LOG","\n$line");
 $MSG="\n$r_s"."Checks: FAIL[$check_failed"."] SUCCESSFUL[$check_ok"."] WHITELIST[$check_whitelisted] $r_e";
 $MSG=$MSG."\n$r_s"."Check FAIL detail: WRONG[$wrong_out"."] no REFs[$ref_not_found"."] no OUTs[$out_not_found"."] no DB[$missing_db"."] $r_e\n";
 &MESSAGE("LOG","$MSG");
 #
 # REPORT
 #
 # OLD
 #&MESSAGE("REPORT","\nRUNS_FAIL: $test_with_fails => CHECKS_FAIL: $check_failed & NO RUN: $test_not_run & SKIPS: $test_skipped % WHITELIST: $check_whitelisted % SUCCESSFUL: $check_ok");
 #
 # NEW
 $MSG="\n$r_s"."Tests: $test_with_fails FAIL, $test_ok OK, $test_not_run NO RUN, $test_skipped SKIPS $r_e";
 &MESSAGE("REPORT","$MSG");
 #
 $MSG="\n$r_s"."Checks: $check_failed FAIL, $check_ok OK, $check_whitelisted WHITELIST $r_e";
 &MESSAGE("REPORT","$MSG");
 if ($check_failed>0) {
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
if ($profile) {&MESSAGE("FAILED","$TESTS_folder/$testdir/$ROBOT_wd/$dir_name\n")};
#
if ("@_" eq "ERR_OUT"){
 my $msg = sprintf("%-"."$left_length"."s", "  $run_filename");
 $err_msg=$testdir."/".$dir_name."/".$run_filename."  :";
 if ($CHECK_error =~ /WHITELISTED/) {
  &MESSAGE("LOG","\n"."$msg"."[$r_s WHITELISTED $r_e]");
  if (not $update_test) {$CHECK_error =~ s/\[\>WHITELISTED\<\]/ /};
  &MESSAGE("WHITE","\n"."$err_msg"."$r_s $CHECK_error   $r_e");
  $check_whitelisted++;
 }else{
  &MESSAGE("LOG","\n"."$msg"."[$r_s $CHECK_error   $r_e]");
  &MESSAGE("ERROR","\n"."$err_msg"."$r_s $CHECK_error   $r_e");
  $wrong_out++;
  &its_a_fail("CHECK");
 }
};
if ("@_" eq "ERR_DB"){
 $missing_db++;
 &its_a_fail("CHECK");
};
if ("@_" eq "NO_REF"){
 my $msg = sprintf("%-"."$left_length"."s", "  $run_filename");
 &MESSAGE("LOG","\n"."$msg"."[$r_s  NO in REFERENCE(s)  $r_e]");
 &MESSAGE("ERROR","\n"."$err_msg"."$r_s  NO $run_filename in REFERENCE(s)  $r_e");
 $ref_not_found++;
 &its_a_fail("CHECK");
};
if ("@_" eq "NO_OUT"){
 my $msg = sprintf("%-"."$left_length"."s", "  $ref_filename");
 &MESSAGE("LOG","\n"."$msg"."[$r_s  NO in OUTPUT $r_e]");
 &MESSAGE("ERROR","\n"."$err_msg"."$r_s  NO $ref_filename in OUTPUT $r_e");
 $out_not_found++;
 &its_a_fail("CHECK");
};
if ("@_" eq "DIR_SKIPPED"){
 &MESSAGE("LOG","\n$CHECK_error") if ($verb);
};
if ("@_" eq "NOT_RUN"){
 $test_not_run++;
 &MESSAGE("ERROR","\n"."$err_msg"." $CHECK_error");
 my $msg = sprintf("%-10s", $cpu_conf."] ".$testname);
 &MESSAGE("LOG","\n"."$msg"." $CHECK_error");
 &its_a_fail("TEST");
};
if ("@_" eq "SKIPPED"){
 $test_skipped++;
 &MESSAGE("LOG","\n[$r_s $CHECK_error  $r_e]");
};
if ("@_" eq "WRONG_CPU_CONF"){
 &MESSAGE("LOG"," [$r_s $CHECK_error  $r_e]");
};
if ("@_" eq "WRONG_DEP"){
 $test_skipped++;
 &MESSAGE("LOG","[$r_s $CHECK_error  $r_e]");
};
if ("@_" eq "OK"){
 $RUN_result="OK";
 $check_ok++;
 $dir_ok++;
}
if ( "$test_ok_action" eq "INCREASE" && $fails_in_the_run eq 0 ) { $test_ok++;  $test_ok_action="CHECK"; };
if ( "$test_ok_action" eq "INCREASE" && $fails_in_the_run >  0 ) {              $test_ok_action="NONE"; };
if ( "$test_ok_action" eq "CHECK"    && $fails_in_the_run >  0 ) { $test_ok--;  $test_ok_action="NONE"; };
}
sub its_a_fail{
 $RUN_result="FAIL";
 if ("@_" eq "CHECK"){ $check_failed++; };
 if ( $fails_in_the_run eq 0) { $test_with_fails++; };
 $dir_failed++;
 $fails_in_the_run++;
 &MESSAGE("FAILED","$TESTS_folder/$testdir/$ROBOT_wd/$dir_name\n");
}
1;
