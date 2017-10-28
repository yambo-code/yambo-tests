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
# SE_CPU=\"$q.$s.$b\" => QSB
# X_all_q_CPU=\"$g.$q.$k.$c.$v\" => GQKCV
# X_q_0_CPU=\"$g.$k.$c.$v\" => GKCV
# X_finite_q_CPU=\"$g.$q.$k.$c.$v\" => GQKCV
# BS_CPU=\"$k.$eh.$t\"  => KEHT
# RT_CPU=\"$q.$k.$s.$b\" => QKSB
#
# Constrains
&RUN_PAR_constrains();
#
if ($random_parallel)
{
 &RUN_random_PAR(4);
 while (&CHECK_me( {G=>$ncpu[0], k=>$ncpu[1], c=>$ncpu[2], v=>$ncpu[3] } ) eq 1){&RUN_random_PAR(4)};
 @GKCV[0]=[@ncpu];
 #
 &RUN_random_PAR(5);
 while (&CHECK_me( {G=>$ncpu[0], k=>$ncpu[1], c=>$ncpu[3], v=>$ncpu[4] } ) eq 1 or &CHECK_me( {G=>$ncpu[0], k=>$ncpu[2], c=>$ncpu[3], v=>$ncpu[4] } ) eq 1  ){&RUN_random_PAR(5)};
 @GQKCV[0]=[@ncpu];
 #
 &RUN_random_PAR(3);
 while (&CHECK_me( {k=>$ncpu[0], c=>$ncpu[2], v=>$ncpu[2] } ) eq 1){&RUN_random_PAR(3)};
 @QSB[0]=[@ncpu];
 #
 &RUN_random_PAR(3);
 while (&CHECK_me( {k=>$ncpu[0]}) eq 1 or $ncpu[2]<=$ncpu[0]*$ncpu[1]){&RUN_random_PAR(3)};
 @KEHT[0]=[@ncpu];
 #
 &RUN_random_PAR(4);
 while (&CHECK_me( {k=>$ncpu[0], c=>$ncpu[3], v=>$ncpu[3] } ) eq 1 or &CHECK_me( {k=>$ncpu[1], c=>$ncpu[3], v=>$ncpu[3] } ) eq 1){&RUN_random_PAR(4)};
 @QKSB[0]=[@ncpu];
 #
}else{
 my $SINGLE;
 @SINGLE = (1,2);
 if (-f "KPT_1") {@SINGLE = (1,2,4)};
 my $GQK;
 @GQK[0] = [(1,1,1)];
 @GQK[1] = [(1,1,2)];
 @GQK[2] = [(1,2,2)];
 @GQK[3] = [(2,2,2)];
 @GQK[4] = [(2,1,2)];
 @GQK[5] = [(2,2,1)];
 if (-f "KPT_1") {@GQK[6] = [(4,1,1)]};
 my $QK;
 @QK[0] = [(1,1)];
 @QK[1] = [(1,2)];
 @QK[2] = [(2,1)];
 @QK[3] = [(2,2)];
 my $GK;
 my $CV;
 my $SB;
 @GK=@QK;
 if (-f "KPT_1") {
 @GK[4] = [(4,1)]
};
 @CV=@QK;
 @SB=@QK;
 #
 $N_gkcv=0;
 $N_gqkcv=0;
 my $trace;
 foreach $cv (@CV){ 
  foreach $gqk (@GQK){
   if (&CHECK_me({c=>@$cv[0],v=>@$cv[1]}) eq 1){next};
   if (&CHECK_me({k=>@$gqk[1]}) eq 1){next};
   if (&CHECK_me({k=>@$gqk[1]}) eq 1){next};
   @conf = ( @$gqk[0], @$gqk[1], @$gqk[2] , @$cv[0], @$cv[1] );
   $trace=&trace( @conf );
   if (not $trace eq $np) {next};
   @GQKCV[$N_gqkcv]= [ @conf ];
   $N_gqkcv++; 
  }
  foreach $gk (@GK){
   if (&CHECK_me({c=>@$cv[0],v=>@$cv[1]}) eq 1){next};
   if (&CHECK_me({k=>@$gk[1]}) eq 1){next};
   @conf = ( @$gk[0], @$gk[1] , @$cv[0], @$cv[1] );
   $trace=&trace( @conf );
   if (not $trace eq $np) {next};
   @GKCV[$N_gkcv]= [ @conf ];
   $N_gkcv++; 
  }
 };
 #
 $N_qksb=0;
 $N_qsb=0;
 foreach $q (@SINGLE){ 
  foreach $sb (@SB){
   foreach $k (@SINGLE){ 
    if (&CHECK_me({k=>$q}) eq 1){next};
    if (&CHECK_me({k=>$k}) eq 1){next};
    $trace=&trace( @conf );
    if (not $trace eq $np) {next};
    @conf = ( $q, $k, @$sb[0], @$sb[1] );
    @QKSB[$N_qksb]= [ @conf ];
    $N_qksb++; 
   }
   if (&CHECK_me({k=>$q}) eq 1){next};
   if (&CHECK_me({c=>@$sb[1],v=>@$sb[1]}) eq 1){next};
   @conf = ( $q, @$sb[0], @$sb[1] );
   $trace=&trace( @conf );
   if (not $trace eq $np) {next};
   @QSB[$N_qsb]= [ @conf ];
   $N_qsb++; 
  }
 };
 $N_keht=0;
 foreach $k (@SINGLE){
  foreach $eh (@SINGLE){ 
   if (&CHECK_me({k=>$k}) eq 1){next};
   $t_max=$k*$eh;
   for( $t = 1; $t < $t_max; $t = $t + 2 ){
    @conf = ( $k, $eh, $t );
    $trace=&trace( @conf );
    if (not $trace eq $np) {next};
    @KEHT[$N_keht]= [ @conf ];
    $N_keht++; 
   }
  }
 }
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
 my ($args) = @_;
 if ($args->{k} and $args->{k} > $MAX_k) {return 1};
 if ($args->{c} and $args->{c} > $MAX_c) {return 1};
 if ($args->{v} and $args->{v} > $MAX_v) {return 1};
 if ($args->{G} and $args->{G} > $MAX_G) {return 1};
 return 0;
}
1;
