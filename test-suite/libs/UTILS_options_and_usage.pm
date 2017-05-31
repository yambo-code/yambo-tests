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
sub UTILS_options
{
#
# Glob available configurations/flows
#
if (-e "./ROBOTS/$host/$user/CONFIGURATIONS"){
 opendir(DIR,"./ROBOTS/$host/$user/CONFIGURATIONS");
 @files = grep { (!/^\./) && -f "./ROBOTS/$host/$user/CONFIGURATIONS/$_" } readdir(DIR);
 closedir DIR;
}
$conf_avail = join(" ", @files);
if (-e "./ROBOTS/$host/$user/FLOWS"){
 opendir(DIR,"./ROBOTS/$host/$user/FLOWS");
 @files = grep { (!/^\./) && -f "./ROBOTS/$host/$user/FLOWS/$_" } readdir(DIR);
 closedir DIR;
}
$flows_avail = join(" ", @files);
#
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
            "c"              => \$clean,
            "compile"        => \$compile,
            "u"              => \$upload,
            "b"              => \$backup_logs,
            "v+"             => \$verb,
            "conf=s"         => \$select_conf_file,
            "gpl=s"          => \$is_GPL,
            "tests=s"        => \$user_tests,
            "theme=s"        => \$theme,
            "prec=s"         => \$prec,
            "keys=s"         => \$keys,
            "svn"            => \$svn_check,
            "broken=s"       => \$tag_test_as_broken,
            "update=s"       => \$update_test,
            "upload=s"       => \$upload_test,
            "colors"         => \$use_colors,
            "kill"           => \$kill_me,
            "edit=s"         => \$edit,
            "flow=s"         => \$flow,
            "autotest"       => \$autotest,
            "report"         => \$report,
            "force"          => \$force,
            "ftp"            => \$ftp,
            "keep_dbs"       => \$keep_dbs,
            "failed=s"       => \$failed
                      );
#
# Defaults
if(!$is_GPL){ $is_GPL="no";}
#
}
sub UTILS_usage {
 print <<EndOfUsage

   Running on host: $host
   By user        : $user
   Version        : $version
   Available CPU's: $SYSTEM_NP
   Available confs: $conf_avail
   Available flows: $flows_avail
   Syntax: driver.pl <ARGS>
           < > are variable parameters, [ ] are optional, | indicates choice
           
   where <ARGS> must include at least one of:
             -h                     This help & svn status
             -l       [<SET>]       List available SETs (-l) or input files for a SET (-l <SET>)
             -c                     Clean
             -d      <SET>|all|list Download & Update the core databases 
             -compile               Compile the sources
             -tests  <TESTS>|all    List* of tests to perform, or all "-tests all"
             -theme  <THEME>        Use predefined list of tests, defined in THEMES/ directory

   (test options)
             -flow   <FILE>         Use the flow of calculations defined in <FILE> (refer to ROBOTS/$host/$user/FLOWS/<FILE>.pl)
             -autotest              Perform a simple serial minimal auto-test
             -gpl    <yes/no>       Test only GPL features              (default: no)
             -keys   <string>       Test keys (see below*)
             -colors                Use colors in messages
             -conf   <NAME>         Use configuration NAME              (default: no options, all: cycle among all confs)
             -prec   <PREC>         Precision of data comparisons       (default: 0.01 = 1% of MAX value)
             -report                Commit the final report to the ML
             -off                   Switch off specific objects (mpi,openmp,io)
             -force                 Run even BROKEN tests
             -keep_dbs              Keep databases at the end of the tests cycle
             -edit   <WHAT>         View and edit. WHAT=filters,branches,flags,<FILE>(in FLOWS, for example)

   (parallel options)
             -np     <N>            Fixed number of CPU used
             -np_min <N>            Minimum number of CPU used
             -np_max <N>            Maximum number of CPU used
             -nt     <T>            # of OMP threads
             -nl     <L>            # of CPU used for linear algebra
             -def_par               Use the default parallelization scheme
             -rand_par              Use randomly generated parallel structures

   (miscellaneous options)
             -v [-v]                Verbose output (use -v -v for extra verbosity)
             -svn                   List SVN new/untracked files
             -broken <TEST>         Tag tests/<TEST> as Broken 
             -update <TEST>         Update all REFERENCE files of the <TEST>. Format is <TEST/testdir> or <TEST/testdir/test>.
             -upload <TEST>         Upload the tests/<TEST> directory.
             -failed <ERROR>        Create a failed.pl theme reading the ERROR file
             -b                     BACKUP the LOGs (automatically used when -report is given)

   (FTP actions)           
             -u                     UPLOAD the LOGs at the end
             -ftp                   Log in FTP server

 * <TESTS> has form: "<SET1> {<input1> [<input2>]|all}; <SET2> {<input1> [<input2>]|all}"
                      where <SET1> is a path within the tests folder 
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
