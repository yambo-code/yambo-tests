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
sub CRON_driver{
 #
 my $cwd=abs_path();
 my $B;
 #
 if ($cron eq "clean")
 {
  &command("crontab -r");
  exit "\n";
 }
 #
 if ($cron eq "install")
 {
  &command("crontab $cwd/ROBOTS/$host/$user/CRONTAB");
  exit "\n";
 }
 #
 if (not $user_branch or not $user_module) {die "Missing -branch and -module\n"};
 #
 &LOAD_branches;
 for $ib ( 0 .. $#branches ) {
  if ( $branch_identity[$ib] =~ /$user_branch/) {$B=$branch_identity[$ib]};
 }
 #
 $script="script_".$B."_".$user_module.".tcsh";
 $log="LOG_".$B."_".$user_module;
 #
 open($slog, '>', "$cwd/ROBOTS/$host/$user/SCRIPTS/$script") or die "Could not open file '$cwd/ROBOTS/$host/$user/SCRIPTS/$script' $!";
 &MY_PRINT($slog, "#!/usr/bin/tcsh\n");
 &MY_PRINT($slog, "cd $cwd\n");
 &MY_PRINT($slog, "module purge\n");
 for( $i = 1; $i <= $n_modules; $i = $i + 1 )
 {
  if ($MODULES[$i]->{NAME} =~ /$user_module/) 
  {
   for $mod (@{$MODULES[$i]->{CMDS}}) 
   {
    &MY_PRINT($slog, "module load $mod\n");
   }
  }
 }
 # CMD
 #
 &MY_PRINT($slog, "./driver.pl -flow validate -report -branch $B -nice -newer 7\n");
 close($slog);
 &command("chmod a+x $cwd/ROBOTS/$host/$user/SCRIPTS/$script");
 #
 my $h=(split(":",$cron))[0];
 my $m=(split(":",$cron))[1];
 #
 open(CRON_file, '<', "$cwd/ROBOTS/$host/$user/CRONTAB");
 my @CRON_lines = <CRON_file>;
 close(CRON_file);
 $empty=1;
 for $line (@CRON_lines)
 {
  if (not $line =~ /#/) {undef $empty};
 }
 #
 open($slog, '>>', "$cwd/ROBOTS/$host/$user/CRONTAB"); 
 #
 if ($empty) 
 {
  &MY_PRINT($slog, "#30 23 * * * $cwd/driver.pl -kill 2>&1\n");
  &MY_PRINT($slog, "#40 23 * * * $cwd/driver.pl -c 2>&1\n");
  &MY_PRINT($slog, "#50 23 * * * $cwd/driver.pl -d all -force 2>&1\n");
 }
 &MY_PRINT($slog, "$m $h * * * $cwd/ROBOTS/$host/$user/SCRIPTS/$script >  $cwd/$log 2>&1 \n");
 close($slog);
 system("vim $cwd/ROBOTS/$host/$user/CRONTAB")
 #
}
1;
