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
sub RUN_global_report{
#
my $what = shift;
#
# RLOG:		Global Report
#
if ("$what" eq "INIT") {
 $global_report = "REPORT-$date"."_"."$time.log";
 $tests_error = "ERROR-$date"."_"."$time.log";
 $whitelist = "WHITELIST-$date"."_"."$time.log";
 open($rlog, '>', $global_report) or die "Could not open file '$global_report' $!";
 open($elog, '>', $tests_error) or die "Could not open file '$tests_error' $!";
 open($wlog, '>', $whitelist) or die "Could not open file '$whitelist' $!";
 &MESSAGE("REPORT ERROR WHITE","\n$wiggly_line");
 &MESSAGE("REPORT","\n% Yambo test suite global REPORT");
 &MESSAGE("WHITE" ,"\n% Yambo test suite WHITELISTEd files log");
 &MESSAGE("ERROR" ,"\n% Yambo test suite ERRORs log");
 &MESSAGE("REPORT ERROR WHITE","\n$wiggly_line");
 $INITIAL_time   = [gettimeofday];
 $REFERENCE_time = [gettimeofday];
 print $REFERENCE_time;
}elsif ("$what" eq "TITLE"){
 &RUN_setup("INIT");
 &UTILS_time($date_now,$time_now);
 &MESSAGE("REPORT ERROR WHITE","\n$double_line");
 &MESSAGE("REPORT ERROR WHITE","\nRunning tests           :$user_tests");
 &MESSAGE("REPORT ERROR WHITE","\nProjects                :$project");
 &MESSAGE("REPORT ERROR WHITE","\nDate - Time             :$date_now - $time_now");
 if ($select_conf_file) {&MESSAGE("REPORT ERROR WHITE","\nCompilation Scheme      :$select_conf_file")};
 &MESSAGE("REPORT ERROR WHITE","\nBuild                   :$branch_key - $BUILD - rev.$REVISION");
 &MESSAGE("REPORT ERROR WHITE","\nParallel Conf           :$cpu_global_conf - $PAR_mode");
 &MESSAGE("REPORT ERROR WHITE","\n$line");
}elsif ("$what" eq "RUNTIME"){
 $NEW_time  = [gettimeofday]; 
 my $TT = tv_interval($REFERENCE_time, $NEW_time);
 my $h = 0;
 if ($TT > 3600) {$h=int($TT/3600)};
 $TT=$TT-$h*3600;
 my $m = 0;
 if ($TT > 60) {$m=int($TT/60)};
 $TT=$TT-$m*60;
 my $s = &ceil($TT);
 my $date_now;
 my $time_now;
 $REFERENCE_time=$NEW_time;
 &MESSAGE("ERROR WHITE REPORT","\n% Section Duration : $h:$m:$s ".("%") x ($left_length+4));
}elsif ("$what" eq "FINAL"){
 $NEW_time  = [gettimeofday]; 
 my $TT = tv_interval($INITIAL_time, $NEW_time);
 my $h = 0;
 if ($TT > 3600) {$h=int($TT/3600)};
 $TT=$TT-$h*3600;
 my $m = 0;
 if ($TT > 60) {$m=int($TT/60)};
 $TT=$TT-$m*60;
 my $s = &ceil($TT);
 my $date_now;
 my $time_now;
 &MESSAGE("ERROR WHITE REPORT","\n% TOTAL   Duration : $h:$m:$s ".("%") x ($left_length+4));
}
}
sub ceil {
        my ($num) = @_;
        return int($num) + ($num > int($num));
}
1;
