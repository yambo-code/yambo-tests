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
sub CHECK_driver{
#
# Specific Rules
#
$CHECK_CORE="no";
if ($SETUP=="1"){
 if ($np==1 or $MPI_CPU_conf[1] eq "serial"){
#  &CHECK_database("Qindx,Sindx","ndb.kindx","CORE");
#  &CHECK_database("ng_in_shell,E_of_shell","ndb.gops","CORE");
 }
}
if ( $is_OLD_IO eq "yes"  ) { &CHECK_database("Sx_Vxc","ndb.HF_and_locXC","")};
if ( $is_OLD_IO eq "no"   ) { &CHECK_database("Sx,Vxc","ndb.HF_and_locXC","")};
if ( $is_NEW_DBGD eq "no"  ) { &CHECK_database("BLOCK_TABLE","ndb.Double_Grid","")};
if ( $is_NEW_DBGD eq "yes" ) { &CHECK_database("BLOCK_TABLE_IBZ,BLOCK_TABLE_BZ","ndb.Double_Grid","")};
&CHECK_database("X_Q_1","ndb.em1s_fragment_1","");
if (not $LIFE=="1") {&CHECK_database("X_Q_1","ndb.em1d_fragment_1","")};
&CHECK_database("X_Q_1","ndb.pp_fragment_1","");
&CHECK_database("BLOCK_TABLE","ndb.E_SOC_map","");
&CHECK_database("CUT_BARE_QPG","ndb.cutoff","");
&CHECK_database("RIM_qpg","ndb.RIM","");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_HXC_fragment_2","");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_COH_fragment_2","");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_GW_NEQ_fragment_2","");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_P_fragment_2","");
#
# OUT files
O_file_loop: foreach $run_filename (<o-$testname.*>){
 &gimme_reference($run_filename);
 if (!-e "$ref_filename") { 
  &RUN_stats("NO_REF");
  if ($update_test and not $CHECK_error =~ /WHITELISTED/) {&UPDATE_action("ADD")};
 }else{
  my $ERR=&CHECK_file;
  if ($ERR eq "FAIL" and $update_test and not $CHECK_error =~ /WHITELISTED/)
  {
   &UPDATE_action("RM");
   &UPDATE_action("ADD");
  }
 }
}
#
# REF files
my $ref_dir;
if ( -d $REF_prefix."REFERENCE_$branch_key" and -f $REF_prefix."REFERENCE_$branch_key/$testname" ) 
{
 $ref_dir="${REF_prefix}REFERENCE_${branch_key}";
}else{
 $ref_dir="${REF_prefix}REFERENCE";
}
@OFILES = (<$ref_dir/o-$testname.*>);
R_file_loop: foreach $ref_filename (@OFILES){
 my $CHECK=&CHECK_GPL_skip("$ref_filename");
 #
 if ($ref_filename =~ ".gops" or $ref_filename =~ ".kindx") {
  if (not $MPI_CPU_conf[1] eq "serial") {$CHECK="SKIP"}
 }
 if ($ref_filename =~ ".em1d" and $LIFE eq "1") {$CHECK="SKIP"}; 
 #
 if ($CHECK eq "SKIP") {next R_file_loop};
 $run_filename = $ref_filename;
 $run_filename =~ s{.*/}{};
 ($base, $dir, $ext) = fileparse($run_filename, qr/\.[^.]*/);
 #
 if ( $ext=~ /hf/  and $is_STABLE=~"yes" ) { next R_file_loop};
 #
 if (!-e "$run_filename") { 
  &RUN_stats("NO_OUT");
  if ($update_test and not $CHECK_error =~ /WHITELISTED/) 
  {
   &UPDATE_action("RM");
  }
 }
}
#
}
1;
