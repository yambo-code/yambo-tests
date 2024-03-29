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
sub CHECK_database{
#
$VAR = "@_[0]";
$DB  = "@_[1]";
$CORE= "@_[2]";
$FIRST= "@_[3]";
$run_filename = "o-$testname.$DB";
&gimme_reference($run_filename);
#
$check_folder="$testname"; 
if ($CORE eq "CORE" and not ($P2Y or $A2Y)) { $check_folder="SAVE"; };
if ($CORE eq "CORE" and     ($P2Y or $A2Y)) { $check_folder=$dir_name; };
#
if ($CORE eq "CORE" and ($P2Y or $A2Y)) {
  $target_dir = "$suite_dir/$TESTS_folder/$testdir/$ROBOT_wd/$check_folder";
  if(! -d $target_dir ) { &command("mkdir -p $target_dir"); };
  #
  if( -d $target_dir && -e "SAVE/$DB" && $FIRST eq "FIRST") {  &command("cp SAVE/* $target_dir") ; };
  #
  if($P2Y) {&CWD_save_p2y;};
  if($A2Y) {&CWD_save_a2y;};
  chdir("$suite_dir/$TESTS_folder/$testdir/$ROBOT_wd") ;
  &gimme_reference($run_filename);
};
#
if( -e "$check_folder/$DB" ){
  my @VAR_NAMES = split(',', $VAR);
  &command("rm -rf $run_filename");
  foreach my $VAR_I (@VAR_NAMES) {
  &command("$ncdump -h $check_folder/$DB | grep $VAR_I  > ${VAR_I}_check" ) ;
  if (! -z "${VAR_I}_check") { &command("$ncdump -v $VAR_I $check_folder/$DB | $awk -f $suite_dir/scripts/find_the_diff/ndb2o.awk | head -n 10000 >> $run_filename") ;}
  &command("rm ${VAR_I}_check" ) ;
  if(! -e "$ref_filename" ) {
   &RUN_stats("ERR_DB");
   if ($CORE eq "CORE" and $P2Y) {$CWD_go_p2y};
   if ($CORE eq "CORE" and $A2Y) {$CWD_go_a2y};
  }
 }
} else{
 if (-e "$ref_filename"){
  &RUN_stats("ERR_DB");
 }
}
if ($CORE eq "CORE" and $P2Y) {$CWD_go_p2y};
if ($CORE eq "CORE" and $A2Y) {$CWD_go_a2y};
}
1;
