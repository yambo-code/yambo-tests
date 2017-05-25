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
 foreach $conf_file (<LOG*.log>,<ERROR*.log>,<REPORT*.log>,<WHITELIST*.log>) {
  &command("mv $conf_file $BACKUP_dir/$BACKUP_subdir");
 };
 &command("mv $DATA_backup_file.tar.gz $BACKUP_dir/$BACKUP_subdir");
 chdir("$BACKUP_dir");
 &command("rm -f LATEST-TEST LATEST-REPORT");
 &command("ln -s $BACKUP_subdir LATEST-TEST");
 &command("ln -s LATEST-TEST/$global_report LATEST-REPORT");
 chdir("../");
}
sub UTILS_backup
{
chdir("$suite_dir");
&command("find tests -name 'o-*' -o -name 'r-*' -o -name 'l-*' -o -name 'yambo.in' | grep -v 'REFERENCE' > list");
$DATA_backup_file="outputs_and_reports_ALL";
if (!-f "$DATA_backup_file.tar.gz") {&command("tar cf $DATA_backup_file.tar -T list")};
if ( -f "$DATA_backup_file.tar.gz") {
 &command("gunzip -f $DATA_backup_file.tar.gz");
 &command("tar rf $DATA_backup_file.tar -T list");
}
foreach $conf_file (<*log>) {
 &command("tar rf  $DATA_backup_file.tar $conf_file");
};
&command("gzip -f $DATA_backup_file.tar");
&command("rm -f list");
#
# Archive
my $DIR=$PAR_string;
if ($openmp_is_off) {$DIR="$PAR_string-OpenMPoff"};
&command("mkdir -p $BACKUP_dir/$BACKUP_subdir");
foreach $conf_file (<*config.log>,<*compile.log>) {
 &command("mv $conf_file $BACKUP_dir/$BACKUP_subdir/compilation/");
};
foreach $conf_file (<LOG*.log>){
 &command("mv $conf_file $BACKUP_dir/$BACKUP_subdir");
};
}
sub UTILS_backup_upload
{
#
# Upload (if $report) to w^3
#
if ($report) {
 &command("echo '<pre>' > LOG_$host.php");
 &command("cat $BACKUP_dir/$global_report >> LOG_$host.php");
 &command("echo '</pre>' >> LOG_$host.php");
 &FTP_upload_it("LOG_$host.php","testing-robots");
 &command("cp $BACKUP_dir/$BACKUP_subdir/$DATA_backup_file.tar.gz $host.tar.gz");
 &FTP_upload_it("$host.tar.gz","testing-robots/results/");
 &command("rm -f LOG_$host.php $host.tar.gz");
}
}
1;

