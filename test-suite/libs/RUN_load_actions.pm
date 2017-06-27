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
sub RUN_load_actions{
## Actions files must direct STDERR to /dev/null
## A cleaner way would be to parse mkdir, cp etc into perl commands.
if( -e "$input_folder/$testname"."$_[0]") {
 open(ACTIONS,"<","$input_folder/$testname"."$_[0]");
 &MY_PRINT($stdout, "ACTION file:$input_folder/$testname"."$_[0] \n") if ($verb);
 @actions_file = <ACTIONS>;
 while($actions_cmd = shift(@actions_file)) {
  chomp($actions_cmd);
  &command("$actions_cmd");
 }
 close(ACTIONS);
 if ( -e "BASE_input" and "$_[0]" eq ".input") {  &command("cat BASE_input >> yambo.in") };
}
}
1;
