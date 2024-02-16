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
# Compilation folder
#
if ( $user_comp_folder eq "" ){
  $comp_folder = $BRANCH ;
}else{
  chdir "/";
  if ( -d $user_comp_folder){
    $comp_folder = "$user_comp_folder" ;
  } else {
    $comp_folder="${suite_dir}/$user_comp_folder";
  }
  chdir $suite_dir;
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
 $conf_bin  = "$comp_folder/bin";
 if ($keep_bin) {$conf_bin  = "$suite_dir/bin-precompiled-$ROBOT_string-$branch_key"};
 &MY_PRINT($stdout, "\n -       Source Check : precompiled ($conf_bin) ... ");
 $bin_check=&exe_check;
 if ( "$bin_check" eq "FAIL") {
  &MY_PRINT($stdout, "\n\nCore executable missing from $conf_bin, skipping...\n");
  return "FAIL";
 }
}
#
if ($compile) {
 #
 &MY_PRINT($stdout, "\n -   Source configure :");
 chdir $BRANCH;
 &MY_PRINT($stdout, " Checking out as $branch_id ...");
 &MY_PRINT($stdout, "Updating (1) ...");
 &command("$git pull -q --no-rebase");
 &command("$git checkout $branch_id -q");
 &MY_PRINT($stdout, "Updating (2) ...");
 &command("$git pull -q --no-rebase");
 &command("$git submodule update --recursive --remote");
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
  $REVISION="unknown";
  $BUILD="FAILED";
  return "CONF FAIL";
 }
 #
 chdir $suite_dir;
 #
}
#
# FC kind/Precision & CUDA
#
if ($compile) { 
 &SETUP_FC_kind;
}elsif (not $FC_kind){
 &SETUP_FC_kind;
};
#
# CUDA => mpi_is_off (serial runs)
#
if ($CUDA_support eq "yes") { $mpi_is_off="yes"};
#
# BIN's
if ("$precompiled_is_run" eq "yes" and not $keep_bin) {
 $conf_bin  = "$suite_dir/bin-precompiled-$ROBOT_string-$branch_key_no_slash";
 &command("rm -fr $conf_bin; mkdir $conf_bin");
 chdir $comp_folder;
 @executables = split(/\s+/, $exec_list);
 while($exec = shift(@executables)) {&command("cp bin/$exec $conf_bin/")};
 if (-f "lib/bin/ncdump") {
  &command("cp lib/bin/ncdump $conf_bin/");
 }
 chdir $suite_dir;
}elsif (not $keep_bin){
 $conf_bin  = "$suite_dir/bin-$conf_file-$FC_kind-$ROBOT_string-$branch_key_no_slash";
}
#
# branch string
#
$branch=$branch_key_no_slash."-".$conf_file;
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
   $REVISION="unknown";
   $BUILD="FAILED";
   return "COMP FAIL";
  }
  chdir("$comp_folder");
  &command("rm -fr $conf_bin; cp -fr bin $conf_bin");
  &command("if [ -d lib/bin  ]; then cp lib/bin/*  $conf_bin/; fi");
  &command("if [ -d bin-libs ]; then cp bin-libs/* $conf_bin/; fi");
  &MY_PRINT($stdout,  "\n -       Source Check : compiled ($conf_bin) ... ");
  $bin_check=&exe_check;
  if ( "$bin_check" eq "FAIL") {
   &MY_PRINT($stdout, "\n\nCore executable missing from $conf_bin, skipping...\n");
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
# NCDUMP
#
my $sys_ncdump = `which ncdump`; 
chomp($sys_ncdump);
if (-e "$conf_bin/ncdump") {
 $ncdump = "$conf_bin/ncdump"; 
 chomp($ncdump);
}elsif(-e "$comp_folder/lib/bin/ncdump") { 
 $ncdump = "$$comp_folder/lib/bin/ncdum"; 
 chomp($ncdump);
}elsif(-e $sys_ncdump) { 
 $ncdump = "$sys_ncdump"; 
}else{ 
 die "\n ncdump not found\n";
}
&MY_PRINT($stdout, "\n               ncdump : $ncdump");
#
# Rename the conf/comp logs
#
if ($compile) {&LOGs_move};
#
# LOCK
$BRANCH_is_correctly_compiled[$ib]=1;
#
#$init_end_time = [gettimeofday];
#$TT  = tv_interval($init_start_time, $init_end_time);
#
#$sec = &ceil(10.*$TT)/10.;
#$msg = "Initialization time $sec s";
#
#&MY_PRINT($stdout, "\n$msg\n");
#&MY_PRINT($rlog,   "\n$msg\n");
#
return "OK";
}
sub exe_check{
 @executables = split(/\s+/, $exec_list);
 while($make_exec = shift(@executables)) {
  if( -x "$conf_bin/$make_exec") 
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
 chdir $comp_folder;
 my $extension=$branch_key_no_slash.'-'.$FC_kind.'-'.$conf_file.'-'.$ROBOT_string.'-'.$host;
 &command ("mv $conf_logfile $suite_dir/$extension"."_config.log");
 &command ("mv $comp_logfile $suite_dir/$extension"."_compile.log");
 chdir $suite_dir;
}
1;
