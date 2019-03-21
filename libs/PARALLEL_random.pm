#
#        Copyright (C) 2000-2018 the YAMBO team
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
sub PARALLEL_random{
#
&RUN_random_PAR(4);
while (&PAR_conf_check( {G=>$ncpu[0], k=>$ncpu[1], c=>$ncpu[2], v=>$ncpu[3] } ) eq 1){&RUN_random_PAR(4)};
@GKCV[0]=[@ncpu];
#
&RUN_random_PAR(5);
while (&PAR_conf_check( {G=>$ncpu[0], k=>$ncpu[1], c=>$ncpu[3], v=>$ncpu[4] } ) eq 1 or &PAR_conf_check( {G=>$ncpu[0], k=>$ncpu[2], c=>$ncpu[3], v=>$ncpu[4] } ) eq 1  ){&RUN_random_PAR(5)};
@GQKCV[0]=[@ncpu];
#
&RUN_random_PAR(3);
while (&PAR_conf_check( {k=>$ncpu[0], c=>$ncpu[1], v=>$ncpu[2] } ) eq 1){&RUN_random_PAR(3)};
@KCV[0]=[@ncpu];
#
&RUN_random_PAR(3);
while (&PAR_conf_check( {k=>$ncpu[0], b=>$ncpu[2]} ) eq 1){&RUN_random_PAR(3)};
@QSB[0]=[@ncpu];
#
&RUN_random_PAR(3);
while (&PAR_conf_check( {k=>$ncpu[0], eh=>$ncpu[1]}) eq 1 ){&RUN_random_PAR(3)};
@KEHT[0]=[@ncpu];
#
&RUN_random_PAR(2);
while (&PAR_conf_check( {w=>$ncpu[0], k=>$ncpu[1]}) eq 1 ){&RUN_random_PAR(2)};
@WK[0]=[@ncpu];
#
&RUN_random_PAR(4);
while (&PAR_conf_check( {k=>$ncpu[0], b=>$ncpu[3] } ) eq 1 or &PAR_conf_check( {k=>$ncpu[1]} ) eq 1){&RUN_random_PAR(4)};
@QKSB[0]=[@ncpu];
#
}
1;
