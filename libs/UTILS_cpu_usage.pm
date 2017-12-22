#
#        Copyright (C) 2000-2017 the YAMBO team
#              http://www.yambo-code.org
#
# Authors (see AUTHORS file for details): AM
#
# Ref: Calculating CPU Usage from /proc/stat
# (http://colby.id.au/node/39)
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
sub UTILS_cpu_usage{
use strict;
use warnings 'all';
use utf8;
use List::Util qw(sum);
my $count=0;
#my $icpu;
#my $prev_idle;
#my $prev_total;
while ($count <= 1) {
 #$icaaa=0;
 #$prev_idle=0;
 #$prev_total[$icpu]=0;
 open(STAT, '/proc/stat') or die "WTF: $!";
 while (<STAT>) {
#  next unless /^cpu[0-9]+/;
#  @cpu = split /\s+/, $_;
#  shift @cpu;
#  $idle[$icpu] = $cpu[3];
#  $total[$icpu] = sum(@cpu);
#  $diff_idle[$icpu] = $idle[$icpu] - $prev_idle[$icpu];
#  $diff_total[$icpu] = $total[$icpu] - $prev_total[$icpu];
#  $diff_usage[$icpu] = 100 * ($diff_total[$icpu] - $diff_idle[$icpu]) / $diff_total[$icpu];
#  $prev_idle[$icpu] = $idle[$icpu];
#  $prev_total[$icpu] = $total[$icpu];
#  $icpu++;
 }
 close STAT;
 $count++;
 sleep 0.2;
}
#print "$diff_usage \n";
die;
}
1;
