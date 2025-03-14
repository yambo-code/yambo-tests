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
sub SETUP_branch{
#
if ("@_" eq "load_the_branches") {
#
undef $branches;
undef $branch_identity;
undef $branch_robot;
&LOAD_branches;
return;
}
#
# Branch record starts with / means full path
# Branch record starts with # means skip
# $BRANCH is the absolute path to the branch
# $dir is short string of BRANCH for filenames, / swapped with _
#
$BRANCH=$branchdir;
#
# Chomp last "/"
#
my $chr = $branchdir;
my $last = chop($chr);
if ($last eq "/") {
 my $last = chop($branchdir);
}
if($branchdir =~ /^#/ || $branchdir eq "") {
 &MY_PRINT($stdout, "Skipping branch: $branchdir\n") if ($verb);
 return "FAIL";
}
if( ! -f "$BRANCH/driver/yambo.F")  { &MY_PRINT($stdout, "ERROR: cannot find $branchdir, skipping!\n"); return "FAIL"; };
#
my $pattern;
if ($branch_id eq "" or $branch_id eq "any") 
{
 chdir $BRANCH;
 $branch_key= qx(git rev-parse --abbrev-ref HEAD);
 $branch_key=~ s/^\s+|\s+$//g;
 $pattern=$branch_key;
 chdir $suite_dir;
}else{
 $branch_key=$branch_id;
 $pattern=$branch_id;
};
# A no-slash branch_key is needed when the branch is composed (like mantain/gw)
$branch_key_no_slash=$branch_key;
$branch_key_no_slash=~ s/\//-/g;
#
# test-suite branch
$test_suite_branch= qx(git rev-parse --abbrev-ref HEAD);
$test_suite_branch=~ s/^\s+|\s+$//g;
#
# GPL?
chdir $BRANCH;
my $git_origin= qx(git remote -v | grep origin | grep fetch);
$git_origin=~ s/\// /g;
$git_origin=~ s/.git/ /g;
if ((split(/ /, $git_origin))[3] eq "yambo-devel") 
{
 $GIT_repo_kind="devel";
}else{
 $GIT_repo_kind="GPL";
 $is_GPL="yes";
}
if ($is_GPL) {$GIT_repo_kind="GPL"} ; # USER provided
#
chdir $suite_dir;
#
# branch and branch_key (to be used in reports/actions)
$is_OLD_IO="no";
if ($pattern=~m/4.1/ix) {$is_OLD_IO="yes"};
#
$is_NEW_WF="yes";
if ($pattern=~m/3.4/ix) {$is_NEW_WF="no"};
if ($pattern=~m/4.0/ix) {$is_NEW_WF="no"};
if ($pattern=~m/4.1/ix) {$is_NEW_WF="no"};
#
$is_NEW_driver="yes";
#
undef $is_OLD_makeinterfcs;
if ($pattern=~m/3.4/ix)  {$is_OLD_makeinterfcs="yes"};
if ($pattern=~m/4.0/ix)  {$is_OLD_makeinterfcs="yes"};
if ($is_OLD_makeinterfcs){$target_list_basic = "yambo ypp interfaces ";}
#
$is_NEW_DBGD="v3";
if ($pattern=~m/5.0/ix){$is_NEW_DBGD="v2"};
if ($pattern=~m/4.5/ix){$is_NEW_DBGD="v1"};
if ($pattern=~m/4.4/ix){$is_NEW_DBGD="v1"};
if ($pattern=~m/4.3/ix){$is_NEW_DBGD="v1"};
if ($pattern=~m/4.2/ix){$is_NEW_DBGD="v1"};
if ($pattern=~m/4.1/ix){$is_NEW_DBGD="v1"};
if ($pattern=~m/4.0/ix){$is_NEW_DBGD="v1"};
if ($pattern=~m/3.4/ix){$is_NEW_DBGD="v1"};
if ($pattern=~m/fixes/ix){$is_NEW_DBGD="v3"};
#
$is_NEW_EXC_SORT="yes";
if ($pattern=~m/4.4/ix){$is_NEW_EXC_SORT="no"};
if ($pattern=~m/4.3/ix){$is_NEW_EXC_SORT="no"};
if ($pattern=~m/4.2/ix){$is_NEW_EXC_SORT="no"};
if ($pattern=~m/4.1/ix){$is_NEW_EXC_SORT="no"};
if ($pattern=~m/4.0/ix){$is_NEW_EXC_SORT="no"};
if ($pattern=~m/3.4/ix){$is_NEW_EXC_SORT="no"};
#
$do_NL_tests="yes";
$is_NEW_YPP="yes";
$PAR_COMP="-j";
$PAR_COMP_LIB="";
if ($pattern=~m/bug-fixes/ix) {$PAR_COMP_LIBS="-j";};
if ($pattern=~m/4.5/ix) {undef $is_NEW_driver;};
if ($pattern=~m/4.4/ix) {undef $is_NEW_driver;};
if ($pattern=~m/4.3/ix) {undef $do_NL_tests; undef $is_NEW_driver;};
if ($pattern=~m/4.2/ix) {undef $is_NEW_YPP ; undef $do_NL_tests; undef $is_NEW_driver;};
if ($pattern=~m/4.1/ix) {undef $is_NEW_YPP ; undef $do_NL_tests; undef $is_NEW_driver;};
if ($pattern=~m/4.0/ix) {undef $is_NEW_YPP ; undef $do_NL_tests; undef $is_NEW_driver; undef $PAR_COMP;};
if ($pattern=~m/3.4/ix) {undef $is_NEW_YPP ; undef $do_NL_tests; undef $is_NEW_driver; undef $PAR_COMP;};
#
undef $is_PAR_SETUP;
if ($pattern=~m/devel-phonon-dynamics/ix) {$is_PAR_SETUP=1;};
#
$is_NEW_scatt=1;
#
undef $is_WF_convertion_free;
if ($pattern=~m/devel-phonon-dynamics/ix) {$is_WF_convertion_free=1;};
#
$do_A2Y_tests="yes";
$PAR_covariant="yes";
if ($pattern=~m/4.4/ix)   {                     undef $PAR_covariant;};
if ($pattern=~m/4.3/ix)   {undef $do_A2Y_tests; undef $PAR_covariant;};
if ($pattern=~m/4.2/ix)   {undef $do_A2Y_tests; undef $PAR_covariant;};
if ($pattern=~m/4.1/ix)   {undef $do_A2Y_tests; undef $PAR_covariant;};
if ($pattern=~m/4.0/ix)   {undef $do_A2Y_tests; undef $PAR_covariant;};
if ($pattern=~m/3.4/ix)   {undef $do_A2Y_tests; undef $PAR_covariant;};
#
# Define list of required executables
$target_list = $target_list_basic; 
$exec_list   = $exec_list_basic;
#
# If project = all or user-selected 
if ($project =~ /magnetic/ or $project =~ /sc/ or  $project eq "all") { $target_list .= $exec_sc; $exec_list  .= $exec_sc};
if ($project =~ /rt/ or $project eq "all")       { $target_list .= $exec_rt; $exec_list  .= $exec_rt};
if ($project =~ /elph/ or $project eq "all")     { $target_list .= $exec_elph; $exec_list  .= $exec_elph};
if ($project =~ /phel/ or $project eq "all")     { $target_list .= $exec_phel; $exec_list  .= $exec_phel};
if (($project =~ /nl/ or $project eq "all" ) and $do_NL_tests ) { $target_list .= $exec_nl; $exec_list  .= $exec_nl};
#
return "OK";
}
sub LOAD_branches{
open(BRANCHES_file,"<","$suite_dir/ROBOTS/$host/$user/BRANCHES");
my @BLINES = <BRANCHES_file>;
my $line;
my $ib=-1;
while($line = shift(@BLINES)) {
 chomp($line);
 next if ( ($line =~ /#/) or ($line eq "") );
 $ib++;
 my @spl = split(' ', $line);
 $n_spl=@spl;
 $branches[$ib]=$spl[0];
 if ($n_spl>1) {
  $branch_identity[$ib]=$spl[1];
 }else{
  $branch_identity[$ib]=(split('\/',$branches[$ib]))[-1];
 };
 if ($n_spl>2) {
  $driver_branch[$ib]=$spl[2];
 }else{
  $driver_branch[$ib]="none";
 };
}
close(BRANCHES_file);
}
1;
