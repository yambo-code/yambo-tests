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
sub UTILS_gimme_childs{
#######################
my ($dir,$in) = @_;
my $childs;
#print "\nLEVEL 0 $dir $in";
my @c1=&scan_file("$dir","$in");
foreach my $f1 (@c1){
 if (not $childs =~ /\Q$f1\E/) {$childs="$childs $f1"};
 #print "\nLEVEL 1 $f1";
 my @c2=&scan_file("$dir","$f1");
 foreach my $f2 (@c2){
  if (not $childs =~ /\Q$f2\E/) {$childs="$childs $f2"};
  #print "\nLEVEL 2 $f2";
  my @c3=&scan_file("$dir","$f2");
  foreach my $f3 (@c3){
   if (not $childs =~ /\Q$f3\E/) {$childs="$childs $f3"};
   #print "\nLEVEL 3 $f3";
  }
 }
}
return $childs;
}
sub scan_file{
##############
my ($dir,$in) = @_;
my @flags;
my @childs;
if (-f "$dir/$input_folder/$in") 
{
 open(FLAGS,"<","$dir/$input_folder/$in.flags");
 @flags = <FLAGS>;
}elsif (-f "$dir/INPUTS/$in") 
{ 
 open(FLAGS,"<","$dir/INPUTS/$in.flags");
 @flags = <FLAGS>;
}else{
 return
};
#
foreach my $flag (@flags)
{
 $flag =~ s/^\s+|\s+$//g ;
 chomp $flag;  
 next if (not -f "$dir/$input_folder/$flag" and not -f "$dir/INPUTS/$flag");
 push @childs, "$flag";
}
#
close(FLAGS);
return @childs;
}
1;
