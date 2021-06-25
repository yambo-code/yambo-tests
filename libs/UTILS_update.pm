#!/usr/bin/perl
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
sub UTILS_update{
#
chomp($update_test);
my $TEST_todo= $update_test;
#
&RUN_global_report("INIT");
#
&FLOW_reset("ALL");
undef $compile;
$keys="all hard p2y a2y";
#
if (-d "$TESTS_folder/$TEST_todo/INPUTS"){
 #
 $user_tests="$TEST_todo";
 $DIR_here=$TEST_todo;
 $TEST_here="any";
 #
 &driver();
 #
}else{
 #
 $user_tests="$TEST_todo";
 #
 &driver();
 #
 my @dummy= split(/ /, $TEST_todo); 
 $DIR_here=$dummy[0];
 $TEST_here=$dummy[1];
}
chdir("$TESTS_folder/$DIR_here");
#
if (not -f "$ROBOT_wd/SAVE/ndb.gops" and not "../SAVE/ndb.gops") 
{
 die "\n\n It seems the test-suite could not run";
}
#
}
sub UPDATE_action{
#
if ("@_" eq "RM" && $ref_filename =~ /$REF_folder/){
 &command("$git rm ../$ref_filename");
}
if ("@_" eq "ADD")
{
 if (not -d $REF_folder) 
 { 
  print "...$REF_folder FOLDER";
  &command("mkdir -p ../$REF_folder");
  &command("$git add ../$REF_folder");
 };
 if (not -f "../$REF_folder/$run_filename") 
 {
  &command("cp $run_filename ../$REF_folder");
  &command("$git  add ../$REF_folder/$run_filename");
  print "...$run_filename";
 }
 foreach my $file (<r*$testname*>,<l*$testname*>) {
  if (not -f "../$REF_folder/$file") 
  {
   &command("cp $file* ../$REF_folder");
   &command("$git add ../$REF_folder/$file");
   print "...$file";
  }
 }
}
if ("@_" eq "INPUT") {
 print "\nUPDATE: Adding";
 if (not -d $input_folder) { 
  print "...$input_folder FOLDER";
  &command("mkdir -p ../$input_folder");
  &command("$git add ../$input_folder");
 }
 if (-f "$testname/yambo.in_generated") {
  &command("cp yambo.in_generated ../$input_folder/$testname");
  &command("$git add ../$input_folder/$testname");
  print "...$input_folder/$testname";
 };
}
print "\n";
}
1;
