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
sub PHP_generate{
#
&command("rm -f $host/www/*");
#
my @dir = ( "$host/$user" );
my @dirs;
find( sub { push @dirs, $File::Find::name if -d }, @dir );
my @dirs_to_process;
foreach $dir (@dirs) {
 @files = glob("$dir/REPORT*");
 next if (scalar(@files) eq 0);
 push @dirs_to_process, $dir;
}
my @sorted_dirs = sort { $a1 = (split ( '2017', $a )) [1]; $b1 = (split ( '2017', $b )) [1]; $a1 cmp $b1} @dirs_to_process;
foreach $dir (@sorted_dirs) {
 @files = glob("$dir/REPORT*");
 foreach $file (@files) {
  print "$suite_dir/$file\n";
  open(REPORT,"<","$suite_dir/$file");
  &PHP_extract;
  close(REPORT);
 }
}

}
#
sub PHP_extract{
#
@lines = <REPORT>;
#
&get_line("Build");
if ($n_patterns eq 0) {return};
$branch_key=$pattern[0][1];
$BUILD=$pattern[0][3];
$FC_kind=$pattern[0][5];
$REVISION=$pattern[0][7];
#
&get_line("Date");
$date=$pattern[0][3];
$time=$pattern[0][5];
#
# Name choosing
$MAX_phps=20;
chdir("$host/www");
#
for( $j = $MAX_phps-1; $j > 0 ; $j = $j - 1 )
{
 $k=$j+1;
 $main_php = $hostname."_".$branch_key."_".$j."_main.php";
 $error_php=$hostname."_".$branch_key."_".$j."_error.php";
 $report_php=$hostname."_".$branch_key."_".$j."_report.php";
 if (-f $main_php){
  ($file = $error_php) =~ s/$j/$k/g;
  &command("mv $error_php $file");
  ($file = $report_php) =~ s/$j/$k/g;
  &command("mv $report_php $file");
  ($file = $main_php) =~ s/$j/$k/g;
  &command("mv $main_php $file");
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
$main_php = $hostname."_".$branch_key."_1_main.php";
$error_php=$hostname."_".$branch_key."_1_error.php";
$report_php=$hostname."_".$branch_key."_1_report.php";
open($php, '>', $main_php) or die "Could not open file '$main_php' $!";
#
# Line #1
&MESSAGE("PHP","<table>\n")
&MESSAGE("PHP","<tr>\n")
&MESSAGE("PHP"," <th>Robot</th>\n")
&MESSAGE("PHP"," <th>Branch</th>\n")
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
&MESSAGE("PHP"," <td>$hostname\n");
&MESSAGE("PHP"," <br><a href='$report_php'> report</a>")
&MESSAGE("PHP"," <br><a href='$error_php'> error</a></td>")
&MESSAGE("PHP"," <td>$branch_key</td>\n");
&MESSAGE("PHP"," <td>$FC_kind</td>\n");
&MESSAGE("PHP"," <td>$date<br>$time</td>\n");
&MESSAGE("PHP"," <td>$REVISION<br>$BUILD</td>\n");
&get_line("RUNS_FAIL");
for( $i = 0; $i < $n_patterns; $i = $i + 1 ){
 &MESSAGE("PHP"," <td>$pattern[$i][1]</td>\n");
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
&command("$msg");
#
# REPORT > .php
&command("echo '<pre>' > $report_php");
foreach $file (<$dir/REPORT*.log>) {
 &command("cat $file >> $report_php");
};
&command("echo '</pre>' >> $report_php");
&command("$msg");
#
# Final copying
#
&command("mv *.php $host/www");
return
}
#
sub PHP_upload
{
#
# Upload (if $report) to w^3
#
foreach $file (<$host/www/*.php>) 
{
 &FTP_upload_it("$file","robots");
}
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
