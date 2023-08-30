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
sub RUN_input_apply_renaming_rules{
 #
 undef $renaming_done;
 #
 for $irunlvl (1...$N_RUNLVLRN) 
 {
  if ($RUNLVLRN_branch[$irunlvl] =~ /$branch_key/ or $RUNLVLRN_branch[$runlvl] =~ "any")
  { 
   for (my $il=0; $il<=$#INPUT ; $il++)
   {
    my $in_line=$INPUT[$il];
    if ($in_line =~ /$RUNLVLRN[$irunlvl][1]/) 
    {
     $renaming_done=1;
     $in_line =~ s/$RUNLVLRN[$irunlvl][1]/$RUNLVLRN[$irunlvl][2]/g;
    }
    $INPUT[$il]=$in_line;
   }
  }
 } 
 if ($renaming_done) 
 {
  open($in_file_to_rn, '>',$INPUT_file);
  for (my $il=0; $il<=$#INPUT ; $il++)
  {
   print $in_file_to_rn "$INPUT[$il] \n";
  }
  close($in_file_to_rn);
 }
 #
}
1;
