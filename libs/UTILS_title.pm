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
sub UTILS_title{
#
my $fh = shift;
#
# tests
if ($verb ge 2) {
 &MY_PRINT( $fh, "\n        Running tests : ".join("\n                ",@input_tests_list));
}else{
 &MY_PRINT( $fh, "\n        Running tests : ".$user_tests);
};
#
# Projects
&MY_PRINT( $fh,  "\n             Projects : $project");
#
# Verb
$verbosity_level = "low";
$verbosity_level = "high" if ($verb eq 1);
$verbosity_level = "highest" if ($verb ge 2);
&MY_PRINT( $fh, "\n            Verbosity : $verbosity_level ") if (!$reduced_log);
&MY_PRINT( $fh, "\n            Precision : $prec ") if (!$reduced_log);
&MY_PRINT( $fh, "\n             Hostname : $host ") if (!$reduced_log);
&MY_PRINT( $fh, "\n                 User : $user ") if (!$reduced_log);
#
if ($branch) {
 &MY_PRINT( $fh,  "\n             revision : $REVISION ") if (!$reduced_log);
 &MY_PRINT( $fh,  "\n                build : $BUILD ") if (!$reduced_log);
 &MY_PRINT( $fh,  "\n             compiler : $FC_kind ") if (!$reduced_log);
 &MY_PRINT( $fh,  "\n              bin dir : $conf_bin ");
 &MY_PRINT( $fh,  "\n           shortname  : $branch_key") if (!$reduced_log);
}
#
if ($branch) {
 &MY_PRINT( $fh,  "\n               source : $branch ");
}
#
# PARALLEL stuff
#
$PAR_mode="none";
if($#NP_set > 1 or $NP_set[0]>1) { 
 if ($default_parallel) {
  $PAR_mode="single, default parallelization";
 }elsif ($random_parallel) {
  $PAR_mode="single, random parallelization";
 }else{
  $PAR_mode="loop over combinations";
 }
 &MY_PRINT($fh,  "\n        Parallel conf : $PAR_mode ");
 &MY_PRINT($fh,  "\n                  MPI : $mpiexec ");
 &MY_PRINT($fh,  "\n                 CPUs : @NP_set ");
}else{
  &MY_PRINT($fh, "\n        Parallel Loop : SERIAL");
}
if($nt and $nt>1) { 
 &MY_PRINT($fh,  "\n              Threads : $nt ");
}
if($nl and $nl>1) {
 &MY_PRINT($fh,  "\n        Lin. Algebra  : $nl ");
}
#
}
1;
