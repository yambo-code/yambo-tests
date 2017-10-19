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
sub RUN_executables{
#
# EXE section
#
$yambo_exec = "$BRANCH/$conf_bin/yambo";
if ($YPP=="1") {$yambo_exec = "$BRANCH/$conf_bin/ypp"};
if ($YPP=="2") {$yambo_exec = "$BRANCH/$conf_bin/ypp -e s"};
if (-e "RT") {
 $yambo_exec = "$BRANCH/$conf_bin/yambo_rt";
 if ($YPP_RT=="1" or $YPP=="1") {$yambo_exec = "$BRANCH/$conf_bin/ypp_rt"};
}
if (-e "QED" && !$YPP=="1" && !$is_GPL) {
 $yambo_exec = "$BRANCH/$conf_bin/yambo_qed";
}
if (-e "PL" && !$is_GPL) {
 $yambo_exec = "$BRANCH/$conf_bin/yambo_pl";
 if ($YPP_RT=="1" or $YPP=="1") {$yambo_exec = "$BRANCH/$conf_bin/ypp_rt"};
}
if (-e "NL" && !$is_GPL) {
 $yambo_exec = "$BRANCH/$conf_bin/yambo_nl";
 if ($YPP_NL=="1" or $YPP=="1") {$yambo_exec = "$BRANCH/$conf_bin/ypp_nl"};
}
if (-e "ELPH") {
 $yambo_exec = "$BRANCH/$conf_bin/yambo_ph";
 if ($YPP_PH=="1" or $YPP=="1") {$yambo_exec = "$BRANCH/$conf_bin/ypp_ph"};
}
if (-e "SC" && !$is_GPL) {
 $yambo_exec = "$BRANCH/$conf_bin/yambo_sc";
 if ($YPP_SC=="1" or $YPP=="1") {$yambo_exec = "$BRANCH/$conf_bin/ypp_sc"};
}
if (-e "MAGNETIC" && !$is_GPL) {
 $yambo_exec = "$BRANCH/$conf_bin/yambo_magnetic";
 if ($YPP_MAGNETIC=="1" or $YPP=="1") {$yambo_exec = "$BRANCH/$conf_bin/ypp_magnetic"};
}
if (-e "KERR"  && !$YPP=="1") {
 $yambo_exec = "$BRANCH/$conf_bin/yambo_kerr";
}
if ($GKBA =="1") {
 $yambo_exec = "$BRANCH/$conf_bin/gkba";
}
#
if ($openmp_is_off) {$yambo_exec="$yambo_exec -N";}
if ($mpi_is_off)    {$yambo_exec="$yambo_exec -M";}
#
}
1;
