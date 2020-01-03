#
#        Copyright (C) 2000-2020 the YAMBO team
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
sub UTILS_time
{
$numParameters = @_ ;
@months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
my @days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
if ($hour < 10) {$hour="0$hour";};
if ($min  < 10) {$min="0$min";};
$current_year=$year+1900;
$current_day=$mon*31+$mday;
$_[0]="$months[$mon]-$mday-$days[$wday]";
$_[1]="$hour-$min";
if ($numParameters > 1){
 $_[2]=$mon+1;
 $_[3]=$mday;
}
}
sub UTILS_day
{
my $im=0;
my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
foreach my $m (@months){
  if ($_[0] eq $m) { return $im*31+$_[1]};
  $im++;
}
return 0;
}
1;
