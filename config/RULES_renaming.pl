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
$N_PATTERNS=0;
#
# [1] = REFERENCE
# [2] = MODIFIED REFERENCE
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-andreaM";
$PATTERN[$N_PATTERNS][1]="o-05_rx_greenfunc.G_Sc_band_001_k_001";
$PATTERN[$N_PATTERNS][2]="o-05_rx_greenfunc.G_Sc_band_1_k_1";
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-andreaM";
$PATTERN[$N_PATTERNS][1]="o-05_rx_greenfunc.G_Sc_band_010_k_002";
$PATTERN[$N_PATTERNS][2]="o-05_rx_greenfunc.G_Sc_band_10_k_2";
#
@patts1 = qw(1 2);
@patts2 = qw(UP DN);
for $patt1 (@patts1) {$N_PATTERNS++;
 $patt2=shift @patts2;
 $PATTERN_branch[$N_PATTERNS]="devel-rt-rotate devel-ypp devel-rt-obs-and-ypp";
 $PATTERN[$N_PATTERNS][1]="spin_factors_$patt1";
 $PATTERN[$N_PATTERNS][2]="spin_factors_$patt2";}
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="devel-rt-rotate";
$PATTERN[$N_PATTERNS][1]="YPP-2D_occ_dos";
$PATTERN[$N_PATTERNS][2]="YPP-TD_dos";
#
$BRANCH_LIST="4.0 4.1 4.2 4.3 4.4";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="exc_amplitude_at_";
$PATTERN[$N_PATTERNS][1]="exc_qpt1_amplitude_at_";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="exc_weights_at_";
$PATTERN[$N_PATTERNS][1]="exc_qpt1_weights_at_";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="exc_E_sorted";
$PATTERN[$N_PATTERNS][1]="exc_qpt1_E_sorted";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="exc_E+spin_sorted";
$PATTERN[$N_PATTERNS][1]="exc_qpt1_E+spin_sorted";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="exc_I_sorted";
$PATTERN[$N_PATTERNS][1]="exc_qpt1_I_sorted";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="exc_I+spin_sorted";
$PATTERN[$N_PATTERNS][1]="exc_qpt1_I+spin_sorted";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="exc_1d";
$PATTERN[$N_PATTERNS][1]="exc_qpt1_1d";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="exc_2d";
$PATTERN[$N_PATTERNS][1]="exc_qpt1_2d";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="exc_3d";
$PATTERN[$N_PATTERNS][1]="exc_qpt1_3d";
#
$BRANCH_LIST="4.0 4.1 4.2 4.3 4.4 4.5";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="PPA.-02_QP_PPA";
$PATTERN[$N_PATTERNS][1]="PPA.02_QP_PPA";
#
$N_PATTERNS++;
$PATTERN_branch[$N_PATTERNS]="$BRANCH_LIST";
$PATTERN[$N_PATTERNS][2]="merged.-02_QP_PPA";
$PATTERN[$N_PATTERNS][1]="merged.02_QP_PPA";

