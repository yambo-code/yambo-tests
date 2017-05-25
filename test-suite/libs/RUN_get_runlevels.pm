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
sub RUN_get_runlevels{
#
$description="";
$YPP="0";
$YPP_RT="0";
$YPP_PH="0";
# Runlevels
$fixsyms=&RUN_feature("fixsyms");
if ($fixsyms eq "1") { $YPP=1; $description .= " Symmetries Compatibility Operations" };
$RT_X=&RUN_feature("RT_X");
if ($RT_X eq "1") { $description .= " Polarization FT" };
$NEGF=&RUN_feature("negf");
if ($NEGF eq "1") { $description .= " NEGF" };
$SETUP=&RUN_feature("setup");
if ($SETUP eq "1") { $description .= " setup" };
$HF=&RUN_feature("HF_and_locXC");
if ($HF eq "1") { $description .= " HF" };
$OPTICS=&RUN_feature("optics");
if ($OPTICS eq "1") { $description .= " optics" };
$SC=&RUN_feature("scpot");
if (&RUN_feature("magnetic") eq "1"){$SC="0"; $MAGNETIC="1"};
if ($SC eq "1") { $description .= " SC cycle" };
$CHI=&RUN_feature("chi");
if ($CHI eq "1") { $description .= " G-space" };
$GW=&RUN_feature("gw");
if ($GW eq "1") { $description .= " GW" };
$BSE=&RUN_feature("bse");
if ($BSE eq "1") { $description .= " T-space" };
$EM1S=&RUN_feature("em1s");
if ($EM1S eq "1") { $description .= " static screening" };
$EM1D=&RUN_feature("em1d");
if ($EM1D eq "1") { $description .= " dyn. screening" };
if (&RUN_feature("DBsIOoff=\"COLLs\"") eq "1"){$io_COLL="0"}else{$io_COLL="1"};
$COLL=&RUN_feature("collisions");
if ($COLL eq "1") { $description .= " collisions" };
$PPA=&RUN_feature("ppa");
if ($PPA eq "1") { $description .= " PPA" };
$COHSEX=&RUN_feature("cohsex");
if ($COHSEX eq "1") { $description .= " COHSEX" };
$EP=&RUN_feature("el_ph_corr");
if ($EP eq "1") { $description .= " e-p" };
$EPHOT=&RUN_feature("el_photon_corr");
if ($EPHOT eq "1") { $description .= " e-gamma" };
$EE_scatt=&RUN_feature("el_el_scatt");
if ($EE_scatt eq "1") { $description .= " e-e scatt" };
if (&RUN_feature("life") eq "1" and &RUN_feature("RTlifetimes") eq "1"){$LIFE="1"}else{$LIFE="0"};
if ($LIFE eq "1") { $description .= " lifetimes" };
#
if (&RUN_feature("Shifted_Grid") eq "1" or &RUN_feature("WFs_map") eq "1" or &RUN_feature("density") eq "1"){$YPP=1}
if (&RUN_feature("bzgrids") eq "1" or &RUN_feature("kpts_map") eq "1" or &RUN_feature("wavefunction") eq "1"){$YPP=1}
if (&RUN_feature("exciton") eq "1") {$YPP=1}
if (&RUN_feature("sort") eq "1") {$YPP=2}
if ($YPP eq "1") { $description .= " post-processing" };
if ($YPP eq "2") { $description .= " sorting" };
#
if (&RUN_feature("gkkp") eq "1" or &RUN_feature("eliashberg") eq "1") {$YPP_PH=1}
if (&RUN_feature("RealTime") eq "1" or &RUN_feature("RT_X") eq "1"  or &RUN_feature("QPDBs") eq "1" or &RUN_feature("RTDBs") eq "1") {$YPP_RT=1}
if ($YPP_PH eq "1") { $description .= " e-p post-processing" };
#
$YPP_NL=&RUN_feature("nonlinear");
if ($YPP_NL eq "1") { $description .= " non-lin post-processing" };
#
}
1;
