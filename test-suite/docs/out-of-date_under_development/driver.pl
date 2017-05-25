#!/usr/bin/perl
#
# Copyright (C) 2010-2016 C. Hogan, A. Marini
#
use Getopt::Long;
use File::Find;
use File::Copy;
use File::Basename;
use Time::HiRes qw(gettimeofday tv_interval);   # Not widely supported
use Cwd 'abs_path';
use Net::Domain qw(hostname hostfqdn hostdomain domainname);
#
@months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
@days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
#
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
#
$year=$year+1900;
#
# Initialize
#
$version=2.3;
$awk=gawk;
$tag="TAG";
$failures=0;
$passes=0;
$not_run=0;
$default_prec=0.01;
#
# Max duration of each run
#
$run_duration = 1200; # 20 minutes
#
&GetOptions("help"           => \$help,
            "path=s"         => \$exe_path,
            "exec=s"         => \$exec,
            "v+"             => \$verb,
            "l"              => \$listtests,
            "a"              => \$add_outputs,
            "n"              => \$dryrun,
            "c"              => \$clean,
            "f"              => \$ftp,
            "e"              => \$veryclean,
            "k"              => \$savefiles,
            "d=s"            => \$download,
            "def_par"        => \$default_parallel,
            "rand_par"       => \$random_parallel,
            "openmp_is_off"  => \$openmp_is_off,
            "x"              => \$extract,
            "b=s"            => \$branch,
            "u=s"            => \$upload,
            "mpi=s"          => \$mpi,
            "np=i"           => \$np,
            "nt=i"           => \$nt,
            "nl=i"           => \$nl,
            "s"              => \$serial,
            "hard"           => \$hard,
            "par_only"       => \$par_only,
            "html"           => \$html,
            "t=s"            => \$tol,
            "prec=s"         => \$default_prec,
            "p=s"            => \$project,
            "par_conf=i"     => \$par_conf,
            "gpl=s"          => \$is_GPL,
            "tests=s"        => \$input_tests);
