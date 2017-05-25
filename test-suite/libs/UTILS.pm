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
sub command{
$cmd="@_";
if ($verb ge 2){
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
$ref_filename = "REFERENCE_$branch_key/".$_[0]; 
if(! -e "$ref_filename" ) { 
 $ref_filename = "REFERENCE_$branch_key/".$testname."/".$_[0]
};
if(! -e "$ref_filename" ) { 
 $ref_filename = "REFERENCE/".$_[0]; 
}
if(! -e "$ref_filename" ) { 
 $ref_filename = "REFERENCE/".$testname."/".$_[0];
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
if ($random_parallel) {$dir_extension.="-rand_par"};
if ($np eq 1 and !$nt and !$nt) {$dir_extension.="-serial"};
if(!$default_parallel && !$random_parallel && $np>1){$dir_extension.="-${run_id}"};
return "$prefix"."$dir_extension"."-$branch_key";
}
sub debug{
 $what = shift;
 print "\nDEBUG: $what\n";
}
1;
