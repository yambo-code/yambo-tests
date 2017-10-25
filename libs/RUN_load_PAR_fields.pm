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
if ( ! $default_parallel and $np>1) {
 $PAR_field[1]="X_q_0_ROLEs= \"g.k.c.v\"";
 $PAR_field[2]="X_finite_q_ROLEs= \"g.q.k.c.v\"";
 $PAR_field[3]="X_all_q_ROLEs= \"g.q.k.c.v\"";
 $PAR_field[4]="SE_ROLEs= \"q.qp.b\"";
 $PAR_field[5]="BS_ROLEs= \"k.eh.t\"";
 $PAR_field[6]="RT_ROLEs= \"q.k.qp.b\"";
}
#
$Nr="1";
@MPI_CPU_conf=();
#
if ($np==1) { 
 $MPI_CPU_conf[1]="serial";
 return;
}
if ($SETUP=="1" or $yambo_exec =~ /ypp/) { 
 $MPI_CPU_conf[1]="serial";
 return;
}
if ( $default_parallel ){ 
 $MPI_CPU_conf[1]="default";
 return;
};
#
# LOOP/RANDOM PARALLEL section
#
# SE_CPU=\"$q.${qp}.$b\" => QSB
# X_all_q_CPU=\"$g.$q.$k.$c.$v\" => GQKCV
# X_q_0_CPU=\"$g.$k.$c.$v\" => GKCV
# X_finite_q_CPU=\"$g.$q.$k.$c.$v\" => GQKCV
# BS_CPU=\"$k.$eh.$t\"  => KEHT
# RT_CPU=\"$q.$k.${qp}.$b\" => QKSB
#
# Constrains
&RUN_PAR_constrains();
#
if ($random_parallel)
{
 &RUN_random_PAR(4);
 while (&CHECK_me($ncpu[1],$ncpu[2],$ncpu[3]) eq 1){&RUN_random_PAR(4)};
 @GKCV[0]=[@ncpu];
 #
 &RUN_random_PAR(5);
 while (&CHECK_me($ncpu[1],$ncpu[3],$ncpu[4]) eq 1 or &CHECK_me($ncpu[2],$ncpu[3],$ncpu[4])){&RUN_random_PAR(5)};
 @GQKCV[0]=[@ncpu];
 #
 &RUN_random_PAR(3);
 while (&CHECK_me($ncpu[0],$ncpu[2],$ncpu[2]) eq 1){&RUN_random_PAR(3)};
 @QSB[0]=[@ncpu];
 #
 &RUN_random_PAR(3);
 while (&CHECK_me($ncpu[0],0,0) eq 1 or $ncpu[2]<=$ncpu[0]*$ncpu[1]){&RUN_random_PAR(3)};
 @KEHT[0]=[@ncpu];
 #
 &RUN_random_PAR(4);
 while (&CHECK_me($ncpu[0],$ncpu[3],$ncpu[3]) eq 1 or &CHECK_me($ncpu[1],$ncpu[3],$ncpu[3]) eq 1){&RUN_random_PAR(4)};
 @QKSB[0]=[@ncpu];
 #
}else{
 my $SINGLE;
 @SINGLE = (1,2);
 my $GQK;
 @GQK[0] = [(1,1,1)];
 @GQK[1] = [(1,1,2)];
 @GQK[2] = [(1,2,2)];
 @GQK[3] = [(2,2,2)];
 my $QK;
 @QK[0] = [(1,1)];
 @QK[1] = [(1,2)];
 @QK[2] = [(2,2)];
 my $GK;
 my $CV;
 my $SB;
 @GK=@QK;
 @CV=@QK;
 @SB=@QK;
 #
 $iconf=0;
 my $trace;
 foreach $cv (@CV){ foreach $gk (@GK){
  @conf = ( @$gk[0], @$gk[1] , @$cv[0], @$cv[1] );
  $trace=&trace( @conf );[1]
  &CHECK_me(@$gk[1],@$cv[0], @$cv[1]);
  if ($trace eq $np and &CHECK_me(@$gk[1],@$cv[0], @$cv[1]) eq 0) {
   @GKCV[$iconf]= [ @conf ];
   $iconf++; 
  }
 }};
 $iconf=0;
 foreach $cv (@CV){ foreach $gqk (@GQK){
  @conf = ( @$gqk[0], @$gqk[1], @$gqk[2] , @$cv[0], @$cv[1] );
  $trace=&trace( @conf );
  if ($trace eq $np and &CHECK_me(@gqk[1],@$cv[0], @$cv[1]) eq 0 and &CHECK_me(@gqk[2],@$cv[0], @$cv[1]) eq 0) {
   @GQKCV[$iconf]= [ @conf ];
   $iconf++; 
  }
 }};
 $iconf=0;
 foreach $q (@SINGLE){ foreach $qpb (@SB){
  @conf = ( $q, @$qpb[0], @$qpb[1] );
  $trace=&trace( @conf );
  if ($trace eq $np and &CHECK_me($q,@$qpb[1],@$qpb[1])  eq 0) {
   @QSB[$iconf]= [ @conf ];
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
 foreach $q (@SINGLE){ foreach $k (@SINGLE){ foreach $qpb (@SB){
  @conf = ( $q, $k, @$qpb[0], @$qpb[1] );
  $trace=&trace( @conf );
  if ($trace eq $np and &CHECK_me($q,@$qpb[1],@$qpb[1]) eq 0 and &CHECK_me($k,@$qpb[1],@$qpb[1]) eq 0) {
   @QKSB[$iconf]= [ @conf ];
   $iconf++; 
  }
 }}};
}
#
if ($verb >2) { 
 foreach $var (@GKCV){ print "\n GKCV @$var"};
 foreach $var (@GQKCV){ print "\n GQKCV @$var"};
 foreach $var (@QSB){print "\n QSB @$var"};
 foreach $var (@KEHT){ print "\n KEHT @$var"};
 foreach $var (@QKSB){print "\n QKSB @$var"};
}
#
# GW & Lifetimes
$Nr=0;
#
if ( $LIFE=="1" or ( $GW=="1" and $EM1D=="1" ) or ($COHSEX=="1" and $COLL=="0") or ($COHSEX=="1" and $COLL=="1" and $EM1S=="0") ) { 
 foreach $f1 (@QSB){ foreach $f2 (@GQKCV){ 
  $Nr++;
  $MPI_CPU_conf[$Nr]="SE_CPU=\"@$f1[0].@$f1[1].@$f1[2]\" X_all_q_CPU=\"@$f2[0].@$f2[1].@$f2[2].@$f2[3].@$f2[4]\"";
 }}
 return;
}
#
# Standard linear-response (G-space)
#
if ( $OPTICS=="1" and $CHI=="1" ) { 
 foreach $f1 (@GKCV){ foreach $f2 (@GQKCV){ 
  $Nr++;
  $MPI_CPU_conf[$Nr]="X_q_0_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3]\" X_finite_q_CPU=\"@$f2[0].@$f2[1].@$f2[2].@$f2[3].@$f2[4]\"";
 }}
 return;
}
#
# EM1S
#
if ($GW=="0" and $EM1S=="1" and $BSE=="0" and $COLL=="0") { 
 foreach $f1 (@GQKCV){
  $Nr++;
  $MPI_CPU_conf[$Nr]="X_all_q_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\"";
 }
 return;
}
#
# BSE
#
if ($BSE=="1" and $EM1S=="0") { 
 foreach $f1 (@KEHT){
  $Nr++;
  $MPI_CPU_conf[$Nr]="BS_CPU=\"@$f1[0].@$f1[1].@$f1[2]\"";
 }
 return;
}
#
# BSE and EM1S
#
if ($BSE=="1" and $EM1S=="1" ) { 
 foreach $f1 (@GQKCV){ foreach $f2 (@KEHT){
  $Nr++;
  $MPI_CPU_conf[$Nr]="X_all_q_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" BS_CPU=\"@$f2[0].@$f2[1].@$f2[2]\"";
 }}
 return;
}
#
# HF, SC or e-p
#
if ( (($HF=="1" and $GW=="0") or $SC=="1" or ($GW=="1" and $EP=="1") or ($GW=="1" and $EPHOT=="1")) and $COLL=="0" and $NEGF=="0" ) { 
 foreach $f1 (@QSB){
  $Nr++;
  $MPI_CPU_conf[$Nr]="SE_CPU=\"@$f1[0].@$f1[1].@$f1[2]\"";
 }
 return;
}
#
# RT
#
if ($SC=="0" and $NEGF=="1" and $COLL=="0") {
 foreach $f1 (@QKSB){
  $Nr++;
  $MPI_CPU_conf[$Nr]="RT_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3]\"";
 }
 return;
}
#
# EM1S+Collisions (_RT)
#
if ($EM1S=="1" and $COLL=="1" and $yambo_exec=~"yambo_rt") { 
 foreach $f1 (@GQKCV){ foreach $f2 (@QKSB){
  $Nr++;
  $MPI_CPU_conf[$Nr]="X_all_q_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" RT_CPU=\"@$f2[0].@$f2[1].@$f2[2].@$f2[3]\"";
 }}
 return;
}
#
# EM1S+Collisions (_SC)
#
if ($EM1S=="1" and $COLL=="1" and $yambo_exec=~"yambo_sc") { 
 foreach $f1 (@GQKCV){ foreach $f2 (@QSB){
  $Nr++;
  $MPI_CPU_conf[$Nr]="X_all_q_CPU=\"@$f1[0].@$f1[1].@$f1[2].@$f1[3].@$f1[4]\" SE_CPU=\"@$f2[0].@$f2[1].@$f2[2]\"";
 }}
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
# COLLISIONS (_RT)
#
if ($COLL=="1" and $yambo_exec=~"yambo_sc"  ) { 
 foreach $f1 (@QSB){
  $Nr++;
  $MPI_CPU_conf[$Nr]="SE_CPU=\"@$f1[0].@$f1[1].@$f1[2]\"";
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
