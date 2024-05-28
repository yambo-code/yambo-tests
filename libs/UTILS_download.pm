#
#        Copyright (C) 2000-2020 the YAMBO team
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
if (!$wget) {return};
&CWD_save;
#
#
$user_tests="all";
&UTILS_get_inputs_tests_list();
@all_tests = split(/ /,$alltests);
#
my $LINK="https://media.yambo-code.eu/robots/databases/$mode";
my $EXTENSION=".tar.gz";
if ($mode eq "bench") {
 $LINK="http://potzie.fisica.unimo.it/ferretti/yambo-benchmarks-databases";
 $EXTENSION="";
};
#
chdir("$suite_dir/$TESTS_folder");
foreach $dir (<*>) {
 if ($download ne " ") {
  if( ($download ne "all") && ($download ne $dir) ){ next; };
 };
 chdir($dir);
 if ($veryclean) {&clean};
 my $do_it="no";
 if ($download) { $do_it = "yes" };
 if ($do_it eq "yes"){
   if (-e "./BROKEN" and ! $force) { $do_it = "no" };
   if ($dir =~ /docs/) { $do_it = "no" };
 }
 if ( $do_it eq "yes"){
  #
  # Filename choosing
  #
  if ($mode eq "bench")
  {
   $i1=-1;
   if ($dir =~ /AGNR/)    {
    $BASE = "agnr_v4.2-IO.tar";
    $last_ch ="a";
    $last_chp="z";
   }
   if ($dir =~ /cobalt/)  {
    $BASE = "cobalt_v4.2-IO.tar";
    $last_ch ="a";
    $last_chp="b";
   }
   if ($dir =~ /chevron/) {
    $BASE = "chevron_poly_v4.2-IO.tar";
    $last_ch ="e";
    $last_chp="w";
   }
   for my $char ('a' .. "$last_ch") { 
    for my $charp ('a' .. "$last_chp") { 
     $i1=$i1+1;
     $filename[$i1] = "$BASE".".$char$charp";
     $position[$i1] = ".";
    }
   }
   if ($dir =~ /hBN_bench/) {
    $i1=0;
    $BASE = "hBN_bench.tar";
    $filename[0] = "hBN_bench.tar";
    $position[0] = ".";
   }
  }else{
   $i1=-1;
   foreach  my $test (@all_tests)
   {
    if ($test =~ /$dir/)
    {
     $i1=$i1+1;
     $filename[$i1] = $test;
     $filename[$i1] =~ s/\//_/g;
     $position[$i1] = $test."/../";
    }
   }
  }
  $imax=$i1;
  $i1=0;
  WWW: while($i1 < $imax+1) {
   $cmd = "$wget --spider -q $LINK/$filename[$i1]$EXTENSION && echo exists || echo not exist";
   my $file_exist = `$cmd`;
   if ($mode eq "tests" or $mode eq "cheers" or $mode eq "validate"){
    if ( "$file_exist" eq "exists\n") {
     chdir("$suite_dir/$TESTS_folder/$position[$i1]");
     $cmd="curl -sI $LINK/$filename[$i1]$EXTENSION | grep Content-Len | cut -f2 -d ':'";
     my $remote_file_size = `$cmd`; 
     if ($force) {&command("rm -f $filename[$i1]$EXTENSION ")};
     my $local_file_size = 1;
     if (-f "$filename[$i1]$EXTENSION") {$local_file_size = `du -b $filename[$i1]$EXTENSION`};
     undef $get_it;
     if (not $remote_file_size == $local_file_size) {$get_it=1};
     #
     if ($get_it){
      &command("rm -f $filename[$i1]$EXTENSION ");
      &MY_PRINT($stdout, "$filename[$i1]$EXTENSION...");
      &command( "$wget -qc $LINK/$filename[$i1]$EXTENSION");
      &MY_PRINT($stdout, " [downloaded]...");
      &command( "tar zxf $filename[$i1]$EXTENSION");
      &MY_PRINT($stdout, "  [opened]\n");
     }
     #
    }else {
     &MY_PRINT($stdout, "$filename[$i1]$EXTENSION [not found]\n");
    }
   }else{
    if ( "$file_exist" eq "exists\n" and  not -f $BASE) {
     &MY_PRINT($stdout, "...$filename[$i1]$EXTENSION [YES] ...");
     &MY_PRINT($stdout, " downloading ...\n");
     &command( "$wget -qc $LINK/$filename[$i1]");
     $CAT_cmd.=" $filename[$i1]";
    }else{
     &MY_PRINT($stdout, "...$BASE [FOUND]\n");
     last WWW;
    }
   }
   $i1=$i1+1;          
  } 
 }
 if ($mode eq "bench" and not -f $BASE) {
  &MY_PRINT($stdout, "   concatenating ...");
  &command( "cat $CAT_cmd >  $BASE");
  &MY_PRINT($stdout, " cleaning the fragments ...");
  &command( "rm -f $CAT_cmd");
 }
 if ($mode eq "bench" and not -f "SAVE/ns.db1") {
  &MY_PRINT($stdout, "   opening ...");
  &command( "tar xf $BASE");
 }
 chdir("$suite_dir/$TESTS_folder");
}
&MY_PRINT($stdout, "\n");
&CWD_go;
chdir("$suite_dir");
}
1;
