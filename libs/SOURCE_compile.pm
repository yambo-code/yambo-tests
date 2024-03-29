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
sub SOURCE_compile{
 chdir("$comp_folder"); 
 open( COMPLOGFILE,'>>',$comp_logfile);
 &MY_PRINT($stdout, "ext-libs ...");
 &command("make $PAR_COMP_LIBS ext-libs >> $comp_logfile 2>&1");
 @executables =  ("yambo");
 if (not $compile eq "ext-libs")  {
   &command("rm -rf bin");
   @executables = split(/\s+/, $target_list)
 };
 foreach $make_exec (@executables) {
   &MY_PRINT($stdout, "$make_exec ...");
   &command("make $PAR_COMP $make_exec >> $comp_logfile 2>&1");
   if (not $make_exec =~ /ext-libs/ and not $make_exec =~ /interfaces/)
   {
     if (not -x "$comp_folder/bin/$make_exec") {
      &MY_PRINT($stdout, "FAILED! Skipping.\n");
      return "FAIL";
     }
   }
 };
 close(COMPLOGFILE);
 &MY_PRINT($stdout, "done.");
 chdir $suite_dir;
 return "OK";
}
1;
