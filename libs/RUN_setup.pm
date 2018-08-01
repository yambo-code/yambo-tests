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
 undef $LAST_COMPLETED_RUN;
 #
 # cpu_conf
 $cpu_conf="[".$string;
 if (not $string eq "serial"){
  if($np gt 1){ $cpu_conf=$cpu_conf."(N=$np)" };
  if(not $random_parallel and not $default_parallel){ $cpu_conf=$cpu_conf."(ID=$ir)" };
 }
 if($nt){ $cpu_conf=$cpu_conf."(Threads=$nt)" };
 if($nl){ $cpu_conf=$cpu_conf."(SLK=$nl)" };
 if($P2Y){$cpu_conf=$cpu_conf."($P2Y_format"."@"."$P2Y_datadir)" };
 #
 # message
 $message=$cpu_conf."] $testname: $description";
 my $msg = sprintf("%-"."$left_length"."s", $message);
 &MESSAGE("LOG","\n$msg");
 #
 # dir name
 $dir_name=&test_dir_name($testname,$ir);
 &command("rm -fr $dir_name $testname");
 #
 # input file
 if (not $P2Y) {
  &command("cat $cpu $input_folder/$testname >> yambo.in");
  if( -e "$suite_dir/$host/$user/FLAGS") {&command("cat $suite_dir/$host/$user/FLAGS >> yambo.in")};
 }
 #
 # append specs
 @specs = split(/\s+/,$string);
 open IN, ">>", "yambo.in" or die "Couldn't open file: $!\n";
 foreach $field (@PAR_field) {print IN "$field \n"};
 foreach $field (@LA_field)  {print IN "$field \n"};
 foreach $field (@OMP_field) {print IN "$field \n"};
 foreach $spec  (@specs)     {print IN "$spec \n"};
 close IN;
 #
 # Input file
 $INPUT_file="yambo.in";
 if ($yambo_exec =~ /\/p2y/) { $INPUT_file=$P2Y_datafile };
}
if ("@_" =~ "after_run"){
 #
 # Collect all the outputs into $dir_name (e.g. ./01_init_N1-M1)
 #
 if (-d $testname or $update_test){
  if (!-d $dir_name and -d $testname) {&command("mv $testname $dir_name")};
  if (!-d $dir_name and !-d $testname) {&command("mkdir $dir_name")};
  if ($ir == $Nr and $LAST_COMPLETED_RUN) {&command("ln -s $LAST_COMPLETED_RUN $testname")};
 }else{
  if (!-d $dir_name) {&command("mkdir $dir_name"); };
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
 if ($error eq "DIR_SKIPPED") { 
  &MY_PRINT($stdout, "$CHECK_error\n") if ($verb);
 }elsif ($mode eq "tests" || $mode eq "validate" || $mode eq "cheers") {
  #
  $dir_end_time = [gettimeofday];
  $TT  = tv_interval($dir_start_time, $dir_end_time);
  $dir_start_time = $dir_end_time;
  #
  $sec = &ceil(10.*$TT)/10.;
  $sec_run = &ceil(100.* $sec / ($dir_ok+$dir_failed))/100.;
  #
  $message_setup="$g_s $dir_ok passes $g_e";
  if ($dir_failed gt 0) {$message_setup="$message_setup $r_s $dir_failed fails $r_e"};
  $msg=sprintf(" %-20s %-5s [%-4s/%-3s]",$message_setup,"${sec}s","${sec_run}s","test");
  #
  &MY_PRINT($stdout, "$msg\n");
  &MY_PRINT($rlog,   "$msg\n");
  #
 }else{
  &MY_PRINT($stdout, "\n");
  &MY_PRINT($rlog,   "\n");
 }
}
}
1;
