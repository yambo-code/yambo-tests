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
sub MESSAGE{
if ("@_[0]" =~ m/WHITE/)  {&MY_PRINT($wlog, "@_[1]")};
if ("@_[0]" =~ m/ERROR/)  {
 &MY_PRINT($elog, "@_[1]");
 @ERROR_entries[$N_errors]="@_[1]";
 ++$N_errors;
}
if ("@_[0]" =~ m/LOG/)    {&MY_PRINT($tlog, "@_[1]")}; 
if ("@_[0]" =~ m/REPORT/) {&MY_PRINT($rlog, "@_[1]")}; 
}
1;
