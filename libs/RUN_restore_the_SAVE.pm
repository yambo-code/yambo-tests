#
#        Copyright (C) 2000-2018 the YAMBO team
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
sub RUN_restore_the_SAVE{
 if(-e "SAVE_backup_old") {
  &command("rm -fr SAVE");
  &command("rm -fr SAVE_backup");
  &command("mv SAVE_backup_old SAVE_backup");
 }
 elsif (-e "SAVE_old") {
  &command("rm -fr SAVE");
  &command("mv SAVE_old SAVE");
 }
 if(-e "GKKP_old") {
  &command("rm -fr GKKP");
  &command("mv GKKP_old GKKP");
 }
 if(-e "SHIFTED_grids" || -e "SHIFTED_GRID") {
  if(-e "SHIFTED_grids") { chdir("SHIFTED_grids"); }
  if(-e "SHIFTED_GRID")  { chdir("SHIFTED_GRID"); }
  if(-e "shift_1/SAVE_old") {
    &command("rm -fr shift_1/SAVE");
    &command("mv shift_1/SAVE_old shift_1/SAVE");
  }
  if(-e "shift_2/SAVE_old") {
    &command("rm -fr shift_2/SAVE");
    &command("mv shift_2/SAVE_old shift_2/SAVE");
  }
  if(-e "shift_3/SAVE_old") {
    &command("rm -fr shift_3/SAVE");
    &command("mv shift_3/SAVE_old shift_3/SAVE");
  }
  chdir("..");
 }
 if(-e "SAVE_SOC_old") {
  &command("rm -fr SAVE_SOC");
  &command("mv SAVE_SOC_old SAVE_SOC");
 }
}
1;
