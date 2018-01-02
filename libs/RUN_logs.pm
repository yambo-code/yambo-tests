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
sub RUN_logs{
#
$extension=$branch.'-'.$BUILD.'-'.$FC_kind.'-'.$PAR_string;
$tests_log="LOG-";
if ($mode eq "bench") {$tests_log="LOG-BENCH-"};
$tests_log="$tests_log"."$ROBOT_string"."-"."$date_$time_$extension.log";
#
open($tlog, '>>', $tests_log) or die "Could not open file '$tests_log' $!";
#
# Summary of requested options
&MESSAGE("LOG","\n$line");
&MESSAGE("LOG","\n= Yambo test suite log");
&MESSAGE("LOG","\n$line");
#
&UTILS_title($tlog);
&MY_PRINT($stdout, "\n");
#
}
1;
