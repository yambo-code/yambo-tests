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
sub SETUP_build{
#
open(SETUP_file,"<","$BRANCH/config/setup");
while(<SETUP_file>) {
 chomp($_);
 if($_ =~ /fc_kind/) { 
  ($desc, $equal, $FC_kind) = split(/\s+/,$_);
 }
};
close(SETUP_file);
#
my $result=`$BRANCH/$conf_bin/yambo -h 2>&1`;
#
@build_patters= split(/\s+/,$result);
$REVISION=$build_patters[5];
$REVISION =~ s/rev.//;
$BUILD=$build_patters[7];
if(not $BUILD =~ /MPI/ and ($NP_set[0] >1 or $#NP_set >1)) {return "Requested MPI support but MPI is off"};
if(not $BUILD =~ /OpenMP/) {
 if ($nt>1) {return "Requested $nt Threads but OpenMP is off"};
}else{
 if (!$nt) {$openmp_is_off="yes"};
}
if(not $BUILD =~ /SLK/ and $nl and ($nl ne 1 and $nl ne 4 and $nl ne 16)) { return "Requested $nl SLK cpu but SLK is off or $nl is not a SLK grid"};
return "OK";
#
}
1;
