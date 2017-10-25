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
sub CPU_CONF_setup{
 #
 if( -e "./ROBOTS/$host/$user/CPU_CONFIGURATIONS/$cpu_conf_file"){
  my $file="./ROBOTS/$host/$user/CPU_CONFIGURATIONS/$cpu_conf_file";
  open(CPU_CONF_point,"<","$file");
  &MY_PRINT($stdout, "CPU_CONF file:$file\n") if ($verb);
  @CPU_CONF = <CPU_CONF_point>;
  foreach $CONF (@CPU_CONF){
   chomp($CONF);
   my @field = split(/\s+/, $CONF);
   if ($field[1] =~ /_CPU/)
   {
    my @cpu_field = split(/\./, $field[2]);
    my $prod=1;
    for(@cpu_field){$prod *= $_;}
    if ($np_single<$prod) {$np_single=$prod};
   }
  }
  $Nr=1;
  $CPU_flag="-E $suite_dir/ROBOTS/$host/$user/CPU_CONFIGURATIONS/$cpu_conf_file";
  $cpu_conf_key = $cpu_conf_file;
  $cpu_conf_key =~ s/\.cpu//;
  close(CPU_CONF_point);
 }
 #
}
1;
