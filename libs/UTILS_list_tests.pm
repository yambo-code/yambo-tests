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
sub UTILS_list_tests
{
if ("@_" eq "list_all" ) {  # -l without options, "default" is overwritten
  &CWD_save;
  chdir("$suite_dir/$TESTS_folder");
  &MY_PRINT($stdout, "\nAvailable test materials/systems: \n");
  DIR_LOOP: foreach $dir (<*>,<*/*>,<*/*/*>,<*/*/*/*>,<*/*/*/*/*>) {      # Glob all files
   # Loop through all files and directories, and save those 'active' dirs containing
   # SAVE and INPUTS folders into @testdirs
   if ( (-d $dir."/SAVE" || -d $dir."/SAVE_backup") && -d $dir."/$input_folder" ) {
    push(@testdirs,$dir);
    $P_str="";
    $HARD_str="";
    if ( $is_GPL ){
      if (-e $dir."/NO_GPL")  { next DIR_LOOP };
      if (-e $dir."/QED")  { next DIR_LOOP };
      if (-e $dir."/PL")  { next DIR_LOOP };
      if (-e $dir."/NL")  { next DIR_LOOP };
      if (-e $dir."/SC")  { next DIR_LOOP };
      if (-e $dir."/MAGNETIC")  { next DIR_LOOP };
    }
    if (-e $dir."/BROKEN")  {
      $BROKEN_tests="$BROKEN_tests"." "."$dir"."$HARD_str"."$P_str";
      if (-e $dir."/RT")   {$BROKEN_tests="$BROKEN_tests"."[RT]"}
      if (-e $dir."/QED")   {$BROKEN_tests="$BROKEN_tests"."[QED]"}
      if (-e $dir."/PL")   {$BROKEN_tests="$BROKEN_tests"."[PL]"}
      if (-e $dir."/NL")   {$BROKEN_tests="$BROKEN_tests"."[NL]"}
      if (-e $dir."/SC")   {$BROKEN_tests="$BROKEN_tests"."[SC]"}
      if (-e $dir."/MAGNETIC")   {$BROKEN_tests="$BROKEN_tests"."[MAGNETIC]"}
      if (-e $dir."/KERR")   {$BROKEN_tests="$BROKEN_tests"."[KERR]"}
      if (-e $dir."/ELPH")   {$BROKEN_tests="$BROKEN_tests"."[ELPH]"}
    }else{
     if (-e $dir."/HARD")     {$HARD_str="[H]"};
     if (-e $dir."/PARALLEL") {$P_str="[P]"};
     if (-e $dir."/RT")   {$RT_tests="$RT_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/QED")  {$QED_tests="$QED_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/PL" )  {$PL_tests="$PL_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/NL" )  {$NL_tests="$NL_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/SC" )  {$SC_tests="$SC_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/MAGNETIC" )  {$MAGNETIC_tests="$MAGNETIC_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/KERR")  {$KERR_tests="$KERR_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/ELPH")  {$ELPH_tests="$ELPH_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (!-e $dir."/SC" && !-e $dir."/MAGNETIC" && !-e $dir."/ELPH" && !-e $dir."/RT" && !-e $dir."/KERR" && !-e $dir."/QED" && !-e $dir."/PL" && !-e $dir."/NL") {
      $NORMAL_tests="$NORMAL_tests"." "."$dir"."$HARD_str"."$P_str";
     }
    };
   }
  } 
  #
  # Remove any files that don't belong in the repository
  #
  &LIST_ELEMENT("[YAMBO]   ",$NORMAL_tests);
  &LIST_ELEMENT("[QED]     ",$QED_tests);
  &LIST_ELEMENT("[PL]      ",$PL_tests);
  &LIST_ELEMENT("[NL]      ",$NL_tests);
  &LIST_ELEMENT("[RT]      ",$RT_tests);
  &LIST_ELEMENT("[SC]      ",$SC_tests);
  &LIST_ELEMENT("[MAGNETIC]",$MAGNETIC_tests);
  &LIST_ELEMENT("[ELPH]    ",$ELPH_tests);
  if ($KERR_tests)  {&LIST_ELEMENT("[KERR]    ",$KERR_tests)};
  if ($BROKEN_tests){&LIST_ELEMENT("[BROKEN]  ",$BROKEN_tests)};
  &MY_PRINT($stdout, "\n");
 &CWD_go;
}
else
{
 &UTILS_tests_in_the_dir("./$TESTS_folder/$listtests");
 my @dummy = split(/ /,$tests_list);
 &MY_PRINT($stdout, "\nAvailable input files for $listtests are:");
 foreach my $i (1 .. $#dummy) { &MY_PRINT($stdout, " $dummy[$i]")};
 die "\n\n";
}
}
sub LIST_ELEMENT
{
  if ($_[1] eq "") {return};
  my @dummy = split(/ /,$_[1]);
  &MY_PRINT($stdout, "$_[0] $dummy[1]\n");
  foreach my $i (2 .. $#dummy) { &MY_PRINT($stdout, "           $dummy[$i]\n")};
}
1;
