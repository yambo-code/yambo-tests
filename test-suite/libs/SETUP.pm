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
 # Check the requested configuration exists, if any
 if($compile && $select_conf_file && not $select_conf_file eq "all"){
  if(!-e "ROBOTS/$host/$user/CONFIGURATIONS/$select_conf_file") {
   &MY_PRINT($stdout, "Couldn't find conf file $select_conf_file in ROBOTS/$host/$user/CONFIGURATIONS/. Stopping.\n") and exit;
  }
 }
 # Initialize parallelism
 $mpiexec = ""; 
 if($np_min) { 
  $mpiexec = "mpirun"; 
  for ($ic=$np_min; $ic<= $np_max ; $ic++){
   $NP_set[$ic-$np_min]=$ic;
  }
 }
 elsif($np_single) { 
  $mpiexec = "mpirun"; 
  $NP_set[0]=$np_single;
 }
 else
 {
  $NP_set[0]=1;
 };
 #
 # Initialization of sources
 $target_list_basic = "yambo ypp interfaces ";
 $exec_list_basic =   "yambo ypp a2y p2y ";
 if($is_GPL eq "no"){
  $exec_rt   = " yambo_rt ypp_rt";
  $exec_sc   = " yambo_sc ypp_rt ypp_sc";
  $exec_pl   = " yambo_pl ypp_pl";
  $exec_nl   = " yambo_nl ypp_nl";
  $exec_magn = " yambo_magnetic ypp_magnetic";
 }
 $exec_elph = " yambo_ph ypp_ph";
 $exec_kerr = " yambo_kerr";
 #
 # Off's 
 if ($is_off){
  if ($is_off =~ /mpi/ and $np_min==1 and $np_max==1 ){$mpi_is_off="yes"};
  if ($is_off =~ /openmp/ ){$openmp_is_off="yes"};
 }
 #
 &MY_PRINT($stdout, "\n$double_line") if (!$reduced_log);
 &MY_PRINT($stdout, "\n= Starting Yambo test-suite") if (!$reduced_log);
 &MY_PRINT($stdout, "\n$double_line\n") if (!$reduced_log);
 #
 # Check (optional) external programs
 #
 if (!$reduced_log) {
  # find_the_diff
  &MY_PRINT($stdout, " - Check requirements : ");
  if($nccopy)   {&MY_PRINT($stdout, "...$nccopy")};
  if($ncftp)    {&MY_PRINT($stdout, "...$ncftp")};
  if($ncftpls)  {&MY_PRINT($stdout, "...$ncftpls")};
  if($ncftpput) {&MY_PRINT($stdout, "...$ncftpput")};
  if($txt2html) {&MY_PRINT($stdout, "...$txt2html")};
  &MY_PRINT($stdout, "\n");
 }
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
 # Local directories to collect logs
 if ($backup_logs){
  &command("mkdir -p $BACKUP_dir");
  &command("mkdir -p $BACKUP_dir/$BACKUP_subdir");
  if ($compile) {&command("mkdir -p $BACKUP_dir/$BACKUP_subdir/compilation")};
 };
 #
}
}
1;
