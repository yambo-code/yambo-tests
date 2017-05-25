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
if ($keys) {$keys_save=$keys};
print "$keys_save";
&FLOW_reset("ALL");
if ($keys_save) {$keys=$keys_save};
$compile="no";
#
if (not -d "tests/$TEST_todo/REFERENCE"){
 &command("mkdir tests/$TEST_todo/REFERENCE");
 &command("svn add tests/$TEST_todo/REFERENCE");
}
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
foreach my $file (<REFERENCE/o*>,<REFERENCE/l-*>,<REFERENCE/r-*>) {
 if ($file =~ /$TEST_here/ or "$TEST_here" eq "any"){
#  print "Do you want to remove $file (Y/N)?"; # first question yes/no
#  my $input = <STDIN>;
#  chomp $input;
#  if ($input =~ m/^[Y]$/i){&command("svn --force del $file") };
  &command("svn --force del $file");
 }
}
DIR_loop: foreach my $dir (<*>) {
 if (not -d $dir) {next DIR_loop};
 if ($dir =~ /REFERENCE/){next DIR_loop};
 if ($dir =~ /BROKEN/){next DIR_loop};
 if ($dir =~ /DFT/){next DIR_loop};
 if ($dir =~ /INPUTS/){next DIR_loop};
 if ($dir =~ /$TEST_here/ or "$TEST_here" eq "any"){
  foreach my $file (<$dir/o*>,<$dir/l*>,<$dir/r*> ) {
   &command("cp $file REFERENCE");
   $file =~  s/\// /;
   my @string = split(/ /, "$file");
   &command("svn add REFERENCE/$string[1]"."@");
  }
 }
}
#
}
1;
