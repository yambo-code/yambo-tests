#
#        Copyright (C) 2000-2017 the YAMBO team
#              http://www.yambo-code.org
#
# Authors (see AUTHORS file for details): AM, DS
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
sub RUN_convert_the_SAVE{
 &MY_PRINT($stdout, "\nConverting SAVE folder to new format");
 #
 $YAMBO_local="$BRANCH/$conf_bin/yambo";
 $YPP_local="$BRANCH/$conf_bin/ypp";
 if(-e "$BRANCH/$conf_bin/yambo_ph") { $YAMBO_local="$BRANCH/$conf_bin/yambo_ph"; }
 if(-e "$BRANCH/$conf_bin/yambo_ph") { $YPP_local="$BRANCH/$conf_bin/ypp_ph"; }
 #
 # Main SAVE folder
 #
 if(-e "SAVE_backup") { &command("cp -r SAVE_backup SAVE"); }
 # initialization
 &command("$YAMBO_local");
 # conversions
 &command("$YPP_local -z");
 #
 if(-e "SAVE_backup") {
  &command("rm -r SAVE");
  &command("mv SAVE_backup SAVE_backup_old");
  &command("mv FixSAVE/SAVE SAVE_backup");
 }
 else {
  &command("mv SAVE SAVE_old");
  &command("mv FixSAVE/SAVE SAVE");
 }
 #
 # SAVE for shifted grids
 #
 if(-e "SHIFTED_grids") {
  &MY_PRINT($stdout, "\nConverting SAVE folder with shifted grids to new format");
  &command("cd SHIFTED_grids");
  if(-e "shift_1") {
   &command("cd shift_1");
   &command("$YAMBO_local");
   &command("$YPP_local -z");
   &command("mv SAVE SAVE_old");
   &command("mv FixSAVE/SAVE SAVE");
   &command("cd ..");
  }
  if(-e "shift_2") {
   &command("cd shift_2");
   &command("$YAMBO_local");
   &command("$YPP_local -z");
   &command("mv SAVE SAVE_old");
   &command("mv FixSAVE/SAVE SAVE");
   &command("cd ..");
  }
  if(-e "shift_3") {
   &command("cd shift_3");
   &command("$YAMBO_local");
   &command("$YPP_local -z");
   &command("mv SAVE SAVE_old");
   &command("mv FixSAVE/SAVE SAVE");
   &command("cd ..");
  }
  &command("cd ..");
 }
 #
 # GKKP
 #
 if(-e "GKKP") {
  &MY_PRINT($stdout, "\nConverting GKKP folder to new format");
  &command("mv GKKP GKKP_old");
  &command("mv FixSAVE/GKKP GKKP");
 }
}
1;
