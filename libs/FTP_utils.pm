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
sub FTP_list
{
&command("echo 'ls -lt htdocs/@_' > cmds");
&command("sftp -b cmds ${FTP_user}\@media.yambo-code.eu");
&command("rm -f cmds");
die "\n";
}
sub FTP_it
{
&command("sftp ${FTP_user}\@media.yambo-code.eu");
die "\n";
}
sub FTP_mkdir
{
#
my $dir  = shift;
#
&command("echo 'mkdir htdocs/$dir' > cmds");
&command("sftp -b cmds ${FTP_user}\@media.yambo-code.eu");
&command("rm -f cmds");
}
sub FTP_upload_it
{
#
my $what  = shift;
my $where = shift;
my $rec = shift;
#
&command("echo 'put $rec $what htdocs/$where' > cmds");
&command("echo 'chmod 775 htdocs/$where/$what' >> cmds");
&command("echo 'chown yambo.user htdocs/$where/$what' >> cmds");
&command("echo 'chgrp 33 htdocs/$where/$what' >> cmds");
&command("sftp -b cmds ${FTP_user}\@media.yambo-code.eu");
&command("rm -f cmds");
}
1;
