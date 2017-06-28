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
sub SETUP_defaults{
#
# Flush output
$|=1;
#
&UTILS_time($date,$time);
#
$BACKUP_dir   ="$host/$user";
$BACKUP_subdir="$date-$time";
#
# Predefs (before options scan)
$listtests="default";
#
$version="4.1";
$prec=0.01;
$project="none"; 
$max_delay_commits = 2; # days
$run_duration = 1200; # 20 minutes
$default_prec=0.01;
$use_colors="no";
$left_length=50;
$double_line=("=") x ($left_length+32);
$wiggly_line=("%") x ($left_length+32);
$line=("-") x ($left_length+30);
$line="=".$line."=";
$stdout = *STDOUT;
$input_folder= "INPUTS";
# ERROR log
@ERROR_entries;
$N_errors=0;
# Default precision
$prec=0.01;
#
$SYSTEM_NP=1;
chomp($SYSTEM_NP = `grep -c -P '^processor\\s+:' /proc/cpuinfo`);
$SYSTEM_NP_half=$SYSTEM_NP/2;
if ($SYSTEM_NP_half<1) { $SYSTEM_NP_half=1 };
$SYSTEM_SLK=1;
if ($SYSTEM_NP>4     ) { $SYSTEM_SLK=4 };
if ($SYSTEM_NP>16    ) { $SYSTEM_SLK=16 };
#
# Default Branches
open(BRANCHES_file,"<","ROBOTS/$host/$user/BRANCHES");
my @BLINES = <BRANCHES_file>;
my $line;
my $ib=-1;
while($line = shift(@BLINES)) {
 chomp($line);
 $ib++;
 ($branches[$ib],$branch_identity[$ib]) = split(/ /, $line);
}
close(BRANCHES_file);
}
#
1;
