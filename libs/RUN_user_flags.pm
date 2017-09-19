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
sub RUN_user_flags{
my ($ir) = @_;
$flags = "";
undef $found;
if( -e "$input_folder/$testname.flags") {
 &MY_PRINT($stdout, "$input_folder/$testname.flags\n") if ($verb);
 open(FLAGS,"<","$input_folder/$testname.flags");
 @flags_file = <FLAGS>;
 while($extra_flag = shift(@flags_file)) {
  $extra_flag =~ s/^\s+|\s+$//g ;
  chomp $extra_flag;  
  #
  my $extra_flag_check=&test_dir_name($extra_flag,$ir);
  if( -d "$extra_flag_check") {
   $flags = $flags.",$extra_flag_check" ;
   $found=1;
   if (&CHECK_the_error_list("$extra_flag_check") !~ "OK") { return "FAIL"};
   next ;
  };
  #
  my $extra_flag_check=&test_dir_name($extra_flag,1);
  if( -d "$extra_flag_check") {
   $flags = $flags.",$extra_flag_check" ;
   $found=1;
   if (&CHECK_the_error_list("$extra_flag_check") !~ "OK") { return "FAIL"};
   next ;
  };
  #
  my $extra_flag_check = $extra_flag;
  if( -d "$extra_flag_check") {
   $flags = $flags.",$extra_flag_check" ;
   $found=1;
   if (&CHECK_the_error_list("$extra_flag_check") !~ "OK") { return "FAIL"};
   next ;
  };
 }
 close(FLAGS);
 if (not $found) { return "FAIL" };
}
$flags = '"' . "$testname$flags" . '"';
&MY_PRINT($stdout, "FLAGS: $flags\n") if ($verb);
return "OK";
}
sub CHECK_the_error_list{
 #
 # Check if the run that is called via the flags has been or not labelled as FAILED
 #
 foreach my $line (@ERROR_entries) {
  if ($line =~ /@_[0]/ and $line =~ /FAILED/) {
   return "FAIL";
  }
  if ($line =~ /@_[0]/ and $line =~ /NO/ and $line =~ /in OUTPUT/) {
   return "FAIL";
  }
 }
 return "OK";
}
1;
