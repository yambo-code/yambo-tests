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
sub PARALLEL_loop{
#
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
my @QK;
if (-f "KPT_1") {@GQK[6] = [(4,1,1)]};
@QK[0] = [(1,1)];
@QK[1] = [(1,2)];
@QK[2] = [(2,1)];
@QK[3] = [(2,2)];
@GK=@QK;
if (-f "KPT_1") {@GK[4] = [(4,1)]};
my @CV;
@CV=@QK;
my @SB;
@SB=@QK;
#
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
};
#
$N_qksb=0;
$N_qsb=0;
foreach $q (@SINGLE){ 
 foreach $sb (@SB){
  foreach $k (@SINGLE){ 
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
$N_keht=0;
foreach $k (@SINGLE){
 foreach $eh (@SINGLE){ 
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
 foreach $var (@GKCV){ print "\n GKCV @$var"};
 foreach $var (@GQKCV){ print "\n GQKCV @$var"};
 foreach $var (@QSB){print "\n QSB @$var"};
 foreach $var (@KEHT){ print "\n KEHT @$var"};
 foreach $var (@QKSB){print "\n QKSB @$var"};
}
}
1;