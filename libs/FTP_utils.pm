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
if ($ncftpls) 
{
 &command("$ncftpls -l -u 1945528\@aruba.it -p uQ\\\$66cx\\*W3T\\*Wh ftp://ftp.yambo-code.org/www.yambo-code.org/@_")
}else{
 &command("echo 'ls -lt htdocs/@_' > cmds");
 &command("sftp -b cmds yambo.user\@media.yambo-code.eu");
 &command("rm -f cmds");
}
die "\n";
}
sub FTP_it
{
if ($ncftp) 
{
 &command("$ncftp -u 1945528\@aruba.it -p uQ\\\$66cx\\*W3T\\*Wh ftp.yambo-code.org");
}else{
 &command("sftp yambo.user\@media.yambo-code.eu");
}
die "\n";
}
sub FTP_upload_it
{
#
my $what  = shift;
my $where = shift;
my $rec = shift;
#
if ($ncftpput)
{
 &command("$ncftpput $rec -u 1945528\@aruba.it -p uQ\\\$66cx\\*W3T\\*Wh ftp.yambo-code.org www.yambo-code.org/$where $what");
}else{
 &command("echo 'put $rec $what htdocs/$where' > cmds");
 &command("echo 'chmod 775 htdocs/$where' >> cmds");
 &command("sftp -b cmds yambo.user\@media.yambo-code.eu");
 &command("rm -f cmds");
}
}
1;
