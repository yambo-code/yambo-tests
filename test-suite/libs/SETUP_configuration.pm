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
sub SETUP_configuration{
#
# Options: all/$select_conf_file/precompiled (default)
# If one conf has been given in input, ignore all the others
#
$conf_file = (split(/\//, $conf_path))[-1];
$conf_bin  = "bin-$conf_file";
if ($select_conf_file){
 my $conf_match;
 my @confs = split(/ /,$select_conf_file);
 foreach my $conf (@confs) {
  if ($conf_file =~ /$conf/ or $conf eq "all"){ $conf_match=1};
 }
 if (not $conf_match) {return "FAIL"};
} 
else {
 if ($compile) {
  if (not $conf_file =~ "default.sh"){ return "FAIL"};
  $conf_file = "default.sh";
  $conf_bin  = "bin-default.sh";
 } else {
  if ("$precompiled_is_run" eq "yes") { return "FAIL"};
  $conf_file = "precompiled";
  $conf_bin  = "bin";
  $precompiled_is_run = "yes";
 }
}
#
# If bin is present with all exe's skip the compilation
#
my $do_it ="no";
if ($compile) { $do_it ="yes" };
if ("$do_it" eq "yes") {
 @executables = split(/ /, $exec_list);
 my $found="yes";
 while($make_exec = shift(@executables)) {
  if (!-x "$BRANCH/$conf_bin/$make_exec") { $found= "no" };
 }
 if ( "$found" eq "yes" ) { $do_it ="no" };
 if ( "$found" eq "no"  ) { $do_it ="yes" };
}
#
# Compile the code if requested
#
if("$do_it" eq "yes") {
 #
 chdir $BRANCH;
 &MY_PRINT($stdout, "\n             Compiling using $conf_file >");
 &MY_PRINT($stdout, "Updating ...\n");
 &command("git pull &> /dev/null");
 &MY_PRINT($stdout, "                          > Configuring sources...");
 # Configure and compilation logs (full paths)
 $conf_logfile = "$suite_dir/"."config.log";
 $comp_logfile = "$suite_dir/"."compile.log";
 # If Makefile present, clean sources
 if(-e "Makefile") {
  $result = `make clean_all 2>&1`;
 };
 #
 # Run this configure script, and log (append) the output, including STDOUT and STDERR
 # Backticks capture the output
 #
 $result = `$suite_dir/$conf_path 2>&1`;
 open( CONFLOGFILE,'>>',$conf_logfile);
 print CONFLOGFILE $result;
 close(CONFLOGFILE);
 #
 # Basic check that configure worked
 #
 if (-e "Makefile"){ &MY_PRINT($stdout, "success.\n")}
 else {
  &MY_PRINT($stdout, "FAILED! Skipping.\n");
  return "FAIL";
 }
 #
 # Compile the required executables, log the output
 # Split the targets or use system in some way for refreshed output, but redirecting standard error (tee?)
 #
 &MY_PRINT($stdout, " - Requested targets  : $target_list\n ");
 #
 &MY_PRINT($stdout, "                         > Compiling : ");
 open( COMPLOGFILE,'>',$comp_logfile);
 @executables = split(/ /, $target_list);
 foreach $make_exec (@executables) {
   &MY_PRINT($stdout, "$make_exec ...");
   $result = `make -j $make_exec 2>&1`;
   print COMPLOGFILE $result;
 }
 close(COMPLOGFILE);
 &MY_PRINT($stdout, "done.");
 #
 # Copy executables to a config-dependent directory
 # This will OVERWRITE any existing files
 #
 if (not $conf_bin eq "bin") {&command("rm -fr $conf_bin; cp -fr bin $conf_bin")};
 #
 chdir $suite_dir;
}  
# system/compiled ncdump/nccopy if available. Otherwise exit.
my $sys_ncdump = `which ncdump`; chomp($sys_ncdump);
#
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
my $sys_nccopy = `which nccopy`; chomp($sys_nccopy);
#
if (-e "$BRANCH/$conf_bin/nccopy") {
 $nccopy = "$BRANCH/$conf_bin/nccopy"; 
 chomp($nccopy);
 &MY_PRINT($stdout, "\n               nccopy : $nccopy");
}elsif(-e $sys_nccopy) { 
 $nccopy = "$sys_nccopy"; 
 &MY_PRINT($stdout, "\n               nccopy : $nccopy");
}else{ 
 undef $nccopy;
}
#
# Check the yambo executables exist
# If not $compile, use existing executables
#
chdir $suite_dir;
&MY_PRINT($stdout, "\n -  Executable checks : ");
@executables = split(/ /, $exec_list);
for $check_exec (@executables){
 if( -x "$BRANCH/$conf_bin/$check_exec") 
 { 
  &MY_PRINT($stdout, "($check_exec $g_s OK $g_e) ")
 }else{
  &MY_PRINT($stdout, "($check_exec $r_s FAIL $r_e)")
  &MY_PRINT($stdout, "\n\nCore executable missing from $BRANCH, skipping...\n");
  return "FAIL";
 };
}
$branch=$dir."-".$conf_file;
#
# Get the FC kind
#
&SETUP_FC_kind;
#
# Rename the conf/comp logs
#
my $extension=$branch_key.'-'.$conf_file.'-'.$FC_kind.'-'.$host;
&command ("mv $conf_logfile $suite_dir/$extension"."_config.log");
&command ("mv $comp_logfile $suite_dir/$extension"."_compile.log");
#
# Get the build string (useful to understand if the code is compiled with MPI,SLK and OpenMP)
#
my $ERROR=&SETUP_build;
if (not "$ERROR" eq "OK") {
 &MY_PRINT($stdout, "\n$ERROR. Code build is $BUILD, skipping...\n");
 return "FAIL";
}
#
&UTILS_title($stdout);
#
&MY_PRINT($stdout, "\n$line");
return "OK";
}
1;
