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
$N_PATTERNS=0;
#
# [1] = OLD
# [2] = NEW
#
# spin_factors_1->spin_factors_DN
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-rt-rotate devel-ypp devel-rt-obs-and-ypp";
$PATTERN[$N_PATTERNS][1]="spin_factors_1";
$PATTERN[$N_PATTERNS][2]="spin_factors_UP";
#
# spin_factors_2->spin_factors_UP
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-rt-rotate devel-ypp devel-rt-obs-and-ypp";
$PATTERN[$N_PATTERNS][1]="spin_factors_2";
$PATTERN[$N_PATTERNS][2]="spin_factors_DN";
#
# TD dos
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-rt-rotate";
$PATTERN[$N_PATTERNS][1]="YPP-2D_occ_dos";
$PATTERN[$N_PATTERNS][2]="YPP-TD_dos";
#
# EXC PP
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-BSE-finite-q";
$PATTERN[$N_PATTERNS][1]="exc_amplitude_at_";
$PATTERN[$N_PATTERNS][2]="exc_qpt1_amplitude_at_";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-BSE-finite-q";
$PATTERN[$N_PATTERNS][1]="exc_weights_at_";
$PATTERN[$N_PATTERNS][2]="exc_qpt1_weights_at_";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-BSE-finite-q";
$PATTERN[$N_PATTERNS][1]="exc_E_sorted";
$PATTERN[$N_PATTERNS][2]="exc_qpt1_E_sorted";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-BSE-finite-q";
$PATTERN[$N_PATTERNS][1]="exc_I_sorted";
$PATTERN[$N_PATTERNS][2]="exc_qpt1_I_sorted";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-BSE-finite-q";
$PATTERN[$N_PATTERNS][1]="exc_1d";
$PATTERN[$N_PATTERNS][2]="exc_qpt1_1d";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-BSE-finite-q";
$PATTERN[$N_PATTERNS][1]="exc_2d";
$PATTERN[$N_PATTERNS][2]="exc_qpt1_2d";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-BSE-finite-q";
$PATTERN[$N_PATTERNS][1]="exc_3d";
$PATTERN[$N_PATTERNS][2]="exc_qpt1_3d";

