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
sub UTILS_INPUT_folder{
$input_folder = "INPUTS";
my $prefix="";
if (@_) {$prefix="@_/"};
if ($branch_key and -d "${prefix}INPUTS_$branch_key"){ $input_folder = "INPUTS_$branch_key"}
if ($is_GPL and -d "${prefix}INPUTS_master_gpl"){ $input_folder = "INPUTS_master_gpl"}
$REF_prefix   = "";
if ($mode eq "bench") {
 $in_dir_cmd_line = "-I ../ -O .";
 $REF_prefix   = "../";
}
}
#
sub UTILS_tests_in_the_dir{
my ($dir, $in) = @_;
&UTILS_INPUT_folder("$dir");
if ( $in ) {$input_folder="$in"};
my $path="$dir/$input_folder";
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
 #
 if(index($user_tests,"0") ne -1 || index($user_tests,";") ne -1){
  &MY_PRINT($stdout, " -     Test selection : from input files/folders");
  $input_tests = $user_tests;
 } 
 else{
  if($user_tests ne "all"){
   &MY_PRINT($stdout, " -     Test selection : from input path");
   $TESTS_folder_scan = "$TESTS_folder/$user_tests";
  }
  elsif($user_tests eq "all"){
   &MY_PRINT($stdout, " -     Test selection : full suite");
   $TESTS_folder_scan = $TESTS_folder;
  }
  # If I find SAVE and $input_folder, treat as a working test dir.
  # Could also exclude BROKEN/HARD here.
  find(\&testdirs, "./$TESTS_folder_scan");
  sub testdirs {
   my $fullpath = $File::Find::name;
   if($fullpath =~ m|INPUTS$| and not $fullpath =~ /ROBOT/){    # The only folder ending ../$input_folder
    if ( -d "SAVE" || -d "SAVE_backup"){		      # Check ./SAVE also present
     if ($mode eq "tests") {$testdir = substr($fullpath,13,-7)}; 
     if ($mode eq "validate") {$testdir = substr($fullpath,17,-7)}; 
     if ($mode eq "cheers") {$testdir = substr($fullpath,15,-7)}; 
     if ($mode eq "bench") {$testdir = substr($fullpath,19,-7)}; 
     $alltests .= "$testdir ";
    }
   }
  }
  #
  # Order alphabetically
  my @list = split(/ /,$alltests);
  my @sorted_list = sort { lc($a) cmp lc($b) } @list;
  undef $input_tests;
  foreach my $element (@sorted_list) {$input_tests .= "$element all; "};
 }
}else{
 &MY_PRINT($stdout, " -     Test selection : (none)");
}
@dummy= split(/\s*;\s*/, $input_tests);  # split 0+ spaces before/after
&CWD_save;
chdir("$suite_dir/$TESTS_folder");
@input_tests_list=" ";
my $ic=-1;
foreach my $lline (@dummy) {
 $ic++;
 @inputs = split(/\s+/,$lline);  # Split 1 or more spaces
 my $dir = shift(@inputs);             # Directory Al111
 #
 $input_tests_list[$ic]=$dir;
 #
 $tests_list=" ";
 if ($branch_key) {
  &UTILS_tests_in_the_dir("$dir","INPUTS");
 }
 my $list1="$tests_list";
 $tests_list=" ";
 &UTILS_tests_in_the_dir("$dir");
 my $list2="$tests_list";
 my @tests = split(/\s+/,$list1);
 for my $el (@tests) 
 {
  if (not $list2 =~ /\Q$el\E/) {$list2="$list2 $el"};
 }
 #
 if($#inputs lt 0) { @inputs = qw("all")};   # If explicit tests omitted, set all of them
 foreach $testname (@inputs) {
  if ($testname =~ "all") {
   $input_tests_list[$ic]="$input_tests_list[$ic] $list2";
  }  
  else{  
   if ($testname =~ /\*/) { 
    $testname=~ s/\*//;
    my @tests = split(/\s+/,$list2);
    foreach $file (@tests ) { 
     if  ($file =~ /$testname/ ){
      $input_tests_list[$ic]="$input_tests_list[$ic] $file";
     }
    }
   }else{
    my $childs=&UTILS_gimme_childs("$dir","$testname");
    $input_tests_list[$ic]="$input_tests_list[$ic] $testname $childs";
   }  
  }  
 }
}
&CWD_go;
}
1;
