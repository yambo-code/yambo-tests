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
sub SOURCE_config{
 #
 use File::Basename;
 #
 chdir("$BRANCH");
 #
 $conf_name=basename($conf_path);
 #
 # Configure and compilation logs (full paths)
 $conf_logfile = "$suite_dir/"."config-$ROBOT_string.log";
 $comp_logfile = "$suite_dir/"."compile-$ROBOT_string.log";
 $comp_folder  = "$suite_dir/"."compile_dir/"."${branch_key_no_slash}";
 if ($user_module) {$comp_folder  = "$comp_folder/$user_module/"};
 $comp_folder  = "$comp_folder/$conf_name/";
 #
 # If Makefile present, clean sources
 if(-e "config/report") { $result = `make clean_all 2>&1` };
 #
 # Run this configure script, and log (append) the output, including STDOUT and STDERR
 # Backticks capture the output
 #
 &MY_PRINT($stdout, "Configuring ...");
 #
 if(!-d $comp_folder) { &command("mkdir -p $comp_folder"); };
 chdir("$comp_folder");
 &command("rm -f conf_local.sh");
 if (not $ext_libs_path eq "none" and $user_module) {
  open(FH, '<', "$suite_dir/$conf_path") or die $!;
  while(<FH>){
   if ($_ =~ /OPENMP=/) {$OPENMP_IOs=(split("=",$_))[1]};
   if ($_ =~ /MPI=/) {$MPIs=(split("=",$_))[1]};
   if ($_ =~ /PAR_LINALG=/) {$PAR_LINALGs=(split("=",$_))[1]};
   if ($_ =~ /PAR_IO=/) {$PAR_IOs=(split("=",$_))[1]};
  }
  $OPENMP_IOs =~ s/"//g;
  $MPIs =~ s/"//g;
  $PAR_LINALGs =~ s/"//g;
  $PAR_IOs =~ s/"//g;
  close(FH);
  chomp($OPENMP_IOs);
  chomp($MPIs);
  chomp($PAR_LINALGs);
  chomp($PAR_IOs);
  $EXT_LIB="$ext_libs_path/${user_module}/MPI-${MPIs}_PAR_IO-${PAR_IOs}_PAR_LINALG-${PAR_LINALGs}";
  &command("echo YAMBO_EXT_LIBS=$EXT_LIB > conf_local.sh");
 }else{
  &command("echo YAMBO_EXT_LIBS=$comp_folder/lib/external > conf_local.sh")
 };
 #
 # Create a new module if absent
 #
 $mod_file="$ext_modules_path/$user_module/MPI-${MPIs}_PAR_IO-${PAR_IOs}_PAR_LINALG-${PAR_LINALGs}";
 if (not $ext_modules_path eq "none" and $user_module and not -f $mod_file) {
  &command("mkdir -p $ext_modules_path");
  &command("mkdir -p $ext_modules_path/$user_module");
  &MY_PRINT($rlog, "\n"."New module created      :$mod_file");
  open(MOD, '>', "$mod_file");
  print MOD "#%Module";
  open(FH, '<', "$suite_dir/ROBOTS/$host/$user/MODULES") or die "Could not open MODULES file";
  undef $use_me;
  while (<FH>){
   if ($_ =~ /START $user_module/) {$use_me=1; next};
   if ($_ =~ /END/) {undef $use_me};
   if ($use_me) {print MOD "\n"."module load $_"};
  }
  close(FH);
  print MOD "\n"."setenv YAMBO_EXT_LIBS $EXT_LIB";
  my @FCs = ("gfortran/mpifort", "gfortran/mpif90", "nvfortran/mpif90"); 
  my $NC_PATH="$EXT_LIB/intel/mpiifort/v4/serial:$EXT_LIB/intel/mpiifort/v4/parallel";
  foreach my $fc (@FCs) {
    $NC_PATH="$NC_PATH:$EXT_LIB/$fc/v4/serial/bin:$EXT_LIB/$fc/v4/parallel/bin";
  }
  print MOD "\n"."prepend-path PATH $NC_PATH";
  close(MOD);
 }
 if (not $driver_branch eq "none") {
  &command("echo DRIVER_LINE=--with-yambo-libs-branch=$driver_branch >> conf_local.sh");
 }
 &command("cat $suite_dir/$conf_path >> conf_local.sh");
 $string1="\.\/configure";
 $string2="$BRANCH/configure";
 $string1=~ s/\//\\\//ig;
 $string2=~ s/\//\\\//ig;
 my $cmd_sed="sed -i \"s/$string1/$string2/g\" conf_local.sh";
 &command($cmd_sed);
 &command("chmod +x conf_local.sh");
 #
 open( CONFLOGFILE,'>>',$conf_logfile);
 &command("make distclean >> $conf_logfile 2>&1");
 &command("./conf_local.sh >> $conf_logfile 2>&1");
 close(CONFLOGFILE);
 #
 if (-e "Makefile"){ 
  &MY_PRINT($stdout, "success.")
 } else {
  &MY_PRINT($stdout, "FAILED! Skipping.\n");
  chdir $suite_dir;
  return "FAIL";
 }
 #
 chdir $suite_dir;
 #
}
1;
