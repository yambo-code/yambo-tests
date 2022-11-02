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
sub UTILS_options
{
my $ret = &GetOptions("h+"   => \$help,
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
            "compile=s"      => \$compile,
            "i"              => \$info,
            "u"              => \$upload,
            "b:s"            => \$backup_logs,
            "v+"             => \$verb,
            "cpu_conf=s"     => \$cpu_conf_file,
            "conf=s"         => \$user_conf_file,
            "gpl"            => \$is_GPL,
            "tests=s"        => \$user_tests,
            "prec=s"         => \$prec,
            "keys=s"         => \$keys,
            "status"         => \$repo_check,
            "broken=s"       => \$tag_test_as_broken,
            "update=s"       => \$update_test,
            "as_master"      => \$update_as_master,
            "upload=s"       => \$upload_test,
            "colors"         => \$use_colors,
            "kill"           => \$kill_me,
            "edit:s"         => \$edit,
            "flow=s"         => \$flow,
            "autotest"       => \$autotest,
            "report"         => \$report,
            "force"          => \$force,
            "ftp"            => \$ftp,
            "dry"            => \$dry_run,
            "newer=i"        => \$max_delay_commits,
            "robot:s"        => \$ROBOT_id,
            "nice:i"         => \$nice_level,
            "no_net"         => \$not_network,
            "host=s"         => \$USER_host,
            "failed=s"       => \$failed,
            "php=s"          => \$branch_php,
            "unsafe"         => \$unsafe_mode,
            "input"          => \$check_input_generation,
            "keep_bin"       => \$keep_bin,
            "profile:s"      => \$profile,
            "cron:s"         => \$cron,
            "branch:s"       => \$user_branch,
            "compdir:s"      => \$user_comp_folder,
            "mpirun:s"       => \$user_mpirun,
            "module:s"       => \$user_module,
            "mode=s"         => \$mode
                      );
#
}
sub UTILS_robot_info {
print <<ROBOT_info

  Running on host    : $host
  Yambo libs path    : $ext_libs_path
  By user            : $user
  Version            : $version
  Available     CPU's: $SYSTEM_NP
  Available  CPU conf: $cpu_avail
  Available Compilers: $conf_avail
  Available     flows: $flows_avail

  Available   modules:

ROBOT_info
;
for( $i = 1; $i <= $n_modules; $i = $i + 1 )
{
 print "\t #".$i." ".$MODULES[$i]->{NAME}.": ";
 print "@{$MODULES[$i]->{CMDS}}\n";
}
print "\n";

if ($#scripts_avail>0)
{
print <<SCRIPTS_info
  Available   scripts: 
SCRIPTS_info
;
for( $i = 0; $i <= $#scripts_avail; $i = $i + 1 )
{
 print "\t ".$scripts_avail[$i]."\n";
}
print "\n";
}

}
sub UTILS_usage {

if ($help>=1) {
 print <<EndOfUsage
   Syntax: driver.pl <ARGS>
           < > are variable parameters, [ ] are optional, | indicates choice
           
   where <ARGS> must include at least one of:
             -h                     This help & status (use -h -h to see more options).
             -kill                  Kill and stop all current test-suite components running. 
             -i                     Robot info
             -l       [<SET>]       List available SETs (-l) or input files for a SET (-l <SET>).
             -c                     Clean.
             -d      <SET>|all|list Download & Update the core databases.
             -compile<WHAT>         Compile the sources. WHAT=all|ext-libs.
             -tests  <TESTS>|all    List* of tests to perform, or all "-tests all".

   (Running options)
             -host   [HOST]         Use HOST instead of current hostname.
             -dry                   Run in dry mode. Not actual job is launched.
             -nice   [VALUE]        Run with priority VALUE. With no VALUE max nice level is used (lower priority).
             -unsafe                Avoid safe running that uses perl time selection
             -no_net                Skip network assisted operations
             -keep_bin              Do not overwrite the robot specific bin-precompiled folder
             -robot  <ID's>         Robot ID. [ID's can be of the form N or N-M]
             -branch [WHAT]         Branch selection.
             -compdir[WHAT]         Folder where the branch was compiled (i.e. compile_dir/devel-rt-vel-and-magn/default.sh ).
             -module [WHAT]         Environment module selection.
             -mpirun [WHAT]         Command name for mpirun if different from standard (default: mpirun)

   (TEST selection)
             -flow   <FILE>         Use the flow of calculations defined in <FILE> 
                                       (refer to ROBOTS/$host/$user/FLOWS/<FILE>.pl).
             -keys   <string>       Test keys (see below*).
             -off    <string>       Switch off specific objects (mpi,openmp,io).
             -prec   <PREC>         Precision of data comparisons       (default: 0.01 = 1% of MAX value)
             -input                 Test input file creation
             -force                 Run even BROKEN tests.

EndOfUsage
}

if ($help==2) {
 print <<EndOfUsage
           
   (Crontab options)
             -cron   <HH:MM>        Add a cron entry @HH:MM (example -cron 01:20). 
                                    Use -cron clean   to crean the CRONTAB
                                    Use -cron install to install the CRONTAB

   (SOURCEs)
             -conf   <NAME>         Use configuration NAME              (default: no options, all: cycle among all confs)
             -gpl                   Only GPL-compliant test.

   (TEST control)
             -mode   <MODE>         Running mode. Can be: bench,validate. Optional.
             -update <TEST>         Update all REFERENCE files of <TEST>. The test path is <TEST_folder>/<TEST>.
             -as_master             Update treating the current branch as it is master
             -upload <TEST>         Upload the <TEST_folder>/<TEST> directory.
             -broken <TEST>         Tag <TEST_folder>/<TEST> as Broken.

   (parallel options)
             -cpu_conf <FILE>       Use the CPU configuration defined in <FILE> 
                                       (refer to ROBOTS/$host/$user/CPU_CONFIGURATION/<FILE>).
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
             -php    <BRANCH>       Translate the latest 20 REPORT files for BRANCH in the ROBOT history in a php format and upload.
	                            If BRANCH is not provided, most recent BRANCH is used. Set BRANCH=all for uplaoding all branches
             -report                UPLOAD the result to the web-page

   (Profiling)
             -profile <string>      Can work in two modes:
                                      *  Add to the profile queue the backup ID (passed by using the -b ID).
                                         <string> can be a pattern to identify the INPUT/PARALLEL_conf 
                                         to add to the PROFILING directory.
                                         A t must be pre-appended to testnames and a c to parallel confs. 
                                         E.g. t03_gw cNmpi64-64.3-bug-fixes.
                                      *  With no options the contents of the profile queue are processed.
   (Internal Setup)
             -edit    <string>      Edit internal files. <string> can be: filters, modules, flags, <flow.pl>, <cpu_conf>

   (Backup)
             -b [ID's]              If running BACKUP the LOGs (automatically used when -report is given)
                                    Otherwise list the BACKUPs available. [ID's can be of the form N or N-M]

   (FTP actions)           
             -ftp                   Log in FTP server

EndOfUsage
}

 print <<EndOfUsage

 * <TESTS> has form: "<SET1> {<input1> [<input2>]|all}; <SET2> {<input1> [<input2>]|all}"
                      where <SET1> is a path within the <TEST_folder> folder 
                      and <input1> <input2>.. is a list of inputs (or all) or a keyword
                      e.g. -tests "Si_bulk/GW/2x2x2 01_init 02_eels ; Al111 01*" 
                           -tests "Si_bulk/GW/2x2x2 01* 02* ; Al111 01*" 

 * keys is string of projects/features:
   
   projects = nopj sc rt elph nl surf hard
   features = bse gw hf rpa spin spinors magnetic kerr pl magnons (more to come)

   Using -keys all all projects/features are used

EndOfUsage
  ;
  exit;
}
1;
