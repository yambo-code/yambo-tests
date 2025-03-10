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
sub SETUP{
#
my $what = shift;
#
if ("$what" eq "BASIC") {
 # Colors
 if ("$use_colors" !=~ "no"){
  $b_s=$color_start{blue};
  $b_e=$color_end{blue};
  $r_s=$color_start{red};
  $r_e=$color_end{red};
  $g_s=$color_start{green};
  $g_e=$color_end{green};
 }
 #
 # Initialize parallelism
 $mpiexec = ""; 
 if($user_mpirun) {$mpiexec = $user_mpirun; } 
 if($np_min) { 
  if(not $user_mpirun) { $mpiexec = "mpirun"; }
  for ($ic=$np_min; $ic<= $np_max ; $ic++){
   $NP_set[$ic-$np_min]=$ic;
  }
 }
 elsif($np_single) { 
  if(not $user_mpirun) { $mpiexec = "mpirun"; }
  $NP_set[0]=$np_single;
 }
 else
 {
  $NP_set[0]=1;
 };
 #
 # Initialization of sources
 #
 $target_list_basic = "yambo ypp a2y p2y ";
 $exec_list_basic =   "yambo ypp a2y p2y ";
 if("$mode" eq "cheers"){ $target_list_basic .= "ycheers ypp_sc"; $exec_list_basic .= "ycheers ypp_sc"}
 $exec_sc   = " yambo_sc ypp_sc";
 $exec_nl   = " yambo_nl ypp_nl";
 $exec_rt   = " yambo_rt ypp_rt";
 $exec_elph = " yambo_ph ypp_ph";
 $exec_ph_dyn = " yambo_ph";
 #
 # Off's 
 if ($is_off){
  if ($is_off =~    /mpi/ ) {$mpi_is_off="yes"};
  if ($is_off =~ /openmp/ ) {$openmp_is_off="yes"};
 }
 #
 &MY_PRINT($stdout, "\n$double_line") if (!$reduced_log);
 &MY_PRINT($stdout, "\n= Starting Yambo test-suite") if (!$reduced_log);
 &MY_PRINT($stdout, "\n$double_line\n") if (!$reduced_log);
 #
 if (! -f "KILLER_yambo_".$ROBOT_string.".awk" ) { &command("$suite_dir/scripts/job_stopper.sh $ROBOT_string &")};
 #
}elsif ("$what" == "DIR"){
 #
 $PAR_string="SERIAL";
 #
 if ($NP_set[0] >1 or $#NP_set >1) {
   $PAR_string="NP$NP_set[0]";
   if ($#NP_set >1) {$PAR_string="$PAR_string-$NP_set[$#NP_set]"};
 }
 #
 if ($nt)  {$PAR_string="$PAR_string-NT$nt"};
 if ($nl)        {$PAR_string="$PAR_string-NL$nl"};
 if ($default_parallel) {$PAR_string="$PAR_string-def_par"};
 if ($random_parallel) {$PAR_string="$PAR_string-rand_par"};
 #
 if (!$np_min and !$np_single and !$nt) {$PAR_string="SERIAL"};
 #
 $REF_folder="REFERENCE";
 if ($is_GPL)  {$REF_folder="REFERENCE_gpl"};
 if ($update_test and $update_as_master)  {$REF_folder="REFERENCE"};
 #
}
}
1;
