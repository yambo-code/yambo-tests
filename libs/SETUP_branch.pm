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
}elsif($branchdir =~ /^\//) {
 my @subdirs = File::Spec->splitdir( $branchdir );  
 # Make shortname from last two subdirs in full path
 $dir= @subdirs[-2]."_".@subdirs[-1];
 # Make shortname from last two subdirs in full path
 $dir_id= @subdirs[-1];
}
if( ! -f "$BRANCH/driver/driver.c")  { &MY_PRINT($stdout, "ERROR: cannot find $branchdir, skipping!\n"); return "FAIL"; };
#
# Define list of required executables
$target_list = $target_list_basic; 
$exec_list   = $exec_list_basic;
#
# If project = all or user-selected 
if ($project =~ /sc/ or $project eq "all")   { $target_list .= $exec_sc; $exec_list  .= $exec_sc};
if ($project =~ /rt/ or $project eq "all")   { $target_list .= $exec_rt; $exec_list  .= $exec_rt};
if ($project =~ /elph/ or $project eq "all") { $target_list .= $exec_elph; $exec_list  .= $exec_elph};
if ($project =~ /kerr/ or $project eq "all") { $target_list .= $exec_kerr; $exec_list  .= $exec_kerr};
if ($project =~ /nl/ or $project eq "all")   { $target_list .= $exec_nl; $exec_list  .= $exec_nl};
if ($project =~ /magnetic/ or $project eq "all") { $target_list .= $exec_magn; $exec_list   .= $exec_magn};
if ($project =~ /pl/ or $project eq "all")       { $target_list .= $exec_pl; $exec_list   .= $exec_pl};
#
# branch and branch_key (to be used in reports/actions)
$is_OLD_IO="no";
if ($BRANCH=~m/4.1/ix) {$is_OLD_IO="yes"};
#
$is_NEW_WF="no";
if ($BRANCH=~m/devel-wf-io/ix)  {$is_NEW_WF="yes"};
if ($BRANCH=~m/master/ix)       {$is_NEW_WF="yes"};
if ($BRANCH=~m/bug-fixes/ix)    {$is_NEW_WF="yes"};
if ($BRANCH=~m/SLK/ix)          {$is_NEW_WF="yes"};
if ($BRANCH=~m/devel-io/ix)     {$is_NEW_WF="yes"};
if ($BRANCH=~m/devel-nl/ix)     {$is_NEW_WF="yes"};
if ($BRANCH=~m/devel-slepc/ix)  {$is_NEW_WF="yes"};
if ($BRANCH=~m/devel-rt/ix)     {$is_NEW_WF="yes"};
if ($BRANCH=~m/devel-ypp/ix)    {$is_NEW_WF="yes"};
if ($BRANCH=~m/devel-dipoles/ix){$is_NEW_WF="yes"};
if ($BRANCH=~m/devel-double-grid/ix){$is_NEW_WF="yes"};
if ($BRANCH=~m/max-release/ix)  {$is_NEW_WF="yes"};
#
$is_NEW_DBGD="no";
if ($BRANCH=~m/devel-double-grid/ix){$is_NEW_DBGD="yes"};
#
if ($BRANCH=~m/max-release-GPL/ix) {$is_GPL="yes"};
if ($is_GPL)  {$is_NEW_WF="yes"};
#
if ($branch_id eq "") 
{
 $branch_key=$dir;
 $branch_key =~ s/_/ /;
 my @locals = split(' ', $branch_key);
 $branch_key=@locals[1];
}else{
 $branch_key=$branch_id
};
if ($is_GPL) {$branch_key.="_gpl"};
return "OK";
}
sub LOAD_branches{
open(BRANCHES_file,"<","$suite_dir/ROBOTS/$host/$user/BRANCHES");
my @BLINES = <BRANCHES_file>;
my $line;
my $ib=-1;
while($line = shift(@BLINES)) {
 chomp($line);
 next if ($line =~ /#/);
 $ib++;
 ($branches[$ib],$branch_identity[$ib],$branch_robot[$ib]) = split(/ /, $line);
}
close(BRANCHES_file);
}
1;
