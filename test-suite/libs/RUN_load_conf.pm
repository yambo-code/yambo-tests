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
sub RUN_load_conf{
$prec = $default_prec;
if( -e "$input_folder/$testname.conf") {
 open(CONF,"<","$input_folder/$testname.conf");
 while($confline = <CONF>) {
  chomp $confline;
  ($desc, $value) = split(/\s+/,$confline);
  # Test precision
  if($desc =~ m/precision/) { 
   &MY_PRINT($stdout, "** Changing precision for $testname to: $value \n");
   $prec = $value;
  }
 }
}
}
1;
