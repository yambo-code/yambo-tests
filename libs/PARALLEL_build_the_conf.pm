#
#        Copyright (C) 2000-2020 the YAMBO team
#              http://www.yambo-code.org
#
# Authors (see AUTHORS file for details): AM
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
sub PARALLEL_build_the_conf{
#
# GW & Lifetimes
#
if ( $LIFE=="1" or ( $GW=="1" and $EM1D=="1" ) or ($COHSEX=="1" and $COLL=="0") or ($COHSEX=="1" and $COLL=="1" and $EM1S=="0") ) { 
 foreach $f1 (@QSB){ foreach $f2 (@GQKCV){ foreach $f3 (@KCV){
  $Nr++;
  $MPI_CPU_conf[$Nr]="SE_CPU=\"@$f1[0].@$f1[1].@$f1[2]\" X_CPU=\"@$f2[0].@$f2[1].@$f2[2].@$f2[3].@$f2[4]\" X_and_IO_CPU=\"@$f2[0].@$f2[1].@$f2[2].@$f2[3].@$f2[4]\" DIP_CPU=\"@$f3[0].@$f3[1].@$f3[2]\"";
 }}}
 return;
}
#
# Standard linear-response (G-space)
#
if ( $DIPOLES=="1" ) {
 foreach $f1 (@KCV){
  $Nr++;
  $MPI_CPU_conf[$Nr]="DIP_CPU=\"@$f1[0].@$f1[1].@$f1[2]\"";
 }
 return;
}
#
# EM1S
#
if ($GW=="0" and $EM1S=="1" and $BSE=="0" and $COLL=="0") { 
 foreach $f1 (@GQKCV){ foreach $f2 (@KCV){
  $Nr++;
  $MPI_CPU_conf[$Nr]="X_and_IO_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" X_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" DIP_CPU=\"@$f2[0].@$f2[1].@$f2[2]\"";
 }}
 return;
}
#
# BSE
#
if ($BSE=="1" and $EM1S=="0") {  foreach $f2 (@KCV){
 foreach $f1 (@KEHT){
  $Nr++;
  $MPI_CPU_conf[$Nr]="BS_CPU=\"@$f1[0].@$f1[1].@$f1[2]\" DIP_CPU=\"@$f2[0].@$f2[1].@$f2[2]\"";
  #print "KEHT(1) $testname $MPI_CPU_conf[$Nr]\n";
 }}
 return;
}
#
# BSE and EM1S
#
if ($BSE=="1" and $EM1S=="1" ) { 
 foreach $f1 (@GQKCV){ foreach $f2 (@KEHT){ foreach $f3 (@KCV){
  $Nr++;
  $MPI_CPU_conf[$Nr]="X_and_IO_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" X_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" BS_CPU=\"@$f2[0].@$f2[1].@$f2[2]\" DIP_CPU=\"@$f3[0].@$f3[1].@$f3[2]\"";
  #print "KEHT(2) $testname $MPI_CPU_conf[$Nr]\n";
 }}}
 return;
}
#
# HF, SC or e-p
#
if ( (($HF=="1" and $GW=="0") or $SC=="1" or ($GW=="1" and $EP=="1") or ($GW=="1" and $EPHOT=="1")) and $COLL=="0" and $NEGF=="0" and $NLOPTICS=="0" ) { 
 foreach $f1 (@QSB){
  $Nr++;
  $MPI_CPU_conf[$Nr]="SE_CPU=\"@$f1[0].@$f1[1].@$f1[2]\"";
 }
 return;
}
#
# NL
#
if ($SC=="0" and $NLOPTICS=="1" and $COLL=="0") {
 foreach $f1 (@WK){ foreach $f2 (@KCV){
  $Nr++;
  $MPI_CPU_conf[$Nr]="NL_CPU=\"@$f1[0].@$f1[1]\" DIP_CPU=\"@$f2[0].@$f2[1].@$f2[2]\"";
 }}
 return;
}
#
# RT
#
if ($SC=="0" and $NEGF=="1" and $COLL=="0") {
 foreach $f1 (@QKSB){ foreach $f2 (@KCV){
  $Nr++;
  $MPI_CPU_conf[$Nr]="RT_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3]\" DIP_CPU=\"@$f2[0].@$f2[1].@$f2[2]\"";
 }}
 return;
}
#
# EM1S+Collisions (_RT)
#
if ($EM1S=="1" and $COLL=="1" and $yambo_exec=~"yambo_rt") { 
 foreach $f1 (@GQKCV){ foreach $f2 (@QKSB){ foreach $f3 (@KCV){
  $Nr++;
  $MPI_CPU_conf[$Nr]="X_and_IO_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" X_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" RT_CPU=\"@$f2[0].@$f2[1].@$f2[2].@$f2[3]\" DIP_CPU=\"@$f3[0].@$f3[1].@$f3[2]\"";
 }}}
 return;
}
#
# EM1S+Collisions (_SC)
#
if ($EM1S=="1" and $COLL=="1" and $yambo_exec=~"yambo_sc") { 
 foreach $f1 (@GQKCV){ foreach $f2 (@QSB){ foreach $f3 (@KCV){
  $Nr++;
  $MPI_CPU_conf[$Nr]="X_and_IO_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" X_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" SE_CPU=\"@$f2[0].@$f2[1].@$f2[2]\" DIP_CPU=\"@$f3[0].@$f3[1].@$f3[2]\"";
 }}}
 return;
}
#
# EM1S+Collisions (_NL)
#
if ($EM1S=="1" and $COLL=="1" and $yambo_exec=~"yambo_nl") { 
 foreach $f1 (@GQKCV){ foreach $f2 (@QSB){ foreach $f3 (@KCV){
  $Nr++;
  $MPI_CPU_conf[$Nr]="X_and_IO_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" X_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" SE_CPU=\"@$f2[0].@$f2[1].@$f2[2]\" DIP_CPU=\"@$f3[0].@$f3[1].@$f3[2]\"";
  }}}
 return;
}
#
# COLLISIONS (_RT)
#
if ($COLL=="1" and $yambo_exec=~"yambo_rt"  ) { 
 foreach $f1 (@QKSB){
  $Nr++;
  $MPI_CPU_conf[$Nr]="RT_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3]\"";
 }
 return;
}
#
# COLLISIONS (_SC)
#
if ($COLL=="1" and $yambo_exec=~"yambo_sc"  ) { 
 foreach $f1 (@QSB){
  $Nr++;
  $MPI_CPU_conf[$Nr]="SE_CPU=\"@$f1[0].@$f1[1].@$f1[2]\"";
 }
 return;
}
#
# COLLISIONS (_NL)
#
if ($COLL=="1" and $yambo_exec=~"yambo_nl"  ) { 
 foreach $f1 (@WK){
  $Nr++;
  $MPI_CPU_conf[$Nr]="NL_CPU=\"@$f1[0].@$f1[1]\"";
 }
 return;
}
# 
}
1;
