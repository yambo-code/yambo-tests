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
$str1="$current_month";
if ($current_month<10) {$str1="0$current_month"};
$str2="$day";
if ($day<10) {$str2="0$day"};
$BACKUP_dir   ="$host/$user/$FC_kind/$current_year/$str1/$str2/$time";
&command("mkdir -p $host/www");
&command("mkdir -p $host/$user");
&command("mkdir -p $host/$user/$FC_kind");
&command("mkdir -p $host/$user/$FC_kind");
&command("mkdir -p $host/$user/$FC_kind/$current_year");
&command("mkdir -p $host/$user/$FC_kind/$current_year/$str1");
&command("mkdir -p $host/$user/$FC_kind/$current_year/$str1/$str2");
&command("mkdir -p $host/$user/$FC_kind/$current_year/$str1/$str2/$time");
#
&command("rm -f list");
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
$DATA_backup_file="outputs_and_reports_ALL-$ROBOT_string";
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
if (-f LOG*$ROBOT_string) {&command("cp LOG*$ROBOT_string $BACKUP_dir")};
}
1;

