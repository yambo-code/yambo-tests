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
 $user_string = $test;
 if (not "$upload_test" eq "all") { $user_string = $upload_test};
 $user_string =~ s/\//_/g;
 $test_string= $test;
 $test_string =~ s/\//_/g;
 $path = (split("\/",$test))[-1];
 if ($test_string =~ /$user_string/)
 {
  chdir("$TESTS_folder/$test/../");
  undef $ok_dir;
  @files=();
  find( sub { push @files, $File::Find::name if -f }, ("$path") );
  foreach $file (@files){
    if ($file =~ /ns./ or $file =~ /gkkp/ or $file =~/Double/) {$ok_dir=1}
  }
  if (not $ok_dir) {next};
  print "\n$r_s Uploading $test ... $r_e\n";
  &command("find $path -name 'ns.*' -o -name 'ndb*gkkp*' -o -name 'ndb*Double*' -o -name '*.save*' -o -name '*io_files*' | $grep -v 'ROBOT_'| xargs tar cf $test_string.tar");
  &command("gzip -f $test_string.tar");
  &FTP_upload_it("$test_string.tar.gz","$UPLOAD_PATH"," ");
  @dirs=();
  find( sub { push @dirs, $File::Find::name if -d }, ("$path") );
  foreach $dir (@dirs){
   if ( $dir  =~ /SAVE/ ) {
    &command("touch $dir/.empty");
    &command("git add -f $dir/.empty");
   }
  }
 }
}
print "\n";
}
1;
