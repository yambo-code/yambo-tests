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
 $comp_folder  = "$suite_dir/"."compile_${branch_key}_${conf_name}";
 #
 # If Makefile present, clean sources
 if(-e "config/report") { $result = `make clean_all 2>&1` };
 #
 # Run this configure script, and log (append) the output, including STDOUT and STDERR
 # Backticks capture the output
 #
 &MY_PRINT($stdout, "Configuring ...");
 #
 if(!-d $comp_folder) { &command("mkdir $comp_folder"); };
 chdir("$comp_folder");
 &command("cat $suite_dir/$conf_path > conf_local.sh");
 $string1="\.\/configure";
 $string2="$BRANCH/configure";
 $string1=~ s/\//\\\//ig;
 $string2=~ s/\//\\\//ig;
 my $cmd_sed="sed -i \"s/$string1/$string2/g\" conf_local.sh";
 &command($cmd_sed);
 &command("chmod +x conf_local.sh");
 #
 open( CONFLOGFILE,'>>',$conf_logfile);
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
