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
sub SETUP_keys{
my @PJs = ("sc","rt","pl","elph","kerr","magnetic","nl","hard","nopj","qp-dbs"); 
my @FTs = ("gw", "bse", "rpa","all"); 
$project= '';
foreach my $index (0..$#PJs) {
    next if ($keys !~ /$PJs[$index]/ and $keys !~ /all/);
    next if ($keys =~ /all/ and $PJs[$index] =~ /nl/ );
    $project .= " ".$PJs[$index];
}
$if=-1;
foreach my $index (0..$#FTs) {
    next if $keys !~ /$FTs[$index]/;
    $if++;
    @features[$if] = $FTs[$index];
}
if ($keys eq "all"  ) {
 @features[0]="all";
}
if ($project eq ''  ) {$project="nopj"};
if ($#features eq -1) {@features[0]="all"};
}
1;