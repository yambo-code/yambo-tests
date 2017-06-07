#!/usr/bin/perl
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
sub UTILS_update{
#
chomp($update_test);
my $TEST_todo= $update_test;
#
&RUN_global_report("INIT");
#
&FLOW_reset("ALL");
undef $compile;
$keys="all hard";
#
if (-d "tests/$TEST_todo/INPUTS"){
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
chdir("tests/$DIR_here");
#
if (not -f "SAVE/ndb.gops") 
{
 die "\n\n It seems the test-suite could not run";
}
#
if ($branch_key eq "master") 
{
 $REF="REFERENCE";
}else{
 $REF="REFERENCE_".$branch_key;
 if (not -d $REF) 
 { 
  &command("mkdir $REF");
  &command("svn add $REF"."@");
 }
}
#
DIR_loop: foreach my $dir (<*>) {
 if (not -d $dir) {next DIR_loop};
 if (-l $dir) {next DIR_loop};
 if ($dir =~ /REFERENCE/){next DIR_loop};
 if ($dir =~ /$REF/){next DIR_loop};
 if ($dir =~ /BROKEN/){next DIR_loop};
 if ($dir =~ /DFT/){next DIR_loop};
 if ($dir =~ /INPUTS/){next DIR_loop};
 foreach my $file (<$dir/o*>,<$dir/l*>,<$dir/r*> ) {
  $svn_file = $file;
  $svn_file =~  s/\// /;
  my @string = split(/ /, "$svn_file");
  if ( $REF eq "REFERENCE")
  {
   &command("svn --force del REFERENCE/$string[1]"."@");
  }
  &command("cp $file $REF");
  &command("svn add $REF/$string[1]"."@");
 }
}
#
}
1;
