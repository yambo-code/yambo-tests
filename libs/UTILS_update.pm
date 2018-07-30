#!/usr/bin/perl
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
sub UTILS_update{
#
chomp($update_test);
my $TEST_todo= $update_test;
#
&RUN_global_report("INIT");
#
&FLOW_reset("ALL");
undef $compile;
$keys="all hard p2y";
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
if ($branch_key eq "master" or $branch_key eq "bug-fixes") 
{
 $REF="REFERENCE";
}else{
 $REF="REFERENCE_".$branch_key;
 if (not -d $REF) 
 { 
  &command("mkdir -p $REF");
  &command("$git add $REF");
 }
}
#
&command("$git add INPUTS");
&command("$git add $REF");
#
}
sub UPDATE_action{
#
if ($branch_key eq "master" or $branch_key eq "bug-fixes") 
{
 $REF_folder="REFERENCE";
}else{
 $REF_folder="REFERENCE_".$branch_key;
};
if (not -d $REF_folder) 
{ 
 &command("mkdir -p ../$REF_folder");
 &command("$git add ../$REF_folder");
};
if ("@_" eq "RM" and "$REF_folder" eq "REFERENCE"){
 &command("$git rm ../$ref_filename");
}
if ("@_" eq "ADD")
{
 &command("cp $run_filename ../$REF_folder");
 &command("$git  add ../$REF_folder/$run_filename");
 foreach my $file (<r*$testname*>,<l*$testname*>) {
  &command("cp $file* ../$REF_folder");
  &command("$git add ../$REF_folder/$file");
 }
}
#
}
1;
