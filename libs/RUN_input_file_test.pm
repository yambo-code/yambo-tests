#
#        Copyright (C) 2000-2019 the YAMBO team
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
sub RUN_input_file_test{

 my $NEW_file=$INPUT_file."_generated";
 my $CMD;
 $INFILE_CHECK="OK";
 &command("echo \"ORIGINAL\" >> $INPUT_file");
 &command("cp $INPUT_file $NEW_file");

 if ($SETUP=="1")   { $CMD=$CMD." -i" };
 if ($HF=="1")      { $CMD=$CMD." -x"};
 if ($COHSEX=="1")  { $CMD=$CMD." -g n -p c"};
 if ($PPA=="1")     { $CMD=$CMD." -g n -p p"};
 if ($BSE=="1")     { $CMD=$CMD." -o b"};
 if ($EM1S=="1")    { $CMD=$CMD." -b"};
 if ($BSSdiago=="1")  { $CMD=$CMD." -y d"};
 if ($BSSslepc=="1")  { $CMD=$CMD." -y s"};
 if ($BSKalda=="1")   { $CMD=$CMD." -k alda"};
 if ($BSKh=="1")   { $CMD=$CMD." -k hartree"};

 if ($CMD) {
  &command("$yambo_exec -Q $CMD -F $NEW_file $log");
  if (compare("$INPUT_file","$NEW_file") == 0) {
   return "Input not Generated";
  }else{
   $INPUT_file=$NEW_file;
   return "OK";
  }
 }else{
  return "No CMD found";
 }
}
1;
