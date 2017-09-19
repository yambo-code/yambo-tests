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
sub RUN_feature{
my @string = split(/ /, "@_");
my $result="0";
LOOP: for (my $il=0; $il<=$#INPUT ; $il++){
 LOOPF: for (my $if=0; $if<=$#string ; $if++){
  if ($INPUT[$il] =~ /$string[$if]/){ $result="1"};
 }
}
return "$result";
}
sub RUN_input_load{
if (-f "BASE_input") 
{
 open(INFILE,"<","BASE_input");
}else{
 open(INFILE,"<","$input_folder/$testname");
}
@INPUT=" ";
my $il=-1;
LOOP: while(<INFILE>) { 
 chomp($_);
 my @string = split(/ /, $_);
 next LOOP if $string[0] =~ /#/;
 my @string = split(/#/, $_);
 $il++;
 $INPUT[$il]=@string[0];
}
close(INFILE);
}
sub PRINT_input{
&MY_PRINT($stdout, "\n");
&MY_PRINT($stdout, "\n INPUT:$input_folder/$testname") ;
LOOP: for (my $il=0; $il<=$#INPUT ; $il++){
 &MY_PRINT($stdout, "\n$INPUT[$il]");
}
}
1;