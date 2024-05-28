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
sub SETUP_FC_kind{
#
# FC & Yambo precision
open(SETUP_file,"<","$comp_folder/config/setup");
$MPI_kind="unknown";
$MPI_kind_short="unknown";
$FC_kind="unknown";
$FC_version="";
while(<SETUP_file>) {
 chomp($_);
 if($_ =~ /fc_kind/) {
  ($desc, $equal, $FC_kind) = split(/\s+/,$_); 
 }
 if($_ =~ /fc_version/) {
  ($desc, $FC_version) = split(/=/,$_);
 }
 if($_ =~ /mpi_kind/) { 
  ($desc, $MPI_kind) = split(/=/,$_);
  if($MPI_kind eq "" ) { $MPI_kind="unknown"}; 
 }
 if($_ =~ /lmpi/) { 
  ($desc, $MPI_lib) = split(/=/,$_);
  if($MPI_lib eq "" ) { $MPI_kind="Serial"}; 
 }
 if($_ =~ /yprecision/) { 
  ($desc, $Yambo_precision) = split(/=/,$_);
 }
};
close(SETUP_file);
$FC_kind_ext="$FC_kind $FC_version";
if($MPI_kind =="Serial") { $MPI_kind_short="Serial" }; 
if($MPI_kind =~ /Open/ ) { $MPI_kind_short="OpenMPI" }; 
if($MPI_kind =~ /MPICH/) { $MPI_kind_short="MPICH" }; 
if($MPI_kind =~ /Intel/) { $MPI_kind_short="IntelMPI"}; 
#
if($Yambo_precision =~ /single/ ) { $Yambo_precision="single" }; 
if($Yambo_precision =~ /double/ ) { $Yambo_precision="double" }; 
#
#CUDA
open(REPORT_file,"<","$comp_folder/config/report");
$CUDA_support="no";
while(<REPORT_file>) {
 if($_ =~ /CUDA/ && $_ =~ /X/) {$CUDA_support="yes"}
};
close(REPORT_file);
}
1;
