#!/usr/bin/perl
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
# spin_factors_1->spin_factors_DN
#
$PATTERN[1][1]="spin_factors_1";
$PATTERN[1][2]="spin_factors_UP";
#
# spin_factors_2->spin_factors_UP
#
$PATTERN[2][1]="spin_factors_2";
$PATTERN[2][2]="spin_factors_DN";
#
# Slepc
#
#$PATTERN[3][1]="diago";
#$PATTERN[3][2]="slepc";
#
$N_PATTERNS=2;
