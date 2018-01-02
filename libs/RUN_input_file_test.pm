#
#        Copyright (C) 2000-2018 the YAMBO team
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
sub RUN_input_file_test{
 chdir("$suite_dir/$TESTS_folder/Inputs");
 print "AAAAB\n";
 @yambo_flags = ('-i','-r',
#'-x','-p p','
#'-g n','-g s','-g g',
#'-o g','-o c',
#'-k hartree','-k alda',
#'-y h'	,'',
 );
#while(($flag,$label) = splice(@yambo_flags,0,2)) {
#Run setup first
 while($flag = shift(@yambo_flags)) {
 $flag_ = ($flag =~ s/\w/_/);
 $ref_file1 = "yambo.in_".$flag_;
 $cmd = "$BRANCH/$conf_bin/yambo $flag -F yambo.in_run_".$flag_;
#if(!-x "$BRANCH/$conf_bin/$check_exec") { next; }
#$result = `$BRANCH/$conf_bin/yambo $flag -F yambo.in_$label`;
 print "AAAA $cmd\n";
 system("$cmd 2>/dev/null  ; ls");
 fldiff yambo.in_run_$flag_ $ref_file1;
 $ref_file2 = "yambo.in_".$flag."_-V_all";
 $cmd = "$BRANCH/$conf_bin/yambo $flag -F yambo.in_run_$flag_";
 system("$cmd 2>/dev/null  ; ls");
 }
 chdir("$suite_dir");
}
1;
