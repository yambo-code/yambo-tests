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
sub CHECK_driver{
#
if ($SETUP=="1"){
 &CHECK_exist("ndb.kindx");
 &CHECK_exist("ndb.gops");
}
if ( $is_OLD_IO eq "yes"  ) { &CHECK_database("Sx_Vxc","ndb.HF_and_locXC")};
if ( $is_OLD_IO eq "no"   ) { &CHECK_database("Sx,Vxc","ndb.HF_and_locXC")};
&CHECK_database("BLOCK_TABLE","ndb.Double_Grid");
&CHECK_database("BLOCK_TABLE","ndb.E_SOC_map");
&CHECK_database("X_Q_1","ndb.em1s_fragment_1");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_HXC_fragment_2");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_COH_fragment_2");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_GW_NEQ_fragment_2");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_P_fragment_2");
#
# OUT files
O_file_loop: foreach $run_filename (<o-$testname.*>){
 &gimme_reference($run_filename);
 if (!-e "$ref_filename") { 
  if ($update_test) {&UPDATE_action("ADD")};
  &RUN_stats("NO_REF");
 }else{
  my $ERR=&CHECK_file;
  if ($ERR eq "FAIL" and $update_test)
  {
   &UPDATE_action("RM");
   &UPDATE_action("ADD");
  }
 }
}
#
# REF files
if ( -d "REFERENCE_$branch_key" and -f "REFERENCE_$branch_key/$testname" ) 
{
 @OFILES = (<REFERENCE_$branch_key/o-$testname.*>)
}else{
 @OFILES = (<REFERENCE/o-$testname.*>, <REFERENCE_$branch_key/o-$testname.*>)
}
O_file_loop: foreach $ref_filename (@OFILES){
 $run_filename = $ref_filename;
 $run_filename =~ s{.*/}{};
 ($base, $dir, $ext) = fileparse($run_filename, qr/\.[^.]*/);
 #
 if ( $ext=~ /hf/  and $is_STABLE=~"yes" ) { next O_file_loop};
 #
 if (!-e "$run_filename") { 
  if ($update_test) 
  {
   &UPDATE_action("RM");
  }
  &RUN_stats("NO_OUT");
 }
}
#
}
1;
