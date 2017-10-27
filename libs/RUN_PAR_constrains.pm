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
 $MAX_k=$np;
 $MAX_v=$np;
 $MAX_c=$np;
 $MAX_G=$np;
 foreach $file ( <G_*> ){ $file =~ s/G_//g; $MAX_G=$file};
 foreach $file ( <KPT_*> ){ $file =~ s/KPT_//g; $MAX_k=$file};
 foreach $file ( <VALENCE_*> ){ $file =~ s/VALENCE_//g; $MAX_v=$file};
 foreach $file ( <CONDUCTION_*> ){ $file =~ s/CONDUCTION_//g; $MAX_c=$file};
}
1;
