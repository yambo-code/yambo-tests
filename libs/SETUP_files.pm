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
sub SETUP_files
{
#
# Glob available configurations/flows
#
if (-e "./ROBOTS/$host/$user/CONFIGURATIONS"){
 opendir(DIR,"./ROBOTS/$host/$user/CONFIGURATIONS");
 @files = grep { (!/^\./) && -f "./ROBOTS/$host/$user/CONFIGURATIONS/$_" } readdir(DIR);
 closedir DIR;
}
$conf_avail = join(" ", @files);
if (-e "./ROBOTS/$host/$user/FLOWS"){
 opendir(DIR,"./ROBOTS/$host/$user/FLOWS");
 @files = grep { (!/^\./) && -f "./ROBOTS/$host/$user/FLOWS/$_" } readdir(DIR);
 closedir DIR;
}
$flows_avail = join(" ", @files);
if (-e "./ROBOTS/$host/$user/CPU_CONFIGURATIONS"){
 opendir(DIR,"./ROBOTS/$host/$user/CPU_CONFIGURATIONS");
 @files = grep { (!/^\./) && -f "./ROBOTS/$host/$user/CPU_CONFIGURATIONS/$_" } readdir(DIR);
 closedir DIR;
}
$cpu_avail = join(" ", @files);
}
1;
