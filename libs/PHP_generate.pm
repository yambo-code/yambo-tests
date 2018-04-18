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
sub PHP_generate{
#
&command("rm -fr $host/www/*");
#
&UTILS_list_backups;
#
foreach $dir (@sorted_dirs) {
 @files = glob("$dir/REPORT*");
 foreach $file (@files) {
  open(REPORT,"<","$suite_dir/$file");
  @lines = <REPORT>;
  &PHP_key_words;
  if ($branch_key =~ "bug-fixes_copy" or $branch_key =~ "max-release" ) {next};
  print "Processing $dir...\n";
  &PHP_extract;
  close(REPORT);
 }
}
}
#
sub PHP_key_words{
 &get_line("Build");
 if ($n_patterns eq 0) {return};
 $branch_key=$pattern[0][1];
 $BUILD=$pattern[0][3];
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
&get_line("Date");
$date=$pattern[0][3];
$time=$pattern[0][5];
}
#
sub PHP_extract{
#
# Name choosing
$MAX_phps=20;
chdir("$host/www");
for( $j = $MAX_phps-1; $j > 0 ; $j = $j - 1 )
{
 $k=$j+1;
 $main_dat = $branch_key."/".$hostname."_".$branch_key."_".$j."_main.dat";
 $main_php  = $branch_key."/".$hostname."_".$branch_key."_".$j."_main.php";
 $error_php = $branch_key."/".$hostname."_".$branch_key."_".$j."_error.php";
 $report_php= $branch_key."/".$hostname."_".$branch_key."_".$j."_report.php";
 $conf_php= $branch_key."/".$hostname."_".$branch_key."_".$j."_conf.php.bz2";
 $comp_php= $branch_key."/".$hostname."_".$branch_key."_".$j."_comp.php.bz2";
 if (-f $main_php){
  ($file = $error_php) =~ s/_$j/_$k/g;
  if (-f $error_php) {&command("mv $error_php $file")};
  ($file = $report_php) =~ s/_$j/_$k/g;
  if (-f $report_php) {&command("mv $report_php $file")};
  ($file = $conf_php) =~ s/_$j/_$k/g;
  if (-f $conf_php) {&command("mv $conf_php $file")};
  ($file = $comp_php) =~ s/_$j/_$k/g;
  if (-f $comp_php) {&command("mv $comp_php $file")};
  ($file = $main_dat) =~ s/_$j/_$k/g;
  if (-f $main_dat) {&command("mv $main_dat $file")};
  ($file = $main_php) =~ s/_$j/_$k/g;
  if (-f $main_php) {&command("mv $main_php $file")};
  open(my $fh1, '<', $file) ;
  open(my $fh2, '>', 'dummy') ;
  while( $line = <$fh1>) {
   $line =~ s/${branch_key}_$j/${branch_key}_$k/ig;
   print $fh2 "$line";
  }
  close($fh1);
  close($fh2);
  &command("mv dummy $file");
 }
}
#
chdir("$suite_dir");
$main_dat = $hostname."_".$branch_key."_1_main.dat";
$main_php = $hostname."_".$branch_key."_1_main.php";
$error_php=$hostname."_".$branch_key."_1_error.php";
$report_php=$hostname."_".$branch_key."_1_report.php";
$conf_php=$hostname."_".$branch_key."_1_conf.php";
$comp_php=$hostname."_".$branch_key."_1_comp.php";
open($php, '>', $main_php) or die "Could not open file '$main_php' $!";
#
# Line #1
&MESSAGE("PHP","<table>\n")
&MESSAGE("PHP","<tr>\n")
&MESSAGE("PHP"," <th>Logs</th>\n")
#&MESSAGE("PHP"," <th>Branch</th>\n")
&MESSAGE("PHP"," <th>Compiler</th>\n");
&MESSAGE("PHP"," <th>Date</th>\n");
&MESSAGE("PHP"," <th>Revision</th>\n");
&get_line("Parallel");
for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
 $field_1=$pattern[$i][4];
 $field_2=$pattern[$i][5];
 if ($field_2 =~ /default/){
  &MESSAGE("PHP"," <td>$pattern[$i][2]<br>DEFAULT</td>\n");
 }elsif ($field_2 =~ /random/){
  &MESSAGE("PHP"," <td>$pattern[$i][2]<br>RANDOM</td>\n");
 }elsif ($field_1 =~ /loop/){
  &MESSAGE("PHP"," <td>$pattern[$i][2]<br>LOOP</td>\n");
 }else{
  &MESSAGE("PHP"," <td>$pattern[$i][2]</td>\n");
 }
}
&MESSAGE("PHP","</tr>\n")
#
# Line #2
&MESSAGE("PHP","<tr>\n")
#&MESSAGE("PHP"," <td>$hostname\n");
&MESSAGE("PHP"," <td>");
&MESSAGE("PHP"," <br><a href='$report_php'> report</a>");
&MESSAGE("PHP"," <br><a href='$error_php'> error</a>");
&MESSAGE("PHP"," <br><a href='$conf_php.bz2'> conf</a>");
&MESSAGE("PHP"," <br><a href='$comp_php.bz2'> comp</a>");
&MESSAGE("PHP"," </td>");
#&MESSAGE("PHP"," <td>$branch_key</td>\n");
&MESSAGE("PHP"," <td>$FC_kind<br>$MPI_kind</td>\n");
&MESSAGE("PHP"," <td>$date<br>$time</td>\n");
&MESSAGE("PHP"," <td>$REVISION<br>$BUILD</td>\n");
&get_line("RUNS_FAIL");
for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
 if ($pattern[$i][1] == 0) { &MESSAGE("PHP"," <td bgcolor=\"#6FFF00\">$pattern[$i][1]</td>\n") };
 if ($pattern[$i][1] > 0 and $pattern[$i][1] < 10) { &MESSAGE("PHP"," <td bgcolor=\"#FC9F00\">$pattern[$i][1]</td>\n")} ;
 if ($pattern[$i][1] >= 10) { &MESSAGE("PHP"," <td bgcolor=\"#CC0000\">$pattern[$i][1]</td>\n")};
}
if ($n_patterns eq 0){
 &get_line("FAIL:");
 for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
  &MESSAGE("PHP"," <td>$pattern[$i][1]</td>\n");
 }
}
&MESSAGE("PHP","</tr>\n")
#
&MESSAGE("PHP","</table>\n");
close($php);
#
# ERROR > .php
&command("echo '<pre>' > $error_php");
foreach $file (<$dir/ERROR*.log>) {
 &command("cat $file >> $error_php");
};
&command("echo '</pre>' >> $error_php");
#
# REPORT > .php
&command("echo '<pre>' > $report_php");
foreach $file (<$dir/REPORT*.log>) {
 &command("cat $file >> $report_php");
};
&command("echo '</pre>' >> $report_php");
#
# CONF/COMPILE > .php
&command("echo '<pre>' > $conf_php");
&command("echo '<pre>' > $comp_php");
foreach $file (<$dir/compilation/*conf*.log>) {&command("cat $file >> $conf_php")};
foreach $file (<$dir/compilation/*comp*.log>) {&command("cat $file >> $comp_php")};
&command("echo '</pre>' >> $conf_php");
&command("echo '</pre>' >> $comp_php");
#
# Final copying
#
foreach $file (<*_comp.php>,<*_conf.php>) {
 &command("bzip2 $file");
}
&command("mkdir -p    $host/www/$branch_key");
&command("mv *.php    $host/www/$branch_key");
&command("mv *.php.bz2 $host/www/$branch_key");   
return
}
#
sub PHP_upload
{
chdir("$suite_dir/$host/www");
&command("$ncftpput -R -u 1945528\@aruba.it -p 5fv94ktp ftp.yambo-code.org www.yambo-code.org/robots/ .")
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
