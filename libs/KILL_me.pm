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
sub KILL_me
{
$process=@_[0];
$list =`ps uax | grep $kill_me | grep $process | grep -v grep | grep -v vim | awk '{print \$2}'`;
$name =`ps uax | grep $kill_me | grep $process | grep -v grep | grep -v vim`;
$list  =~ tr/\n/ /d;
my @pids  = split(/ /,$list);
my @names = split(/\n/,$name);
$i=0;
print "Killing $process related jobs...\n";
foreach my $pid (@pids)
{
 &command("kill -9 $pid");
 print "$names[$i]\n";
 $i++;
}
}
1;
