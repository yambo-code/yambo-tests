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
sub UTILS_tests_in_the_dir{
$tests_list=" ";
my $path="@_/$input_folder";
LOOP: foreach $test ( <$path/*> ) { 
 if (index($test, ".conf")>0) {next LOOP};
 if (index($test, ".actions")>0) {next LOOP};
 if (index($test, ".input")>0) {next LOOP};
 if (index($test, ".flags")>0) {next LOOP};
 my $name = substr($test,length($path)+1,length($test)) ;
 $tests_list="$tests_list $name";
}
}
sub UTILS_get_inputs_tests_list{
#
if ($reduced_log) {&MY_PRINT($stdout, "\n$double_line\n")};
#
undef $input_tests;
undef $alltests;
#
if($user_tests){
 #
 # Parse the $input_tests string (--tests " M x y; M x y ")
 # Sort into @input_tests_list[] array:
 # $input_tests_list[0] = "Al111/GW 00_init 01_init" $dir $testname
 # $input_tests_list[1] = "Si_bulk 00_init 01_init"
 $input_tests=$user_tests;
 # If I find SAVE and $input_folder, treat as a working test dir.
 # Could also exclude BROKEN/HARD here.
 if($input_tests eq "all"){
  find(\&testdirs, "./tests");
  sub testdirs {
   my $fullpath = $File::Find::name;
   if($fullpath =~ m|INPUTS$|){    # The only folder ending ../$input_folder
    if ( -d "SAVE" || -d "SAVE_backup"){		      # Check ./SAVE also present
     $testdir = substr($fullpath,8,-7); 
     $alltests .= "$testdir all; ";
    }
   }
  }
  $input_tests = $alltests;
  &MY_PRINT($stdout, " -     Test selection : full suite");
 } 
 else {
  &MY_PRINT($stdout, " -     Test selection : from input");
 }
}
if($theme){
 open(THEME,"<","THEMES/$theme") or die "Error opening theme file THEMES/$theme\n";
  while($theme_line = <THEME>) {
   chomp $theme_line;
   $input_tests .= $theme_line."; ";
 }
 &MY_PRINT($stdout,        " -     Test selection : from theme file $theme");
}
@dummy= split(/\s*;\s*/, $input_tests);  # split 0+ spaces before/after
&CWD_save;
chdir("$suite_dir/tests");
@input_tests_list=" ";
my $ic=-1;
foreach my $lline (@dummy) {
 $ic++;
 @inputs = split(/\s+/,$lline);  # Split 1 or more spaces
 $dir = shift(@inputs);             # Directory Al111
 &UTILS_tests_in_the_dir("$dir");
 my @files = split(/\s+/,$tests_list);
 $input_tests_list[$ic]=$dir;
 if($#inputs lt 0) { @inputs = qw("all")};   # If explicit tests omitted, set all of them
 foreach $testname (@inputs) {
  if ($testname =~ "all") {
   &UTILS_tests_in_the_dir("$dir");
   $input_tests_list[$ic]="$input_tests_list[$ic] $tests_list";
  }  
  else{  
   if ($testname =~ /\*/) { 
    $testname=~ s/\*//;
    foreach $file (@files ) { 
     if  ($file =~ /$testname/ ){
      $input_tests_list[$ic]="$input_tests_list[$ic] $file";
     }
    }
   }else{
    $input_tests_list[$ic]="$input_tests_list[$ic] $testname";
   }  
  }  
 }
}
&CWD_go;
}
1;
