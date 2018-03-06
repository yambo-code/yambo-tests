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
sub PROFILE_python{
###################
my @DATs;
@dirs = ( "PROFILING" );
find( sub { push @DATS, $File::Find::name if /TOTAL_TIME_vs_PAR_CONF.dat/ }, @dirs );
#
print "Processing";
for $file (@DATS) 
{
 @paths=split('\/',$file);
 $test=$paths[$NP-2];
 my($filename, $directory) = fileparse($file);
 print "...$test($directory)";
 &command("python scripts/profiling/profiling_report.py $directory");
 #
 &command("mv TIME_vs_SECTION.pdf TIME_vs_SECTION-$test.pdf");
 &command("mv MEMORY_vs_SECTION.pdf MEMORY_vs_SECTION-$test.pdf");
 &command("mv TOTAL_TIME_vs_PAR_CONF_legend.pdf TOTAL_TIME_vs_PAR_CONF_legend-$test.pdf");
 &command("mv TOTAL_TIME_vs_PAR_CONF_text.pdf TOTAL_TIME_vs_PAR_CONF_text-$test.pdf");
 &command("mv TOTAL_TIME_vs_PAR_CONF_ticks.pdf TOTAL_TIME_vs_PAR_CONF_ticks-$test.pdf");
 #
}
print "\n\n";
die;
}
1;
