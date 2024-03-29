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
sub RUN_load_LA_fields{
#
my $nl_here=1;
$nl_here=$nl if ($nl);
#
$LA_field[1]="X_nCPU_LinAlg_INV=$nl_here";
$LA_field[2]="X_and_IO_nCPU_LinAlg_INV=$nl_here";
$LA_field[3]="X_q_0_nCPU_LinAlg_INV=$nl_here";
$LA_field[4]="X_finite_q_nCPU_LinAlg_INV=$nl_here";
$LA_field[5]="BS_nCPU_LinAlg_INV=$nl_here";
$LA_field[6]="BS_nCPU_LinAlg_DIAGO=$nl_here";
$LA_field[7]="SE_nCPU_LinAlg_DIAGO=$nl_here";
#
}
1;
