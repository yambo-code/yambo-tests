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
sub trace{
 $trace=1;
 $trace *= $_ for @_;
 return $trace;
}
sub KILL{
$cmd="$mpiexec";
if($np==1){ $cmd="@_[0]";}
$ID="@_[1]";
my $pid1 = `ps -awu | $grep $user | $grep '$cmd' | $grep '$ID' | $grep -v $grep | $grep -v kill |$grep null | awk '{P=P" "\$2}END{print P}'`;
chomp($pid1);
my $pid2 = `ps -awu | $grep $user | $grep '$cmd' | $grep '$ID' | $grep -v $grep | $grep -v kill |$grep -v null | awk '{P=P" "\$2}END{print P}'`;
chomp($pid2);
if (not "$pid1" eq "") {
 print "\n Killing @_ with PID |$pid1|\n"; # if ($verb);
 &command("kill $pid1");
};
if (not "$pid2" eq "") {
 print "\n Killing @_ with PID |$pid2|\n"; # if ($verb);
 &command("kill $pid2");
};
}
sub command{
$cmd="@_";
if ($verb){
 my $cwd=abs_path();
 &MY_PRINT($stdout, "$cmd @ $cwd\n");
}
if ($dry_run) {
 print "\n CMD: $cmd";
}else{
 $system_error=system($cmd);
 return "$system_error";
}
}
sub CWD_save{
 $cwd_save=abs_path();
}
sub CWD_go{
 chdir($cwd_save);
}
sub gimme_reference
{
my $RUN_local=$_[0];
#
for $ipatt (1...$N_PATTERNS) 
{
 if ($RUN_local =~ $PATTERN[$ipatt][1]){
   $RUN_local =~ s/$PATTERN[$ipatt][2]/$PATTERN[$ipatt][1]/;
 }
}
#
$ref_filename = $REF_prefix."REFERENCE_$branch_key/".$RUN_local;
print "\n\n PROP $ref_filename\n";
if(! -e "$ref_filename" ) { 
 $ref_filename = $REF_prefix."REFERENCE_$branch_key/".$testname."/".$RUN_local;
};
if(! -e "$ref_filename" ) { 
 $ref_filename = $REF_prefix."REFERENCE/".$RUN_local;
}
if(! -e "$ref_filename" ) { 
 $ref_filename = $REF_prefix."REFERENCE/".$testname."/".$RUN_local;
}
if(! -e "$ref_filename" ) { 
 $ref_filename = "FAIL";
}
if ( not $ref_filename =~ /FINAL/ ){print " FINAL $ref_filename\n\n"};
}
sub test_dir_name
{
my $prefix = $_[0];
my $run_id = $_[1];
my $dir_extension="";
if ($nt>1) {$dir_extension.="-Omp${nt}"};
if ($nl>1) {$dir_extension.="-Slk${nl}"};
if ($np>1) {$dir_extension.="-Nmpi${np}"};
if ($default_parallel) {$dir_extension.="-def_par"};
if ($random_parallel)  {$dir_extension.="-rand_par"};
if ($np eq 1 and !$nt and !$nt) {$dir_extension.="-serial"};
if ($cpu_conf_file) {
 $dir_extension.="-$cpu_conf_key";
}elsif (!$default_parallel && !$random_parallel && $np>1) {
 $dir_extension.="-${run_id}";
}
return "$prefix"."$dir_extension"."-$branch_key";
}
sub debug{
 $what = shift;
 print "\nDEBUG: $what\n";
}
1;
