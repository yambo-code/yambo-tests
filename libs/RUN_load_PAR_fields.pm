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
sub RUN_load_PAR_fields{
#
#
$Nr="0";
@MPI_CPU_conf=();
#
if ($np==1) { 
 $Nr="1";
 $MPI_CPU_conf[1]="serial";
 return;
}
if ($yambo_exec =~ /\/p2y/ or $yambo_exec =~ /\/a2y/ or $yambo_exec =~ /\/ypp/  ) { 
 $Nr="1";
 $MPI_CPU_conf[1]="default";
 return;
}
if ($RIMCUT=="1" and not $GW  and not $OPTICS ){
 $Nr="1";
 $MPI_CPU_conf[1]="default";
 return;
}
if ( $default_parallel ){ 
 $Nr="1";
 $MPI_CPU_conf[1]="default";
 return;
};
#
# PARALLEL section
#
$PAR_field[0]="DIP_ROLEs= \"k.c.v\""; #  => KCV
$PAR_field[1]="X_and_IO_ROLEs= \"g.q.k.c.v\""; # => GQKCV/GKCV
$PAR_field[2]="X_ROLEs= \"g.q.k.c.v\""; # => GQKCV
$PAR_field[3]="BS_ROLEs= \"k.eh.t\""; # => KEHT
$PAR_field[4]="SE_ROLEs= \"q.qp.b\""; # => QSB
$PAR_field[5]="RT_ROLEs= \"q.k.qp.b\""; # => QKSB
$PAR_field[6]="NL_ROLEs= \"w.k\""; # => WK
#
# Resets
#
undef @KCV;
undef @GKCV;
undef @GQKCV;
undef @QSB;
undef @KEHT;
undef @QKSB;
undef @WK;
#
# Constrains
&RUN_PAR_constrains();
#
if ($random_parallel){ 
 # Random
 &PARALLEL_random();
}else{
 # LOOP
 &PARALLEL_loop() ;
}
# Combination
&PARALLEL_build_the_conf();
#
}
sub PAR_conf_check{
 my ($args) = @_;
 if ($args->{b} and $args->{b} > $MAX_b) {return 1};
 if ($args->{k} and $args->{k} > $MAX_k) {return 1};
 if ($args->{c} and $args->{c} > $MAX_c) {return 1};
 if ($args->{v} and $args->{v} > $MAX_v) {return 1};
 if ($args->{G} and $args->{G} > $MAX_G) {return 1};
 if ($args->{eh}and $args->{eh}> $MAX_eh){return 1};
 if ($args->{w} and $args->{w} > $MAX_w) {return 1};
}
1
;
