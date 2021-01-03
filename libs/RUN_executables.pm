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
sub RUN_executables{
#
# EXE section
#
undef $yambo_running;
if ($P2Y) 
 {$yambo_exec = "$conf_bin/p2y"}
elsif ($A2Y)
 {$yambo_exec = "$conf_bin/a2y"} 
elsif ($YPP=="1") 
 {$yambo_exec = "$conf_bin/ypp"}
elsif ($YPP=="2") 
 {
 if ($is_NEW_EXC_SORT eq "no" ) {$yambo_exec = "$conf_bin/ypp -e s"}
 if ($is_NEW_EXC_SORT eq "yes") {$yambo_exec = "$conf_bin/ypp -e s $IQ"}
 if ($is_NEW_driver eq "yes"  ) {$yambo_exec = "$conf_bin/ypp -e s -b $IQ"}
 }
else
 {$yambo_exec = "$conf_bin/yambo";
  $yambo_running=1}
if (-e "RT") {
 undef $yambo_running;
 if ($YPP_RT=="1" or $YPP=="1") 
  {$yambo_exec = "$conf_bin/ypp_rt"}
 elsif ($YPP_SC=="1" or $YPP=="1") 
  {$yambo_exec = "$conf_bin/ypp_sc"}
 else
  {$yambo_exec = "$conf_bin/yambo_rt";
   $yambo_running=1}
}
if (-e "QED" && !$YPP=="1" && !$is_GPL) {
 $yambo_running=1;
 $yambo_exec = "$conf_bin/yambo_qed"
}
if (-e "NL") {
 undef $yambo_running;
 if ($YPP_NL=="1" or $YPP=="1") 
  {$yambo_exec = "$conf_bin/ypp_nl"}
 else
  {$yambo_exec = "$conf_bin/yambo_nl";
   $yambo_running=1}
}
if (-e "ELPH") {
 undef $yambo_running;
 if ($YPP_PH=="1" or $YPP=="1") 
  {$yambo_exec = "$conf_bin/ypp_ph"}
 else
  {$yambo_exec = "$conf_bin/yambo_ph";
   $yambo_running=1}
}
if (-e "SC" && !$is_GPL) {
 undef $yambo_running;
 if ($YPP_SC=="1" or $YPP=="1") 
  {$yambo_exec = "$conf_bin/ypp_sc"}
 else
  {$yambo_exec = "$conf_bin/yambo_sc";
   $yambo_running=1}
}
if (-e "MAGNETIC" && !$is_GPL) {
 undef $yambo_running;
 if ($YPP_MAGNETIC=="1" or $YPP=="1") 
  {$yambo_exec = "$conf_bin/ypp_magnetic"}
 else
  {$yambo_exec = "$conf_bin/yambo_magnetic";
   $yambo_running=1}
}
if ($CHEERS =="1") {
 undef $yambo_running;
 $yambo_exec = "$conf_bin/ycheers";
}
#
if ($openmp_is_off) {
 if ( not $is_NEW_driver) {$yambo_exec="$yambo_exec -N"}
 if (     $is_NEW_driver) {$yambo_exec="$yambo_exec -noopenmp"}
}
if ($mpi_is_off){
 if ( not $is_NEW_driver) {$yambo_exec="$yambo_exec -M"}
 if (     $is_NEW_driver) {$yambo_exec="$yambo_exec -nompi"}
}
#
}
1;
