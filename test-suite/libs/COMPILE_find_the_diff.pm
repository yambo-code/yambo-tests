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
sub COMPILE_find_the_diff{
# Try to compile the find_the_diff fortran code if necessary
if ("@_" =~ "clean"){
 &command("rm -f find_the_diff/find_the_diff.o find_the_diff/find_the_diff find_the_diff/Makefile");
}
if ("@_" =~ "compile" and !-f "./find_the_diff/find_the_diff" ){
 &command("cp $BRANCH/config/setup find_the_diff/Makefile");
 chdir("find_the_diff");
 &command("./make_the_makefile.sh");
 &command("./make");
 chdir "../";
 if(! -e "./find_the_diff/find_the_diff") { die "Missing ./find_the_diff/find_the_diff executable. Make it manually.\n"};
}
}
1;
