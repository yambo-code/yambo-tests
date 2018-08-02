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
 $test_with_fails=0;
 $test_ok=0;
 $test_skipped=0;
 $test_silent=0;
 #
 # Reason of the test fail/skip
 #
 $test_skipped_setup=0;
 $test_skipped_cpuconf=0;
 $test_not_run=0;
 $test_runtime=0;
 $test_wrong=0;
 #
 # Single check for eack test
 #
 $check_failed=0;
 $check_ok=0;
 $check_whitelisted=0;
 $check_rules_ok=0;
 #
 # Reason of the check fail
 #
 $missing_db=0;
 $wrong_out=0;
 $ref_not_found=0;
 $out_not_found=0;
 #
 $dir_failed=0;
 $dir_ok=0;
 #
 #$init_start_time = [gettimeofday];
 #
 return;
}
if ("@_" eq "INIT_DIR"){
 $dir_failed=0;
 $dir_ok=0;
 $dir_start_time = [gettimeofday];
 return;
}
if ("@_" eq "REPORT"){
 #
 $test_sum=$test_ok+$test_silent;
 #
 &MESSAGE("LOG","\n$line");
 my $MSG="\n$r_s"."Tests: FAIL[$test_with_fails"."] SUCCESSFUL[$test_sum"."] SKIPS[$test_skipped"."] (SETUP[$test_skipped_setup] CPU-CONF[$test_skipped_cpuconf]) $r_e";
 &MESSAGE("LOG","$MSG");
 $MSG="\n$r_s"."Test FAIL detail: WRONG[$test_wrong"."] NO RUN[$test_not_run"."] RUNTIME[$test_runtime] $r_e";
 &MESSAGE("LOG","$MSG");
 &MESSAGE("LOG","\n$line");
 $MSG="\n$r_s"."Checks: FAIL[$check_failed"."] SUCCESSFUL[$check_ok"."] WHITELIST[$check_whitelisted] RULES-SUCC [$check_rules_ok] $r_e";
 $MSG=$MSG."\n$r_s"."Check FAIL detail: WRONG[$wrong_out"."] no REFs[$ref_not_found"."] no OUTs[$out_not_found"."] no DB[$missing_db"."] $r_e\n";
 &MESSAGE("LOG","$MSG");
 #
 # REPORT
 #
 $MSG="\n$r_s"."Tests: $test_with_fails FAIL, $test_sum OK, $test_skipped SKIPS( $test_skipped_setup SETUP, $test_skipped_cpuconf CPU-CONF) $r_e";
 &MESSAGE("REPORT","$MSG");
 $MSG="\n$r_s"."Test FAIL detail: $test_wrong WRONG, $test_not_run NO RUN $test_runtime RUNTIME $r_e";
 &MESSAGE("REPORT","$MSG");
 &MESSAGE("REPORT","\n$line");
 #
 $MSG="\n$r_s"."Checks: $check_failed FAIL, $check_ok OK, $check_whitelisted WHITELIST $check_rules_ok RULES-SUCC $r_e";
 $MSG=$MSG."\n$r_s"."Check FAIL detail: $wrong_out WRONG, $ref_not_found no REF, $out_not_found no OUT, $missing_db no DB $r_e";
 &MESSAGE("REPORT","$MSG");
 &MESSAGE("REPORT","\n$line");
 return;
}
#
my $err_msg=$testdir."/".$dir_name."  :";
my $skip_msg=$testdir."/".$dir_name."  :";
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
 }elsif ($CHECK_error =~ /RULES-SUCC/) {
  &MESSAGE("LOG","\n"."$msg"."[$r_s RULES-SUCC $r_e]");
  if (not $update_test) {$CHECK_error =~ s/\[\>RULES-SUCC\<\]/ /};
  &MESSAGE("RULES","\n"."$err_msg"."$r_s $CHECK_error   $r_e");
  $check_rules_ok++;
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
 my $msg = sprintf("%-"."$left_length"."s", "  $run_filename");
 &MESSAGE("LOG","\n"."$msg"."[$r_s  NO in OUTPUT $r_e]");
 &MESSAGE("ERROR","\n"."$err_msg"."$r_s  NO $run_filename in OUTPUT $r_e");
 $out_not_found++;
 &its_a_fail("CHECK");
};
if ("@_" eq "SILENT"){
 $test_ok_action="SKIP";
 $test_silent++;
};
if ("@_" eq "DIR_SKIPPED"){
 $test_ok_action="SKIP";
 &MESSAGE("LOG","\n$CHECK_error") if ($verb);
};
if ("@_" eq "NOT_RUN"){
 $test_not_run++;
 &MESSAGE("ERROR","\n"."$err_msg"." $CHECK_error");
 my $msg = sprintf("%-10s", $cpu_conf."] ".$testname);
 &MESSAGE("LOG","\n"."$msg"." $CHECK_error");
 &its_a_fail("TEST");
};
if ("@_" eq "RUNTIME"){
 $test_runtime++;
 &MESSAGE("ERROR","\n"."$err_msg"." $CHECK_error");
 my $msg = sprintf("%-10s", $cpu_conf."] ".$testname);
 &MESSAGE("LOG","\n"."$msg"." $CHECK_error");
 &its_a_fail("TEST");
};
if ("@_" eq "SKIPPED"){
 $test_skipped++;
 $test_ok_action="SKIP";
 &MESSAGE("SKIP","\n"."$skip_msg"." $CHECK_error");
 &MESSAGE("LOG","\n[$r_s $CHECK_error  $r_e]");
};
if ("@_" eq "SKIPPED_CORE"){
 $test_skipped++;
 $test_skipped_setup++;
 $test_ok_action="SKIP";
};
if ("@_" eq "WRONG_CPU_CONF"){
 $test_ok_action="SKIP";
 if( $default_parallel) 
 {
   $test_skipped++;
   $test_skipped_cpuconf++;
   &MESSAGE("SKIP","\n"."$skip_msg"." $CHECK_error");
 }
 &MESSAGE("LOG"," [$r_s $CHECK_error  $r_e]");
};
if ("@_" eq "ERROR_CPU_CONF"){
 $test_skipped++;
 $test_skipped_cpuconf++;
 $test_ok_action="SKIP";
 &MESSAGE("SKIP","\n"."$skip_msg"." $CHECK_error");
 &MESSAGE("LOG"," [$r_s $CHECK_error  $r_e]");
};
if ("@_" eq "WRONG_DEP"){
 $test_skipped++;
 $test_ok_action="SKIP";
 &MESSAGE("SKIP","\n"."$skip_msg"." $CHECK_error");
 &MESSAGE("LOG","[$r_s $CHECK_error  $r_e]");
};
if ("@_" eq "OK"){
 $RUN_result="OK";
 $check_ok++;
}
if (! ("$test_ok_action" eq "SKIP") )
{ 
 if ( "$test_ok_action" eq "INCREASE" && $fails_in_the_run eq 0 ) { $test_ok++; $dir_ok++; $test_ok_action="CHECK"; };
 if ( "$test_ok_action" eq "INCREASE" && $fails_in_the_run >  0 ) {              $test_ok_action="NONE"; };
 if ( "$test_ok_action" eq "CHECK"    && $fails_in_the_run >  0 ) { $test_ok--; $dir_ok--; $test_ok_action="NONE"; };
}
}
sub its_a_fail{
 $RUN_result="FAIL";
 if ("@_" eq "CHECK"){ $check_failed++; };
 if ( $fails_in_the_run eq 0) { $test_with_fails++; $dir_failed++; };
 if ( $fails_in_the_run eq 0 && "@_" eq "CHECK") { $test_wrong++; };
 $fails_in_the_run++;
 &MESSAGE("FAILED","$TESTS_folder/$testdir/$ROBOT_wd/$dir_name\n");
}
1;
