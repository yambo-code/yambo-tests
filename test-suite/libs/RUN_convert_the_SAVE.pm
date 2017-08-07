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
 #
 $YAMBO_local="$BRANCH/$conf_bin/yambo";
 $YPP_local="$BRANCH/$conf_bin/ypp -z";
 if(-e "$BRANCH/$conf_bin/yambo_ph") { $YAMBO_local="$BRANCH/$conf_bin/yambo_ph"; }
 if(-e "$BRANCH/$conf_bin/ypp_ph")   { $YPP_local="$BRANCH/$conf_bin/ypp_ph -z"; }
 #
 # Main SAVE folder and eventually GKKP
 #
 $MESSAGE="\nConverting SAVE folder to new format";
 if(-e "GKKP") {
  $MESSAGE="\nConverting SAVE and GKKP folders to new format";
  $YPP_local="$YPP_local -J GKKP"
 }
 &MY_PRINT($stdout, "$MESSAGE");
 #
 if(-e "SAVE_backup") { &command("cp -r SAVE_backup SAVE"); }
 &command("$YAMBO_local");
 &command("$YPP_local");
 if(-e "SAVE_backup") {
  &command("rm -r SAVE");
  &command("mv SAVE_backup SAVE_backup_old");
  &command("mv FixSAVE/SAVE SAVE_backup");
 }
 else {
  &command("mv SAVE SAVE_old");
  &command("mv FixSAVE/SAVE SAVE");
 }
 if(-e "GKKP") {
  &command("mv GKKP GKKP_old");
  &command("mv FixSAVE/GKKP GKKP");
 }
 #
 # SAVE for shifted grids
 #
 if(-e "SHIFTED_grids" || -e "SHIFTED_GRID") {
  &MY_PRINT($stdout, "\nConverting SAVE folder with shifted grids to new format");
  if(-e "SHIFTED_grids") { chdir("SHIFTED_grids"); }
  if(-e "SHIFTED_GRID")  { chdir("SHIFTED_GRID"); }
  if(-e "shift_1") {
   &MY_PRINT($stdout, "\nConverting shift 1");
   chdir("shift_1");
   &command("$YAMBO_local");
   &command("$YPP_local");
   &command("mv SAVE SAVE_old");
   &command("mv FixSAVE/SAVE SAVE");
   chdir("..");
  }
  if(-e "shift_2") {
   &MY_PRINT($stdout, "\nConverting shift 2");
   chdir("shift_2");
   &command("$YAMBO_local");
   &command("$YPP_local");
   &command("mv SAVE SAVE_old");
   &command("mv FixSAVE/SAVE SAVE");
   chdir("..");
  }
  if(-e "shift_3") {
   &MY_PRINT($stdout, "\nConverting shift 3");
   chdir("shift_3");
   &command("$YAMBO_local");
   &command("$YPP_local");
   &command("mv SAVE SAVE_old");
   &command("mv FixSAVE/SAVE SAVE");
   chdir("..");
  }
  chdir("..");
 }
 #
 # SAVE for SOC mapping
 #
 if(-e "SAVE_SOC") {
  &MY_PRINT($stdout, "\nConverting SAVE folder with SOC to new format");
  &command("mv SAVE_SOC SAVE_SOC_old");
  &command("mkdir -p SOC_tmp_dir/SAVE");
  &command("cp SAVE_SOC_old/* SOC_tmp_dir/SAVE");
  chdir("SOC_tmp_dir");
  &command("$YAMBO_local");
  &command("$YPP_local");
  &command("mv FixSAVE/SAVE ../SAVE_SOC");
  chdir("..");
 }
}
1;
