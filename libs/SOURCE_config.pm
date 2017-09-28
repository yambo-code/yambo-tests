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
sub SOURCE_config{
 #
 chdir $BRANCH;
 #
 # Configure and compilation logs (full paths)
 $conf_logfile = "$suite_dir/"."config-$ROBOT_string.log";
 $comp_logfile = "$suite_dir/"."compile-$ROBOT_string.log";
 #
 # If Makefile present, clean sources
 if(-e "Makefile") { $result = `make clean_all 2>&1` };
 #
 # Run this configure script, and log (append) the output, including STDOUT and STDERR
 # Backticks capture the output
 #
 &MY_PRINT($stdout, "Configuring ...");
 open( CONFLOGFILE,'>>',$conf_logfile);
 &command("$suite_dir/$conf_path >> $conf_logfile 2>&1");
 #$result = `$suite_dir/$conf_path 2>&1`;
 #print CONFLOGFILE $result;
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
