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
sub trace{
 $trace=1;
 $trace *= $_ for @_;
 return $trace;
}
sub KILL{
$cmd="@_[0]";
$ID="@_[1]";
my $pid = `ps -awu | grep $user | grep '$cmd' | grep '$ID' | grep -v grep |  grep -v kill |grep -v null | awk '{P=P" "\$2}END{print P}'`;
chomp($pid);
print "\n Killing @_ with PID |$pid|\n" if ($verb);
if (not "$pid" eq "") {&command("kill -9 $pid")};
}
sub command{
$cmd="@_";
if ($verb){
 my $cwd=abs_path();
 &MY_PRINT($stdout, "$cmd @ $cwd\n");
}
$system_error=system($cmd);
return "$system_error";
}
sub CWD_save{
 $cwd_save=abs_path();
}
sub CWD_go{
 chdir($cwd_save);
}
sub gimme_reference
{
$ref_filename = $REF_prefix."REFERENCE_$branch_key/".$_[0]; 
if(! -e "$ref_filename" ) { 
 $ref_filename = $REF_prefix."REFERENCE_$branch_key/".$testname."/".$_[0]
};
if(! -e "$ref_filename" ) { 
 $ref_filename = $REF_prefix."REFERENCE/".$_[0]; 
}
if(! -e "$ref_filename" ) { 
 $ref_filename = $REF_prefix."REFERENCE/".$testname."/".$_[0];
}
if(! -e "$ref_filename" ) { 
 $ref_filename = "FAIL";
}
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
