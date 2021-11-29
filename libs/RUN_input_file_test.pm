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
sub RUN_input_file_test{

 undef $NEW_file;
 my $CMD;
 if (-f $INPUT_file) 
 {
  $NEW_file=$INPUT_file."_generated";
  &command("echo \"ORIGINAL\" >> $INPUT_file");
  &command("cp $INPUT_file $NEW_file");
 }

 if ($SETUP=="1")   { $CMD=$CMD." -setup" };
 if ($HF=="1")      { $CMD=$CMD." -hf"};
 if ($GW=="1" && &RUN_feature("_gw_")==0) { $CMD=$CMD." -dyson n"};
 if ($PPA=="1" &&  &RUN_feature("gw")==1  &&  &RUN_feature("_gw_")==0 )    { $CMD=$CMD." -gw0 p"};
 if ($PPA=="1" &&  &RUN_feature("gw")==0  &&  &RUN_feature("_gw_")==0)    { $CMD=$CMD." -X p"};
 if ($COHSEX=="1" &&  &RUN_feature("_gw_")==0)  { $CMD=$CMD." -gw0 c"};
 if ($BSE=="1")     { $CMD=$CMD." -optics b"};
 if ($CHI=="1")     { $CMD=$CMD." -optics c"};
 if ($EM1S=="1")    { $CMD=$CMD." -X s"};
 if ($EM1D=="1")    { $CMD=$CMD." -X d"};
 if ($SC=="1")      { $CMD=$CMD." -sc"};
 if ($LIFE=="1")    { $CMD=$CMD." -lifetimes"};

 if (&RUN_feature("rim_cut")=="1") {$CMD=$CMD." -coulomb"};
 if ($GW=="1" && $EM1D=="1") {$CMD=$CMD." -gw0 r"}

 if (&RUN_feature("DysSolver= \"n\"")=="1") {$CMD=$CMD." -dyson n"};
 if (&RUN_feature("DysSolver= \"s\"")=="1") {$CMD=$CMD." -dyson s"}
 if (&RUN_feature("DysSolver= \"g\"")=="1") {$CMD=$CMD." -dyson g"};

 if (&RUN_feature("BSSmod= \"di\"")=="1") {$CMD=$CMD." -Ksolver di"};
 if (&RUN_feature("BSSmod= \"d\"")=="1")  {$CMD=$CMD." -Ksolver d"};
 if (&RUN_feature("BSSmod= \"s\"")=="1")  {$CMD=$CMD." -Ksolver s"};
 if (&RUN_feature("BSSmod= \"h\"")=="1")  {$CMD=$CMD." -Ksolver h"};
 if (&RUN_feature("BSSmod= \"hd\"")=="1")  {$CMD=$CMD." -Ksolver hd"};
 if (&RUN_feature("BSSmod= \"dh\"")=="1")  {$CMD=$CMD." -Ksolver hd"};
 if (&RUN_feature("BSSmod= \"hdi\"")=="1")  {$CMD=$CMD." -Ksolver hdi"};
 if (&RUN_feature("BSSmod= \"i\"")=="1")  {$CMD=$CMD." -Ksolver i"};

 if (&RUN_feature("negf")=="1") {$CMD=$CMD." -rt p"};
 if (&RUN_feature("collisions")=="1") {$CMD=$CMD." -collisions"};
 
 if (&RUN_feature("el_photon_scatt")=="1") {
   if (not $is_NEW_scatt) {$CMD=$CMD." -scattering h"}
   if (    $is_NEW_scatt) {$CMD=$CMD." -scattering eh"}
 }
 if (&RUN_feature("el_ph_scatt")=="1") {
   if (not $is_NEW_scatt) {$CMD=$CMD." -scattering p"}
   if (    $is_NEW_scatt) {$CMD=$CMD." -scattering ep -J GKKP"}
 }
 if (&RUN_feature("el_el_scatt")=="1") {
   if (not $is_NEW_scatt) {$CMD=$CMD." -scattering e"}
   if (    $is_NEW_scatt) {$CMD=$CMD." -scattering ee"}
 }
 if (&RUN_feature("ph_el_scatt")=="1") {
   if (    $is_NEW_scatt) {$CMD=$CMD." -scattering pe"}
 }

 my $POT;
 if (&RUN_feature("HXC_Potential= IP")=="1") {$POT="ip"};
 if (&RUN_feature("HXC_Potential= HARTREE")=="1") {$POT=$POT."h"};
 if (&RUN_feature("HXC_Potential= HARTREE+SEX")=="1") {$POT=$POT."hsex"};
 if (&RUN_feature("HXC_Potential= GS_xc")=="1") {$POT=$POT."gs"};
 if (&RUN_feature("HXC_Potential= COH")=="1") {$POT=$POT."coh"}
 if (&RUN_feature("HXC_Potential= SEX")=="1") {$POT=$POT."sex"}
 if (&RUN_feature("HXC_Potential= FOCK")=="1") {$POT=$POT."f"}
 if (&RUN_feature("HXC_Potential= LDA_X")=="1") {$POT=$POT."ldax"};
 if (&RUN_feature("HXC_Potential= PZ")=="1") {$POT=$POT."pz"};
 if (&RUN_feature("HXC_Potential= DEFAULT")=="1") {$POT="d"};
 if (&RUN_feature("HXC_Potential= default")=="1") {$POT="d"};
 if ($POT) {$CMD=$CMD." -potential ".$POT};

 if (&RUN_feature("magnetic")=="1") 
 { 
   if (&RUN_feature("Hamiltonian= \"landau\"")=="1") { $CMD=$CMD." -magnetic l"};
   if (&RUN_feature("Hamiltonian= \"pauli\"")=="1") { $CMD=$CMD." -magnetic p"};
   if (&RUN_feature("Hamiltonian= \"all\"")=="1") { $CMD=$CMD." -magnetic a"};
 };

 if (&RUN_feature("el_ph_corr")=="1")      { $CMD=$CMD." -correlation ep -gw0 fan"};
 if (&RUN_feature("ph_el_corr")=="1")      { $CMD=$CMD." -correlation pe -gw0 X"};

 if (&RUN_feature("BSKmod= \"SEX\"")=="1")      { $CMD=$CMD." -kernel sex"};
 if (&RUN_feature("BSKmod= \"ALDA\"")=="1")      { $CMD=$CMD." -kernel alda"};
 if (&RUN_feature("Chimod= \"ALDA\"")=="1")      { $CMD=$CMD." -kernel alda"};
 if (&RUN_feature("BSKmod= \"HARTREE\"")=="1")   { $CMD=$CMD." -kernel hartree"};
 if (&RUN_feature("BSKmod= \"Hartree\"")=="1")   { $CMD=$CMD." -kernel hartree"};
 if (&RUN_feature("Chimod= \"HARTREE\"")=="1" && $BSE=="0")   { $CMD=$CMD." -kernel hartree"};
 if (&RUN_feature("Chimod= \"Hartree\"")=="1" && $BSE=="0")   { $CMD=$CMD." -kernel hartree"};
 if (&RUN_feature("Chimod= \"LRC\"")=="1")   { $CMD=$CMD." -kernel lrc"};
 if (&RUN_feature("BSKmod= \"HF\"")=="1")   { $CMD=$CMD." -kernel hf"};

 if (&RUN_feature("WFs_map")=="1"){ 
  if (not $is_WF_convertion_free) {$CMD=$CMD." -wf p"}
  if (    $is_WF_convertion_free) {$CMD=$CMD." -soc"}
 };
 if (&RUN_feature("fixsyms")=="1") { $CMD=$CMD." -fixsym"};
 if (&RUN_feature("RToccupations")=="1") { $CMD=$CMD." -rtplot o"};
 if (&RUN_feature("RTdeltaRho")=="1") { $CMD=$CMD." -rtplot d"};
 if (&RUN_feature("RTenergy")=="1") { $CMD=$CMD." -rtmode e"};
 if (&RUN_feature("RTfitbands")=="1") { $CMD=$CMD." -rtmode b"};
 if (&RUN_feature("RTdos")=="1") { $CMD=$CMD." -rtmode d"};
 if (&RUN_feature("RTtime")=="1") { $CMD=$CMD." -rtmode t"};
 if (&RUN_feature("RTabs")=="1") { $CMD=$CMD." -rtplot a"};
 if (&RUN_feature("RT_X")=="1") { $CMD=$CMD." -rtplot X"};
 if (&RUN_feature("K_grid")=="1") { $CMD=$CMD." -grid k"};
 if (&RUN_feature("QPDB_edit")=="1") { $CMD=$CMD." -qpdb g"};
 if (&RUN_feature("QPDB_merge")=="1") { $CMD=$CMD." -qpdb m"};
 if (&RUN_feature("QPDB_expand")=="1") { $CMD=$CMD." -qpdb e"};
 if (&RUN_feature("Shifted_Grid")=="1") { $CMD=$CMD." -grid s"};
 if (&RUN_feature("High_Symm")=="1") { $CMD=$CMD." -grid h"};
 if (&RUN_feature("avehole")=="1") { $CMD=$CMD." -avehole"};
 if (&RUN_feature("kpts_map")=="1") { $CMD=$CMD." -map"};
 if (&RUN_feature("RTDBs")=="1" && &RUN_feature("Select_Fermi")=="1") { $CMD=$CMD." -rtdb f"};
 if (&RUN_feature("RTDBs")=="1" && &RUN_feature("Select_energy")=="1") { $CMD=$CMD." -rtdb e"};
 if (&RUN_feature("RTDBs")=="1" && &RUN_feature("Select_kspace")=="1") { $CMD=$CMD." -rtdb k"};
 if (&RUN_feature("freehole")=="1") { $CMD=$CMD." -freehole"};
 if (&RUN_feature("excitons")=="1" && &RUN_feature("amplitude")=="1")   { $CMD=$CMD." -exciton a"};
 if (&RUN_feature("excitons")=="1" && &RUN_feature("wavefunction")=="1")   { $CMD=$CMD." -exciton w"};
 if (&RUN_feature("excitons")=="1" && &RUN_feature("spin")=="1")   { $CMD=$CMD." -exciton sp"};
 if (&RUN_feature("electrons")=="1" && &RUN_feature("wavefunction")=="1")   { $CMD=$CMD." -electron w"};
 if (&RUN_feature("electrons")=="1" && &RUN_feature("dos")=="1")   { $CMD=$CMD." -electron s"};
 if (&RUN_feature("eliashberg")=="1" && &RUN_feature("electron")=="1") { $CMD=$CMD." -electron e"};
 if (&RUN_feature("bnds")=="1" && &RUN_feature("electron")=="1") { $CMD=$CMD." -electron b"};
 if (&RUN_feature("electrons")=="1" && &RUN_feature("density")=="1")   { $CMD=$CMD." -electron d"};
 if (&RUN_feature("electrons")=="1" && &RUN_feature("dos")=="1")   { $CMD=$CMD." -electron s"};
 if (&RUN_feature("electrons")=="1" && &RUN_feature("dos")=="1" && &RUN_feature("bnds")=="1" )   { $CMD=$CMD." -electron sb"};

 if (&RUN_feature("sort")=="1")   { return "OK" };
 if (&RUN_feature("p2y")=="1")   { return "OK" };
 if (&RUN_feature("a2y")=="1")   { return "OK" };

 if ($CMD and $NEW_file) {
  &command("$yambo_exec -Q $CMD -F $NEW_file $log");
  if (compare("$INPUT_file","$NEW_file") == 0) {
   return "Input not Generated";
  }else{
   $INPUT_file=$NEW_file;
   return "OK";
  }
 }else{
  return "No CMD found";
 }
}
1;
