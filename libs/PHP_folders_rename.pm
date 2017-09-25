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
sub PHP_folders_rename{
#
my @dir = ( "$host/$user" );
my @dirs;
find( sub { push @dirs, $File::Find::name if -d }, @dir );
my @dirs_to_process;
foreach $dir (@dirs) {
 @files = glob("$dir/REPORT*");
 if (scalar(@files) eq 0) {
  chdir("$dir");
  foreach $arch (<*.gz>) {
   print "$dir/$arch\n";
   &command("tar -xzf $arch --wildcards --no-anchored '*.log'");
  }
  chdir("$suite_dir");
 }
 @files = glob("$dir/REPORT*");
 next if (scalar(@files) eq 0);
 push @dirs_to_process, $dir
}
#
my %renaming = (
Jan => "01", Feb => "02", Mar => "03", Apr => "04", May => "05", Jun => "06", Jul => "07", Aug => "08",
Sep => "09", Oct => "10", Nov => "11", Dec => "12");
#
foreach $dir (@dirs_to_process) {
 chdir("$dir/../");
 @dir_splitted_1  = split(/\//,$dir);
 @dir_splitted_2  = split(/-/,$dir_splitted_1[$#dir_splitted_1]);
 $new_dir=$dir;
 $string="2017/$renaming{$dir_splitted_2[0]}/$dir_splitted_2[1]/$dir_splitted_2[3]-$dir_splitted_2[4]";
 $new_dir=~ s/$dir_splitted_1[$#dir_splitted_1]/$string/ig;
 print "$dir -> $new_dir\n";
 chdir("$suite_dir");
 #
 @dir_splitted_1  = split(/\//,$new_dir);
 foreach $part (@dir_splitted_1) {
   next if ("$part" eq "$dir_splitted_1[$#dir_splitted_1]");
   &command("mkdir -p $part");
   chdir("$part");
 }
 &command("mv $suite_dir/$dir $dir_splitted_1[$#dir_splitted_1]");
 chdir("$suite_dir");
}     
}
1
