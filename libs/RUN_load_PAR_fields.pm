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
$PAR_field[11]="SE_nCPU_LinAlg_DIAGO=$nl_here";
#
if ( ! $default_parallel and $np>1) {
 $PAR_field[12]="X_q_0_ROLEs= \"k.c.v\"";
 $PAR_field[13]="X_finite_q_ROLEs= \"q.k.c.v\"";
 $PAR_field[14]="X_all_q_ROLEs= \"q.k.c.v\"";
 $PAR_field[15]="SE_ROLEs= \"q.qp.b\"";
 $PAR_field[16]="BS_ROLEs= \"k.eh.t\"";
 $PAR_field[17]="RT_ROLEs= \"q.k.qp.b\"";
}
#
$Nr="1";
@RUN_spec=();
#
if ($np==1) { 
 $RUN_spec[1]="serial";
 return;
}
if ($SETUP=="1" or $yambo_exec =~ /ypp/) { 
 $RUN_spec[1]="serial";
 return;
}
if ( $default_parallel ){ 
 $RUN_spec[1]="default";
 return;
};
#
# LOOP/RANDOM PARALLEL section
#
# SE_CPU=\"$q.$qp.$b\" => QQPB
# X_all_q_CPU=\"$q.$k.$c.$v\" => QKCV
# X_q_0_CPU=\"$k.$c.$v\" => KCF
# X_finite_q_CPU=\"$q.$k.$c.$v\" => QKCV
# BS_CPU=\"$k.$eh.$t\"  => KEHT
# RT_CPU=\"$q.$k.${qp}.$b\" => QKQPB
#
# Constrains
&RUN_PAR_constrains();
#
if ($random_parallel)
{
 &RUN_random_PAR(3);
 while (&CHECK_me($ncpu[0],$ncpu[1],$ncpu[2]) eq 1){&RUN_random_PAR(3)};
 @KCV[0]=[@ncpu];
 #
 &RUN_random_PAR(4);
 while (&CHECK_me($ncpu[0],$ncpu[2],$ncpu[3]) eq 1 or &CHECK_me($ncpu[1],$ncpu[2],$ncpu[3])){&RUN_random_PAR(4)};
 @QKCV[0]=[@ncpu];
 #
 &RUN_random_PAR(3);
 while (&CHECK_me($ncpu[0],$ncpu[2],$ncpu[2]) eq 1){&RUN_random_PAR(3)};
 @QQPB[0]=[@ncpu];
 #
 &RUN_random_PAR(3);
 while (&CHECK_me($ncpu[0],0,0) eq 1 or $ncpu[2]<=$ncpu[0]*$ncpu[1]){&RUN_random_PAR(3)};
 @KEHT[0]=[@ncpu];
 #
 &RUN_random_PAR(4);
 while (&CHECK_me($ncpu[0],$ncpu[3],$ncpu[3]) eq 1 or &CHECK_me($ncpu[1],$ncpu[3],$ncpu[3]) eq 1){&RUN_random_PAR(4)};
 @QKQPB[0]=[@ncpu];
 #
}else{
 my $SINGLE;
 @SINGLE = (1,2,4);
 my $QK;
 @QK[0] = [(1,1)];
 @QK[1] = [(1,2)];
 @QK[2] = [(2,2)];
 my $CV;
 @CV=@QK;
 my $QPB;
 @QPB=@QK;
 #
 $iconf=0;
 my $trace;
 foreach $cv (@CV){ foreach $k (@SINGLE){
  @conf = ( $k , @$cv[0], @$cv[1] );
  $trace=&trace( @conf );
  &CHECK_me($k,@$cv[0], @$cv[1]);
  if ($trace eq $np and &CHECK_me($k,@$cv[0], @$cv[1]) eq 0) {
   @KCV[$iconf]= [ @conf ];
   $iconf++; 
  }
 }};
 $iconf=0;
 foreach $cv (@CV){ foreach $qk (@QK){
  @conf = ( @$qk[0], @$qk[1] , @$cv[0], @$cv[1] );
  $trace=&trace( @conf );
  if ($trace eq $np and &CHECK_me(@qk[0],@$cv[0], @$cv[1]) eq 0 and &CHECK_me(@qk[1],@$cv[0], @$cv[1]) eq 0) {
   @QKCV[$iconf]= [ @conf ];
   $iconf++; 
  }
 }};
 $iconf=0;
 foreach $q (@SINGLE){ foreach $qpb (@QPB){
  @conf = ( $q, @$qpb[0], @$qpb[1] );
  $trace=&trace( @conf );
  if ($trace eq $np and &CHECK_me($q,@$qpb[1],@$qpb[1])  eq 0) {
   @QQPB[$iconf]= [ @conf ];
   $iconf++; 
  }
 }};
 $iconf=0;
 foreach $k (@SINGLE){foreach $eh (@SINGLE){ 
  $t_max=$k*$eh;
  for( $t = 1; $t < $t_max; $t = $t + 2 ){
   @conf = ( $k, $eh, $t );
   $trace=&trace( @conf );
   if ($trace eq $np and &CHECK_me($k,0,0)  eq 0) {
    @KEHT[$iconf]= [ @conf ];
    $iconf++; 
   }
 }}};
 $iconf=0;
 foreach $q (@SINGLE){ foreach $k (@SINGLE){ foreach $qpb (@QPB){
  @conf = ( $q, $k, @$qpb[0], @$qpb[1] );
  $trace=&trace( @conf );
  if ($trace eq $np and &CHECK_me($q,@$qpb[1],@$qpb[1]) eq 0 and &CHECK_me($k,@$qpb[1],@$qpb[1]) eq 0) {
   @QKQPB[$iconf]= [ @conf ];
   $iconf++; 
  }
 }}};
}
#
if ($verb >2) { 
 foreach $var (@KCV){ print "\n KCV @$var"};
 foreach $var (@QKCV){ print "\n QKCV @$var"};
 foreach $var (@QQPB){print "\n QQPB @$var"};
 foreach $var (@KEHT){ print "\n KEHT @$var"};
 foreach $var (@QKQPB){print "\n QKQPB @$var"};
}
#
# GW & Lifetimes
$Nr=0;
#
if ( $LIFE=="1" or ( $GW=="1" and $EM1D=="1" ) or ($COHSEX=="1" and $COLL=="0") or ($COHSEX=="1" and $COLL=="1" and $EM1S=="0") ) { 
 foreach $f1 (@QQPB){ foreach $f2 (@QKCV){ 
  $Nr++;
  $RUN_spec[$Nr]="SE_CPU=\"@$f1[0].@$f1[1].@$f1[2]\" X_all_q_CPU=\"@$f2[0].@$f2[1].@$f2[2].@$f2[3]\"";
 }}
 return;
}
#
# Standard linear-response (G-space)
#
if ( $OPTICS=="1" and $CHI=="1" ) { 
 foreach $f1 (@KCV){ foreach $f2 (@QKCV){ 
  $Nr++;
  $RUN_spec[$Nr]="X_q_0_CPU=\"@$f1[0].@$f1[1].@$f1[2]\" X_finite_q_CPU=\"@$f2[0].@$f2[1].@$f2[2].@$f2[3]\"";
 }}
 return;
}
#
# EM1S
#
if ($GW=="0" and $EM1S=="1" and $BSE=="0" and $COLL=="0") { 
 foreach $f1 (@QKCV){
  $Nr++;
  $RUN_spec[$Nr]="X_all_q_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3]\"";
 }
 return;
}
#
# BSE
#
if ($BSE=="1" and $EM1S=="0") { 
 foreach $f1 (@KEHT){
  $Nr++;
  $RUN_spec[$Nr]="BS_CPU=\"@$f1[0].@$f1[1].@$f1[2]\"";
 }
 return;
}
#
# BSE and EM1S
#
if ($BSE=="1" and $EM1S=="1" ) { 
 foreach $f1 (@QKCV){ foreach $f2 (@KEHT){
  $Nr++;
  $RUN_spec[$Nr]="X_all_q_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3]\" BS_CPU=\"@$f2[0].@$f2[1].@$f2[2]\"";
 }}
 return;
}
#
# HF, SC or e-p
#
if ( (($HF=="1" and $GW=="0") or $SC=="1" or ($GW=="1" and $EP=="1") or ($GW=="1" and $EPHOT=="1")) and $COLL=="0" and $NEGF=="0" ) { 
 foreach $f1 (@QQPB){
  $Nr++;
  $RUN_spec[$Nr]="SE_CPU=\"@$f1[0].@$f1[1].@$f1[2]\"";
 }
 return;
}
#
# RT
#
if ($SC=="0" and $NEGF=="1" and $COLL=="0") {
 foreach $f1 (@QKQPB){
  $Nr++;
  $RUN_spec[$Nr]="RT_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3]\"";
 }
 return;
}
#
# EM1S+Collisions (_RT)
#
if ($EM1S=="1" and $COLL=="1" and $yambo_exec=~"yambo_rt") { 
 foreach $f1 (@QKCV){ foreach $f2 (@QKQPB){
  $Nr++;
  $RUN_spec[$Nr]="X_all_q_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3]\" RT_CPU=\"@$f2[0].@$f2[1].@$f2[2].@$f2[3]\"";
 }}
 return;
}
#
# EM1S+Collisions (_SC)
#
if ($EM1S=="1" and $COLL=="1" and $yambo_exec=~"yambo_sc") { 
 foreach $f1 (@QKCV){ foreach $f2 (@QQPB){
  $Nr++;
  $RUN_spec[$Nr]="X_all_q_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3]\" SE_CPU=\"@$f2[0].@$f2[1].@$f2[2]\"";
 }}
 return;
}
#
# COLLISIONS (_RT)
#
if ($COLL=="1" and $yambo_exec=~"yambo_rt"  ) { 
 foreach $f1 (@QKQPB){
  $Nr++;
  $RUN_spec[$Nr]="RT_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3]\"";
 }
 return;
}
#
# COLLISIONS (_RT)
#
if ($COLL=="1" and $yambo_exec=~"yambo_sc"  ) { 
 foreach $f1 (@QQPB){
  $Nr++;
  $RUN_spec[$Nr]="SE_CPU=\"@$f1[0].@$f1[1].@$f1[2]\"";
 }
 return;
}
# END @
}
sub CHECK_me{
 if (@_[0] <= $MAX_k and  @_[1] <= $MAX_c and @_[2] <= $MAX_v) { return 0};
 return 1;
}
1;
