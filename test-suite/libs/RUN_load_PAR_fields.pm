#
#        Copyright (C) 2000-2017 the YAMBO team
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
sub RUN_load_PAR_fields{
#
my $nt_here=1;
$nt_here=$nt if ($nt);
my $nl_here=1;
$nl_here=$nl if ($nl);
#
$PAR_field[1]="K_Threads= $nt_here";
$PAR_field[2]="X_Threads= $nt_here";
$PAR_field[3]="DIP_Threads= $nt_here";
$PAR_field[4]="SE_Threads= $nt_here";
$PAR_field[5]="RT_Threads= $nt_here";
$PAR_field[6]="X_all_q_nCPU_LinAlg_INV=$nl_here";
$PAR_field[7]="X_q_0_nCPU_LinAlg_INV=$nl_here";
$PAR_field[8]="X_finite_q_nCPU_LinAlg_INV=$nl_here";
$PAR_field[9]="BS_nCPU_LinAlg_INV=$nl_here";
$PAR_field[10]="BS_nCPU_LinAlg_DIAGO=$nl_here";
#
if ( ! $default_parallel and $np>1) {
 $PAR_field[11]="X_q_0_ROLEs= \"k.c.v\"";
 $PAR_field[12]="X_finite_q_ROLEs= \"q.k.c.v\"";
 $PAR_field[13]="X_all_q_ROLEs= \"q.k.c.v\"";
 $PAR_field[14]="SE_ROLEs= \"q.qp.b\"";
 $PAR_field[15]="BS_ROLEs= \"k.eh.t\"";
 $PAR_field[16]="RT_ROLEs= \"k.b.q.qp\"";
}
#
$Nr="1";
#
@RUN_spec=();
if ($np==1) { 
 $RUN_spec[1]="serial";
 return;
}
if ($SETUP=="1" or $yambo_exec =~ /ypp/) { 
 $RUN_spec[1]="serial";
 return;
}
#
$ir=0;
@CPUs= qw(1 2);
if ($np>4){ @CPUs= qw(1 2 3 4) };
if ( $default_parallel ){ 
 $RUN_spec[1]="default";
 return;
};
&RUN_random_PAR(3);
&RUN_random_PAR(4);
#
# GW & Lifetimes
#
if ( $LIFE=="1" or ( $GW=="1" and $EM1D=="1" ) or ($COHSEX=="1" and $COLL=="0") or ($COHSEX=="1" and $COLL=="1" and $EM1S=="0") ) { 
 if ( ! $random_parallel ){
  foreach $q (@CPUs){ foreach $qp (@CPUs){ foreach $b (@CPUs){
   foreach $k (@CPUs){foreach $c (@CPUs){foreach $v (@CPUs){
    $CONDITION="no";
    if ($q*$qp*$b==$np and $q*$k*$c*$v==$np){ $CONDITION="yes"};
    if ( $CONDITION=~"yes" and &RUN_PAR_constrains() eq 0){
     $ir++;
     $RUN_spec[$ir]="SE_CPU=\"$q.$qp.$b\" X_all_q_CPU=\"$q.$k.$c.$v\"";
  }}}}}}}
  $Nr=$ir
 } else {
  $Nr=1;
  $RUN_spec[1]="SE_CPU=\"$cpu_3_conf\" X_all_q_CPU=\"$cpu_4_conf\"";
 }
 return
}
#
# Standard linear-response (G-space)
#
if ( $OPTICS=="1" and $CHI=="1" ) { 
 if ( ! $random_parallel ){
  foreach $q (@CPUs){ foreach $k (@CPUs){ foreach $c (@CPUs){
   foreach $v (@CPUs){
    $CONDITION="no";
    if ($k*$c*$v==$np and $q*$k*$c*$v==$np){ $CONDITION="yes"};
    if ( $CONDITION=~"yes" and &RUN_PAR_constrains() eq 0){
     $ir++;
     $RUN_spec[$ir]="X_q_0_CPU=\"$k.$c.$v\" X_finite_q_CPU=\"$q.$k.$c.$v\"";
  }}}}}
  $Nr=$ir
 } else {
  $Nr=1;
  $RUN_spec[1]="X_q_0_CPU=\"$cpu_3_conf\" X_finite_q_CPU=\"$cpu_4_conf\"";
 }
 return
}
#
# EM1S
#
if ($GW=="0" and $EM1S=="1" and $BSE=="0" and $COLL=="0") { 
 if ( ! $random_parallel ){
  foreach $q (@CPUs){ foreach $k (@CPUs){ foreach $c (@CPUs){
   foreach $v (@CPUs){
    $CONDITION="no";
    if ($q*$k*$c*$v==$np){ $CONDITION="yes"};
    if ( $CONDITION=~"yes" and &RUN_PAR_constrains() eq 0){
     $ir++;
     $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\"";
  }}}}}
  $Nr=$ir
 } else {
  $Nr=1;
  $RUN_spec[1]="X_all_q_CPU=\"$cpu_4_conf\"";
 }
 return
}
#
# BSE
#
if ($BSE=="1" and $EM1S=="0") { 
 if ( ! $random_parallel ){
  foreach $k (@CPUs){ foreach $eh (@CPUs){ foreach $t (@CPUs){
    $CONDITION="no";
    $t_max=($eh*$k+1)/2;
    if ($k*$eh*$t==$np){ $CONDITION="yes"};
    if ( $t>$t_max ) { $CONDITION="no"};
    if ( $CONDITION=~"yes" and &RUN_PAR_constrains() eq 0){
     $ir++;
     $RUN_spec[$ir]="BS_CPU=\"$k.$eh.$t\"";
    };
  }}};
  $Nr=$ir
 } else {
  $Nr=1;
  $RUN_spec[1]="BS_CPU=\"$cpu_3_conf\"";
 }
 return;
}
#
# BSE and EM1S
#
if ($BSE=="1" and $EM1S=="1" ) { 
 if ( ! $random_parallel ){
  foreach $q (@CPUs){ foreach $k (@CPUs){ foreach $c (@CPUs){ foreach $v (@CPUs){
  foreach $kp (@CPUs){ foreach $eh (@CPUs){ foreach $t (@CPUs){
    $CONDITION="no";
    $t_max=($eh*$kp+1)/2;
    if ($q*$k*$c*$v==$np and $kp*$eh*$t==$np){ $CONDITION="yes"};
    if ( $t>$t_max ) { $CONDITION="no"};
    if ( $CONDITION=~"yes" and &RUN_PAR_constrains() eq 0){
     $ir++;
     $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\" BS_CPU=\"$kp.$eh.$t\"";
    };
  }}}}}}};
  $Nr=$ir
 } else {
  $Nr=1;
  $RUN_spec[1]="X_all_q_CPU=\"$cpu_4_conf\" BS_CPU=\"$cpu_3_conf\"";
 }
 return;
}
#
# HF, SC or e-p
#
if ( (($HF=="1" and $GW=="0") or $SC=="1" or ($GW=="1" and $EP=="1") or ($GW=="1" and $EPHOT=="1")) and $COLL=="0" and $NEGF=="0" ) { 
 if ( ! $random_parallel ){
  foreach $q (@CPUs){ foreach $qp (@CPUs){ foreach $b (@CPUs){
    $CONDITION="no";
    if ($q*$qp*$b==$np){ $CONDITION="yes"};
    if ( $CONDITION=~"yes" and &RUN_PAR_constrains() eq 0){
     $ir++;
     $RUN_spec[$ir]="SE_CPU=\"$q.$qp.$b\"";
    };
  }}};
  $Nr=$ir
 } else {
  $Nr=1;
  $RUN_spec[1]="SE_CPU=\"$cpu_3_conf\"";
 }
 return;
}
#
# RT
#
if ($SC=="0" and $NEGF=="1" and $COLL=="0") {
 if ( ! $random_parallel ){
  foreach $k (@CPUs){ foreach $b (@CPUs){ foreach $q (@CPUs){ foreach $qp (@CPUs){
    $CONDITION="no";
    if ($k*$b*$q*${qp}==$np){ $CONDITION="yes"};
    if ( $CONDITION=~"yes" and &RUN_PAR_constrains() eq 0){
     $ir++;
     $RUN_spec[$ir]="RT_CPU=\"$k.$b.$q.${qp}\"";
  }}}}}
  $Nr=$ir
 } else {
  $Nr=1;
  $RUN_spec[1]="RT_CPU=\"$cpu_4_conf\"";
 }
 return;
}
#
# EM1S+Collisions
#
if ($EM1S=="1" and $COLL=="1") { 
 if ( ! $random_parallel ){
  foreach $q (@CPUs){ foreach $k (@CPUs){ foreach $c (@CPUs){ foreach $v (@CPUs){
   foreach $kp (@CPUs){ foreach $b (@CPUs){ foreach $qp (@CPUs){
    $CONDITION="no";
    if ($yambo_exec=~"yambo_rt") {
     if ($q*$k*$c*$v==$np and $kp*$b*$q*${qp}==$np){ $CONDITION="yes"};
    } else {
     if ($q*$k*$c*$v==$np and $b*$q*${qp}==$np){ $CONDITION="yes"};
    }
    if ( $CONDITION=~"yes" and &RUN_PAR_constrains() eq 0){
     if ($yambo_exec=~"yambo_rt" ) {
      $ir++;
      $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\" RT_CPU=\"$kp.$b.$q.${qp}\"";
     }
     else
     {
      $ir++;
      $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\" SE_CPU=\"$q.$qp.$b\"";
     };
    };
  }}}}}}};
  $Nr=$ir
 } else {
  $Nr=1;
  if ($yambo_exec=~"yambo_rt" ) {
   $RUN_spec[1]="X_all_q_CPU=\"$cpu_4_conf\" RT_CPU=\"$cpu_4_conf\"";
  }
  else
  {
   $RUN_spec[1]="X_all_q_CPU=\"$cpu_4_conf\" SE_CPU=\"$cpu_3_conf\"";
  };
 }
 return;
}
#
# COLLISIONS
#
if ($COLL=="1" ) { 
 if ( ! $random_parallel ){
  foreach $q (@CPUs){ foreach $qp (@CPUs){ foreach $b (@CPUs){
    $CONDITION="no";
    if ($q*$qp*$b==$np){ $CONDITION="yes"};
    if ( $CONDITION=~"yes" and &RUN_PAR_constrains() eq 0){
     $ir++;
     $RUN_spec[$ir]="SE_CPU=\"$q.$qp.$b\"";
  }}}}
  $Nr=$ir
 } else {
  $Nr=1;
  $RUN_spec[1]="SE_CPU=\"$cpu_3_conf\"";
 }
 return;
}
}
1;
