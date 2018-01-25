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
sub UTILS_options
{
my $ret = &GetOptions("h"    => \$help,
            "np=i"           => \$np_single,
            "np_min=i"       => \$np_min,
            "np_max=i"       => \$np_max,
            "nt=i"           => \$nt,
            "nl=i"           => \$nl,
            "def_par"        => \$default_parallel,
            "rand_par"       => \$random_parallel,
            "off=s"          => \$is_off,
            "l:s"            => \$listtests,
            "d=s"            => \$download,
            "c+"             => \$clean,
            "compile"        => \$compile,
            "i"              => \$info,
            "u"              => \$upload,
            "b:s"            => \$backup_logs,
            "v+"             => \$verb,
            "cpu_conf=s"     => \$cpu_conf_file,
            "conf=s"         => \$select_conf_file,
            "gpl"            => \$is_GPL,
            "tests=s"        => \$user_tests,
            "prec=s"         => \$prec,
            "keys=s"         => \$keys,
            "status"         => \$repo_check,
            "broken=s"       => \$tag_test_as_broken,
            "update=s"       => \$update_test,
            "upload=s"       => \$upload_test,
            "colors"         => \$use_colors,
            "kill:s"         => \$kill_me,
            "edit:s"         => \$edit,
            "flow=s"         => \$flow,
            "autotest"       => \$autotest,
            "report"         => \$report,
            "force"          => \$force,
            "ftp"            => \$ftp,
            "dry"            => \$dry_run,
            "newer=i"        => \$max_delay_commits,
            "robot=i"        => \$ROBOT_id,
            "nice:i"         => \$nice_level,
            "host=s"         => \$USER_host,
            "failed=s"       => \$failed,
            "php"            => \$php,
            "profile:s"      => \$profile,
            "mode=s"         => \$mode
                      );
#
}
sub UTILS_robot_info {
 print <<ROBOT_info

   Running on host    : $host
   By user            : $user
   Version            : $version
   Available     CPU's: $SYSTEM_NP
   Available  CPU conf: $cpu_avail
   Available Compilers: $conf_avail
   Available     flows: $flows_avail
ROBOT_info
}
sub UTILS_usage {
 print <<EndOfUsage
   Syntax: driver.pl <ARGS>
           < > are variable parameters, [ ] are optional, | indicates choice
           
   where <ARGS> must include at least one of:
             -h                     This help & status.
             -kill    <USER>        Kill the test-suite runs for user <USER>. If not given use the current one.
             -i                     Robot info
             -l       [<SET>]       List available SETs (-l) or input files for a SET (-l <SET>).
             -c                     Clean.
             -d      <SET>|all|list Download & Update the core databases.
             -compile               Compile the sources.
             -tests  <TESTS>|all    List* of tests to perform, or all "-tests all".

   (Running options)
             -dry                   Run in dry mode. Not actual job is launched.
             -nice   [VALUE]        Run with priority VALUE. With no VALUE max nice level is used (lower priority).

   (General options)
             -mode                  Can be "tests/perturbo/cheers/bench". It selects which suite to use. Default is "tests".
             -host  <string>        Robot name.
             -robot <ID>            Robot ID.
             -status                List SVN/GIT new/untracked files.
             -v [-v]                Verbose output (use -v -v for extra verbosity)
             -colors                Use colors in messages.
             -edit   <WHAT>         View and edit. WHAT=filters,branches,flags,<FILE>(in FLOWS and CPU_CONFIGURATION, for example).
                                    Use -e backup with -b ## to edit the REPORT of the backupd REPORT number ##

   (SOURCEs)
             -conf   <NAME>         Use configuration NAME              (default: no options, all: cycle among all confs)
             -gpl                   Only GPL-compliant test.

   (TEST selection)
             -flow   <FILE>         Use the flow of calculations defined in <FILE> (refer to ROBOTS/$host/$user/FLOWS/<FILE>.pl).
             -keys   <string>       Test keys (see below*).
             -off    <string>       Switch off specific objects (mpi,openmp,io).
             -prec   <PREC>         Precision of data comparisons       (default: 0.01 = 1% of MAX value)
             -force                 Run even BROKEN tests.

   (TEST control)
             -update <TEST>         Update all REFERENCE files of the <TEST_folder>. Format is <TEST_folder/testdir> or <TEST_folder/testdir/test>.
             -upload <TEST>         Upload the <TEST_folder>/<TEST> directory.
             -broken <TEST>         Tag <TEST_folder>/<TEST> as Broken.

   (parallel options)
             -cpu_conf <FILE>       Use the CPU configuration defined in <FILE> (refer to ROBOTS/$host/$user/CPU_CONFIGURATION/<FILE>.cpu).
             -np     <N>            Fixed number of CPU used.
             -np_min <N>            Minimum number of CPU used.
             -np_max <N>            Maximum number of CPU used.
             -nt     <T>            # of OMP threads.
             -nl     <L>            # of CPU used for linear algebra.
             -def_par               Use the default parallelization scheme.
             -rand_par              Use randomly generated parallel structures.
             -newer  <D>            Run only if the source is newer than <D> days.

   (Auto-testing)
             -autotest              Perform a simple serial minimal auto-test.

   (Reporting)
             -failed <ERROR>        Create a failed.pl theme reading the ERROR file.
             -php                   Translate the latest 20 REPORT files in the ROBOT history in a php format and upload.
             -report                UPLOAD the result to the web-page

   (Profiling)
             -profile [DIR]         Create a Profile analysis [of DIR]

   (Backup)
             -b [ID's]              If running BACKUP the LOGs (automatically used when -report is given)
                                    Otherwise list the BACKUPs available

   (FTP actions)           
             -ftp                   Log in FTP server

 * <TESTS> has form: "<SET1> {<input1> [<input2>]|all}; <SET2> {<input1> [<input2>]|all}"
                      where <SET1> is a path within the <TEST_folder> folder 
                      and <input1> <input2>.. is a list of inputs (or all) or a keyword
                      e.g. -tests "Si_bulk/GW/2x2x2 01_init 02_eels ; Al111 01*" 
                           -tests "Si_bulk/GW/2x2x2 01* 02* ; Al111 01*" 

 * keys is string of projects/features:
   
   projects = sc rt elph pl magnetic nl kerr hard
   features = bse gw hf rpa (more to come)

   Using -keys all all projects/features are used

EndOfUsage
  ;
  exit;
}
1;
