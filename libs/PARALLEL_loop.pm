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
sub PARALLEL_loop{
# 
# Pre-def
@THREE[0] = [(1,1,1)];
@THREE[1] = [(2,1,1)];
@THREE[2] = [(1,2,1)];
@THREE[3] = [(1,1,2)];
@THREE[4] = [(1,2,2)];
@THREE[5] = [(2,1,2)];
@THREE[6] = [(2,2,1)];
@THREE[7] = [(2,2,2)];
#
@TWO[0] = [(1,1)];
@TWO[1] = [(1,2)];
@TWO[2] = [(2,1)];
@TWO[3] = [(2,2)];
@TWO[4] = [(1,4)];
@TWO[5] = [(4,1)];
@TWO[6] = [(2,4)];
@TWO[7] = [(4,2)];
@TWO[8] = [(8,1)];
@TWO[9] = [(1,8)];
#
my $KPT;
@KPT = (1,2,4);
if (-f "KPT_1") {@KPT = (1)};
#
my $QPT;
@QPT = (1,2,4);
if (-f "KPT_1") {@QPT = (1)};
#
my $FREQ;
@FREQ = (1,2);
if (-f "FREQ_1") {@FREQ = (1)};
if (-f "KPT_1") {@FREQ = (1,2,4)};
#
my $GQK;
if (-f "KPT_1") 
{
 @GQK[0] = [(1,1,1)];
 @GQK[1] = [(2,1,1)];
 @GQK[2] = [(4,1,1)];
 @GQK[2] = [(8,1,1)];
}else{
 @GQK = @THREE;
}
#
my @QK;
if (-f "KPT_1") 
{
 @QK[0] = [(1,1)];
}else{
 @QK = @TWO;
}
#
my @GK;
if (-f "KPT_1") 
{
 @GK[0] = [(1,1)];
 @GK[1] = [(2,1)];
 @GK[2] = [(4,1)];
 @GK[2] = [(8,1)];
}else{
 @GK=@TWO;
}
#
my @CV;
if (-f "VALENCE_1") 
{
 @CV[0] = [(1,1)];
 @CV[1] = [(2,1)];
 @CV[2] = [(4,1)];
 @CV[3] = [(8,1)];
}elsif (-f "VALENCE_1"){
 @CV[0] = [(1,1)];
 @CV[1] = [(1,2)];
 @CV[2] = [(1,4)];
 @CV[3] = [(1,8)];
}else{
 @CV = @TWO;
}
#
my @EH;
@EH= (1,2,4,8);
#
my @SB;
@SB=@TWO;
#
$N_kcv=0;
$N_gkcv=0;
$N_gqkcv=0;
my $trace;
foreach $cv (@CV){ 
 foreach $gqk (@GQK){
  if (&PAR_conf_check({c=>@$cv[0],v=>@$cv[1]}) eq 1){next};
  if (&PAR_conf_check({k=>@$gqk[1]}) eq 1){next};
  if (&PAR_conf_check({k=>@$gqk[1]}) eq 1){next};
  @conf = ( @$gqk[0], @$gqk[1], @$gqk[2] , @$cv[0], @$cv[1] );
  $trace=&trace( @conf );
  if (not $trace eq $np) {next};
  @GQKCV[$N_gqkcv]= [ @conf ];
  $N_gqkcv++; 
 }
 foreach $gk (@GK){
  if (&PAR_conf_check({c=>@$cv[0],v=>@$cv[1]}) eq 1){next};
  if (&PAR_conf_check({k=>@$gk[1]}) eq 1){next};
  @conf = ( @$gk[0], @$gk[1] , @$cv[0], @$cv[1] );
  $trace=&trace( @conf );
  if (not $trace eq $np) {next};
  @GKCV[$N_gkcv]= [ @conf ];
  $N_gkcv++; 
 }
 foreach $k (@KPT){
  if (&PAR_conf_check({c=>@$cv[0],v=>@$cv[1]}) eq 1){next};
  if (&PAR_conf_check({k=>$k}) eq 1){next};
  @conf = ( $k, @$cv[0], @$cv[1] );
  $trace=&trace( @conf );
  if (not $trace eq $np) {next};
  @KCV[$N_kcv]= [ @conf ];
  $N_kcv++;
 }
};
#
$N_qksb=0;
$N_qsb=0;
foreach $q (@QPT){ 
 foreach $sb (@SB){
  foreach $k (@KPT){ 
   if (&PAR_conf_check({k=>$q}) eq 1){next};
   if (&PAR_conf_check({k=>$k}) eq 1){next};
   $trace=&trace( @conf );
   if (not $trace eq $np) {next};
   @conf = ( $q, $k, @$sb[0], @$sb[1] );
   @QKSB[$N_qksb]= [ @conf ];
   $N_qksb++; 
  }
  if (&PAR_conf_check({k=>$q}) eq 1){next};
  if (&PAR_conf_check({c=>@$sb[1],v=>@$sb[1]}) eq 1){next};
  @conf = ( $q, @$sb[0], @$sb[1] );
  $trace=&trace( @conf );
  if (not $trace eq $np) {next};
  @QSB[$N_qsb]= [ @conf ];
  $N_qsb++; 
 }
};
#
$N_wqkb=0;
foreach $w (@FREQ){ 
  foreach $k (@KPT){ 
   if (&PAR_conf_check({w=>$w}) eq 1){next};
   if (&PAR_conf_check({k=>$k}) eq 1){next};
   @conf = ( $w, $k );
   $trace=&trace( @conf );
   if (not $trace eq $np) {next};
   @WK[$N_wqkb]= [ @conf ];
   $N_wqkb++; 
  }
};
#
$N_keht=0;
foreach $k (@KPT){
 foreach $eh (@EH){ 
  if (&PAR_conf_check({k=>$k}) eq 1){next};
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
#
if ($verb) { 
 foreach $var (@KCV){ print "\n KCV @$var"};
 foreach $var (@GKCV){ print "\n GKCV @$var"};
 foreach $var (@GQKCV){ print "\n GQKCV @$var"};
 foreach $var (@QSB){print "\n QSB @$var"};
 foreach $var (@KEHT){ print "\n KEHT @$var"};
 foreach $var (@QKSB){print "\n QKSB @$var"};
 foreach $var (@WK){print "\n WK @$var"};
}
}
1;
