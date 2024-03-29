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
    $MORE_str="";
    if ( $is_GPL ){
      if (-e $dir."/NO_GPL")  { next DIR_LOOP };
      if (-e $dir."/QED")  { next DIR_LOOP };
    }
    if (-e $dir."/EMPTY")  {
      $EMPTY_tests="$EMPTY_tests"." "."$dir";
      if (-e $dir."/P2Y")   {$EMPTY_tests="$EMPTY_tests"."[P2Y]"."$MORE_str"}
      if (-e $dir."/A2Y")   {$EMPTY_tests="$EMPTY_tests"."[A2Y]"."$MORE_str"}
      if (-e $dir."/RT")   {$EMPTY_tests="$EMPTY_tests"."[RT]"."$MORE_str"}
      if (-e $dir."/QED")   {$EMPTY_tests="$EMPTY_tests"."[QED]"."$MORE_str"}
      if (-e $dir."/PL")   {$EMPTY_tests="$EMPTY_tests"."[PL]"."$MORE_str"}
      if (-e $dir."/NL")   {$EMPTY_tests="$EMPTY_tests"."[NL]"."$MORE_str"}
      if (-e $dir."/SC")   {$EMPTY_tests="$EMPTY_tests"."[SC]"."$MORE_str"}
      if (-e $dir."/MAGNETIC")   {$EMPTY_tests="$EMPTY_tests"."[MAGNETIC]"."$MORE_str"}
      if (-e $dir."/KERR")   {$EMPTY_tests="$EMPTY_tests"."[KERR]"."$MORE_str"}
      if (-e $dir."/MAGNONS"){$EMPTY_tests="$EMPTY_tests"."[MAGNONS]"."$MORE_str"}
      if (-e $dir."/SPIN")   {$EMPTY_tests="$EMPTY_tests"."[SPIN]"."$MORE_str"}
      if (-e $dir."/SPINORS")   {$EMPTY_tests="$EMPTY_tests"."[SPINORS]"."$MORE_str"}
      if (-e $dir."/ELPH")   {$EMPTY_tests="$EMPTY_tests"."[ELPH]"."$MORE_str"}
      if (-e $dir."/PHEL")   {$EMPTY_tests="$EMPTY_tests"."[PHEL]"."$MORE_str"}
    }elsif (-e $dir."/BROKEN")  {
      $BROKEN_tests="$BROKEN_tests"." "."$dir";
      if (not -e $dir."/CONVERTED" and not -e $dir."/SAVE_converted" and not -e $dir."/SAVE_backup_converted"){$MORE_str.="[*]"};
      if (-e $dir."/P2Y")   {$BROKEN_tests="$BROKEN_tests"."[P2Y]"."$MORE_str"}
      if (-e $dir."/A2Y")   {$BROKEN_tests="$BROKEN_tests"."[A2Y]"."$MORE_str"}
      if (-e $dir."/RT")   {$BROKEN_tests="$BROKEN_tests"."[RT]"."$MORE_str"}
      if (-e $dir."/QED")   {$BROKEN_tests="$BROKEN_tests"."[QED]"."$MORE_str"}
      if (-e $dir."/PL")   {$BROKEN_tests="$BROKEN_tests"."[PL]"."$MORE_str"}
      if (-e $dir."/NL")   {$BROKEN_tests="$BROKEN_tests"."[NL]"."$MORE_str"}
      if (-e $dir."/SC")   {$BROKEN_tests="$BROKEN_tests"."[SC]"."$MORE_str"}
      if (-e $dir."/MAGNETIC")   {$BROKEN_tests="$BROKEN_tests"."[MAGNETIC]"."$MORE_str"}
      if (-e $dir."/KERR")   {$BROKEN_tests="$BROKEN_tests"."[KERR]"."$MORE_str"}
      if (-e $dir."/MAGNONS"){$BROKEN_tests="$BROKEN_tests"."[MAGNONS]"."$MORE_str"}
      if (-e $dir."/SPIN")   {$BROKEN_tests="$BROKEN_tests"."[SPIN]"."$MORE_str"}
      if (-e $dir."/SPINORS")   {$BROKEN_tests="$BROKEN_tests"."[SPINORS]"."$MORE_str"}
      if (-e $dir."/ELPH")   {$BROKEN_tests="$BROKEN_tests"."[ELPH]"."$MORE_str"}
      if (-e $dir."/PHEL")   {$BROKEN_tests="$BROKEN_tests"."[PHEL]"."$MORE_str"}
    }else{
     if (-e $dir."/HARD")     {$MORE_str="[H]"};
     if (-e $dir."/PARALLEL") {$MORE_str.="[P]"};
     if (not -e $dir."/CONVERTED" and not -e $dir."/SAVE_converted" and not -e $dir."/SAVE_backup_converted"){$MORE_str.="[*]"};
     if (-e $dir."/RT")   {$RT_tests="$RT_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/QED")  {$QED_tests="$QED_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/PL" )  {$PL_tests="$PL_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/NL" )  {$NL_tests="$NL_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/SC" )  {$SC_tests="$SC_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/MAGNETIC" )  {$MAGNETIC_tests="$MAGNETIC_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/KERR")  {$KERR_tests="$KERR_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/MAGNONS"){$MAGNONS_tests="$MAGNONS_tests"."[MAGNONS]"."$MORE_str"}
     if (-e $dir."/SPIN")  {$SPIN_tests="$SPIN_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/SPINORS")  {$SPINORS_tests="$SPINORS_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/ELPH")  {$ELPH_tests="$ELPH_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/PHEL")  {$PHEL_tests="$PHEL_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/P2Y")  {$P2Y_tests="$P2Y_tests"." "."$dir"."$MORE_str"};
     if (-e $dir."/A2Y")  {$A2Y_tests="$A2Y_tests"." "."$dir"."$MORE_str"};
     if (!-e $dir."/SC" && !-e $dir."/MAGNETIC" && !-e $dir."/ELPH" && !-e $dir."/RT" && !-e $dir."/MAGNETIC" && !-e $dir."/QED" && !-e $dir."/NL" && !-e $dir."PHEL" && !-e $dir."/KERR") {
      $NORMAL_tests="$NORMAL_tests"." "."$dir"."$MORE_str";
     }
    };
   }
  } 
  #
  # Remove any files that don't belong in the repository
  #
  if (not $keys) {$keys="all"};
  #
  if ($keys =~ /nopj/ or $keys =~ /all/) {&LIST_ELEMENT("[YAMBO]   ",$NORMAL_tests)};
  if ($keys =~ /qed/ or $keys =~/all/) {&LIST_ELEMENT("[QED]     ",$QED_tests)};
  if ($keys =~ /pl/ or $keys =~ /all/)  {&LIST_ELEMENT("[PL]      ",$PL_tests)};
  if ($keys =~ /nl/ or $keys =~ /all/)  {&LIST_ELEMENT("[NL]      ",$NL_tests)};
  if ($keys =~ /rt/ or $keys =~ /all/)  {&LIST_ELEMENT("[RT]      ",$RT_tests)};
  if ($keys =~ /sc/ or $keys =~ /all/)  {&LIST_ELEMENT("[SC]      ",$SC_tests)};
  if ($keys =~ /magnetic/ or $keys =~ /all/)  {&LIST_ELEMENT("[MAGNETIC]",$MAGNETIC_tests)};
  if ($keys =~ /elph/ or $keys =~ /all/)  {&LIST_ELEMENT("[ELPH]    ",$ELPH_tests)};
  if ($keys =~ /phel/ or $keys =~ /all/)  {&LIST_ELEMENT("[PHEL]    ",$PHEL_tests)};
  if ($keys =~ /p2y/ or $keys =~ /all/)  {&LIST_ELEMENT("[P2Y]     ",$P2Y_tests)};
  if ($keys =~ /a2y/ or $keys =~ /all/)  {&LIST_ELEMENT("[A2Y]     ",$A2Y_tests)};
  if ($keys =~ /spin/ or $keys =~ /all/)  {&LIST_ELEMENT("[SPIN]    ",$SPIN_tests)};
  if ($keys =~ /spinors/ or $keys =~ /all/)  {&LIST_ELEMENT("[SPINORS] ",$SPINORS_tests)};
  if ($keys =~ /magnons/ or $keys =~ /all/)  {&LIST_ELEMENT("[MAGNONS]    ",$SPIN_tests)};
  if ($keys =~ /kerr/ or $keys =~/all/)  {&LIST_ELEMENT("[KERR]    ",$KERR_tests)};
  if ($keys =~ /all/ or $keys =~/all/)   {if ($BROKEN_tests){&LIST_ELEMENT("[BROKEN]  ",$BROKEN_tests)}};
  if ($keys =~ /all/ or $keys =~/all/)   {if ($EMPTY_tests){&LIST_ELEMENT("[EMPTY]   ",$EMPTY_tests)}};
  &MY_PRINT($stdout, "\n[*] To be converted to the new format\n");
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

