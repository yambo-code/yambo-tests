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
sub RUN_PAR_constrains{
 foreach $file ( <KPT_*> ){
  $file =~ s/KPT_//g;
  if ($q>$file){ return -1};
  if ($k>$file){ return -1};
 };
 foreach $file ( <VALENCE_*> ){
  $file =~ s/VALENCE_//g;
  if ($v>$file){ return -1};
 };
 foreach $file ( <CONDUCTION_*> ){
  $file =~ s/CONDUCTION_//g;
  if ($c>$file){ return -1};
 };
 return 0;
}
1;
