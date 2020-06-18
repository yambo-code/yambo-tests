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
if( ! -f "$BRANCH/driver/driver.c")  { &MY_PRINT($stdout, "ERROR: cannot find $branchdir, skipping!\n"); return "FAIL"; };
#
my $pattern;
if ($branch_id eq "") 
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
#
if ($is_GPL) {$branch_key.="_gpl"; $pattern.="_gpl";};
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
$is_NEW_DBGD="yes";
if ($pattern=~m/4.5/ix){$is_NEW_DBGD="no"};
if ($pattern=~m/4.4/ix){$is_NEW_DBGD="no"};
if ($pattern=~m/4.3/ix){$is_NEW_DBGD="no"};
if ($pattern=~m/4.2/ix){$is_NEW_DBGD="no"};
if ($pattern=~m/4.1/ix){$is_NEW_DBGD="no"};
if ($pattern=~m/4.0/ix){$is_NEW_DBGD="no"};
if ($pattern=~m/3.4/ix){$is_NEW_DBGD="no"};
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
if ($pattern=~m/gpl/ix) {undef $is_NEW_driver;};
if ($pattern=~m/4.5/ix) {undef $is_NEW_driver;};
if ($pattern=~m/4.4/ix) {undef $is_NEW_driver;};
if ($pattern=~m/4.3/ix) {undef $do_NL_tests; undef $is_NEW_driver;};
if ($pattern=~m/4.2/ix) {undef $is_NEW_YPP; undef $do_NL_tests; undef $is_NEW_driver;};
if ($pattern=~m/4.1/ix) {undef $is_NEW_YPP; undef $do_NL_tests; undef $is_NEW_driver;};
if ($pattern=~m/4.0/ix) {undef $is_NEW_YPP; undef $do_NL_tests; undef $is_NEW_driver; undef $PAR_COMP;};
if ($pattern=~m/3.4/ix) {undef $is_NEW_YPP; undef $do_NL_tests; undef $is_NEW_driver; undef $PAR_COMP;};
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
if ($project =~ /sc/ or $project eq "all")       { $target_list .= $exec_sc; $exec_list  .= $exec_sc};
if ($project =~ /rt/ or $project eq "all")       { $target_list .= $exec_rt; $exec_list  .= $exec_rt};
if ($project =~ /elph/ or $project eq "all")     { $target_list .= $exec_elph; $exec_list  .= $exec_elph};
if ($project =~ /kerr/ or $project eq "all")     { $target_list .= $exec_kerr; $exec_list  .= $exec_kerr};
#if ($project =~ /pl/ or $project eq "all")       { $target_list .= $exec_pl; $exec_list   .= $exec_pl};
if ($project =~ /magnetic/ or $project eq "all") { $target_list .= $exec_magn; $exec_list   .= $exec_magn};
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
 ($branches[$ib],$branch_identity[$ib],$branch_robot[$ib]) = split ' ', $line;
}
close(BRANCHES_file);
}
1;