#
sub usage {

 print <<EndOfUsage

   Syntax: driver.pl [OPTIONS]

         [OPTIONS] are:
                   -h                   This help
                   -path   [DIR]        Path to the yambo source
                   -exec   [EXEC]       Name of executable (default: yambo)
                   -v                   Verbose output
                   -l                   List available tests and stop
                   -a                   Add missing Outputs (usefull to create new test)
                   -n                   Perform dry run
                   -c                   Clean
                   -f                   Login (using ncftp) on the ftp account 
                   -e                   Clean (including ns files)
                   -k                   Keep output files          
                   -d      [TEST]/all   Download & Update the core databases 
                   -par_only            Run ONLY parallel tests
                   -def_par             Use the default parallelization scheme
                   -rand_par            Use randomly generated parallel structures
                   -openmp_is_off       Switch openmp off
                   -x                   Extract the core databases 
                   -b      [BRANCH]     Branch name
                   -u      [DIR]        Upload DIR results or create and upload the tar.gz database
                   -mpi    [MPI]        mpi command (e.g. "mpirun")
                   -np     [N]          # of CPUs
                   -nt     [T]          # of OMP threads
                   -nl     [L]          # of CPUs for linear algebra
                   -s                   Force serial (yambo -M)
                   -hard                Force also hard testes
                   -html                Log 2 HTML and archive of results/reports
                   -t      [PREC]       Tolerance.
                   -prec   [PREC]       Precision (tolerance). Default: 0.01 (1%)
                   -p      [PJ]         Test only this project (e.g. sc, all, none)
                   -par_conf [CONF]     Run only the specific parallel conf.
                   -gpl    [yes/no]     Test only GPL features (default: no)
                   -tests  [TESTS]      List of tests to perform

         [TESTS] has form: "DIR1 [test1 test2 ..]; DIR2 [test1 test2...]"
                            where DIR1 is the directory containing the material-specific tests
                            test1 is the name of the test to perform. 
                             
                            It is possible also to specify all tests in a specific directory
         [TESTS] has form: "DIR1 all ; DIR2 all"
 

EndOfUsage
  ;
  exit;
}
#Defunct:
#                  -t      [TOL]        Tolerance (h)arder/(e)asier/(b)asic
# Check, if STDOUT is a terminal. If not, not ANSI sequences are
# emitted.
if(-t STDOUT) {
     $color_start{blue}="\033[34m";
     $color_end{blue}="\033[0m";
     $color_start{red}="\033[31m";
     $color_end{red}="\033[0m";
     $color_start{green}="\033[32m";
     $color_end{green}="\033[0m";
}
#
#
# PATHS (1)
#
my $cwd=abs_path();
#
# Hostname
#
$host=hostname().".".hostdomain();
if(!hostdomain()){ $host=hostname() };
# Precision
$prec = $default_prec;
#
# date
#
my $date="Date:$days[$wday]-$mday-$months[$mon]-$year Time:$hour-$min";
#
# FTP
#
if ($ftp) {
  $system_command = "ncftp -u 1945528\@aruba.it -p 5fv94ktp ftp.yambo-code.org";
  system ($system_command);
  die "\n";
}
#
# DEFINE input_folder
#
$input_folder= "INPUTS";
if ($is_GPL eq "no" ){ $input_folder = "INPUTS"; }
if ($is_GPL eq "yes"){ $input_folder = "INPUTS-GPL"; }
#
# Files saving & upload
#
if ($upload) {
   my @dirs = ( $upload );
   my @files;
   find( sub { push @files, $File::Find::name if /\$input_folder$/ }, @dirs );
   my $filesSize = @files;
   if ($filesSize>0) 
   {
    my $dir = (split(/\//, $cwd))[-1];
    $system_command = "find . -name 'ns.*' -o -name 'ndb.elph*' | xargs tar cvf $dir.tar";
    system ($system_command);
    $system_command = "gzip $dir.tar";
    system ($system_command);
    $system_command = "ncftpput -u 1945528\@aruba.it -p 5fv94ktp ftp.yambo-code.org www.yambo-code.org/testing-robots/databases $dir.tar.gz";
    system ($system_command);
   }
   else
   {
    $system_command = "ncftpput -u 1945528\@aruba.it -p 5fv94ktp -R ftp.yambo-code.org www.yambo-code.org/testing-robots ROBOTS/$host.php";
    system ($system_command);
    $system_command = "ncftpput -u 1945528\@aruba.it -p 5fv94ktp -R ftp.yambo-code.org www.yambo-code.org/testing-robots $upload/*.html";
    system ($system_command);
    $system_command = "ncftpput -u 1945528\@aruba.it -p 5fv94ktp -R ftp.yambo-code.org www.yambo-code.org/testing-robots $upload/*.tar.gz";
    system ($system_command);
    $system_command = "svn propset dummyproperty '$date' ROBOTS/$host.TIME_ID";
    print $system_command."\n" if ($verb);
    system ($system_command);
    $system_command = "svn commit -F $upload/ERROR-$upload";
    print $system_command."\n" if ($verb);
    system ($system_command);
   };
  die "\n";
}
#
#
# PATHS (2)
#
chdir('tests');
my $cwd=abs_path();
$scripts_dir="$cwd/../scripts/";
#
if ($veryclean) {$clean="yes"};
#
# Databases download
#
if ( $download or $veryclean or $extract){ 
  foreach $dir (<*>) {
    if ($download ne " ") {
     if( ($download ne "all") && ($download ne $dir) ){ next; };
    };
    my @dirs = ( "$dir" );
    my @files;
    find( sub { push @files, $File::Find::name if /\.db1$/ }, @dirs );
    #print "$dir $files[0]\n";
    chdir($dir);
    if ($veryclean) {&clean};
    #if ( ($download && index($files[0],"ns.db1") == -1) or $extract ) {
    if ( ($download or $extract) and !-e "./BROKEN" ) {
      print "\n=> ".$dir." ...";
      $i1=0;
      $filename[$i1] = $dir;
      foreach $subdir (<*>) {
        $i1=$i1+1;
        $filename[$i1] = "${dir}_${subdir}";
      }
      $imax=$i1;
      $i1=0;
      $icheck=0;
      do{
       #print "\n$i1 $filename[$i1]\n";
       if ( $extract){
         if (-e "$filename[$i1].tar.gz") {
          print "[$filename[$i1]]opening ...";
          $system_command = "gunzip $filename[$i1].tar.gz";
          system ($system_command);
          $system_command = "tar xf $filename[$i1].tar";
          system ($system_command);
          print " recompressing ...";
          $system_command = "gzip $filename[$i1].tar";
          system ($system_command);
          print "done";
         }
       }else{
          $system_command = "wget --spider -q http://www.yambo-code.org/testing-robots/databases/$filename[$i1].tar.gz && echo exists || echo not exist";
          my $file_exist = `$system_command`;
          if ( "$file_exist" eq "exists\n") {
            if( $icheck>0 ){ print "\n   ".$dir." ..." };
            print " found $filename[$i1].tar.gz ...";
            $system_command = "rm -f $filename[$i1].tar.gz";
            system ($system_command);
            print " downloading ...";
            $system_command = "wget -qc http://www.yambo-code.org/testing-robots/databases/$filename[$i1].tar.gz";
            system ($system_command);
            print " opening ...";
            $system_command = "gunzip $filename[$i1].tar.gz";
            system ($system_command);
            $system_command = "tar xf $filename[$i1].tar";
            system ($system_command);
            print " recompressing ...";
            $system_command = "gzip $filename[$i1].tar";
            system ($system_command);
            print "done";
            $icheck=$icheck+1;
           }
        } 
       $i1=$i1+1;          
      } until ( $i1 == $imax+1 );
    }
    chdir($cwd);
  }
  print "\n";
}
#
# List available tests (format $RT_tests.. etc) and clean
# Somewhat convoluted perl just to list/clean tests...
#
if($listtests or $clean ) {
  if (! $clean) {print "\nAvailable test materials/systems: \n"};
  DIR_LOOP: foreach $dir (<*>,<*/*>,<*/*/*>,<*/*/*/*>,<*/*/*/*/*>) {      # Glob all files
    # Loop through all files and directories, and save those 'active' dirs containing
    # SAVE and INPUTS folders into @testdirs
    # Then clean up, and/or save $RT_tests strings
    # If directory contains an empty file "RT" or "HARD" etc then log this
    if ( (-d $dir."/SAVE" || -d $dir."/SAVE_backup") && -d $dir."/$input_folder" ) {
      push(@testdirs,$dir);
      if ($clean) {
        chdir($dir) or die("$!, stopped");
        &clean();
        chdir($cwd) or die("$!, stopped");
      }
      $P_str="";
      $HARD_str="";
      if ($hard && !-e $dir."/HARD") {next DIR_LOOP};
      if ($par_only && !-e $dir."/PARALLEL") {next DIR_LOOP};
      #
      if (-e $dir."/HARD") {$HARD_str="[H]"};
      if (-e $dir."/PARALLEL") {$P_str="[P]"};
      if (-e $dir."/RT")   {$RT_tests="$RT_tests"." "."$dir"."$HARD_str"."$P_str"};
      if (-e $dir."/QED")  {$QED_tests="$QED_tests"." "."$dir"."$HARD_str"."$P_str"};
      if (-e $dir."/PL" )  {$PL_tests="$PL_tests"." "."$dir"."$HARD_str"."$P_str"};
      if (-e $dir."/NL" )  {$NL_tests="$NL_tests"." "."$dir"."$HARD_str"."$P_str"};
      if (-e $dir."/SC" )  {$SC_tests="$SC_tests"." "."$dir"."$HARD_str"."$P_str"};
      if (-e $dir."/MAGNETIC" )  {$MAGNETIC_tests="$MAGNETIC_tests"." "."$dir"."$HARD_str"."$P_str"};
      if (-e $dir."/KERR")  {$KERR_tests="$KERR_tests"." "."$dir"."$HARD_str"."$P_str"};
      if (-e $dir."/ELPH")  {$ELPH_tests="$ELPH_tests"." "."$dir"."$HARD_str"."$P_str"};
      if (-e $dir."/BROKEN")  {$BROKEN_tests="$BROKEN_tests"." "."$dir"."$HARD_str"."$P_str"};
      if (!-e $dir."/BROKEN" && !-e $dir."/SC" && !-e $dir."/MAGNETIC" && !-e $dir."/ELPH" && !-e $dir."/RT" && !-e $dir."/KERR" && !-e $dir."/QED" && !-e $dir."/PL" && !-e "/NL") {
       $NORMAL_tests="$NORMAL_tests"." "."$dir"."$HARD_str"."$P_str";
      };
      #
      # Loop through all files inside INPUTS (conf/actions/flags/00_*) -> $SUB_DIR
      # Remove any local copies in the run dir ($dir), otherwise skip (!)
      #
      @testinputs = <$dir/$input_folder/*>;
      LOOP: foreach $test (@testinputs) { 
        if (index($test, ".conf")>0) {next LOOP};
        if (index($test, ".actions")>0) {next LOOP};
        if (index($test, ".flags")>0) {next LOOP};
        $SUB_DIR = substr($test,length($dir)+8,length($test)) ;
        #if (! $clean) {print $SUB_DIR." "};
        if ($clean) {
          chdir($dir) or die("$!, stopped");
          $system_command = "rm -fr $SUB_DIR*";
          print $system_command."\n" if ($verb);
          system ($system_command);
          chdir($cwd) or die("$!, stopped");
        }
      }
    }
  } 
  #
  # Remove any files that don't belong in the repository
  #
  if (  $clean) {
    $system_command = "svn st | grep -v 'ns.' | grep -v 'ndb.elph_gkkp' | grep -v '.gz' | grep -v '.conf' | grep '?' | awk '{print $2}' | xargs rm -fr";
    print $system_command."\n" if ($verb);
    system ($system_command);
  };
}
if ($listtests) {
 &print_the_list_element("[YAMBO] ",$NORMAL_tests);
 &print_the_list_element("[QED]   ",$QED_tests);
 &print_the_list_element("[PL]    ",$PL_tests);
 &print_the_list_element("[NL]    ",$NL_tests);
 &print_the_list_element("[RT]    ",$RT_tests);
 &print_the_list_element("[SC]    ",$SC_tests);
 &print_the_list_element("[MAGNETIC]    ",$MAGNETIC_tests);
 &print_the_list_element("[ELPH]  ",$ELPH_tests);
 if ($KERR_tests) {&print_the_list_element("[KERR]  ",$KERR_tests)};
 if ($BROKEN)     {&print_the_list_element("[BROKEN]",$BROKEN_tests)};
 print "\n";
};
#
# Exit unless running tests
#
if($download) {die "\n"};
if($clean) {die "\n"};
if($listtests) {die "\n"};
if($extract) {die "\n"};
#
if($help or not $input_tests){ usage }
#
# Parse the $input_tests string (--tests " M x y; M x y ")
# Sort into @input_tests_list[] array:
# $input_tests_list[0] = "Al111/GW 00_init 01_init" $dir $testname
# $input_tests_list[1] = "Si_bulk 00_init 01_init"
#
@dummy= split(/\s*;\s*/, $input_tests);  # split 0+ spaces before/after
my @input_tests_list=" ";
my $ic=-1;
foreach $testline (@dummy) {
   $ic++;
   @inputs = split(/\s+/,$testline);  # Split 1 or more spaces
   $dir = shift(@inputs);             # Directory Al111
   $input_tests_list[$ic]=$dir;
   if($#inputs lt 0) { @inputs = qw("all")};   # If explicit tests omitted, set all of them
   foreach $testname (@inputs) {
     if ($testname =~ "all") {
       if (!-d "$dir/$input_folder") {
         $local_path=`pwd`;
         chomp $local_path;
         $cmd = "mkdir $dir/$input_folder";
         system($cmd);
         $cmd = "ln -s $local_path/$dir/INPUTS/* $local_path/$dir/$input_folder/";
         system($cmd);
       }
       LOOP: foreach $test ( <$dir/$input_folder/*> ) { 
         if (index($test, ".conf")>0) {next LOOP};
         if (index($test, ".actions")>0) {next LOOP};
         if (index($test, ".flags")>0) {next LOOP};
         $n=8; if($is_GPL eq "yes"){ $n=12 };
         $testname = substr($test,length($dir)+$n,length($test)) ;
         $input_tests_list[$ic]="$input_tests_list[$ic] $testname";
       }
     }  
     else {  
        $input_tests_list[$ic]="$input_tests_list[$ic] $testname";
     }  
   }
}
#
# FILES
#
$is_OLD_IO="no";
if ($branch=~m/4.1/ix) {$is_OLD_IO="yes"};
$is_NEW_WF="no";
if ($branch=~m/devel-wf-io/ix) {$is_NEW_WF="yes"};
#
$local_b=$branch;
$local_b =~ s/_/ /;
my @locals = split(' ', $local_b);
$local_b=@locals[1];
$local_b =~ s|[^-]+$||;
$local_b =~ s/-$//;
#
# Open log files: here $branch is passed from run_me.pl
# ELOG:		Error 
# TLOG:		Standard log
# TSLOG:	Compact log
#
my $tests_error = '../ERROR-'.$branch.'-'.$host.'.log';
my $tests_log = '../LOG-'.$branch.'-'.$host.'.log';
my $tests_compact_log = '../COMPACT-'.$branch.'-'.$host.'.log';
open(elog, '>>', $tests_error) or die "Could not open file '$tests_error' $!";
open(tlog, '>>', $tests_log) or die "Could not open file '$tests_log' $!";
open(tslog, '>>', $tests_compact_log) or die "Could not open file '$tests_compact_log' $!";
#
# Summary of requested options
#
#   print tslog "$color_start{blue} ***** $testdir-$branch ***** $color_end{blue}\n";
print tlog "\n=---------------------------------------------------------------=\n";
print tlog   "=                  Yambo test suite log                         =\n";
print tlog   "=---------------------------------------------------------------=\n";
print elog "\n=---------------------------------------------------------------=\n";
print elog   "=              Yambo test suite ERROR(s) log                    =\n";
print elog   "=---------------------------------------------------------------=\n";
#
# date
#
for my $fh (tlog, elog) { 
print $fh "$date \n\n";
if ($verb eq 1 ) {
print $fh "Running tests : ".join("\n                ",@input_tests_list)."\n" ;
}else{
print $fh "Running tests : ".$input_tests."\n" ;
};
$verbosity_level = "low";
$verbosity_level = "high" if ($verb eq 1);
$verbosity_level = "highest" if ($verb ge 2);
print $fh "Verbosity     : $verbosity_level \n";
print $fh "Precision     : $prec \n";
#
# Define floating point tolerances
# $UP_lim_on_diff =  ...
#
#if(! $tol) { 
#  $default_tolerance = "";
#  $UP_lim_on_diff= "1e-4";
#  print tlog "Tolerance     : default (4 sf) \n";
#}
#elsif($tol eq "b") {
#  $default_tolerance = "-ridiculous";
#  print tlog "Tolerance     : basic (2 sf) \n";
#  $UP_lim_on_diff= "1e-3";
#}
#elsif($tol eq "e") {
#  $default_tolerance = "-easy";
#  print tlog "Tolerance     : easier (3 sf)\n";
#  $UP_lim_on_diff= "1e-4";
#}
#elsif($tol eq "h") {
#  $default_tolerance = "-medium";
#  print tlog "Tolerance     : harder (5 sf) \n";
#  $UP_lim_on_diff= "1e-5";
#}
#else {
#  $default_tolerance = "";
#  $UP_lim_on_diff= "1e-4";
#  print tlog "Tolerance     : default (4 sf) \n";
#}
#print tlog "Max DIFF      : $UP_lim_on_diff \n";
#
# EXE
#
if($exec) {
  print $fh "EXEC          : $exec \n";
  $yambo_exec = $exec;
}
print $fh "Hostname      : $host \n";
#
# PARALLEL stuff
#
if($serial) {$force_serial = "-M"};
$mpiexec = "mpirun"; 
if($mpi) { 
  $mpiexec = $mpi; 
  print $fh "MPI           : $mpiexec \n";
}
$N=1;
if($np) { 
  $N = $np; 
  print $fh "CPUs          : $N \n";
}
$N_t=1;
if($nt) { 
  $N_t = $nt; 
  print $fh "Threads       : $N_t \n";
}
$N_l=1;
if($nl) {
  $N_l = $nl;
  print $fh "Lin. Algebra  : $N_l \n";
}
# If serial only need once
if($serial or $N eq 1){
  print $fh "Configuration is SERIAL throughout\n";
}
print $fh   "=---------------------------------=\n\n";
}
#
# Loop over test directories
#
$numtests = @input_tests_list; # Number of elements
$count_tests=0;
LOOP_DIRS: foreach $testline (@input_tests_list) {
   #
   $dir_failures=0;
   $first_time_in_the_dir="yes";
   $dir_passes=0;
   $count_tests++;
   @inputs = split(/\s+/,$testline);
   $testdir = shift(@inputs); 
   #
   for my $fh (tlog, tslog) { 
   print $fh "$color_start{blue} ***** $testdir-$branch ***** $color_end{blue}\n";
   }
   printf(" > $color_start{blue} [%-3s/%-3s] %-40s $color_end{blue} ",$count_tests,$numtests,$testdir);
   chdir($testdir) or die("$!, stopped changing dir to $testdir");
   #
   # clean up old shit
   #
   unless($savefiles) {&clean()};
   #
   if(-e "HARD" and !$hard) {
       print " skipping (H)\n"; 
       chdir($cwd) or die("$!, stopped changing to dir $cwd");
       next LOOP_DIRS;
   }
   #
   # Check if I need to convert the folder
   #
   if($is_NEW_WF eq "yes") {
     print "\nConverting SAVE folder to new format";
     if(-e "SAVE_backup") {
       $command_line = "cp -r SAVE_backup SAVE";
       $return_value = system("$command_line");
     }
     # initialization
     $command_line = "$exe_path/yambo";
     $return_value = system("$command_line");
     # conversions
     $command_line = "$exe_path/ypp -z"; 
     $return_value = system("$command_line");
     if(-e "SAVE_backup") {
       $command_line = "mv SAVE_backup SAVE_backup_old";
       $return_value = system("$command_line");
       $command_line = "mv FixSAVE/SAVE SAVE_backup";
       $return_value = system("$command_line");
     }
     else {
       $command_line = "mv SAVE SAVE_old";
       $return_value = system("$command_line");
       $command_line = "mv FixSAVE/SAVE SAVE";
       $return_value = system("$command_line");
     }
     
   }
   #
   # Loop over each test file
   #
   LOOP_INPUTS: foreach $testname (@inputs) {
     print "\nRunning input: $testname\n" if ($verb);
     #
     $testname_err_report=" ";
     #
     # Runlevels
     #
     $skip_dir="no";
     &get_runlevels("$input_folder/$testname");
     if($skip_dir =~ m/yes/) {
       chdir($cwd);
       if($skip_dir =~ m/1/) {print " skipping (P)"}; # wrong project
       if($skip_dir =~ m/2/) {print " skipping (N)"}; # no projects
       if($skip_dir =~ m/3/) {print " skipping (G)"}; # not GPL
       if($skip_dir =~ m/4/) {print " (broken)"};
       if($skip_dir =~ m/5/) {print " skipping (Too many CPU's)"}; # not GPL
       if($skip_dir =~ m/6/) {print " missing exec"}; # not GPL
#      print " $color_start{red} skipping $color_end{red}\n";
       print "\n";
       next LOOP_DIRS;
     }
     #
     # Overwrite specific options from .conf for this input file
     #
     $prec = $default_prec;
     if( -e "$input_folder/$testname.conf") {
       open(CONF,"<","$input_folder/$testname.conf");
       while($confline = <CONF>) {
         chomp $confline;
         ($desc, $value) = split(/\s+/,$confline);
         # Test precision
         if($desc =~ m/precision/) { 
            print tlog "** Changing precision for $testname to: $value \n";
            $prec = $value;
         }
       }
     #&set_tolerance;
     }
     #
     # Do actions (if any)
     #
     &do_user_actions;
     #
     # If the input is created on-the-fly check again for runlevels
     #
     if (-f "BASE_input") {&get_runlevels("BASE_input")};
     #
     # Prepare the input file
     #
     $Nr=0;
     #
     &RUN_specs;
     #
     # Do the actual run!
     #
     LOOP: for (my $ir=1; $ir<=$Nr ; $ir++){
       #
       # Check if extra flags are needed (JOB specific)
       #
       &add_user_flags($ir);
       #
       $string=$RUN_spec[$ir];
       #
       if($N gt 1){ print tlog ">> Configuration is $string($ir)\n"};
       print tslog "[$string($ir)(N=$Ncpu)(Nt=$nt)][(Nl=$nl)]$testname($ir)";
       #
       #$command_line = "rm -f $testname";
       #$return_value = system("$command_line");
       $dir_name=$testname;
       if(!$default_parallel && $np>1){$dir_name="${testname}_N${np}-M${nt}-${ir}";};
       #
       # Tests with Covariant dipoles are broken
       if ($testname =~ m/Covariant/ && $np>1) {
         print tslog " Covariant test not working in parallel (SKIP)\n";
         next LOOP;
       };
       #
       @specs = split(/\s+/,$string);
       #
       $command_line = "cat $cpu $input_folder/$testname > yambo.in";
       $return_value = system("$command_line");
       if( -e "BASE_input") { 
         $command_line = "cat BASE_input >> yambo.in";
         $return_value = system("$command_line");
       }
       if( -e "$cwd/../FLAGS/LIST.$host") { 
         $command_line = "cat  $cwd/../FLAGS/LIST.$host >> yambo.in";
         $return_value = system("$command_line");
       }
       #
       open IN, ">>", "yambo.in" or die "Couldn't open file: $!\n";
       foreach $field (@PAR_field)  {print IN "$field \n"};
       foreach $spec (@specs)  {print IN "$spec \n"};
       close IN;
       #
       $fail="no"; 
       &run_it;    # Run the job
       #
       # Parse input file to find standard runlevels and consequent actions to take
       #
       if ($fail=~"no") {&get_actions_from_input_file};
       if ($fail=~"yes"){print tslog "($color_start{red} FAIL $color_end{red})\n"};
       if ($fail=~"no") {print tslog "($color_start{green} OK $color_end{green})\n"};
       #
       # Collect all the outputs into $dir_name (e.g. ./01_init_N1-M1)
       #
       if(-d "$testname" && $np>1){
        $command_line = "mv $testname $dir_name-DBs";
        $return_value = system("$command_line");
        if($ir==$Nr && !$default_parallel){
         $command_line = "ln -s $dir_name-DBs $testname";
         $return_value = system("$command_line");
        }
       }
       #
       if (!-d "$dir_name") {mkdir($dir_name) or &print_error_msg("Error creating directory $!");};
       copy("yambo.in", $dir_name) or &print_error_msg("Error copying file $!");
       foreach $file (<o-*$testname*>) 			{ move($file,$dir_name) };
       foreach $file (<r-*$testname*>,<ref_*>,<run_*>) 	{ move($file,$dir_name) };
       foreach $file (<l-*$testname*>) 			{ move($file,$dir_name) };
       foreach $file (<LOG/l*$testname*>)		{ move($file,$dir_name) };
       if( -e "l_stderr")   { move("l_stderr","$dir_name/l-${testname}_stderr") };
       #
       if($np>1 && -d "$dir_name-DBs" && $default_parallel){
        chdir($testname);
        $command_line = "ln -s ../$dir_name-DBs/ndb* .";
        $return_value = system("$command_line");
        chdir("../");
       }
       #
     }
     #
   }# End loop on input files
   # 
   # Restore SAVE/SAVE_backup to old format
   #
   if(-e "SAVE_backup_old") {
     $command_line = "rm -r SAVE_backup";
     $return_value = system("$command_line");
     $command_line = "mv SAVE_backup_old SAVE_backup";
     $return_value = system("$command_line");
   }
   elsif (-e "SAVE_old") {
     $command_line = "rm -r SAVE";
     $return_value = system("$command_line");
     $command_line = "mv SAVE_old SAVE";
     $return_value = system("$command_line");
   }
   unless($savefiles) { 
     &clean();
     foreach $testname (@inputs) {
       $system_command = "rm -fr $testname";
#      print tlog $system_command."\n" if ($verb);
       system ($system_command);
     }
   }
   chdir($cwd);
   print "$color_start{green} $dir_passes passes $color_end{green}";
   if($dir_failures gt 0) {print "$color_start{red} $dir_failures failures $color_end{red}"};
   print "\n";
}
# Report total passes/failures
print tlog "$color_start{blue} ***** Tests completed ***** $color_end{blue}\n";
#print elog "***** Tests completed *****\n";
for my $fh (tlog, elog) { 
print $fh "Tests failed      : $failures\n";
print $fh "Tests passed      : $passes\n";
print $fh "Tests interrupted : $not_run\n";
}
# 
# Files closing
#
close elog;
close tlog;
close tslog;
#
chdir($cwd."/../"); # Return to /test-suite
#
##########################################################
# Subroutines follow here...
##########################################################
#
# (1) Identifies the correct executable for a particular runlevel in the input file
# (2) Sets the $description flag
#
sub get_runlevels
{
 $fixsyms="0";
 $NEGF="0";
 $SETUP="0";
 $HF="0";
 $OPTICS="0";
 $SC="0";
 $MAGNETIC="0";
 $CHI="0";
 $PPA="0";
 $COHSEX="0";
 $GW="0";
 $EM1D="0";
 $CHI="0";
 $GW="0";
 $BSE="0";
 $EM1S="0";
 $EM1D="0";
 $io_COLL="1";
 $COLL="0";
 $PPA="0";
 $COHSEX="0";
 $EP="0";
 $EPHOT="0";
 $EE_scatt="0";
 $LIFE="0";
 $YPP="0";
 $YPP_RT="0";
 $YPP_PH="0";
 $YPP_NL="0";
 $RUNLEVEL_file=$_[0];
 open(INPUT_file,"<","$RUNLEVEL_file");
 @input_file = <INPUT_file>;
 while ($field = shift(@input_file)) {
   @field= split(/\s+/, $field);
   $runlevel = shift(@field);
   if ($runlevel=~"fixsyms"){$fixsyms="1"};
   if ($runlevel=~"negf"){$NEGF="1"};
   if ($runlevel=~"setup"){$SETUP="1"};
   if ($runlevel=~"HF_and_locXC"){$HF="1"};
   if ($runlevel=~"optics"){$OPTICS="1"};
   if ($runlevel=~"scpot"){$SC="1"};
   if ($runlevel=~"magnetic"){$SC="0"; $MAGNETIC="1";};
   if ($runlevel=~"chi"){$CHI="1"};
   if ($runlevel=~"gw"){ $GW="1"};
   if ($runlevel=~"bse"){ $BSE="1"};
   if ($runlevel=~"em1s"){ $EM1S="1"};
   if ($runlevel=~"em1d"){ $EM1D="1"};
   if ($runlevel=~"DBsIOoff=\"COLLs\""){ $io_COLL="0"};
   if ($runlevel=~"collisions"){ $COLL="1"};
   if ($runlevel=~"ppa"){ $PPA="1"};
   if ($runlevel=~"cohsex"){ $COHSEX="1"};
   if ($runlevel=~"el_ph_corr"){ $EP="1"};
   if ($runlevel=~"el_photon_corr"){ $EPHOT="1"};
   if ($runlevel=~"el_el_scatt"){ $EE_scatt="1"};
   if ($runlevel=~"life" && ! $runlevel=~RTlifetimes){ $LIFE="1"};
   if ($runlevel=~"scpot"){ $SCPOT="1"};
   if ($runlevel=~"magnetic"){ $SCPOT="0"; $MAGNETIC="1"};
   if ($runlevel=~"Shifted_Grid"){ $YPP="1"};
   if ($runlevel=~"WFs_map"){ $YPP="1"};
   if ($runlevel=~"density"){ $YPP="1"};
   if ($runlevel=~"bzgrids"){ $YPP="1"};
   if ($runlevel=~"kpts_map"){ $YPP="1"};
   if ($runlevel=~"wavefunction"){ $YPP="1"};
   if ($runlevel=~"exciton"){ $YPP="1"};
   if ($runlevel=~"sort"){ $YPP="2"};
   if ($runlevel=~"gkkp"){ $YPP_PH="1"};
   if ($runlevel=~"eliashberg"){ $YPP_PH="1"};
   if ($runlevel=~"RealTime"){ $YPP_RT="1"};
   if ($runlevel=~"fixsyms"){ $YPP="1"};
   if ($runlevel=~"QPDBs"){ $YPP_RT="1"};
   if ($runlevel=~"RTDBs"){ $YPP_RT="1"};
   if ($runlevel=~"nonlinear"){ $YPP_NL="1"};

 #
 }
 close(INPUT_file);
 if ($fixsyms=="1") { $description="Symmetries Compatibility Operations" };
 if ($SETUP=="1") { $description="Initialization" };
 if ($LIFE=="1") { $description="GW Lifetimes"};
 if ($COHSEX=="1") { $description="COHSEX" };
 if ($PPA=="1") { $description="PPA" };
 if ($GW && $EM1D=="1") { $description="GW (real-axis)" };
 if ($GW && $EP=="1") { $description="GW (e-p)" };
 if ($GW && $EPHOT=="1") { $description="GW (e-photon)" };
 if ($COHSEX=="0" && $PPA=="0" && $GW=="0" && $HF=="1") { $description="Hartree-Fock" } ;
 if ($EM1S=="1" ) { $description="Static Screened Interaction"};
 if ($OPTICS=="1" && $CHI=="1" ) { $description="Optics (G-space)"};
 if ($OPTICS=="1" && $BSE=="1" ) { $description="Optics (T-space)"};
 if ($COLL=="1") { $description="Collisions" };
 if ($NEGF=="1") { $description="Real-Time" };
 if ($SCPOT=="1") { $description="Self-consistent" };
 if ($MAGNETIC=="1") { $description="Magnetic" };
 #
 # EXE section
 #
 $ncdump_exec="$exe_path/ncdump";
 if (!-x $ncdump_exec) {
   $ncdump_exec="ncdump";
 }
 $nccopy_exec="$exe_path/nccopy";
 if (!-x $nccopy_exec) {
   $nccopy_exec="nccopy";
 }
 if ($exec) {
   $yambo_exec = $exec;
 }
 else {
   $yambo_exec = "none";

#  if ($project) {
#    if (!-e "QED" && $project eq "qed") {die};
#    if (!-e "RT" && $project eq "rt") {die};
#    if (!-e "ELPH" && $project eq "elph") {die};
#    if (!-e "SC" && $project eq "sc") {die};
#    if (!-e "MAGNETIC" && $project eq "magnetic") {die};
#    if (!-e "KERR" && $project eq "kerr") {die};
#    if ((-e "KERR" or -e "RT" or -e "ELPH" or -e "SC" or -e "MAGNETIC" or -e "QED") && $project eq "none") {die};
#  }
#  if ($is_GPL eq "yes") {
#    if ((-e "KERR" or -e "RT" or -e "SC" or -e "MAGNETIC" or -e "QED") ) {die};
#  }
# if (-e "BROKEN") {die;}

   if ($project eq "none" ) {
     if ((-e "KERR" or -e "RT" or -e "ELPH" or -e "SC" or -e "MAGNETIC" or -e "QED" or -e "PL" or -e "NL" ) && $project eq "none") {$skip_dir="yes2"};
   } elsif ($project ne "all") {
     if (!-e "PL" && $project eq "pl") {$skip_dir="yes1"};
     if (!-e "NL" && $project eq "nl") {$skip_dir="yes1"};
     if (!-e "QED" && $project eq "qed") {$skip_dir="yes1"};
     if (!-e "RT" && $project eq "rt") {$skip_dir="yes1"};
     if (!-e "ELPH" && $project eq "elph") {$skip_dir="yes1"};
     if (!-e "SC" && $project eq "sc") {$skip_dir="yes1"};
     if (!-e "MAGNETIC" && $project eq "magnetic") {$skip_dir="yes1"};
     if (!-e "KERR" && $project eq "kerr") {$skip_dir="yes1"};
     if (!-e "PARALLEL" && $par_only) {$skip_dir="yes1"};
   }
   if ($is_GPL eq "yes") {
     if ((-e "RT" or -e "SC" or -e "MAGNETIC" or -e "QED" or -e "PL" or -e "NL") ) {$skip_dir="yes3"};
   }
   if (-e "BROKEN") {$skip_dir="yes4"};
   if (-e "PARALLEL_2" && $N>2 ) {$skip_dir="yes5"};
   if (-e "PARALLEL_4" && $N>4 ) {$skip_dir="yes5"};
   if (-e "PARALLEL_8" && $N>8 ) {$skip_dir="yes5"};

  $yambo_exec = "$exe_path/yambo";
  if ($YPP=="1") {$yambo_exec = "$exe_path/ypp"};
  if ($YPP=="2") {$yambo_exec = "$exe_path/ypp -e s"};
  if (-e "RT") {
   $yambo_exec = "$exe_path/yambo_rt";
   if ($YPP_RT=="1" or $YPP=="1") {$yambo_exec = "$exe_path/ypp_rt"};
  }
  if (-e "QED" && !$YPP=="1") {
   $yambo_exec = "$exe_path/yambo_qed";
  }
  if (-e "PL") {
   $yambo_exec = "$exe_path/yambo_pl";
   if ($YPP_RT=="1" or $YPP=="1") {$yambo_exec = "$exe_path/ypp_rt"};
  }
  if (-e "NL") {
   $yambo_exec = "$exe_path/yambo_nl";
   if ($YPP_NL=="1" or $YPP=="1") {$yambo_exec = "$exe_path/ypp_nl"};
  }
  if (-e "ELPH") {
   $yambo_exec = "$exe_path/yambo_ph";
   if ($YPP_PH=="1" or $YPP=="1") {$yambo_exec = "$exe_path/ypp_ph"};
  }
  if (-e "SC") {
    $yambo_exec = "$exe_path/yambo_sc";
   if ($YPP_SC=="1" or $YPP=="1") {$yambo_exec = "$exe_path/ypp_sc"};
  }
  if (-e "MAGNETIC") {
    $yambo_exec = "$exe_path/yambo_magnetic";
   if ($YPP_MAGNETIC=="1" or $YPP=="1") {$yambo_exec = "$exe_path/ypp_magnetic"};
  }
  if (-e "KERR"  && !$YPP=="1") {
    $yambo_exec = "$exe_path/yambo_kerr";
  }
  #
  if(! -x "$yambo_exec"){$skip_dir="yes6"};
  if ($openmp_is_off) {$yambo_exec="$yambo_exec -N";}
  if ($is_STABLE eq "yes") {$yambo_exec="$yambo_exec -S";}
  #
 };
}
 
#############################
sub get_actions_from_input_file
{
 if ($SETUP=="1"){
   $action = "exist";
   $file = "ndb.kindx";
   print "Testing $file $action\n" if ($verb);
   &exist_action( );
   $file = "ndb.gops";
   print "Testing $file $action\n" if ($verb);
   &exist_action( );
 }
 if ( -e "$testname/ndb.HF_and_locXC" ){
   $action = "dbcomp";
   $file = "ndb.HF_and_locXC";
   print "Testing $file $action\n" if ($verb);
   if ( $is_OLD_IO eq "yes"  ) { $VAR = "Sx_Vxc"; };
   if ( $is_OLD_IO eq "no" ) { $VAR = "Sx,Vxc"; };
   &comp_action( );
 }
 if ( -e "$testname/ndb.Double_Grid" ){
   $action = "dbcomp";
   $file = "ndb.Double_Grid";
   print "Testing $file $action\n" if ($verb);
   $VAR = "BLOCK_TABLE";
   &comp_action( );
 }
 if ( -e "$testname/ndb.em1s_fragment_1" ){
   $action = "dbcomp";
   $file = "ndb.em1s_fragment_1";
   print "Testing $file $action\n" if ($verb);
   $VAR = "X_Q_1";
   &comp_action( );
 }
 if ( -e "$testname/ndb.COLLISIONS_HXC_fragment_2" ){
   $action = "dbcomp";
   $file = "ndb.COLLISIONS_HXC_fragment_2";
   print "Testing $file $action\n" if ($verb);
   $VAR = "COLLISIONS_v";
   &comp_action( );
 }
 if ( -e "$testname/ndb.COLLISIONS_COH_fragment_2" ){
   $action = "dbcomp";
   $file = "ndb.COLLISIONS_COH_fragment_2";
   print "Testing $file $action\n" if ($verb);
   $VAR = "COLLISIONS_v";
   &comp_action( );
 }
 if ( -e "$testname/ndb.COLLISIONS_GW_NEQ_fragment_2" ){
   $action = "dbcomp";
   $file = "ndb.COLLISIONS_GW_NEQ_fragment_2";
   print "Testing $file $action\n" if ($verb);
   $VAR = "COLLISIONS_v";
   &comp_action( );
 }
 if ( -e "$testname/ndb.COLLISIONS_P_fragment_2" ){
   $action = "dbcomp";
   $file = "ndb.COLLISIONS_P_fragment_2";
   print "Testing $file $action\n" if ($verb);
   $VAR = "COLLISIONS_v";
   &comp_action( );
 }
 if ( -e "$testname/ndb.E_SOC_map" ){
   $action = "dbcomp";
   $file = "ndb.E_SOC_map";
   print "Testing $file $action\n" if ($verb);
   $VAR = "BLOCK_TABLE";
   &comp_action( );
 }
 $action = "ocomp";
 #
 O_file_loop: foreach $file (<o-$testname.*>){
   #
   $missing_file="no";
   &gimme_reference($file);
   if (!-e "$ref_filename") { 
     #&print_error_msg("OUTPUT $file not found among the REFERENCEs");
     $failures++;
     $dir_failures++;
     $missing_file="yes";
     if ($add_outputs) { 
      copy($file, "REFERENCE");
      $actions_cmd="svn add REFERENCE/$file";
      $return_value = system("$actions_cmd");
     };
   };
 }
 if ( -d "REFERENCE_$local_b" and -f "REFERENCE_$local_b/$testname" ) 
 {
  @OFILES = (<REFERENCE_$local_b/o-$testname.*>)
 }else{
  @OFILES = (<REFERENCE/o-$testname.*>, <REFERENCE_$local_b/o-$testname.*>)
 }
 print "@OFILES\n" if ($verb);
 O_file_loop: foreach $file (@OFILES){
   $file =~ s{.*/}{};
   ($base, $dir, $ext) = fileparse($file, qr/\.[^.]*/);
   #
   if ( $ext=~ /hf/  and $is_STABLE=~"yes" ) { next O_file_loop};
   #
   $missing_file="no";
   if (!-e "$file") { 
     &print_error_msg("REFERENCE $file not found as output");
     if ($add_outputs) { 
      $actions_cmd="rm -f REFERENCE/$file";
      $return_value = system("$actions_cmd");
      $actions_cmd="svn del REFERENCE/$file";
      $return_value = system("$actions_cmd");
     };
     $failures++;
     $dir_failures++;
     $missing_file="yes";
   }
   #
   # Skip specific files
   #
   $comp_it="yes";
   if ( $missing_file=~"yes" ){ $fail = "yes"};
   if ( $missing_file=~"yes" ){ $comp_it = "no"};
   if ( $file=~ /alpha/ ) { $comp_it = "no"};
   if ( $file=~ /exc_I_sorted/ ) { $comp_it = "no"};
   if ( $ext=~ /hf/ and $is_STABLE=~"yes" ) { next O_file_loop};
   if ( $file=~ /o-03_QP_PPA_terminator.qp/ and $is_STABLE=~"yes" ) { $comp_it = "no"};
   if ( $comp_it=~"yes" ) {&comp_action( )};
 };
};

#############################
sub add_user_flags
{
 my ($ir) = @_;
 $flags = "";
 if( -e "$input_folder/$testname.flags") {
   print "$input_folder/$testname.flags\n" if ($verb);
   open(FLAGS,"<","$input_folder/$testname.flags");
   @flags_file = <FLAGS>;
   while($extra_flag = shift(@flags_file)) {
     $extra_flag =~ s/^\s+|\s+$//g ;
     chomp $extra_flag;  
     #
     $extra_flag_check = "${extra_flag}_N${np}-M${nt}-${ir}-DBs";
     if( -d "$extra_flag_check") {
      $flags = $flags.",$extra_flag_check" ;
      next ;
     };
     #
     $extra_flag_check = "${extra_flag}_N${np}-M${nt}-1-DBs";
     if( -d "$extra_flag_check") {
      $flags = $flags.",$extra_flag_check" ;
      next ;
     };
     #
     $extra_flag_check = "$extra_flag-DBs";
     if( -d "$extra_flag_check") {
      $flags = $flags.",$extra_flag_check" ;
      next ;
     };
     #
     $extra_flag_check = $extra_flag;
     if( -d "$extra_flag_check") {
      $flags = $flags.",$extra_flag_check" ;
      next ;
     };
   }
  close(FLAGS);
 }
 print "FLAGS: $flags\n" if ($verb);
 $flags = '"' . "$testname$flags" . '"';
}
 
#############################
# Actions files must direct STDERR to /dev/null
# A cleaner way would be to parse mkdir, cp etc into perl commands.
sub do_user_actions
{
 if( -e "$input_folder/$testname.actions") {
   open(ACTIONS,"<","$input_folder/$testname.actions");
   print "$input_folder/$testname.actions \n" if ($verb);
   @actions_file = <ACTIONS>;
   while($actions_cmd = shift(@actions_file)) {
#    $return_value = system("$actions_cmd");
     $return_value = `$actions_cmd 2>> /dev/null`;
     print "$actions_cmd \n" if ($verb);
   }
  close(ACTIONS);
 }
}
 
#############################
sub set_tolerance
{
 $tolerance = $default_tolerance;
 $field = shift(@conf_file);
 @field_list = split(/ /, $field);
 if ($field_list[1]=~"toler"){
   $conf_tolerance = substr($field,6);
   chomp($conf_tolerance);
   if($conf_tolerance eq "basic") {
      $tolerance = "-ridiculous";
   }
   elsif($conf_tolerance eq "easier") {
      $tolerance = "-easy";
   }
   elsif($conf_tolerance eq "harder") {
      $tolerance = "-medium";
   }
 }
}

#############################
#
# Run the yambo job
#
sub run_it
{
  # Report the input file
  if($verb ge 2) { 
    open(INFILE,"<","yambo.in");
    print "\n yambo.in:\n";
    print "--------------------\n";
    while(<INFILE>) { print $_ };
    print "--------------------\n";
  }
  # $command_line = "cat yambo.in";
  # $return_value = system("$command_line") if ($verb ge 2);  # Show input file only at max verbosity
  # yambo output log is directed to /dev/null unless verbosity highest
  $log = "> /dev/null 2>&1";
  if ($verb ge 2) { $log = "" };
  if ($Ncpu==1) {
    $command_line = "$yambo_exec -F yambo.in -J $flags $force_serial $log";
   }
  if ($Ncpu>1) {
    $command_line = "$mpiexec -np $Ncpu $yambo_exec -F yambo.in -J $flags $force_serial $log";
   }
 print "$command_line\n"  if ($verb); 
 printf tlog ">> %-25s %-54s ... ",$testname,$description;
 if($dryrun) {next}; 
 $test_start = [gettimeofday];
 if ($verb ge 2) { print "--------------------\n"};
 eval { 
     local $SIG{ALRM} = sub { die "alarm\n" };
     alarm $run_duration;                  # schedule alarm 
     $return_value = system("$command_line");   # launch the yambo job
     alarm 0;                   # cancel the alarm
 };
 if ($verb ge 2) { print "--------------------\n"};
 if ($@) {
   die unless $@ eq "alarm\n"; # propagate unexpected errors
 }
 $test_end   = [gettimeofday]; 
 $elapsed = tv_interval($test_start, $test_end);
 $wrong_cpu_conf = "no";
 if($return_value == 0) {
   if ($elapsed > $run_duration) 
   {
    print tlog "FAILED (Runtime above $run_duration secs.)\n";
    &print_error_msg("FAILED (Runtime above $run_duration secs.)");
    #print elog "$testdir-$branch/$dir_name/$run_filename\t FAILED (Runtime above $run_duration secs.)\n";
    $fail="yes";
    $failures++;
    $dir_failures++;
   }
   else
   {
    printf tlog "%8.1f s\n", $elapsed;
   }
 } 
 else 
 {
   foreach $file (<LOG/l-*>) {
    open $fh, $file or die;
    while (my $line = <$fh>) {
        if ($line =~ /Empty workload/ ||  $line =~ /n_t_CPU > n_blocks/) { 
          if ($verb) {
            &print_error_msg("WRONG CPU configuration (empty workload for some CPU's)");
            $fail = "yes";
            $failures++;
            $dir_failures++;
          }
        }
     }
   };
   print tlog "FAILED (exit code $return_value)\n";
 }
 if ($Ncpu>1) {$dumb = system("sleep 3s")};
 $dumb = system("pkill yambo") ;
 $dumb = system("pkill ypp") ;
 if ($Ncpu>1) {$dumb = system("sleep 3s")};
}

#########################
sub exist_action
{
 printf tlog "%-10s %-65s","exist",$file;
 if(-e "SAVE/".$file or -e $testname."/".$file) { 
   print tlog "\t [ FOUND  ] \n"; 
   $passes++;
   $dir_passes++;
   $test_succeeded = 1;
 } 
 else  
 {
   &print_error_msg("$run_filname [RUN] not FOUND");
   #print elog "$testdir-$branch/$dir_name/$run_filename:\t $file not FOUND\n" if ($elapsed < $run_duration); 
   $test_succeeded = 0;
   $failures++;
   $dir_failures++;
 }
}
 
#########################
sub comp_action
{
 #
 # Floating point test between o.* plottable files
 #
 $run_filename = $file;
 #
 #print elog "**** Test: $testname \n";
 #print elog "****     > $action $run_filename \n";
 #
 if($action =~ /dbcomp/)
 {
   $DB = $file;
   $run_filename = "o-$testname.$run_filename";
   &gimme_reference($run_filename);
   #$ref_filename = "REFERENCE/".$run_filename; 
   if(! -e "$ref_filename" ) {
     #$ref_filename = "REFERENCE/".$testname."/".$run_filename; 
     &print_error_msg("OUTPUT $run_filename not FOUND in *ANY* REFERENCE");
     #print elog "$testdir-$branch/$dir_name/$run_filename:\t $ref_filename not FOUND\n" if ($elapsed < $run_duration); 
     if ($fail=~"no") {$fail="yes"};
   }
   if(-e "$testname/$DB") {
     if( $is_OLD_IO eq "yes" ) { 
       $DB_tmp="${DB}_tmp";
       $system_command = "mv $testname/$DB $testname/$DB_tmp"; 
       system($system_command);
       $system_command = "$nccopy_exec -d0 $testname/$DB_tmp $testname/$DB"; 
       system($system_command);
     };
     $system_command = "$ncdump_exec -v $VAR $testname/$DB | $awk -f $scripts_dir/ndb2o.awk | head -n 10000 > $run_filename" ;
     print "$system_command \n" if ($verb);
     system($system_command);
     if( $is_OLD_IO eq "yes" ) { 
       $DB_d0="${DB}_d0";
       $system_command = "mv $testname/$DB $testname/$DB_d0"; 
       system($system_command);
       $system_command = "mv $testname/$DB_tmp $testname/$DB"; 
       system($system_command);
     };
   }
   else {
     &print_error_msg("OUTPUT $testname/$DB not PRODUCED");
     #print elog "$testdir-$branch/$dir_name/$run_filename:\t $testname/$DB not FOUND\n" if ($elapsed < $run_duration); 
     if ($fail=~"no") {$fail="yes"};
   };
   printf tlog "%-10s %-15s %-3s %-45s","check",$VAR,"in",$DB;
 };
 #
 &gimme_reference($run_filename);
 if ( $action =~ /ocomp/) {printf tlog "%-10s %-65s",$action,$ref_filename;};
 if(! -e "$ref_filename" and $action =~ /ocomp/) {
     &print_error_msg("OUTPUT $ref_filename not PRODUCED ");
     #print elog "$testdir-$branch/$dir_name/$ref_filename:\t $ref_filename not FOUND\n" if ($elapsed < $run_duration); 
     print tlog "\t [ $color_start{red} FAIL $color_end{red} ] \n"; 
     if ($fail=~"no") {$fail="yes"};
     $failures++;
     $dir_failures++;
     return;
   #}
 }
 if (! -e "$run_filename" and $run_filename ne "skip") {
   print tlog "\t [ $color_start{red} FAIL $color_end{red} ] \n"; 
   &print_error_msg("$run_filname [RUN] not FOUND");
   #print elog "$testdir-$branch/$dir_name/$run_filename:\t $run_filename not FOUND\n" if ($elapsed < $run_duration); 
   $test_succeeded = 0;
   $failures++;
   $dir_failures++;
   if ($fail=~"no") {$fail="yes"};
   return;
 }
 #
 # Run the statistics diff script
 #
 if($ref_filename ne "skip" && -e $ref_filename && -e $run_filename )
 {
   $system_command = "$scripts_dir/find_the_diff -r $ref_filename -o $run_filename -p $prec";
   if($verb) {print "Running floating point test: $system_command \n\n";}
   $fldiff_output = `$system_command 2>&1`;
   #
   if( $fldiff_output =~ /OK/) {
    print tlog "\t [ $color_start{green}  OK  $color_end{green} ] \n"; 
    $test_succeeded = 1;
    $passes++;
    $dir_passes++;
   }
   else {
     &print_error_msg("FIND_THE_DIFF\@".$ref_filename." gives: $fldiff_output");
     print tlog "\t [ $color_start{red} FAIL $color_end{red} ] \n"; 
     print tlog "\t $fldiff_output \n"; 
     $test_succeeded = 0;
     if ($fail=~"no") {$fail="yes"};
     $failures++;
     $dir_failures++;
   }
 }
}

#########################
sub clean
{
 $system_command = "rm -fr o-* o.* r-* r_* l-* l_* *log run* yambo.in ref* SAVE\/ndb.kindx SAVE\/ndb.gops LOG";
# if ($veryclean) {
#   $system_command = "rm -fr o-* o.* r-* r_* l-* l_* *log run* yambo.in ref* SAVE\/ndb.* SAVE\/ns.* *gz *tar LOG"
# };
#print tlog $system_command."\n" if ($verb);
 system ($system_command);
}


#########################
sub RUN_specs
{
 #RT_CPU= ""                   # [PARALLEL] CPUs for each role
 #X_all_q_CPU= ""              # [PARALLEL] CPUs for each role
 #SE_CPU= ""                   # [PARALLEL] CPUs for each role
 #X_q_0_CPU= ""                # [PARALLEL] CPUs for each role
 #X_finite_q_CPU= ""           # [PARALLEL] CPUs for each role
 #BS_CPU= ""                   # [PARALLEL] CPUs for each role
 #X_all_q_nCPU_invert=0        # [PARALLEL] CPUs for matrix inversion
 #X_q_0_nCPU_invert=0          # [PARALLEL] CPUs for matrix inversion
 #X_finite_q_nCPU_invert=0     # [PARALLEL] CPUs for matrix inversion
 #BS_nCPU_invert=0             # [PARALLEL] CPUs for matrix inversion
 #BS_nCPU_diago=0              # [PARALLEL] CPUs for matrix diagonalization
 @PAR_field;
 $PAR_field[1]="K_Threads= $nt";
 $PAR_field[2]="X_Threads= $nt";
 $PAR_field[3]="DIP_Threads= $nt";
 $PAR_field[4]="SE_Threads= $nt";
 $PAR_field[5]="RT_Threads= $nt";
 $PAR_field[6]="X_all_q_nCPU_LinAlg_INV=$nl";
 $PAR_field[7]="X_q_0_nCPU_LinAlg_INV=$nl";
 $PAR_field[8]="X_finite_q_nCPU_LinAlg_INV=$nl";
 $PAR_field[9]="BS_nCPU_LinAlg_INV=$nl";
 $PAR_field[10]="BS_nCPU_LinAlg_INV=$nl";
 $PAR_field[11]="BS_nCPU_LinAlg_DIAGO=$nl";
 if ( ! $default_parallel and $N>1) {
  $PAR_field[12]="X_q_0_ROLEs= \"k.c.v\"";
  $PAR_field[13]="X_finite_q_ROLEs= \"q.k.c.v\"";
  $PAR_field[14]="X_all_q_ROLEs= \"q.k.c.v\"";
  $PAR_field[15]="SE_ROLEs= \"q.qp.b\"";
  $PAR_field[16]="BS_ROLEs= \"k.eh.t\"";
  $PAR_field[17]="RT_ROLEs= \"k.b.q.qp\"";
 }
 #
 $Nr="1";
 #
 # Open RUN configure file ...
 #
 $Ncpu="$N";
 @RUN_spec=();
 if ($N==1) { 
  $RUN_spec[1]="serial";
  return;
 }
 if ($SETUP=="1" or $yambo_exec=~"ypp") { 
  $Ncpu="1";
  $RUN_spec[1]="serial";
  return;
 }
 #
 if( -e "$input_folder/$testname.run") {
   #
   open(RUN,"<","$input_folder/$testname.run");
   @run_file = <RUN>;
   #
   # ... and extract runtime options
   #
   while($run_line = shift(@run_file)) {
     print $run_line;
   }
   #
   close(RUN);
 }
 else {
  #
  #X_q_0_ROLEs="k.c.v" 
  #X_finite_q_ROLEs= "q.k.c.v" 
  #X_all_q_ROLEs= "q.k.c.v" 
  #SE_ROLEs= "q.qp.b" 
  #BS_ROLEs= "k.eh.t" 
  #RT_ROLEs= "k.b.q.qp" 
  #
  $ir=0;
  @CPUs= qw(1 2);
  if ($np>4){ @CPUs= qw(1 2 4) };
  if ( $default_parallel ){ 
   $RUN_spec[1]="default";
   return;
  };
  &random_cpu_conf(3);
  #print "$cpu_3_conf\n";
  &random_cpu_conf(4);
  #print "$cpu_4_conf\n";
  #
  # GW & Lifetimes
  #
  if ( $LIFE=="1" or ( $GW=="1" and $EM1D=="1" ) or ($COHSEX=="1" and $COLL=="0") or ($COHSEX=="1" and $COLL=="1" and $EM1S=="0") ) { 
   if ( ! $random_parallel ){
    foreach $q (@CPUs){ foreach $qp (@CPUs){ foreach $b (@CPUs){
     foreach $k (@CPUs){foreach $c (@CPUs){foreach $v (@CPUs){
      $CONDITION="no";
      if ($q*$qp*$b==$np and $q*$k*$c*$v==$np){ $CONDITION="yes"};
      if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
      if ( -e "GAMMA" and $k>1){ $CONDITION="no"};
      if ( -e "NO_VALENCE" and $v>1){ $CONDITION="no"};
      if ( -e "NO_CONDUCTION" and $c>1){ $CONDITION="no"};
      if ( $CONDITION=~"yes"){
       $ir++;
       $RUN_spec[$ir]="SE_CPU=\"$q.$qp.$b\" X_all_q_CPU=\"$q.$k.$c.$v\"";
    }}}}}}}
    $Nr=$ir
   } else {
    $Nr=1;
    $RUN_spec[1]="SE_CPU=\"$cpu_3_conf\" X_all_q_CPU=\"$cpu_4_conf\"";
   }
   return
  }
  #
  # Standard linear-response (G-space)
  #
  if ( $OPTICS=="1" and $CHI=="1" ) { 
   if ( ! $random_parallel ){
    foreach $q (@CPUs){ foreach $k (@CPUs){ foreach $c (@CPUs){
     foreach $v (@CPUs){
      $CONDITION="no";
      if ($k*$c*$v==$np and $q*$k*$c*$v==$np){ $CONDITION="yes"};
      if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
      if ( -e "GAMMA" and $k>1){ $CONDITION="no"};
      if ( -e "NO_VALENCE" and $v>1){ $CONDITION="no"};
      if ( -e "NO_CONDUCTION" and $c>1){ $CONDITION="no"};
      if ( $CONDITION=~"yes"){
       $ir++;
       $RUN_spec[$ir]="X_q_0_CPU=\"$k.$c.$v\" X_finite_q_CPU=\"$q.$k.$c.$v\"";
    }}}}}
    $Nr=$ir
   } else {
    $Nr=1;
    $RUN_spec[1]="X_q_0_CPU=\"$cpu_3_conf\" X_finite_q_CPU=\"$cpu_4_conf\"";
   }
   return
  }
  #
  # EM1S
  #
  if ($GW=="0" and $EM1S=="1" and $BSE=="0" and $COLL=="0") { 
   if ( ! $random_parallel ){
    foreach $q (@CPUs){ foreach $k (@CPUs){ foreach $c (@CPUs){
     foreach $v (@CPUs){
      $CONDITION="no";
      if ($q*$k*$c*$v==$np){ $CONDITION="yes"};
      if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
      if ( -e "GAMMA" and $k>1){ $CONDITION="no"};
      if ( -e "NO_VALENCE" and $v>1){ $CONDITION="no"};
      if ( -e "NO_CONDUCTION" and $c>1){ $CONDITION="no"};
      if ( $CONDITION=~"yes"){
       $ir++;
       $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\"";
    }}}}}
    $Nr=$ir
   } else {
    $Nr=1;
    $RUN_spec[1]="X_all_q_CPU=\"$cpu_4_conf\"";
   }
   return
  }
  #
  # BSE
  #
  if ($BSE=="1" and $EM1S=="0") { 
   if ( ! $random_parallel ){
    foreach $k (@CPUs){ foreach $eh (@CPUs){ foreach $t (@CPUs){
      $CONDITION="no";
      $t_max=($eh*$k+1)/2;
      if ($k*$eh*$t==$np){ $CONDITION="yes"};
      if ( -e "GAMMA" and $k>1 ) { $CONDITION="no"};
      if ( $t>$t_max ) { $CONDITION="no"};
      if ( $CONDITION=~"yes"){
       $ir++;
       $RUN_spec[$ir]="BS_CPU=\"$k.$eh.$t\"";
      };
    }}};
    $Nr=$ir
   } else {
    $Nr=1;
    $RUN_spec[1]="BS_CPU=\"$cpu_3_conf\"";
   }
   return;
  }
  #
  # BSE and EM1S
  #
  if ($BSE=="1" and $EM1S=="1" ) { 
   if ( ! $random_parallel ){
    foreach $q (@CPUs){ foreach $k (@CPUs){ foreach $c (@CPUs){ foreach $v (@CPUs){
    foreach $kp (@CPUs){ foreach $eh (@CPUs){ foreach $t (@CPUs){
      $CONDITION="no";
      $t_max=($eh*$kp+1)/2;
      if ($q*$k*$c*$v==$np and $kp*$eh*$t==$np){ $CONDITION="yes"};
      if ( $t>$t_max ) { $CONDITION="no"};
      if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
      if ( -e "GAMMA" and ( $k>1 or $kp>1 )){ $CONDITION="no"};
      if ( -e "NO_VALENCE" and $v>1){ $CONDITION="no"};
      if ( -e "NO_CONDUCTION" and $c>1){ $CONDITION="no"};
      if ( $CONDITION=~"yes"){
       $ir++;
       $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\" BS_CPU=\"$kp.$eh.$t\"";
      };
    }}}}}}};
    $Nr=$ir
   } else {
    $Nr=1;
    $RUN_spec[1]="X_all_q_CPU=\"$cpu_4_conf\" BS_CPU=\"$cpu_3_conf\"";
   }
   return;
  }
  #
  # HF, SC or e-p
  #
  if ( (($HF=="1" and $GW=="0") or $SC=="1" or ($GW=="1" and $EP=="1") or ($GW=="1" and $EPHOT=="1")) and $COLL=="0" and $NEGF=="0" ) { 
   if ( ! $random_parallel ){
    foreach $q (@CPUs){ foreach $qp (@CPUs){ foreach $b (@CPUs){
      $CONDITION="no";
      if ($q*$qp*$b==$np){ $CONDITION="yes"};
      if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
      if ( $CONDITION=~"yes"){
       $ir++;
       $RUN_spec[$ir]="SE_CPU=\"$q.$qp.$b\"";
      };
    }}};
    $Nr=$ir
   } else {
    $Nr=1;
    $RUN_spec[1]="SE_CPU=\"$cpu_3_conf\"";
   }
   return;
  }
  #
  # RT
  #
  if ($SC=="0" and $NEGF=="1" and $COLL=="0") {
   if ( ! $random_parallel ){
    foreach $k (@CPUs){ foreach $b (@CPUs){ foreach $q (@CPUs){ foreach $qp (@CPUs){
      $CONDITION="no";
      if ($k*$b*$q*${qp}==$np){ $CONDITION="yes"};
      if ( -e "GAMMA" and $k>1){ $CONDITION="no"};
      if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
      if ( $CONDITION=~"yes"){
       $ir++;
       $RUN_spec[$ir]="RT_CPU=\"$k.$b.$q.${qp}\"";
    }}}}}
    $Nr=$ir
   } else {
    $Nr=1;
    $RUN_spec[1]="RT_CPU=\"$cpu_4_conf\"";
   }
   return;
  }
  #
  # EM1S+Collisions
  #
  if ($EM1S=="1" and $COLL=="1") { 
   if ( ! $random_parallel ){
    foreach $q (@CPUs){ foreach $k (@CPUs){ foreach $c (@CPUs){ foreach $v (@CPUs){
     foreach $kp (@CPUs){ foreach $b (@CPUs){ foreach $qp (@CPUs){
      $CONDITION="no";
      if ($yambo_exec=~"yambo_rt") {
       if ($q*$k*$c*$v==$np and $kp*$b*$q*${qp}==$np){ $CONDITION="yes"};
      } else {
       if ($q*$k*$c*$v==$np and $b*$q*${qp}==$np){ $CONDITION="yes"};
      }
      if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
      if ( -e "GAMMA" and ($k>1 or $kp>1)){ $CONDITION="no"};
      if ( -e "NO_VALENCE" and $v>1){ $CONDITION="no"};
      if ( -e "NO_CONDUCTION" and $c>1){ $CONDITION="no"};
      if ( $CONDITION=~"yes"){
       if ($yambo_exec=~"yambo_rt" ) {
        $ir++;
        $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\" RT_CPU=\"$kp.$b.$q.${qp}\"";
       }
       else
       {
        $ir++;
        $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\" SE_CPU=\"$q.$qp.$b\"";
       };
      };
    }}}}}}};
    $Nr=$ir
   } else {
    $Nr=1;
    if ($yambo_exec=~"yambo_rt" ) {
     $RUN_spec[1]="X_all_q_CPU=\"$cpu_4_conf\" RT_CPU=\"$cpu_4_conf\"";
    }
    else
    {
     $RUN_spec[1]="X_all_q_CPU=\"$cpu_4_conf\" SE_CPU=\"$cpu_3_conf\"";
    };
   }
   return;
  }
  #
  # COLLISIONS
  #
  if ($COLL=="1" ) { 
   if ( ! $random_parallel ){
    foreach $q (@CPUs){ foreach $qp (@CPUs){ foreach $b (@CPUs){
      $CONDITION="no";
      if ($q*$qp*$b==$np){ $CONDITION="yes"};
      if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
      if ( $CONDITION=~"yes"){
       $ir++;
       $RUN_spec[$ir]="SE_CPU=\"$q.$qp.$b\"";
    }}}}
    $Nr=$ir
   } else {
    $Nr=1;
    $RUN_spec[1]="SE_CPU=\"$cpu_3_conf\"";
   }
   return;
  }
 }
}
#########################
sub random_cpu_conf
{
$n_fields=$_[0];
if ($n_fields == 3) {
@icpu = qw(1 2 3);
@ncpu = qw(1 1 1)
}
if ($n_fields == 4) {
@icpu = qw(1 2 3 4);
@ncpu = qw(1 1 1 1)
}
#
$ic=0;
while ($ic<=$n_fields-1) {
  my $random_i = int(rand($n_fields));
  #print "$random_i \n";
  $i_dummy=$icpu[$ic];
  $icpu[$ic]=$icpu[$random_i];
  $icpu[$random_i]=$i_dummy;
  $ic++
};
#print "CPU conf= @icpu \n";
#
$np_now=$np;
$ic=0;
while ($ic<=$n_fields-1) {
 $icp=$icpu[$ic]-1;
 if ($np_now!=1) {
  $int_np_now=$np_now;
  $running_np=$np_now-0.1;
  while ($int_np_now-$running_np != 0) {
   $random_cpu = int(rand($np_now))+1;
   $running_np=$np_now/$random_cpu;
   $int_np_now=int($running_np);
   $ncpu[$icp]=$random_cpu;
   #print "LOOP NP=$np_now NP_remaining=$running_np N_cpu=$random_cpu \n";
  }
  $np_now=$running_np;
  #print "ASSIGN IC=$icp NC=$ncpu[$icp] \n";
 }
 #print "NP $np_now \n";
 $ic++;
}
$ic=0;
if ($np_now!=1) {
 while ($ic<=$n_fields-1) {
  if ($ncpu[$ic] == 1) { 
    $ncpu[$ic]=$np_now;
    $np_now=1;
  }
  $ic++
 }
}
#print "NCPU = @ncpu \n";
if ($n_fields == 3) {
 $cpu_3_conf="$ncpu[0].$ncpu[1].$ncpu[2]";
}
if ($n_fields == 4) {
 $cpu_4_conf="$ncpu[0].$ncpu[1].$ncpu[2].$ncpu[3]";
}
#
}
#########################
sub print_error_msg
{
if ($first_time_in_the_dir eq "yes") {print elog "\n***** $testdir-$branch *****\n";};
$first_time_in_the_dir="no";
if ( $testname_err_report ne $testname) {print elog "Test : $testname\n";};
$testname_err_report="$testname";
print elog "ERROR: $_[0]\n";
}
##########################
sub gimme_reference
{
$ref_filename = "REFERENCE_$local_b/".$_[0]; 
if(! -e "$ref_filename" ) { 
$ref_filename = "REFERENCE_$local_b/".$testname."/".$_[0]};
#
if(! -e "$ref_filename" ) { 
$ref_filename = "REFERENCE/".$_[0]; 
if(! -e "$ref_filename" ) { $ref_filename = "REFERENCE/".$testname."/".$_[0] }
}
}
##########################
sub print_the_list_element
{
  my @dummy = split(/ /,$_[1]);
  print "$_[0] $dummy[1]\n";
  foreach my $i (2 .. $#dummy) { print "         $dummy[$i]\n"};
}

