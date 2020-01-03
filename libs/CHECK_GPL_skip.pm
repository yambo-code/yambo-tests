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
sub CHECK_GPL_skip{
#
if ($is_GPL) 
{
 undef $skip_the_file;
 #if ("@_" =~ /.external_field/ ) { $skip_the_file="yes" };
 if ("@_" =~ /.energy/         ) { $skip_the_file="yes" };
 if ("@_" =~ /.carriers/       ) { $skip_the_file="yes" };
 if ("@_" =~ /.magnetization/  ) { $skip_the_file="yes" };
 if ("@_" =~ /.thermodynamics/ ) { $skip_the_file="yes" };
 if ("@_" =~ /.ean_RADlifetimes/ ) { $skip_the_file="yes" };
 #
 if ($skip_the_file){
  return "SKIP";
 }
}
return "OK";
#
}
1;
