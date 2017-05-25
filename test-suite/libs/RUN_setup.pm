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
sub RUN_setup{
#
if ("@_" =~ "INIT"){
 #
 # Global cpu_conf
 $cpu_global_conf="[";
 if($np gt 1){ $cpu_global_conf=$cpu_global_conf."(N=$np)" };
 if($nt){ $cpu_global_conf=$cpu_global_conf."(Threads=$nt)" };
 if($nl){ $cpu_global_conf=$cpu_global_conf."(SLK=$nl)" };
 if ("$cpu_global_conf" eq "[") {
  $cpu_global_conf="[serial]";
 }else{
  $cpu_global_conf= $cpu_global_conf."]";
 }
};
if ("@_" =~ "before_run"){
 #
 # cpu_conf
 $cpu_conf="[".$string;
 if (not $string eq "serial"){
  if($np gt 1){ $cpu_conf=$cpu_conf."(N=$np)" };
 }
 if($nt){ $cpu_conf=$cpu_conf."(Threads=$nt)" };
 if($nl){ $cpu_conf=$cpu_conf."(SLK=$nl)" };
 #
 # message
 $message=$cpu_conf."] $testname: $description";
 my $msg = sprintf("%-"."$left_length"."s", $message);
 &MESSAGE("LOG","\n$msg");
 #
 # dir name
 $dir_name=&test_dir_name($testname,$ir);
 &command("rm -fr $dir_name");
 #
 # input file
 &command("cat $cpu $input_folder/$testname > yambo.in");
 if( -e "$suite_dir/$host/FLAGS") {&command("cat $suite_dir/$host/FLAGS >> yambo.in")};
 #
 # append specs
 @specs = split(/\s+/,$string);
 open IN, ">>", "yambo.in" or die "Couldn't open file: $!\n";
 foreach $field (@PAR_field) {print IN "$field \n"};
 foreach $spec (@specs)      {print IN "$spec \n"};
 close IN;
}
if ("@_" =~ "after_run"){
 #
 # Collect all the outputs into $dir_name (e.g. ./01_init_N1-M1)
 #
 if (-d $testname){
  if (!-d $dir_name) {&command("mv $testname $dir_name")}; 
  if ($ir == $Nr and  not "$dir_name" eq "$testname" ) {&command("ln -s $dir_name $testname")};
 }else{
   &command("mkdir $dir_name");
 }
 #
 copy("yambo.in", $dir_name) or &MESSAGE("ERROR WHITE","Error copying file $!");
 foreach $file (<o-*$testname*>) 			{ move($file,$dir_name) };
 foreach $file (<r-*$testname*>,<ref_*>,<run_*>) 	{ move($file,$dir_name) };
 foreach $file (<l-*$testname*>) 			{ move($file,$dir_name) };
 foreach $file (<LOG/l*$testname*>)		{ move($file,$dir_name) };
 if( -e "l_stderr")   { move("l_stderr","$dir_name/l-${testname}_stderr") };
 #
}
if ("@_" =~ "after_tests_loop"){
 # 
 # Restore SAVE/SAVE_backup and GKKP to old format
 #
 if(-e "SAVE_backup_old") {
  &command("rm -fr SAVE_backup");
  &command("mv SAVE_backup_old SAVE_backup");
 }
 elsif (-e "SAVE_old") {
  &command("rm -fr SAVE");
  &command("mv SAVE_old SAVE");
 }
 if(-e "GKKP_old") {
  &command("rm -fr GKKP");
  &command("mv GKKP_old GKKP");
 }
 if ($error eq "DIR_SKIPPED") { 
  &MY_PRINT($stdout, "$CHECK_error\n") if ($verb);
 }else{
  &MY_PRINT($stdout, "$g_s $dir_ok passes $g_e");
  if ($dir_failed gt 0) {&MY_PRINT($stdout, "$r_s $dir_failed fails $r_e")};
  &MY_PRINT($stdout, "\n");
 }
}
}
1;
