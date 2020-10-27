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
sub UTILS_upload
{
#
my $UPLOAD_PATH="robots/databases/$mode";
#
$user_tests="all";
&UTILS_get_inputs_tests_list();
@all_tests = split(/ /,$alltests);
#
foreach  my $test (@all_tests)
{
 chdir("$suite_dir");
 $archive = $upload_test;
 $path = (split("\/",$archive))[-1];
 $archive =~ s/\//_/g;
 $test_string= $test;
 $test_string =~ s/\//_/g;
 if ($test_string =~ /$archive/)
 {
  chdir("$TESTS_folder/$test/../");
  print "$test_string - $archive - $path\n";
  &command("find $path -name 'ns.*' -o -name 'ndb*gkkp*' -o -name 'ndb*Double*' | $grep -v 'ROBOT_'| xargs tar cvf $archive.tar");
  &command("gzip $archive.tar");
  &FTP_upload_it("$archive.tar.gz","$UPLOAD_PATH");
  find( sub { push @dirs, $File::Find::name if -d }, (".") );
  DIR_LOOP: foreach $dir (@dirs){
   if ( $dir  =~ /SAVE/ ) {
    &command("touch add $dir/.empty");
    &command("git add $dir/.empty");
   }
  }
 }
}
}
1;
