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
sub UTILS_upload
{
@paths = split(/\//,$upload_test);
$archive = $upload_test;
$archive =~ s/\//_/;
$test_dir   =$upload_test;
$test_subdir=".";
if ( scalar @paths > 1) {
  $test_dir=@paths[0];
  $test_subdir=$upload_test;
  $test_subdir =~ s/$test_dir\///;
}
chdir("tests/$test_dir");
&command("find $test_subdir -name 'ns.*' -o -name 'ndb*gkkp*' -o -name 'ndb*Double*' | xargs tar cvf $archive.tar");
&command("gzip $archive.tar");
&FTP_upload_it("$archive.tar.gz","testing-robots/databases")
&command("rm -f $archive.tar.gz");
die;
}
1;
