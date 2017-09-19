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
sub UTILS_clean{
#
my @paths=("tests");
if ( "@_" eq "ALL" or "@_" eq "DEEP") {
 @paths=("tests","find_the_diff","config");
}
#
if ("@_" eq "RESTORE") {
 &CWD_save;
 chdir("$suite_dir/$TESTS_folder");
 DIR_LOOP: foreach $dir (<*>,<*/*>,<*/*/*>,<*/*/*/*>,<*/*/*/*/*>) {      # Glob all files
   if ( -d $dir."/SAVE_old" ) { 
    chdir("$dir");
    &RUN_restore_the_SAVE( ) ;
    chdir("$suite_dir/$TESTS_folder");
   }
 }
 &CWD_go;
}
#
if ("@_" eq "SAVEs") {
 my @files;
 find( sub { push @files, $File::Find::name if /\.gops$/ }, "tests" );
 foreach my $file (@files){
   $dirname  = dirname($file);
   if (-d $dirname."_backup") {
    &command("rm -fr $dirname")
   }else{
    foreach my $to_remove (< $dirname/ndb*>) {
     if (not $to_remove =~ /gkkp/ ){ &command("rm -fr $to_remove") }
    }
   };
 }
}elsif("@_" eq "ALL") {
 my $CMD="svn st | grep -v 'MODULES.pl' | grep -v 'TOOLS.pl' | grep -v '.gz' | grep -v 'SAVE/ns.' | grep -v 'elph_gkkp'";
 $CMD=$CMD." |grep -v '.empty' |grep -v 'NO_GPL' ";
 $CMD=$CMD." |grep -v 'SAVE_backup' | grep '?'|  $awk '{print \$2}' | xargs rm -fr";
 LOOP_CONF: foreach  my $clean_path (@paths){
  &CWD_save;
  chdir("$suite_dir/$clean_path");
  &command($CMD);
  &CWD_go;
 };
}elsif("@_" eq "BINs" ) {
 foreach $branchdir (@branches) {
  chomp($branchdir);
  foreach $conf_file (<ROBOTS/$host/$user/CONFIGURATIONS/*>){
   $conf_file = (split(/\//, $conf_file))[-1];
   $conf_bin  = "$branchdir/bin-$conf_file";
   if (-d $conf_bin) { &command("rm -fr $conf_bin")};
  }
 }
}
#
&command("rm -f find_the_diff/*.o");
#
if ( "@_" eq "ALL") {
 &command("rm -f outputs* *.log");
}
#
if ( "@_" eq "DEEP") {
 &command("rm -f config/MODULES.pl config/TOOLS.pl *.log");
}
#
}
1;
