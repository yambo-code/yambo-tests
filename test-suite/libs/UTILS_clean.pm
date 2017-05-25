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
my @paths=("tests");
if ( "@_" eq "ALL" or "@_" eq "DEEP") {
 &command("rm -f *.log");
 @paths=("tests","find_the_diff","config");
}
&command("rm -f find_the_diff/*.o");
LOOP_CONF: foreach  my $clean_path (@paths){
 &CWD_save;
 chdir("$suite_dir/$clean_path");
 &command("svn st | grep -v 'MODULES.pl' | grep -v 'TOOLS.pl' | grep -v '.gz' | grep -v 'SAVE/ns.' | grep -v 'elph_gkkp' |grep -v 'SAVE_backup' | grep '?'|  $awk '{print \$2}' | xargs rm -fr");
 &CWD_go;
}
if ( "@_" eq "ALL") {
 &command("rm -f outputs*");
}
if ( "@_" eq "DEEP") {
 &command("rm -f config/MODULES.pl config/TOOLS.pl");
}
}
1;
