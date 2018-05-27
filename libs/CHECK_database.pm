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
sub CHECK_database{
#
$VAR = "@_[0]";
$DB  = "@_[1]";
$CORE= "@_[2]";
$run_filename = "o-$testname.$DB";
&gimme_reference($run_filename);
#
$check_folder="$testname"; 
#if ($CORE eq "CORE") { $check_folder="SAVE"; };
if ($CORE eq "CORE") { $check_folder=$dir_name; };
#
if ($CORE eq "CORE") {
  $target_dir = "$suite_dir/$TESTS_folder/$testdir/$ROBOT_wd/$check_folder";
  if(! -d $target_dir ) { &command("mkdir -p $target_dir"); };
  #
  &command("cp SAVE/$DB $target_dir") ;
  #
  &CWD_save;
  chdir("$suite_dir/$TESTS_folder/$testdir/$ROBOT_wd") ;
  &gimme_reference($run_filename);
};
#
if( -e "$check_folder/$DB" ){
 &command("$ncdump -v $VAR $check_folder/$DB | $awk -f $suite_dir/scripts/find_the_diff/ndb2o.awk | head -n 10000 > $run_filename") ;
 if(! -e "$ref_filename" ) {
  &RUN_stats("ERR_DB");
  if ($CORE eq "CORE") {$CWD_go};
  return;
 }
} else{
 if (-e "$ref_filename"){
  &RUN_stats("ERR_DB");
 }
}
if ($CORE eq "CORE") {$CWD_go};
}
1;
