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
sub RUN_load_conf{
#
# CONF
#
$prec = $default_prec;
undef $skip_this_test;
if( -e "$input_folder/$testname.conf") {
 open(CONF,"<","$input_folder/$testname.conf");
 while($confline = <CONF>) {
  chomp $confline;
  ($desc, $value) = split(/\s+/,$confline);
  # Test precision
  if($desc =~ m/precision/) { 
   &MY_PRINT($stdout, "** Changing precision for $testname to: $value \n") if ($verb);
   $prec = $value;
  };
  # P2Y
  if($desc =~ m/format/ && $yambo_exec =~ /\/p2y/) { 
   &MY_PRINT($stdout, "** Setting P2Y format for $testname to: $value \n") if ($verb);
   $P2Y_format = $value;
  }
  if($desc =~ m/datadir/ && $yambo_exec =~ /\/p2y/) { 
   &MY_PRINT($stdout, "** Setting P2Y datadir for $testname to: $value \n") if ($verb);
   $P2Y_datadir = $value;
   chdir($P2Y_datadir);
  }
  if($desc =~ m/datafile/ && $yambo_exec =~ /\/p2y/) { 
   &MY_PRINT($stdout, "** Setting P2Y datafile for $testname to: $value \n") if ($verb);
   $P2Y_datafile = $value;
  }
  # A2Y
  if($desc =~ m/datadir/ && $yambo_exec =~ /\/a2y/) { 
   &MY_PRINT($stdout, "** Setting A2Y datadir for $testname to: $value \n") if ($verb);
   $A2Y_datadir = $value;
   chdir($A2Y_datadir);
  }
  if($desc =~ m/datafile/ && $yambo_exec =~ /\/a2y/) { 
   &MY_PRINT($stdout, "** Setting A2Y datafile for $testname to: $value \n") if ($verb);
   $A2Y_datafile = $value;
  }
  # GPL 
  if($confline =~ /"no GPL"/) { 
   $skip_this_test = "1";
  }
 };
 close(CONF);
}
#
}
1;
