#
#        Copyright (C) 2000-2020 the YAMBO team
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
sub COMPILE_find_the_diff{
#
if ($dry_run) {return};
#
# Try to compile the find_the_diff fortran code if necessary
#
chdir("scripts/find_the_diff");
if ("@_" =~ "clean" and -f "Makefile"){
 &command("make clean");
}
if ("@_" =~ "compile" and !-f "$find_the_diff" ){
 if ($keep_bin    ) {&command("cp $conf_bin/setup Makefile")};
 if (not $keep_bin) {&command("cp $comp_folder/config/setup Makefile")};
 &command("./make_the_makefile.sh");
 &command("mv find_the_diff $find_the_diff");
 if(! -e "$find_the_diff") { die "Missing $find_the_diff executable. Make it manually.\n"};
 &command("make clean");
}
chdir "../../";
}
1;
