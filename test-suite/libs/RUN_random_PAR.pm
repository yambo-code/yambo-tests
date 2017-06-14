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
sub RUN_random_PAR{
$n_fields=$_[0];
if ($n_fields == 3) {
@icpu = qw(1 2 3);
@ncpu = qw(1 1 1)
}
if ($n_fields == 4) {
@icpu = qw(1 2 3 4);
@ncpu = qw(1 1 1 1)
}
#
$ic=0;
while ($ic<=$n_fields-1) {
  my $random_i = int(rand($n_fields));
  $i_dummy=$icpu[$ic];
  $icpu[$ic]=$icpu[$random_i];
  $icpu[$random_i]=$i_dummy;
  $ic++
};
#
$np_now=$np;
my $max_random_np=8;
$ic=0;
while ($ic<=$n_fields-1) {
 $icp=$icpu[$ic]-1;
 if ($np_now!=1) {
  $random_cpu = int(rand($max_random_np))+1;
  while (int($np_now/$random_cpu) != $np_now/$random_cpu){
    $random_cpu = int(rand($max_random_np))+1;
  }
  $np_now=$np_now/$random_cpu;
  $ncpu[$icp]=$random_cpu;
 }
 $ic++;
}
$ic=0;
if ($np_now!=1) {
 while ($ic<=$n_fields-1) {
  if ($ncpu[$ic] == 1) { 
    $ncpu[$ic]=$np_now;
    $np_now=1;
  }
  $ic++
 }
}
if ($n_fields == 3) {
 $cpu_3_conf="$ncpu[0].$ncpu[1].$ncpu[2]";
}
if ($n_fields == 4) {
 $cpu_4_conf="$ncpu[0].$ncpu[1].$ncpu[2].$ncpu[3]";
}
}
1;
