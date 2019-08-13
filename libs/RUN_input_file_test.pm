#
#        Copyright (C) 2000-2019 the YAMBO team
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

 my $NEW_file=$INPUT_file."_generated";
 my $CMD;
 &command("echo \"ORIGINAL\" >> $INPUT_file");
 &command("cp $INPUT_file $NEW_file");

 if ($SETUP=="1")   { $CMD=$CMD." -setup" };
 if ($HF=="1")      { $CMD=$CMD." -hf"};
 if ($GW=="1")      { $CMD=$CMD." -dyson n"};
 if ($PPA=="1")     { $CMD=$CMD." -gw p"};
 if ($COHSEX=="1")  { $CMD=$CMD." -gw c"};
 if ($BSE=="1")     { $CMD=$CMD." -optics b"};
 if ($CHI=="1")     { $CMD=$CMD." -optics c"};
 if ($EM1S=="1")    { $CMD=$CMD." -Xs"};
 if ($SC=="1")      { $CMD=$CMD." -sc"};

 if (&RUN_feature("BSSmod= \"di\"")=="1") {$CMD=$CMD." -Ksolver di"};
 if (&RUN_feature("BSSmod= \"d\"")=="1")  {$CMD=$CMD." -Ksolver d"};
 if (&RUN_feature("BSSmod= \"s\"")=="1")  {$CMD=$CMD." -Ksolver s"};
 if (&RUN_feature("BSSmod= \"h\"")=="1")  {$CMD=$CMD." -Ksolver h"};
 if (&RUN_feature("BSSmod= \"i\"")=="1")  {$CMD=$CMD." -Ksolver i"};

 if (&RUN_feature("negf")=="1") {$CMD=$CMD." -rt p"};
 if (&RUN_feature("collisions")=="1") {$CMD=$CMD." -collisions"};
 if (&RUN_feature("el_photon_scatt")=="1") {$CMD=$CMD." -scattering h"};
 if (&RUN_feature("el_ph_scatt")=="1") {$CMD=$CMD." -scattering p"};
 if (&RUN_feature("el_el_scatt")=="1") {$CMD=$CMD." -scattering e"};

 my $POT;
 if (&RUN_feature("HXC_Potential= IP")=="1") {$POT="ip"};
 if (&RUN_feature("HXC_Potential= DEFAULT")=="1") {$POT=$POT."d"};
 if (&RUN_feature("HXC_Potential= HARTREE")=="1") {$POT=$POT."h"}
 if (&RUN_feature("HXC_Potential= COH")=="1") {$POT=$POT."coh"}
 if (&RUN_feature("HXC_Potential= SEX")=="1") {$POT=$POT."sex"}
 if (&RUN_feature("HXC_Potential= FOCK")=="1") {$POT=$POT."f"}
 if (&RUN_feature("HXC_Potential= LDA_X")=="1") {$POT=$POT."ldax"};
 if (&RUN_feature("HXC_Potential= PZ")=="1") {$POT=$POT."pz"};
 if ($POT) {$CMD=$CMD." -potential ".$POT};

 if (&RUN_feature("BSKmod= \"SEX\"")=="1")      { $CMD=$CMD." -kernel sex"};
 if (&RUN_feature("BSKmod= \"ALDA\"")=="1")      { $CMD=$CMD." -kernel alda"};
 if (&RUN_feature("BSKmod= \"Hartree\"")=="1")   { $CMD=$CMD." -kernel hartree"};
 if (&RUN_feature("BSKmod= \"HF\"")=="1")   { $CMD=$CMD." -kernel hf"};

 if (&RUN_feature("RT_X")=="1") { $CMD=$CMD." -rtplot X"};
 if (&RUN_feature("kpts_map")=="1") { $CMD=$CMD." -map"};
 if (&RUN_feature("RTDBs")=="1" && &RUN_feature("Select_Fermi")=="1") { $CMD=$CMD." -rtdb f"};
 if (&RUN_feature("freehole")=="1") { $CMD=$CMD." -freehole"};
 if (&RUN_feature("excitons")=="1" && &RUN_feature("amplitude")=="1")   { $CMD=$CMD." -exciton a"};
 if (&RUN_feature("excitons")=="1" && &RUN_feature("wavefunction")=="1")   { $CMD=$CMD." -exciton w"};
 if (&RUN_feature("electrons")=="1" && &RUN_feature("wavefunction")=="1")   { $CMD=$CMD." -electron w"};
 if (&RUN_feature("electrons")=="1" && &RUN_feature("dos")=="1")   { $CMD=$CMD." -electron s"};
 if (&RUN_feature("electrons")=="1" && &RUN_feature("density")=="1")   { $CMD=$CMD." -electron d"};

 if (&RUN_feature("sort")=="1")   { return "OK" };

 if ($CMD) {
  &command("$yambo_exec -Q $CMD -F $NEW_file $log");
  if (compare("$INPUT_file","$NEW_file") == 0) {
   return "Input not Generated";
  }else{
   print "\nCMD $CMD\n";
   $INPUT_file=$NEW_file;
   return "OK";
  }
 }else{
  return "No CMD found";
 }
}
1;
