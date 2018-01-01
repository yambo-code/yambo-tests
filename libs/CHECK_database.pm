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
sub CHECK_database{
#
$DB  = "@_[1]";
$VAR = "@_[0]";
$run_filename = "o-$testname.$DB";
&gimme_reference($run_filename);
#
$check_folder="NONE";
if( -e "$testname/$DB" ){ $check_folder="$testname"; };
if( -e "SAVE/$DB" )     { $check_folder="SAVE"; };
#
#print "CHECK_folder=$check_folder/$DB\n";
if( -e "$check_folder/$DB" ){
 #print "$check_folder/$DB found!\n";
 if( $is_OLD_IO eq "yes" ) { 
  $DB_tmp="${DB}_tmp";
  &command("mv $check_folder/$DB $testname/$DB_tmp"); 
  &command("$nccopy -d0 $testname/$DB_tmp $testname/$DB"); 
 };
 if( $is_OLD_IO eq "yes" ) { 
  $DB_d0="${DB}_d0";
  &command("mv $testname/$DB $testname/$DB_d0"); 
  &command("mv $testname/$DB_tmp $check_folder/$DB"); 
 };
 &command("$ncdump -v $VAR $check_folder/$DB | $awk -f $suite_dir/scripts/find_the_diff/ndb2o.awk | head -n 10000 > $run_filename") ;
 if(! -e "$ref_filename" ) {
  &RUN_stats("ERR_DB");
  return;
 }
} else{
 if (-e "$ref_filename"){
  &RUN_stats("ERR_DB");
 }
}
}
1;
