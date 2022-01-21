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
sub PHP_generate{
#
if( not ( -d "backup_and_www/$host/www/" ) ){ &command("mkdir -p backup_and_www/$host/www/");}
if( not ($branch_key eq "") ){ &command("rm -fr backup_and_www/$host/www/$branch_key");}
if(     ($branch_key eq "") ){ &command("rm -fr backup_and_www/$host/www/*");}
#
&UTILS_list_backups;
#
$i_file = 0;
$i_dir = 0;
foreach $dir (@reversed_dirs) {
 @files = glob("$dir/REPORT*");
 $yambo_branch="none";
 foreach $file (@files) {
  $i_file = $i_file+1;
  open(REPORT,"<","$suite_dir/$file");
  @lines = <REPORT>;
  &PHP_key_words($file);
  if ($branch_php and not "$branch_php" eq "$yambo_branch" ) {next};
  if (not $branch_php and not "$branch_key" eq "$yambo_branch") {next} ;
  $i_dir = $i_dir+1;
  if ($i_dir > 21 ) {next};
  print "Processing $dir...\n";
  &PHP_extract;
  close(REPORT);
 }
}
}
#
sub PHP_key_words{
 # Notice that here date and time are already defined
 $robot_id = (split(/REPORT-R/,@_[0]))[1];
 $robot_id = (split(/-/,$robot_id))[0];
 &get_line("Yambo      branch");
 $yambo_branch=$pattern[0][2];
 &get_line("Test-suite branch");
 $tsuite_branch=$pattern[0][2];
 if( $yambo_branch eq ""){$yambo_branch="none";}
 &get_line("Build");
 if ($n_patterns eq 0)
 {
   undef $BUILD;
   undef $MPI_kind;
   undef $FC_kind;
   undef $REVISION;
   undef $Yambo_precision;
   undef $duration;
   return;
 }
 $BUILD=$pattern[0][3];
 $BUILD =~ s/\+/ /g;
 $MPI_kind=$pattern[0][5];
 $FC_kind=$pattern[0][7];
 $REVISION=$pattern[0][9];
 if ($FC_kind =~ /rev./) 
 {
  $REVISION=$FC_kind;
  $FC_kind=$MPI_kind;
  $MPI_kind=" ";
 }
#
&get_line("Compilation Scheme");
$scheme=$pattern[0][2]; 
$Yambo_precision="unknown";
&get_line("Compilation Precision");
if ($n_patterns > 0) { $Yambo_precision=$pattern[0][2];  };
#
&get_line("Date");
$date=$pattern[0][3];
$time=$pattern[0][5];
$time=~ s/\-/h/g;
$time.="m";
#
&get_line("TOTAL");
$duration="";
if( $pattern[0][3] != "") { $duration="$pattern[0][3]h$pattern[0][4]m$pattern[0][5]s"; }
#
&get_line("Running tests");
$size=@{ $pattern[0] };
$running_tests="";
for( $i = 2; $i < $size; $i = $i + 1 ){
 $running_tests.=" $pattern[0][$i]";
 }
#
&get_line("Projects");
$size=@{ $pattern[0] };
$projects="";
for( $i = 1; $i < $size; $i = $i + 1 ){
 $projects.=" $pattern[0][$i]";
 }
}
#
sub PHP_extract{
#
# Name choosing
$MAX_phps=20;
chdir("backup_and_www/$host/www");
for( $j = 1; $j < $MAX_phps ; $j = $j + 1 )
{
 $main_dat = $yambo_branch."/".$host."_".$yambo_branch."_".$j."_main.dat";
 if (! -f $main_dat) { last} ;
}
#
chdir("$suite_dir");
$main_dat = $host."_".$yambo_branch."_".$j."_main.dat";
$error_php=$host."_".$yambo_branch."_".$j."_error.php";
$report_php=$host."_".$yambo_branch."_".$j."_report.php";
$conf_php=$host."_".$yambo_branch."_".$j."_conf.php";
$comp_tgz=$host."_".$yambo_branch."_".$j."_comp.tgz";
$logs_tgz=$host."_".$yambo_branch."_".$j."_logs.tgz";
#
# RETRIVE DATA
#
&get_line("Parallel");
for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
 $field_1=$pattern[$i][4];
 $field_2=$pattern[$i][5];
 if ($field_2 =~ /default/){
  $run_kind[$i]="$pattern[$i][2] DEFAULT";
 }elsif ($field_2 =~ /random/){
  $run_kind[$i]="$pattern[$i][2] RANDOM";
 }elsif ($field_1 =~ /loop/){
  $run_kind[$i]="$pattern[$i][2] LOOP";
 }else{
  $run_kind[$i]="$pattern[$i][2]";
 }
}
#
# TESTS
&get_line("Tests");
for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
 $test_fail[$i]=$pattern[$i][1];
 $test_success[$i]=$pattern[$i][3];
 $test_skipped[$i]=$pattern[$i][5];
 $setup_skipped[$i]=$pattern[$i][7];
 $randcpu_skipped[$i]=$pattern[$i][9];
}
&get_line("Test FAIL");
for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
 $test_wrong[$i]=$pattern[$i][3];
 $test_notrun[$i]=$pattern[$i][5];
 $test_runtime[$i]=$pattern[$i][8];
}
# CHECKS
&get_line("Checks");
for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
 $checks_fail[$i]=$pattern[$i][1];
 $success[$i]=$pattern[$i][3];
 $whitel[$i]=$pattern[$i][5];
 $rulesok[$i]=$pattern[$i][7];
}
&get_line("Check FAIL");
for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
 $check_out[$i]=$pattern[$i][3];
 $check_noref[$i]=$pattern[$i][5];
 $check_noout[$i]=$pattern[$i][8];
 $check_nodb[$i]=$pattern[$i][11];
}

