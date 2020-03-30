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
sub UTILS_list_tests
{
if ("@_" eq "list_all" ) {  # -l without options, "default" is overwritten
  &CWD_save;
  chdir("$suite_dir/$TESTS_folder");
  &MY_PRINT($stdout, "\nAvailable test materials/systems: \n");
  my @dirs;
  my @dir = ( "." );
  find( sub { push @dirs, $File::Find::name if -d }, @dir );
  DIR_LOOP: foreach $dir (@dirs){
   if ( (-d $dir."/SAVE" || -d $dir."/SAVE_backup") && -d $dir."/$input_folder" && not $dir  =~ /ROBOT/  ) {
    push(@testdirs,$dir);
    my $n = 2;
    $dir =~ s/^.{$n}//s;
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
      if (-e $dir."/P2Y")   {$BROKEN_tests="$BROKEN_tests"."[P2Y]"}
      if (-e $dir."/A2Y")   {$BROKEN_tests="$BROKEN_tests"."[A2Y]"}
      if (-e $dir."/RT")   {$BROKEN_tests="$BROKEN_tests"."[RT]"}
      if (-e $dir."/QED")   {$BROKEN_tests="$BROKEN_tests"."[QED]"}
      if (-e $dir."/PL")   {$BROKEN_tests="$BROKEN_tests"."[PL]"}
      if (-e $dir."/NL")   {$BROKEN_tests="$BROKEN_tests"."[NL]"}
      if (-e $dir."/SC")   {$BROKEN_tests="$BROKEN_tests"."[SC]"}
      if (-e $dir."/MAGNETIC")   {$BROKEN_tests="$BROKEN_tests"."[MAGNETIC]"}
      if (-e $dir."/KERR")   {$BROKEN_tests="$BROKEN_tests"."[KERR]"}
      if (-e $dir."/SPIN")   {$BROKEN_tests="$BROKEN_tests"."[SPIN]"}
      if (-e $dir."/SPINORS")   {$BROKEN_tests="$BROKEN_tests"."[SPINORS]"}
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
     if (-e $dir."/SPIN")  {$SPIN_tests="$SPIN_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/SPINORS")  {$SPINORS_tests="$SPINORS_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/ELPH")  {$ELPH_tests="$ELPH_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/P2Y")  {$P2Y_tests="$P2Y_tests"." "."$dir"."$HARD_str"."$P_str"};
     if (-e $dir."/A2Y")  {$A2Y_tests="$A2Y_tests"." "."$dir"."$HARD_str"."$P_str"};
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
  &LIST_ELEMENT("[P2Y]     ",$P2Y_tests);
  &LIST_ELEMENT("[A2Y]     ",$A2Y_tests);
  &LIST_ELEMENT("[SPIN]    ",$SPIN_tests);
  &LIST_ELEMENT("[SPINORS] ",$SPINORS_tests);
  if ($KERR_tests)  {&LIST_ELEMENT("[KERR]    ",$KERR_tests)};
  if ($BROKEN_tests){&LIST_ELEMENT("[BROKEN]  ",$BROKEN_tests)};
  &MY_PRINT($stdout, "\n");
 &CWD_go;
}
else
{
 my @dirs;
 my @dir = ( "./$TESTS_folder/$listtests" );
 find( sub { push @dirs, $File::Find::name if -d }, @dir );
 &MY_PRINT($stdout, "\nAvailable input files for $listtests are:");
 foreach $el (@dirs)
 {
   if ($el =~ /INPUTS/ and not $el =~ /ROBOT/) 
   {
    $tests_list=" ";
    $input_folder=(split '/',$el)[-1];
    &UTILS_tests_in_the_dir("./$TESTS_folder/$listtests",$input_folder);
    my @dummy = split(/ /,$tests_list);
    &MY_PRINT($stdout, "\n $input_folder:");
    foreach my $i (1 .. $#dummy) { &MY_PRINT($stdout, " $dummy[$i]")};
   }
 }
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

