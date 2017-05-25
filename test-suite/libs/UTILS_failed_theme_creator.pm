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
sub UTILS_failed_theme_creator
{
my $testline=" ";
if (-e "$failed"){
 open(ERROR,"<","$failed");
 open(THEME,">","failed.pl");
 print THEME "#!/usr/bin/perl\n";
 print THEME "\@flow = (\n";
 @lines = <ERROR>;
 LINE: while($line = shift(@lines)) {
  chomp($line);
  $line =~ s\ \\;
  if ($line eq '') {next LINE};
  if ($line =~ "Parallel") { 
   $line =~ s/\://g;
   $line =~ s/\[//g;
   $line =~ s/\]//g;
   $line =~ s/\(/ /g;
   $line =~ s/\)/ /g;
   $line =~ s/\=/ /g;
   print THEME "{\n";
   print THEME "KEYS        => 'all hard',\n";
   my @par = split(/\s+/, $line);
   for (my $i=0; $i <= $#par + 1 ; $i++) {
    if (@par[$i] eq "N") { print THEME "MPI_CPU     => '@par[$i+1]',\n"};
    if (@par[$i] eq "Threads") { print THEME "THREADS     => '@par[$i+1]',\n"};
    if (@par[$i] eq "SLK") { print THEME "SLK_CPU     => '@par[$i+1]',\n"};
    if (@par[$i] eq "random") { print THEME "PAR_MODE     => '@par[$i]',\n"};
    if (@par[$i] eq "loop") { print THEME "PAR_MODE     => '@par[$i]',\n"};
    if (@par[$i] eq "default") { print THEME "PAR_MODE     => '@par[$i]',\n"};
   }
   my $testline=" ";
   next LINE;
  }; 
  if ($line =~ "Section Duration"){
   print THEME "ACTIVE      => 'yes',\n";
   print THEME "TESTS     => '$testline',\n";
   print THEME "},\n";
  };
  if ($line =~ "===" or $line =~ "%%%" or $line =~ "Running" or $line =~ "Projects") { next LINE };
  if ($line =~ "Build" or $line =~ "Date" or $line =~ "-----") { next LINE };
  if ($line =~ "ERRORs") { next LINE };
  $test = (split(/ /, $line))[0];
  my($filename, $directory) = fileparse("/".$test);
  my $dir="./tests".$directory;
  if (not -d "$dir") {
    $last = (split(/\//, $directory))[-1];
    $last =~ s/\+//;
    $directory =~ s/\+//;
    $directory =~ s/\/$last//;
  }
  $directory =~ s/\///;
  if ($testline =~ $directory) {next LINE};
  $testline = "$directory all ;".$testline;
  if ($directory =~ "Si_bulk/ELPH/BSE/") {
    $testline = "Si_bulk/ELPH/ELPH_for_BSE/ all ;".$testline;
  }
 }
 print THEME ");\n";
 close(ERROR);
 close(THEME);
}
}
1;
