#
#        Copyright (C) 2000-2019 the YAMBO team
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
sub FTP_list
{
if (!$ncftpls) {die "Undefined ncftp ( $ncftpls)"};
&command("$ncftpls -l -u 1945528\@aruba.it -p 5fv94ktp ftp://ftp.yambo-code.org/www.yambo-code.org/@_");
die "\n";
}
sub FTP_it
{
if (!$ncftp) {die "Undefined ncftp ( $ncftp)"};
&command("$ncftp -u 1945528\@aruba.it -p 5fv94ktp ftp.yambo-code.org");
die "\n";
}
sub FTP_upload_it
{
if (!$ncftpput) {return};
#
my $what  = shift;
my $where = shift;
#
&command("$ncftpput -u 1945528\@aruba.it -p 5fv94ktp ftp.yambo-code.org www.yambo-code.org/$where $what");
}
1;
