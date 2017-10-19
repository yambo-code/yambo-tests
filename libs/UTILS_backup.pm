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
sub UTILS_list_backups{
 my @dir = ( "$host/$user" );
 my @dirs;
 find( sub { push @dirs, $File::Find::name if -d }, @dir );
 my @dirs_to_process;
 foreach $dir (@dirs) {
  @files = glob("$dir/REPORT*");
  next if (scalar(@files) eq 0);
  push @dirs_to_process, $dir;
 }
 @sorted_dirs = sort { $a1 = (split ( '2017', $a )) [1]; $b1 = (split ( '2017', $b )) [1]; $a1 cmp $b1} @dirs_to_process;
 #
 $data_id=0;
 if ("@_" eq "list")
 {
  foreach $dir (@sorted_dirs) {
   #
   @REPS = glob("$dir/REPORT*");
   open(REPORT,"<","$suite_dir/$REPS[0]");
   @lines = <REPORT>;
   &PHP_key_words;
   $data_id++;
   close(REPORT);
   #
   if ($backup_logs eq "yes" or $backup_logs eq $data_id) 
   {
    print "ID    : $data_id\n";
    print "DATE  : $date\n";
    print "TIME  : $time\n";
    print "BRANCH: $branch_key\n";
    print "FC    : $FC_kind $MPI_kind\n";
   }
   #
   #@DATAS = glob("$dir/*_ALL*");
   #my $size = -s $DATAS[0];
   #$size=int($size/1024/1000);
   #if ($size>100 and $clean) {
    #&command("rm -f $DATAS[0]");
    #print "...cleaning DATA's\n";
   if ($backup_logs eq $data_id) 
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
   print "\n";
  }
 }
}
#
sub UTILS_backup_save{
if ($compile) {&command("mkdir -p $BACKUP_dir/compilation")};
foreach $conf_file (<*$ROBOT_string*.log>){
 &command("mv $conf_file $BACKUP_dir");
 if ($conf_file =~ /REPORT-/) {$global_report=$conf_file};
};
&command("mv $DATA_backup_file.tar.gz $BACKUP_dir");
}
sub UTILS_backup
{
chdir("$suite_dir");
if (not $RUNNING_suite) 
{
 $ROBOT_string="R".$ROBOT_id;
 $file= (glob("REPORT*R${ROBOT_id}*"))[0];
 if (not $file) {die "\nNo files to backup\n\n"};
 open(REPORT,"<","$suite_dir/$file");
 &PHP_extract;
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
$BACKUP_dir   ="$host/$user/$FC_kind/$INITIAL_year/$str1/$str2/$time";
&command("mkdir -p $host/www");
&command("mkdir -p $host/$user");
&command("mkdir -p $host/$user/$FC_kind");
&command("mkdir -p $host/$user/$FC_kind");
&command("mkdir -p $host/$user/$FC_kind/$INITIAL_year");
&command("mkdir -p $host/$user/$FC_kind/$INITIAL_year/$str1");
&command("mkdir -p $host/$user/$FC_kind/$INITIAL_year/$str1/$str2");
&command("mkdir -p $host/$user/$FC_kind/$INITIAL_year/$str1/$str2/$time");
#
&command("rm -f list");
$DATA_backup_file="outputs_and_reports_ALL-$ROBOT_string";
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
 &command("find $line -name 'o-*' -o -name 'r-*' -o -name 'l-*' -o -name 'yambo.in' | grep -v 'REFERENCE' >> list");
}
if ( -f "$DATA_backup_file.tar.gz") {
 &command("gunzip -f $DATA_backup_file.tar.gz");
 if (-s "list") {&command("tar rf $DATA_backup_file.tar -T list")};
}else{
 if (-s "list") {&command("tar cf $DATA_backup_file.tar -T list")};
}
foreach $conf_file (<*$ROBOT_string*log>) {
 &command("tar rf  $DATA_backup_file.tar $conf_file");
};
&command("gzip -f $DATA_backup_file.tar");
&command("rm -f list");
#
# Archive
my $DIR=$PAR_string;
if ($openmp_is_off) {$DIR="$PAR_string-OpenMPoff"};
foreach $conf_file (<*config.log>,<*compile.log>) {
 &command("mkdir -p $BACKUP_dir/compilation");
 &command("mv $conf_file $BACKUP_dir/compilation/");
};
if (-f "LOG_$ROBOT_id") {&command("cp LOG_$ROBOT_id $BACKUP_dir")};
}
1;

