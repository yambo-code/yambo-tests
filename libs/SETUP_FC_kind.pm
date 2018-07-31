#
#        Copyright (C) 2000-2018 the YAMBO team
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
sub SETUP_FC_kind{
open(SETUP_file,"<","$BRANCH/config/setup");
$MPI_kind="unknown";
$MPI_kind_short="unknown";
while(<SETUP_file>) {
 chomp($_);
 if($_ =~ /fc_kind/) { 
  ($desc, $equal, $FC_kind) = split(/\s+/,$_);
 }
 if($_ =~ /mpi_kind/) { 
  ($desc, $MPI_kind) = split(/=/,$_);
  if($MPI_kind == "" ) { $MPI_kind="unknown"}; 
 }
 if($_ =~ /yprecision/) { 
  ($desc, $Yambo_precision) = split(/=/,$_);
 }
};
close(SETUP_file);
if($MPI_kind =~ /Open/ ) { $MPI_kind_short="OpenMPI" }; 
if($MPI_kind =~ /MPICH/) { $MPI_kind_short="MPICH" }; 
if($MPI_kind =~ /Intel/) { $MPI_kind_short="IntelMPI"}; 
#
if($Yambo_precision =~ /single/ ) { $Yambo_precision="single" }; 
if($Yambo_precision =~ /double/ ) { $Yambo_precision="double" }; 
}
1;
