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
sub SOURCE_driver{
#
# CONF FILE
$conf_file = (split(/\//, $conf_path))[-1];
if ($select_conf_file){
 my $conf_match;
 my @confs = split(/ /,$select_conf_file);
 foreach my $conf (@confs) {
  if ($conf_file =~ /$conf/ or $conf eq "all"){ $conf_match=1};
 }
 if (not $conf_match) {return "FAIL"};
} else {
 if ($compile) {
  if (not $conf_file =~ "default.sh"){ return "FAIL"};
  $conf_file = "default.sh";
 } else {
  if ("$precompiled_is_run" eq "yes") { return "FAIL"};
  $conf_file = "precompiled";
  $precompiled_is_run = "yes";
 }
}
#
if ($BRANCH_is_correctly_compiled[$ib]) {
 if($BUILD =~ /OpenMP/ and !$nt) {$openmp_is_off="yes"};
 return "OK";
};
#
# Already compiled and failed?
#
if ($FAILED_conf_comp_branches) {
 if ($FAILED_conf_comp_branches =~ /$branch_id/) {return "FAIL"};
}
#
# Precompiled (bin) exe's test
#
if ("$precompiled_is_run" eq "yes") {
 &MY_PRINT($stdout, "\n -       Source Check : precompiled (bin) ... ");
 $conf_bin  = "bin";
 $bin_check=&exe_check;
 if ( "$bin_check" eq "FAIL") {
  &MY_PRINT($stdout, "\n\nCore executable missing from $BRANCH/$conf_bin, skipping...\n");
  return "FAIL";
 }
}
#
if ($compile) {
 #
 &MY_PRINT($stdout, "\n -   Source configure :");
 chdir $BRANCH;
 &MY_PRINT($stdout, " Checking out as $branch_id ...");
 &command("$git checkout $branch_id -q");
 &MY_PRINT($stdout, "Updating ...");
 &command("$git pull -q");
 #
 # CHECK AGE
 #
 if ($max_delay_commits) {
  $ERROR=&SOURCE_delay;
  if ("$ERROR" eq "FAIL") {return "FAIL"};
 };
 #
 # CONFIG
 $ERROR=&SOURCE_config;
 if ("$ERROR" eq "FAIL") {
  &LOGs_move;
  $FAILED_conf_comp_branches.="$branch_id ";
  return "FAIL";
 }
 #
 chdir $suite_dir;
 #
}
#
# FC kind
#
if ($compile) { 
 &SETUP_FC_kind;
}elsif (not $FC_kind){
 &SETUP_FC_kind 
};
#
# BIN's
if ("$precompiled_is_run" eq "yes") {
 $conf_bin  = "bin-precompiled-$ROBOT_string";
 chdir $BRANCH;
 &command("rm -fr $conf_bin; cp -fr bin $conf_bin");
 &command("if [ -d libs/bin ]; then cp libs/bin/* $conf_bin/; fi");
 chdir $suite_dir;
}else{
 $conf_bin  = "bin-$conf_file-$FC_kind-$ROBOT_string";
}
#
# branch string
#
$branch=$branch_key."-".$conf_file;
#
if ($compile)
{
 #
 # Check if already compiled
 #
 &MY_PRINT($stdout,  "\n -       Source Check : precompiled ($conf_bin) ... ");
 $bin_check=&exe_check;
 #
 if ( "$bin_check" eq "FAIL") { 
  &MY_PRINT($stdout, "\n - Source compilation : bin is $conf_bin...");
  $ERROR=&SOURCE_compile;
  if ("$ERROR" eq "FAIL") {
   &LOGs_move;
   $FAILED_conf_comp_branches.="$branch_id ";
   if ($backup_logs eq "yes"){ &UTILS_backup };
   return "FAIL";
  }
  chdir $BRANCH;
  &command("rm -fr $conf_bin; cp -fr bin $conf_bin");
  &command("if [ -d libs/bin ]; then cp libs/bin/* $conf_bin/; fi");
  &MY_PRINT($stdout,  "\n -       Source Check : compiled ($conf_bin) ... ");
  $bin_check=&exe_check;
  if ( "$bin_check" eq "FAIL") {
   &MY_PRINT($stdout, "\n\nCore executable missing from $BRANCH/$conf_bin, skipping...\n");
   &LOGs_move;
   return "FAIL";
  }
  chdir $suite_dir;
 }else{
  undef $compile;
 }
}
#
# Get the build string (useful to understand if the code is compiled with MPI,SLK and OpenMP)
#
my $ERROR=&SETUP_build;
if (not "$ERROR" eq "OK") {
 &MY_PRINT($stdout, "\n$ERROR. Code build is $BUILD, skipping...\n");
 &LOGs_move;
 return "FAIL";
}
#
# NCDUMP/NCCOPY
#
my $sys_ncdump = `which ncdump`; chomp($sys_ncdump);
my $sys_nccopy = `which nccopy`; chomp($sys_nccopy);
if (-e "$BRANCH/$conf_bin/ncdump") {
 $ncdump = "$BRANCH/$conf_bin/ncdump"; 
 chomp($ncdump);
 &MY_PRINT($stdout, "\n               ncdump : $ncdump");
}elsif(-e $sys_ncdump) { 
 $ncdump = "$sys_ncdump"; 
 &MY_PRINT($stdout, "\n               ncdump : $ncdump");
}else{ 
 die "\n ncdump not found\n";
}
if (-e "$BRANCH/$conf_bin/nccopy") {
 $nccopy = "$BRANCH/$conf_bin/nccopy"; 
 chomp($nccopy);
 &MY_PRINT($stdout, "\n               nccopy : $nccopy");
}elsif(-e $sys_nccopy) { 
 $nccopy = "$sys_nccopy"; 
 &MY_PRINT($stdout, "\n               nccopy : $nccopy");
}else{ 
 &MY_PRINT($stdout, "\n               nccopy : not found");
}
#
# Rename the conf/comp logs
#
if ($compile) {&LOGs_move};
#
# LOCK
$BRANCH_is_correctly_compiled[$ib]=1;
#
return "OK";
}
sub exe_check{
 @executables = split(/\s+/, $exec_list);
 while($make_exec = shift(@executables)) {
  if( -x "$BRANCH/$conf_bin/$make_exec") 
  { 
   &MY_PRINT($stdout, "($make_exec $g_s OK $g_e) ");
  }else{
   &MY_PRINT($stdout, "($make_exec $r_s FAIL $r_e)");
   return "FAIL";
  };
 };
 return "OK";
}
sub SOURCE_delay{
 $result=`$git log --pretty=format:"%cd" | head -n 1`;
 chomp($result);
 my @rs=split(' ', $result);
 my $day= &UTILS_day($rs[1],$rs[2]);
 my $delay=$INITIAL_day-$day+($INITIAL_year-$rs[4])*365;
 #
 if ($delay > $max_delay_commits)
 {
  &MY_PRINT($stdout, "$branch_id is $delay day(s) old. Skipped.\n");
  chdir $suite_dir;
  return "FAIL";
 }
}
sub LOGs_move{
 chdir $BRANCH;
 my $extension=$branch_key.'-'.$FC_kind.'-'.$conf_file.'-'.$ROBOT_string.'-'.$host;
 &command ("mv $conf_logfile $suite_dir/$extension"."_config.log");
 &command ("mv $comp_logfile $suite_dir/$extension"."_compile.log");
 chdir $suite_dir;
}
1;
