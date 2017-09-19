#
#        Copyright (C) 2000-2017 the YAMBO team
#              http://www.yambo-code.org
#
# Authors (see AUTHORS file for details): AM
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
sub UTILS_download
{
&CWD_save;
#
my $LINK="http://www.yambo-code.org/testing-robots/databases/";
my $EXTENSION="tar.gz";
if ($mode eq "bench") {
 $LINK="http://potzie.fisica.unimo.it/ferretti/";
 $EXTENSION="tgz";
};
#
chdir("$suite_dir/$TESTS_folder");
foreach $dir (<*>) {
 if ($download ne " ") {
  if( ($download ne "all") && ($download ne $dir) ){ next; };
 };
 my @dirs = ( "$dir" );
 my @files;
 find( sub { push @files, $File::Find::name if /\.db1$/ }, @dirs );
 chdir($dir);
 if ($veryclean) {&clean};
 my $do_it="no";
 if ($download) { $do_it = "yes" };
 if ($do_it eq "yes"){
   if (-e "./BROKEN" and ! $force) { $do_it = "no" };
 }
 if ( $do_it eq "yes"){
  &MY_PRINT($stdout, "\n=> [".$dir."]\n");
  $i1=0;
  $filename[$i1] = $dir;
  foreach $subdir (<*>) {
   next if (not -d $subdir);
   next if ($subdir =~ /INPUTS/ or $subdir =~ /REFERENCE/ or $subdir =~ /SAVE/ or $subdir =~ /BROKEN/ or $subdir =~ /DFT/ );
   $i1=$i1+1;
   $filename[$i1] = "${dir}_${subdir}";
  }
  if ($mode eq "bench")
  {
   if ($dir =~ /AGNR/)   {$filename[0] = "agnr_v4.2-IO"};
   if ($dir =~ /cobalt/) {$filename[0] = "cobalt_v4.2-IO"};
   $i1=0;
  }
  $imax=$i1;
  $i1=0;
  $icheck=0;
  do{
   $cmd = "wget --spider -q $LINK/$filename[$i1].$EXTENSION && echo exists || echo not exist";
   my $file_exist = `$cmd`;
   if ( "$file_exist" eq "exists\n") {
    &MY_PRINT($stdout, "...$filename[$i1].$EXTENSION [YES] ...");
    &MY_PRINT($stdout, " downloading ...\n");
    &command( "wget --show-progress -qc $LINK/$filename[$i1].$EXTENSION");
    &MY_PRINT($stdout, "   opening ...");
    &command( "gunzip $filename[$i1].$EXTENSION");
    &command( "tar xf $filename[$i1].tar");
    if (not $mode eq "bench")
    {
     &MY_PRINT($stdout, " recompressing ...");
     &command( "gzip $filename[$i1].tar");
     &MY_PRINT($stdout, "done");
    }
    $icheck=$icheck+1;
   }else {
    &MY_PRINT($stdout, "...$filename[$i1].$EXTENSION [NO]");
   }
   &MY_PRINT($stdout, "\n");
   $i1=$i1+1;          
  } until ( $i1 == $imax+1 );
 }
 chdir("$suite_dir/$TESTS_folder");
}
&MY_PRINT($stdout, "\n");
&CWD_go;
chdir("$suite_dir");
}
1;