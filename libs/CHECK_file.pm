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
sub CHECK_file{
$system_command = "$suite_dir/scripts/find_the_diff/$find_the_diff -r $ref_filename -o $run_filename -p $prec -m $material -c $FC_kind";
if($verb) {
  $system_command = "$system_command -v";
  &MY_PRINT($stdout, "Running floating point test: $system_command \n\n");
}
if(     $verb) { $CHECK_error = `$system_command 2>> find_the_diff.log`; }
if( not $verb) { $CHECK_error = `$system_command 2>&1`; }
chomp($CHECK_error);
if($CHECK_error =~ /OK/) {
 my $msg = sprintf("%-"."$left_length"."s", "  $run_filename");
 &MESSAGE("LOG","\n"."$msg"."[$g_s  OK  $g_e]");
 &RUN_stats("OK");
 return "OK";
} else {
 &RUN_stats("ERR_OUT");
 return "FAIL";
}
}
1;