#
# OLD VERSION
#
if ($n_patterns eq 0){
 &get_line("RUNS_FAIL");
 for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
  # TESTS
  $test_fail[$i]=$pattern[$i][1];
  $test_notrun[$i]=$pattern[$i][8];
  $test_skipped[$i]=$pattern[$i][11];
  # CHECKS
  $checks_fail[$i]=$pattern[$i][4];
  $whitel[$i]=$pattern[$i][14];
  $success[$i]=$pattern[$i][17];
  #
  $test_success[$i]=$success[$i];
  $test_wrong[$i]=$checks_fail[$i];
  $test_runtime[$i]="";
  $setup_skipped[$i]="";
  $randcpu_skipped[$i]="";
  $rulesok[$i]="";
  #
 }
}
#
# Generate DAT file
#
open($dat, '>', $main_dat) or die "Could not open file '$main_dat' $!";
&MESSAGE("DAT","$REVISION\nFC_kind $FC_kind\nMPI_kind $MPI_kind\nBUILD $BUILD\nPrecision $Yambo_precision\n");
&MESSAGE("DAT","DATE $date\nTIME $time\nRUN $duration\nROBOT $robot_id\n");
&MESSAGE("DAT","TESTS $running_tests\nPROJ $projects\n");
&MESSAGE("DAT","\n");

&get_line("Parallel");
@run_kind = @pattern;

for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
 $field_1=$run_kind[$i][4];
 $field_2=$run_kind[$i][5];
 if ($field_2 =~ /default/){
  &MESSAGE("DAT","$run_kind[$i][2] DEFAULT\n");
 }elsif ($field_2 =~ /random/){
  &MESSAGE("DAT","$run_kind[$i][2] RANDOM\n");
 }elsif ($field_1 =~ /loop/){
  &MESSAGE("DAT","$run_kind[$i][2] LOOP\n");
 }else{
  &MESSAGE("DAT","$run_kind[$i][2]\n");
 }
 #
 $test_total=$test_fail[$i]+$test_skipped[$i]+$test_success[$i];
 $checks_total=$checks_fail[$i]+$whitel[$i]+$success[$i]+$rulesok[$i];
 #
 &MESSAGE("DAT","TESTS $test_total\n-OKs $test_success[$i]\n-SKIP $test_skipped[$i]\n--SETUP $setup_skipped[$i]\n--RAND-CPU $randcpu_skipped[$i]\n");
 &MESSAGE("DAT","-FAIL $test_fail[$i]\n--NOT_RUN $test_notrun[$i]\n--RUNTIME $test_runtime[$i]\n--WRONG_TEST $test_wrong[$i]\n");
 &MESSAGE("DAT","CHECKS $checks_total\n-OKs $success[$i]\n-WHITE $whitel[$i]\n-RULESOK $rulesok[$i]\n-FAIL $checks_fail[$i]\n");
 &MESSAGE("DAT","--WRONG_OUT $check_out[$i]\n--NO_REF $check_noref[$i]\n--NO_OUT $check_noout[$i]\n--NO_DB $check_nodb[$i]\n\n");
}

close($dat);
#
# ERROR > .php
&command("echo '<pre>' > $error_php");
foreach $file (<$dir/ERROR*.log>) {
 &command("cat $file >> $error_php");
};
&command("echo '\n\n' >> $error_php");
foreach $file (<$dir/SKIP*.log>) {
 &command("cat $file >> $error_php");
};
&command("echo '\n\n' >> $error_php");
foreach $file (<$dir/WHITE*.log>) {
 &command("cat $file >> $error_php");
};
&command("echo '\n\n' >> $error_php");
foreach $file (<$dir/RULES*.log>) {
 &command("cat $file >> $error_php");
};
&command("echo '\n\n</pre>' >> $error_php");
#
# REPORT > .php
&command("echo '<pre>' > $report_php");
foreach $file (<$dir/REPORT*.log>) {
 &command("cat $file >> $report_php");
};
&command("echo '</pre>' >> $report_php");
#
# CONF > .php
&command("echo '<pre>' > $conf_php");
foreach $file (<$dir/compilation/*conf*.log>) {&command("cat $file >> $conf_php")};
&command("echo '</pre>' >> $conf_php");
&command("echo '</pre>' >> $conf_php");
#
# LOGs and compilation as tgz file
&CWD_save;
chdir($dir);
$compress="no";
foreach $file (<compilation/*comp*.log>) {  $compress="yes"; };
if ( "$compress" eq "yes" ){ &command("tar -czf $comp_tgz compilation/*comp*.log"); };
&command("tar -czf $logs_tgz LOG*.log");
&CWD_go;
&command("mv $dir/*.tgz ./");
#
# Final copying
#
&command("mkdir -p backup_and_www/$host/www/$yambo_branch");
&command("mv *.php *.dat *.tgz backup_and_www/$host/www/$yambo_branch");   
#
return
}
#
sub PHP_upload
{
chdir("$suite_dir/backup_and_www/$host/www");
&command("$ncftpput -R -u 1945528\@aruba.it -p Qqrmm3vHhrTER3X ftp.yambo-code.org www.yambo-code.org/robots .")
}
#
sub get_line{
undef @pattern;
$n_patterns=0;
foreach $line (@lines) {
 chomp($line);
 if ($line eq '') {next};
 if ($line =~ "@_[0]") { 
  $line =~ s/\:/ /g;
  push(@pattern, [ split(/\s+/, $line) ]);
  $n_patterns++;
 }
}
}
1;
