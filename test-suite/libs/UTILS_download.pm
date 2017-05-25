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
sub UTILS_download
{
&CWD_save;
chdir("$suite_dir/tests");
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
 if ($download or $extract) { $do_it = "yes" };
 if ($do_it eq "yes"){
   if (-e "./BROKEN" and ! $force) { $do_it = "no" };
 }
 if ( $do_it eq "yes"){
  &MY_PRINT($stdout, "\n=> ".$dir." ...");
  $i1=0;
  $filename[$i1] = $dir;
  foreach $subdir (<*>) {
   $i1=$i1+1;
   $filename[$i1] = "${dir}_${subdir}";
  }
  $imax=$i1;
  $i1=0;
  $icheck=0;
  do{
   if ( $extract){
    if (-e "$filename[$i1].tar.gz") {
     &MY_PRINT($stdout, "[$filename[$i1]]opening ...");
     &command( "gunzip $filename[$i1].tar.gz");
     &command("tar xf $filename[$i1].tar");
     &MY_PRINT($stdout, " recompressing ...");
     &command( "gzip $filename[$i1].tar");
     &MY_PRINT($stdout, "done");
    }
   }else{
    $cmd = "wget --spider -q http://www.yambo-code.org/testing-robots/databases/$filename[$i1].tar.gz && echo exists || echo not exist";
    my $file_exist = `$cmd`;
    if ( "$file_exist" eq "exists\n") {
      if( $icheck>0 ){ &MY_PRINT($stdout, "\n   ".$dir." ...") };
     &MY_PRINT($stdout, " found $filename[$i1].tar.gz ...");
     &command( "rm -f $filename[$i1].tar.gz");
     &MY_PRINT($stdout, " downloading ...");
     &command( "wget -qc http://www.yambo-code.org/testing-robots/databases/$filename[$i1].tar.gz");
     &MY_PRINT($stdout, " opening ...");
     &command( "gunzip $filename[$i1].tar.gz");
     &command( "tar xf $filename[$i1].tar");
     &MY_PRINT($stdout, " recompressing ...");
     &command( "gzip $filename[$i1].tar");
     &MY_PRINT($stdout, "done");
     $icheck=$icheck+1;
    }
   } 
   $i1=$i1+1;          
  } until ( $i1 == $imax+1 );
 }
 chdir("$suite_dir/tests");
}
&MY_PRINT($stdout, "\n");
die "Download complete.\n";
&CWD_go;
chdir("$suite_dir");
}
1;
