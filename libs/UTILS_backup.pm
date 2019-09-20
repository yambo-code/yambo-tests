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
sub UTILS_list_backups{
 my $n_backups_to_save=50;
 my $n_backups=0;
 my @dir = ( "backup_and_www/$host/$user/" );
 if ($mode eq "bench") {@dir="benchmark-results/"};
 print @dir;
 my @dirs;
 find( sub { push @dirs, $File::Find::name if -d }, @dir );
 my @dirs_to_process;
 foreach $dir (@dirs) {
  @reps  = glob("$dir/REPORT*");
  @comps = glob("$dir/compilation/*");
  next if (scalar(@reps) eq 0 and scalar(@comps) eq 0);
  if ($dir =~ /\/2017\//) {
   #print "check 2017: $dir\n";
   push @dirs_to_process_2017, $dir;
   $n_backups++;
  }
  if ($dir =~ /\/2018\//) {
   #print "check 2018: $dir\n";
   push @dirs_to_process_2018, $dir;
   $n_backups++;
  }
  if ($dir =~ /\/2019\//) {
   #print "check 2019: $dir\n";
   push @dirs_to_process_2019, $dir;
   $n_backups++;
  }
 }
 #
 if ($clean and $backup_logs eq "yes") {
  $first_to_keep=$n_backups-$n_backups_to_save+1;
  print "\nCleaning backups with ID < $first_to_keep\n";
 };
 @sorted_dirs = sort { $a1 = (split ( '2017', $a )) [1]; $b1 = (split ( '2017', $b )) [1]; $a1 cmp $b1} @dirs_to_process_2017;
 @dirs_2018   = sort { $a1 = (split ( '2018', $a )) [1]; $b1 = (split ( '2018', $b )) [1]; $a1 cmp $b1} @dirs_to_process_2018;
 @dirs_2019   = sort { $a1 = (split ( '2019', $a )) [1]; $b1 = (split ( '2019', $b )) [1]; $a1 cmp $b1} @dirs_to_process_2019;
 push(@sorted_dirs, @dirs_2018, @dirs_2019);
 if ($branch_php or $report) 
 {
  @reversed_dirs = reverse @sorted_dirs
 }else{
  @reversed_dirs = @sorted_dirs 
 }
 #
 @id_to_clean=split(/-/, $backup_logs);
 if ( scalar @id_to_clean == 1 ) {push @id_to_clean,$id_to_clean[0]};
 #
 $data_id=0;
 if ("@_" eq "list")
 {
  foreach $dir (@reversed_dirs) {
   #
   #print "Dir sorted $dir pippo\n";
   @REPS = glob("$dir/REPORT*");
   open(REPORT,"<","$suite_dir/$REPS[0]");
   @lines = <REPORT>;
   undef $date;
   undef $time;
   &PHP_key_words($REPS[0]);
   $data_id++;
   close(REPORT);
   #
   if ( ($backup_logs eq "yes" or ($data_id <= $id_to_clean[1] and $data_id >= $id_to_clean[0]) ) and not $clean) 
   {
    print "ID    : $data_id\n";
    if ($date) {
     print "DATE  : $date\n";
     print "TIME  : $time\n";
     print "ROBOT : $robot_id\n";
     print "BRANCH: $branch_in_the_log\n";
     print "FC    : $FC_kind $MPI_kind\n";
    }
    print "DIR   : $dir\n";
    print "\n";
   }elsif ($clean and $backup_logs eq "yes") {
    if ($data_id<$first_to_keep) {
      print "\n...cleaning ID $data_id";
      &command("rm -fr $dir");
    };
   };
   if ( $data_id <= $id_to_clean[1] and $data_id >= $id_to_clean[0]) 
   {
    #
    if ($profile) {&PROFILE($dir)};
    #
    if ($clean)
    {
     &command("rm -fr $dir");
     print "\n...cleaning BACKUP #$data_id\n";
    }
    if ($edit) {&command("vim $dir/REPORT*")};
   }
  }
 }
 print "\n";
}
#
sub UTILS_backup_save{
if ($compile) {
 &command("mkdir -p $BACKUP_dir/compilation");
 foreach $conf_file (<*R${ROBOT_id}*config.log>,<*R${ROBOT_id}*compile.log>) {
  &command("mv $conf_file $BACKUP_dir/compilation/");
 };
};
foreach $conf_file (<*$ROBOT_string*.log>){
 &command("mv $conf_file $BACKUP_dir");
 if ($conf_file =~ /REPORT-/) {$global_report=$conf_file};
};
if (-f "$OUTPUT_backup_file.tar.gz"){ &command("mv $OUTPUT_backup_file.tar.gz $BACKUP_dir") };
if ($DBS_backup_file) {&command("mv $DBS_backup_file.tar $BACKUP_dir")};
}
sub UTILS_backup
{
chdir("$suite_dir");
if (not $RUNNING_suite) 
{
 $ROBOT_string="R".$ROBOT_id;
 $file= (glob("REPORT*R${ROBOT_id}*"))[0];
 if (not $file) {die "\nNo files to backup\n\n"};
 if ($file =~ /BENCH/) {$mode="bench"};
 open(REPORT,"<","$suite_dir/$file");
 @lines = <REPORT>;
 &PHP_key_words($file);
 close(REPORT);
 $day=(split("-",$date))[1];
 $str1=(split("-",$date))[0];
 ( $INITIAL_month )= grep { $months[$_] eq $str1 } 0..$#months;
 $INITIAL_month++;
 $INITIAL_year=$current_year;
}
$str1="$INITIAL_month";
if ($INITIAL_month<10) {$str1="0$INITIAL_month"};
$str2="$day";
if ($day<10) {$str2="0$day"};
$BACKUP_dir   ="";
if ($mode eq "bench") {$BACKUP_dir="benchmark-results/"};
$BACKUP_dir   .="backup_and_www/$host/$user/$FC_kind/$INITIAL_year/$str1/$str2/$time";
#
# Directories
my @subdirs=split /\//,$BACKUP_dir;
my $tmp_dir="./";
foreach $subd (@subdirs){
 $tmp_dir .="$subd/";
 &command("mkdir -p $tmp_dir");
}
&command("mkdir -p backup_and_www/$host/www");
#
$OUTPUT_backup_file="outputs_and_reports_ALL-$ROBOT_string";
undef $DBS_backup_file;
if ($mode eq "bench") {$DBS_backup_file="DATABASES-$ROBOT_string"};
#
# OUTPUT filling
#
&command("rm -f list");
if ($mode eq "bench") 
{
 #&command("find . -name 'ROBOT_Nr_${ROBOT_id}' > list");
 #if (-s "list") {&command("tar rf $DBS_backup_file.tar -T list")};
 &command("find . -name 'o-*' -o -name 'r-*' -o -name 'l-*' -o -name 'yambo.in' | $grep 'ROBOT_Nr_${ROBOT_id}' > list");
}else{
 if (not $RUNNING_suite) {$failed_log=(glob("FAILED*R${ROBOT_id}*"))[0]};
 open(FAILED,"<","$suite_dir/$failed_log");
 my @FLINES = <FAILED>;
 close(FAILED);
 for(@FLINES){ 
     push @out, $_ if (not @out) or ($out[-1] ne $_);
 };
 my $line;
 while($line = shift(@out)) {
  chomp($line);
  &command("find $line -name 'o-*' -o -name 'r-*' -o -name 'l-*' -o -name 'yambo.in' | $grep -v 'REFERENCE' | grep -v log >> list");
 }
}
#
if ( -f "$OUTPUT_backup_file.tar.gz") {
 &command("gunzip -f $OUTPUT_backup_file.tar.gz");
 if (-s "list") {&command("tar rf $OUTPUT_backup_file.tar -T list")};
}else{
 if (-s "list") {&command("tar cf $OUTPUT_backup_file.tar -T list")};
}
foreach $conf_file (<*$ROBOT_string*log>) {
 &command("tar rf  $OUTPUT_backup_file.tar $conf_file");
};
&command("gzip -f $OUTPUT_backup_file.tar");
&command("rm -f list");
#
# Archive
my $DIR=$PAR_string;
if ($openmp_is_off) {$DIR="$PAR_string-OpenMPoff"};
if (-f "LOG_$ROBOT_id") {&command("cp LOG_$ROBOT_id $BACKUP_dir")};
}
1;

