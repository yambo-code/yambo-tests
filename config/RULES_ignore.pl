#!/usr/bin/perl
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
# Keywords listed here are matched against REFERENCE files and ignored
#
$N_IGNORE=0;
#
@PATTS = qw(k2_kRT10 k2_kRT11 k2_kRT12 k2_kRT13 k2_kRT14 k2_kRT15 k2_kRT16 k2_kRT17 k2_kRT18 k2_kRT19 k2_kRT20 k3_kRT18 k3_kRT19 k3_kRT20 k2_kRT99);
for $patt (@PATTS) {$N_IGNORE++;
$IGNORE_branch[$N_IGNORE]="devel-andreaM";
$IGNORE_file[$N_IGNORE]="$patt";
$IGNORE_test[$N_IGNORE]="Si_bulk/RT"}
#
@PATTS = qw(10_ypp_Map_FineGridx9.ndb.Double_Grid);
for $patt (@PATTS) {$N_IGNORE++;
$IGNORE_branch[$N_IGNORE]="devel-andreaM";
$IGNORE_file[$N_IGNORE]="$patt";
$IGNORE_test[$N_IGNORE]="Si_bulk/RT"}
#
