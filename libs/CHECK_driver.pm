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
sub CHECK_driver{
#
$n_stats=0;
#
# Specific Rules
#
$CHECK_CORE="1";
if ($nt and $nt>1 and $SETUP=="1") {undef $CHECK_CORE;  &RUN_stats("SKIPPED_CORE"); $n_stats=1; };
if (        $np>1 and $SETUP=="1") {undef $CHECK_CORE;  &RUN_stats("SKIPPED_CORE"); $n_stats=1; };
if (              not $SETUP=="1") {undef $CHECK_CORE};
if ($P2Y){
  &CHECK_database("EIGENVALUES","ns.db1","CORE","FIRST");
  &CHECK_database("PP_KB_K1","ns.kb_pp_pwscf_fragment_1","CORE");
  &CHECK_database("ATOM_PROJ_IK1_SP_POL1","ns.atom_proj_pwscf_fragment_1","CORE");
  &CHECK_database('WF_COMPONENTS_@_SP_POL1_K1_BAND_GRP_1',"ns.wf_fragments_1_1","CORE");
}
if ($A2Y){
  &CHECK_database("EIGENVALUES","ns.db1","CORE","FIRST");
  &CHECK_database("PP_KB_IK1_SP_POL1","ns.kb_pp_fragment_1","CORE");
  &CHECK_database('WF_COMPONENTS_@_SP_POL1_K1_BAND_GRP_1',"ns.wf_fragments_1_1","CORE");
}
if ($CHECK_CORE){
 &CHECK_database("Qindx,Sindx","ndb.kindx","CORE");
 &CHECK_database("ng_in_shell,E_of_shell","ndb.gops","CORE");
}
if ( $is_OLD_IO eq "yes"  ) { &CHECK_database("Sx_Vxc","ndb.HF_and_locXC","")};
if ( $is_OLD_IO eq "no"   ) { &CHECK_database("Sx,Vxc","ndb.HF_and_locXC","")};
if ( $is_NEW_DBGD eq "v1"  ) { &CHECK_database("BLOCK_TABLE","ndb.Double_Grid","")};
if ( $is_NEW_DBGD eq "v2" ) { &CHECK_database("BLOCK_TABLE_IBZ,BLOCK_TABLE_BZ","ndb.Double_Grid","")};
if ( $is_NEW_DBGD eq "v3" ) { &CHECK_database("IBZ_E_MAP,IBZ_K_RANGE","ndb.Double_Grid","")};
&CHECK_database("X_Q_1","ndb.em1s_fragment_1","");
if (not $LIFE=="1") {&CHECK_database("X_Q_1","ndb.em1d_fragment_1","")};
&CHECK_database("X_Q_1","ndb.pp_fragment_1","");
&CHECK_database("QP_table","ndb.QP","");
&CHECK_database("QP_kpts","ndb.QP","");
&CHECK_database("QP_E","ndb.QP","");
&CHECK_database("QP_Z","ndb.QP","");
&CHECK_database("QP_table","ndb.QP_expanded","");
&CHECK_database("QP_kpts","ndb.QP_expanded","");
&CHECK_database("QP_E","ndb.QP_expanded","");
&CHECK_database("QP_Z","ndb.QP_expanded","");
&CHECK_database("BLOCK_TABLE","ndb.E_SOC_map","");
&CHECK_database("CUT_BARE_QPG","ndb.cutoff","");
&CHECK_database("RIM_qpg","ndb.RIM","");
$append="";
if(not $BUILD =~ /MPI_IO/) { $append="_fragment_2"; }
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_HXC$append","");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_COH$append","");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_GW_NEQ$append","");
&CHECK_database("COLLISIONS_v","ndb.COLLISIONS_P$append","");
#
# OUT files
O_file_loop: foreach $run_filename (<o-$testname.*>){
 #
 ($tmpname,$tmppath,$tmpsuffix) = fileparse($run_filename,".yaml");
 if( $tmpsuffix eq ".yaml" ) {next;}
 #
 $n_stats++;
 #
 &gimme_reference($run_filename);
 #
 if (&CHECK_ignore($run_filename)) {next O_file_loop};
 #
 if (!-e "$ref_filename") { 
  &RUN_stats("NO_REF");
  if ($update_test) {&UPDATE_action("ADD")};
 }else{
  my $ERR=&CHECK_file;
  if ($update_test and $ERR eq "FAIL" and (not $CHECK_error =~ /WHITELISTED/ and not $CHECK_error =~ /RULES-SUCC/) ) 
  {
   &UPDATE_action("RM");
   &UPDATE_action("ADD");
  }
 }
}
#
# REF files
my $ref_dir;
$ref_dir="${REF_prefix}REFERENCE";
my @OFILES = (<$ref_dir/o-$testname.*>);
if ( -d $REF_prefix.$REF_folder."/$testname")
{
 $ref_dir="${REF_prefix}.${REF_folder}/$testname";
 my @MFILES = (<$ref_dir/o-$testname.*>);
 push @OFILES, @MFILES;
}elsif ( -d $REF_prefix.$REF_folder)
{
 $ref_dir="${REF_prefix}${REF_folder}";
 my @MFILES = (<$ref_dir/o-$testname.*>);
 push @OFILES, @MFILES;
}
R_file_loop: foreach $ref_filename (@OFILES){
 #
 $n_stats++;
 #
 my $CHECK=&CHECK_GPL_skip("$ref_filename");
 #
 if ($ref_filename =~ /db1/) {next R_file_loop};
 if ($ref_filename =~ /gops/ or $ref_filename =~ /kindx/) {next R_file_loop};
 if ($ref_filename =~ /em1d/ and $LIFE eq "1") {next R_file_loop};
 #
 if (&CHECK_ignore($ref_filename)) {next R_file_loop};
 #
 for $ipatt (1...$N_PATTERNS) 
 {
  if ($ref_filename =~ $PATTERN[$ipatt][1] and ($PATTERN_branch[$ipatt] =~ /$branch_key/ or $PATTERN_branch[$ipatt] =~ "any")){ 
   if ($PATTERN[$ipatt][3] and "$PATTERN[$ipatt][3]" eq "end") {
     $ref_filename =~ s/$PATTERN[$ipatt][1]$/$PATTERN[$ipatt][2]/;
   }else{
     $ref_filename =~ s/$PATTERN[$ipatt][1]/$PATTERN[$ipatt][2]/;
   }
  }
 } 
 #
 if ($CHECK eq "SKIP") {next R_file_loop};
 #
 $run_filename = $ref_filename;
 $run_filename =~ s{.*/}{};
 ($base, $dir, $ext) = fileparse($run_filename, qr/\.[^.]*/);
 #
 if (&CHECK_ignore($run_filename)) {next R_file_loop};
 #
 $SKIP_MPIIO=(  ("$BUILD" =~ "MPI_IO" ) && ( "$run_filename" =~ "fragment_2")    );
 $SKIP_SERIO=( !("$BUILD" =~ "MPI_IO" ) && ( "$run_filename" =~ "COLLISIONS") && !( "$run_filename" =~ "fragment_2")  );
 if ( (!-e "$run_filename") && !( $SKIP_MPIIO || $SKIP_SERIO ) ) { 
  &RUN_stats("NO_OUT");
  if ($update_test and (not $CHECK_error =~ /WHITELISTED/) and (not $CHECK_error =~ /RULES-SUCC/) ) 
  {
   &UPDATE_action("RM");
  }
 }
}
#
# Count tests without any output
#
if ( $n_stats eq "0" ){
 &RUN_stats("SILENT");
}
#
}
1;
