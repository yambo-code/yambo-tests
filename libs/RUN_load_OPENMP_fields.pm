#
#        Copyright (C) 2000-2019 the YAMBO team
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
sub RUN_load_OPENMP_fields{
#
my $nt_here=1;
$nt_here=$nt if ($nt);
#
$OMP_field[1]="K_Threads= $nt_here";
$OMP_field[2]="X_Threads= $nt_here";
$OMP_field[3]="DIP_Threads= $nt_here";
$OMP_field[4]="SE_Threads= $nt_here";
$OMP_field[5]="RT_Threads= $nt_here";
$OMP_field[6]="NL_Threads= $nt_here";
#
}
1;
