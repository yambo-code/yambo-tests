#!/usr/bin/perl
#
# Copyright (C) 2010-2015 C. Hogan, A. Marini
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
            "v+"              => \$verb,
            "l"              => \$listtests,
            "a"              => \$add_outputs,
            "n"              => \$dryrun,
            "c"              => \$clean,
            "f"              => \$ftp,
            "e"              => \$veryclean,
            "k"              => \$savefiles,
            "d=s"            => \$download,
            "def_par"        => \$default_parallel,
            "openmp_is_off"  => \$openmp_is_off,
            "x"              => \$extract,
            "b=s"            => \$branch,
            "u=s"            => \$upload,
            "mpi=s"          => \$mpi,
            "np=i"           => \$np,
            "nt=i"           => \$nt,
            "s"              => \$serial,
            "hard"           => \$hard,
            "html"           => \$html,
            "t=s"            => \$tol,
            "host=s"         => \$my_host,
            "prec=s"         => \$default_prec,
            "p=s"            => \$project,
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
                   -def_par             Skip loop on parallel structures
                   -openmp_is_off       Switch openmp off
                   -a                   Add missing Outputs (usefull to create new test)
                   -p      [PJ]         Test only this project (e.g. sc, all, none)
                   -n                   Perform dry run
                   -c                   Clean
                   -f                   Login (using ncftp) on the ftp account 
                   -e                   Clean (including ns files)
                   -k                   Keep output files          
                   -d      [TEST]/all   Download & Update the core databases 
                   -x                   Extract the core databases 
                   -b      [BRANCH]     Branch name
                   -u      [DIR]        Upload DIR results or create and upload the tar.gz database
                   -mpi    [MPI]        mpi command (e.g. "mpirun")
                   -np     [N]          # of CPU's
                   -nt     [T]          # of OMP threads
                   -s                   Force serial (yambo -M)
                   -html                Log 2 HTML and archive of results/reports
                   -prec   [PREC]       Precision (tolerance). Default: 0.01 (1%)
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
# PATHS (1)
#
my $cwd=abs_path();
#
# Hostname
#
$host=hostname().".".hostdomain();
if(!hostdomain()){ $host=hostname() };
# OVerwrite with user defined host
if($my_host) {$host=$my_host};
# Precision
$prec = $default_prec;
#
# FTP
#
if ($ftp) {
  $system_command = "ncftp -u 1945528\@aruba.it -p 5fv94ktp ftp.yambo-code.org";
  system ($system_command);
  die "\n";
}
#
# Files saving & upload
#
if ($upload) {
   my @dirs = ( $upload );
   my @files;
   find( sub { push @files, $File::Find::name if /\INPUTS$/ }, @dirs );
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
    #$system_command = "tar cf $upload.tar $upload ;gzip $upload.tar; rm -fr $upload";
    #system ($system_command);
    #$system_command = "ncftpput -u 1945528\@aruba.it -p 5fv94ktp -R ftp.yambo-code.org www.yambo-code.org/testing-robots/results $upload.tar.gz";
    #system ($system_command);
    #$system_command = "cp $upload.tar.gz log-latest.tar.gz";
    #system ($system_command);
    #$system_command = "ncftpput -u 1945528\@aruba.it -p 5fv94ktp -R ftp.yambo-code.org www.yambo-code.org/testing-robots log-latest.tar.gz";
    #system ($system_command);
    $system_command = "ncftpput -u 1945528\@aruba.it -p 5fv94ktp -R ftp.yambo-code.org www.yambo-code.org/testing-robots ROBOTS/$host.php";
    system ($system_command);
    $system_command = "ncftpput -u 1945528\@aruba.it -p 5fv94ktp -R ftp.yambo-code.org www.yambo-code.org/testing-robots $upload/*.html";
    system ($system_command);
    $system_command = "ncftpput -u 1945528\@aruba.it -p 5fv94ktp -R ftp.yambo-code.org www.yambo-code.org/testing-robots $upload/*.tar.gz";
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
  foreach $dir (<*>,<*/*>,<*/*/*>,<*/*/*/*>,<*/*/*/*/*>) {      # Glob all files
    # Loop through all files and directories, and save those 'active' dirs containing
    # SAVE and INPUTS folders into @testdirs
    # Then clean up, and/or save $RT_tests strings
    # If directory contains an empty file "RT" or "HARD" etc then log this
    if (-d $dir."/SAVE" && -d $dir."/INPUTS" ) {
      push(@testdirs,$dir);
      if ($clean) {
        chdir($dir) or die("$!, stopped");
        &clean();
        chdir($cwd) or die("$!, stopped");
      }
      if (-e $dir."/RT") {
        if (-e $dir."/HARD") {
         $RT_tests="$RT_tests"." ".$dir."[H]";
        }else{
         $RT_tests="$RT_tests"." ".$dir;
        }
      };
      if (-e $dir."/QED") {
        if (-e $dir."/HARD") {
         $QED_tests="$QED_tests"." ".$dir."[H]";
        }else{
         $QED_tests="$QED_tests"." ".$dir;
        }
      };
      if (-e $dir."/SC") {
        if (-e $dir."/HARD") {
         $SC_tests="$SC_tests"." ".$dir."[H]";
        }else{
         $SC_tests="$SC_tests"." ".$dir;
        }
      };
      if (-e $dir."/ELPH") {
        if (-e $dir."/HARD") {
         $ELPH_tests="$ELPH_tests"." ".$dir."[H]";
        }else{
         $ELPH_tests="$ELPH_tests"." ".$dir;
        }
      };
      if (-e $dir."/BROKEN") {
       $BROKEN_tests="$BROKEN_tests"." ".$dir;
      };
      if (!-e $dir."/BROKEN" && !-e $dir."/SC" && !-e $dir."/ELPH" && !-e $dir."/RT" && !-e $dir."/KERR" && !-e $dir."/QED") {
        if (-e $dir."/HARD") {
         $NORMAL_tests="$NORMAL_tests"." ".$dir."[H]";
        }else{
         $NORMAL_tests="$NORMAL_tests"." ".$dir;
        }
      };

      #
      # Loop through all files inside INPUTS (conf/actions/flags/00_*) -> $SUB_DIR
      # Remove any local copies in the run dir ($dir), otherwise skip (!)
      #
      @testinputs = <$dir/INPUTS/*>;
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
  print "[YAMBO] "."$NORMAL_tests\n";
  print "[QED]   "."$QED_tests\n";
  print "[RT]    "."$RT_tests\n";
  print "[SC]    "."$SC_tests\n";
  print "[ELPH]  "."$ELPH_tests\n";
  print "[KERR]  "."$KERR_tests\n";
  print "[BROKEN]"."$BROKEN_tests\n";
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
       LOOP: foreach $test ( <$dir/INPUTS/*> ) { 
         if (index($test, ".conf")>0) {next LOOP};
         if (index($test, ".actions")>0) {next LOOP};
         if (index($test, ".flags")>0) {next LOOP};
         $testname = substr($test,length($dir)+8,length($test)) ;
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
$is_GPL="no";
if ($branch=~m/gpl/ix) {$is_GPL="yes"};
$is_STABLE="no";
if ($branch=~m/trunk_stable/ix) {$is_STABLE="yes"};
#
# Open log files: here $branch is passed from run_me.pl
# ELOG:		Error 
# TLOG:		Standard log
# TSLOG:	Compact log
#
my $tests_error = '../Tests-'.$branch.'-'.$host.'.error';
my $tests_log = '../Tests-'.$branch.'-'.$host.'.log';
my $tests_compact_log = '../Tests-compact-'.$branch.'-'.$host.'.log';
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
#
# date
#
my $date="Date:$days[$wday]-$mday-$months[$mon]-$year Time:$hour-$min";
print tlog "$date \n\n";
#
print tlog "Running tests : ".join("\n                ",@input_tests_list)."\n";
#$verb = 1 if ($dryrun); 
$verbosity_level = "low";
$verbosity_level = "high" if ($verb eq 1);
$verbosity_level = "highest" if ($verb ge 2);
print tlog "Verbosity     : $verbosity_level \n";
print tlog "Precision     : $prec \n";

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
  print tlog "EXEC          : $exec \n";
  $yambo_exec = $exec;
}
print tlog "Hostname      : $host \n";
#
# PARALLEL stuff
#
if($serial) {$force_serial = "-M"};
$mpiexec = "mpirun"; 
if($mpi) { 
  $mpiexec = $mpi; 
  print tlog "MPI           : $mpiexec \n";
}
$N=1;
if($np) { 
  $N = $np; 
  print tlog "CPU's         : $N \n";
}
$N_t=1;
if($nt) { 
  $N_t = $nt; 
  print tlog "Threads       : $N_t \n";
}
# If serial only need once
if($serial or $N eq 1){
  print tlog "Configuration is SERIAL throughout\n";
}
print tlog   "=---------------------------------=\n\n";
#
# Loop over test directories
#
$numtests = @input_tests_list; # Number of elements
$count_tests=0;
LOOP_DIRS: foreach $testline (@input_tests_list) {
   #
   $dir_failures=0;
   $dir_passes=0;
   $count_tests++;
   @inputs = split(/\s+/,$testline);
   $testdir = shift(@inputs); 
   #
   print tslog "$color_start{blue} ***** $testdir-$branch ***** $color_end{blue}\n";
   print tlog "$color_start{blue} ***** $testdir-$branch ***** $color_end{blue}\n";
   #print elog "$color_start{blue} ***** $testdir-$branch ***** $color_end{blue}\n";
   printf(" > $color_start{blue} [%-3s/%-3s] %-40s $color_end{blue} ",$count_tests,$numtests,$testdir);
   chdir($testdir) or die("$!, stopped changing dir to $testdir");
   #
   # clean up old shit
   #
   unless($savefiles) {&clean()};

   if(-e "HARD" and !$hard) {
       print " skipping (H)\n"; 
       chdir($cwd) or die("$!, stopped changing to dir $cwd");
       next LOOP_DIRS;
   }
   #
   # Loop over each test file
   #
   LOOP_INPUTS: foreach $testname (@inputs) {
     print "\nRunning input: $testname\n" if ($verb);
     #
     # Runlevels
     #
     $skip_dir="no";
     &get_runlevels;
     if($skip_dir =~ m/yes/) {
       chdir($cwd);
       if($skip_dir =~ m/1/) {print " skipping (P)"}; # wrong project
       if($skip_dir =~ m/2/) {print " skipping (N)"}; # no projects
       if($skip_dir =~ m/3/) {print " skipping (G)"}; # not GPL
       if($skip_dir =~ m/4/) {print " (broken)"};
#      print " $color_start{red} skipping $color_end{red}\n";
       print "\n";
       next LOOP_DIRS;
     }
     #
     # Overwrite specific options from .conf for this input file
     #
     $prec = $default_prec;
     if( -e "INPUTS/$testname.conf") {
       open(CONF,"<","INPUTS/$testname.conf");
       while($confline = <CONF>) {
         chomp $confline;
         ($desc, $value) = split(/\s+/,$confline);
         # Test precision
         if($desc =~ m/precision/) { 
            print tlog "** Changing precision for $testname to: $value \n";
            $prec = $value;
         }
       }
#      &set_tolerance;
     }
     #
     # Do actions (if any)
     #
     &do_user_actions;
     #
     # Check if extra flags are needed
     #
     &add_user_flags;
     #
     # Prepare the input file
     #
     $Nr=0;
     #
     &RUN_specs;
     #
     #print "$Nr \n";
     # Do the actual run!
     #
     LOOP: for (my $ir=1; $ir<=$Nr ; $ir++){
       #
       $string=$RUN_spec[$ir];
       #
       if($N gt 1){ print tlog ">> Configuration is $string($ir)\n"};
       print tslog "[$string($ir)(N=$Ncpu)(Nt=$nt)]$testname($ir)";
       #
       if (-e "$testname-$ir") {next LOOP};
       #
       @specs = split(/\s+/,$string);
       #
       $command_line = "cat $cpu INPUTS/$testname > yambo.in";
       $return_value = system("$command_line");
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
       &run_it;    # Run the job
       $fail="no"; 
       #
       # This $dir_name is a local directory for each input file that collects
       # all the outputs
       $dir_name="${testname}_N${np}-M${nt}";
       if ($np>1 && !$default_parallel){ $dir_name="${testname}_N${np}-M${nt}-${ir}"};
       # 
       # If a configure file exists (DEPRECATED) 
       # 
#      if( -e "INPUTS/$testname.conf") {
#        while ($confline = shift(@conf_file)) {
#           # 
#           @confline = split(/\s+/,$confline);
#           $action = shift(@confline);
#           $file = shift(@confline);
#           $VAR = shift(@confline);
#           #
#           if(! $return_value == 0) {
#             if( $action =~ /comp/) {
#               $not_run++;
#             }
#             next;
#           }
#           #
#           if($action =~ /exist/) { &exist_action( ) };
#           #
#           if($action =~ /comp/) { &comp_action( ) };
#           #
#        }
#        close(CONF);
#      }
#      else {
       #
       # Parse input file to find standard runlevels and consequent actions to take
       #
       &get_actions_from_input_file;
#      }
       if ($fail=~"yes"){print tslog "($color_start{red} FAIL $color_end{red})\n"};
       if ($fail=~"no") {print tslog "($color_start{green} OK $color_end{green})\n"};
       #
       #
       # Collect all the outputs into $dir_name (e.g. ./01_init_N1-M1)
       #
       mkdir($dir_name) or print elog "Error creating directory $!\n";
       copy("yambo.in", $dir_name) or print elog "Error copying file $!\n";
       foreach $file (<o-*$testname*>) 			{ move($file,$dir_name) };
       foreach $file (<r-*$testname*>,<ref_*>,<run_*>) 	{ move($file,$dir_name) };
       foreach $file (<l-*$testname*>) 			{ move($file,$dir_name) };
       foreach $file (<LOG/l*$testname*>)		{ move($file,$dir_name) };
       #
       if( -d "$testname") {
#        move($testname,"testname-DBs"); 
        $command_line = "rm -fr $testname-DBs; mv $testname $testname-DBs";
        $return_value = system("$command_line");
       }
     }
     #
     $command_line = "ln -s $testname-DBs $testname";
     $return_value = system("$command_line");
     #
   }  # End loop on input files
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
print tlog "Tests failed      : $failures\n";
print tlog "Tests passed      : $passes\n";
print tlog "Tests interrupted : $not_run\n";
#
# Files closing
#
close elog;
close tlog;
close tslog;

#
chdir($cwd."/../"); # Return to /test-suite



##########################################################
# Subroutines follow here...
##########################################################
#
# (1) Identifies the correct executable for a particular runlevel in the input file
# (2) Sets the $description flag
#
sub get_runlevels
{
 $SETUP="0";
 $HF="0";
 $PPA="0";
 $COHSEX="0";
 $GW="0";
 $EM1D="0";
 $CHI="0";
 $OPTICS="0";
 $LIFE="0";
 $EM1S="0";
 $BSE="0";
 $EP="0";
 $EE_scatt="0";
 $SC="0";
 $COLL="0";
 $io_COLL="1";
 $fixsyms="0";
 $YPP="0";
 $YPP_RT="0";
 $YPP_PH="0";
 open(INPUT_file,"<","INPUTS/$testname");
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
   if ($runlevel=~"el_el_scatt"){ $EE_scatt="1"};
   if ($runlevel=~"life"){ $LIFE="1"};
   if ($runlevel=~"Shifted_Grid"){ $YPP="1"};
   if ($runlevel=~"WFs_map"){ $YPP="1"};
   if ($runlevel=~"density"){ $YPP="1"};
   if ($runlevel=~"kpts_map"){ $YPP="1"};
   if ($runlevel=~"wavefunction"){ $YPP="1"};
   if ($runlevel=~"sort"){ $YPP="2"};
   if ($runlevel=~"gkkp"){ $YPP_PH="1"};
   if ($runlevel=~"eliashberg"){ $YPP_PH="1"};
   if ($runlevel=~"RealTime"){ $YPP_RT="1"};
   if ($runlevel=~"fixsyms"){ $YPP_RT="1"};
 }
 close(INPUT_file);
 if ($fixsyms=="1") { $description="Symmetries Compatibility Operations" };
 if ($SETUP=="1") { $description="Initialization" };
 if ($LIFE=="1") { $description="GW Lifetimes"};
 if ($COHSEX=="1") { $description="COHSEX" };
 if ($PPA=="1") { $description="PPA" };
 if ($GW && $EM1D=="1") { $description="GW (real-axis)" };
 if ($GW && $EP=="1") { $description="GW (e-p)" };
 if ($COHSEX=="0" && $PPA=="0" && $GW=="0" && $HF=="1") { $description="Hartree-Fock" } ;
 if ($EM1S=="1" ) { $description="Static Screened Interaction"};
 if ($OPTICS=="1" && $CHI=="1" ) { $description="Optics (G-space)"};
 if ($OPTICS=="1" && $BSE=="1" ) { $description="Optics (T-space)"};
 if ($COLL=="1") { $description="Collisions" };
 if ($NEGF=="1") { $description="Real-Time" };
 #
 # EXE section
 #
 $ncdump_exec="$exe_path/ncdump";
 if (!-x $ncdump_exec) {
   $ncdump_exec="ncdump";
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
#    if (!-e "KERR" && $project eq "kerr") {die};
#    if ((-e "KERR" or -e "RT" or -e "ELPH" or -e "SC" or -e "QED") && $project eq "none") {die};
#  }
#  if ($is_GPL eq "yes") {
#    if ((-e "KERR" or -e "RT" or -e "SC" or -e "QED") ) {die};
#  }
# if (-e "BROKEN") {die;}

   if ($project eq "none" ) {
     if ((-e "KERR" or -e "RT" or -e "ELPH" or -e "SC" or -e "QED") && $project eq "none") {$skip_dir="yes2"};
   } elsif ($project ne "all") {
     if (!-e "QED" && $project eq "qed") {$skip_dir="yes1"};
     if (!-e "RT" && $project eq "rt") {$skip_dir="yes1"};
     if (!-e "ELPH" && $project eq "elph") {$skip_dir="yes1"};
     if (!-e "SC" && $project eq "sc") {$skip_dir="yes1"};
     if (!-e "KERR" && $project eq "kerr") {$skip_dir="yes1"};
   }
   if ($is_GPL eq "yes") {
     if ((-e "KERR" or -e "RT" or -e "SC" or -e "QED") ) {$skip_dir="yes3"};
   }
   if (-e "BROKEN") {$skip_dir="yes4"};

  $yambo_exec = "$exe_path/yambo";
  if ($YPP=="1") {$yambo_exec = "$exe_path/ypp"};
  if ($YPP=="2") {$yambo_exec = "$exe_path/ypp -e s"};
  if (-e "RT") {
   $yambo_exec = "$exe_path/yambo_rt";
   if ($YPP_RT=="1" or $YPP=="1") {$yambo_exec = "$exe_path/ypp_rt"};
  }
  if (-e "QED") {
   $yambo_exec = "$exe_path/yambo_qed";
  }
  if (-e "ELPH") {
   $yambo_exec = "$exe_path/yambo_ph";
   if ($YPP_PH=="1" or $YPP=="1") {$yambo_exec = "$exe_path/ypp_ph"};
  }
  if (-e "SC" ) {$yambo_exec = "$exe_path/yambo_sc";}
  if (-e "KERR" ) {$yambo_exec = "$exe_path/yambo_kerr";}
  #
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
   $VAR = "Sx_Vxc";
   &comp_action( );
 }
 if ( -e "$testname/ndb.em1s_fragment_1" ){
    $action = "dbcomp";
    $file = "ndb.em1s_fragment_1";
   print "Testing $file $action\n" if ($verb);
    $VAR = "X_Q_1";
    &comp_action( );
 }
 if ( -e "$testname/ndb.COLLISIONS_COHSEX_fragment_2" ){
    $action = "dbcomp";
    $file = "ndb.COLLISIONS_COHSEX_fragment_2";
   print "Testing $file $action\n" if ($verb);
    $VAR = "COLLISIONS_v";
    &comp_action( );
 }
 if ( -e "$testname/ndb.COLLISIONS_HF_fragment_2" ){
    $action = "dbcomp";
    $file = "ndb.COLLISIONS_HF_fragment_2";
   print "Testing $file $action\n" if ($verb);
    $VAR = "COLLISIONS_v";
    &comp_action( );
 }
 if ( -e "$testname/ndb.COLLISIONS_FOCK_fragment_2" ){
    $action = "dbcomp";
    $file = "ndb.COLLISIONS_FOCK_fragment_2";
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
 if ( -e "$testname/ndb.E_SOC_map" ){
    $action = "dbcomp";
    $file = "ndb.E_SOC_map";
   print "Testing $file $action\n" if ($verb);
    $VAR = "BLOCK_TABLE";
    &comp_action( );
 }
 #
 $missing_file="no";
 $action = "ocomp";
 O_file_loop: foreach $file (<o-$testname.*>){
   #
   if (!-e "REFERENCE/$file" and $add_outputs) { 
     print tslog "[$testdir] OUTPUT $file not found in REFERENCE \n";
     copy($file, "REFERENCE");
     $actions_cmd="svn add REFERENCE/$file";
     $return_value = system("$actions_cmd");
     #$missing_file="yes";
   };
 }
 O_file_loop: foreach $file (<REFERENCE/o-$testname.*>){
   $file =~ s{.*/}{};
   ($base, $dir, $ext) = fileparse($file, qr/\.[^.]*/);
   #
   if ( $ext=~ /hf/ and $is_STABLE=~"yes" ) { next O_file_loop};
   #
   if (!-e "$file") { 
     print tslog "[$testdir] REFERENCE $file not found as output\n";
     $actions_cmd="rm -f REFERENCE/$file";
     $return_value = system("$actions_cmd") if ($add_outputs);
     $actions_cmd="svn del REFERENCE/$file";
     $return_value = system("$actions_cmd") if ($add_outputs);
     #$missing_file="yes";
   }
   if (  $missing_file=~"yes" ){ $fail = "yes"};
   #
   # Skip specific (noisy) files
   #
   $comp_it="yes";
   if (  $missing_file=~"yes" ){ $fail = "yes"};
   if (  $missing_file=~"yes" ){ $comp_it = "no"};
   if ( $file=~ /alpha/ ) { $comp_it = "no"};
   if ( $file=~ /exc_I_sorted/ ) { $comp_it = "no"};
   if ( $ext=~ /hf/ and $is_STABLE=~"yes" ) { next O_file_loop};
   if ( $file=~ /o-06_RPA_no_LF_x_shifted_grids/ and $is_STABLE=~"yes" ) { $comp_it = "no"};
   if ( $file=~ /o-06_RPA_no_LF_z_shifted_grids/ and $is_STABLE=~"yes" ) { $comp_it = "no"};
   if ( $file=~ /o-03_QP_PPA_terminator.qp/ and $is_STABLE=~"yes" ) { $comp_it = "no"};
   if ( $comp_it=~"yes" ) {&comp_action( )};
 };
};

#############################
sub add_user_flags
{
 $flags = "";
 if( -e "INPUTS/$testname.flags") {
   open(FLAGS,"<","INPUTS/$testname.flags");
   @flags_file = <FLAGS>;
   while($extra_flag = shift(@flags_file)) {
     $extra_flag =~ s/^\s+|\s+$//g ;
     $flags = $flags.",$extra_flag" ;
   }
  close(FLAGS);
 }
 $flags = '"' . "$testname$flags" . '"';
}
 
#############################
# Actions files must direct STDERR to /dev/null
# A cleaner way would be to parse mkdir, cp etc into perl commands.
sub do_user_actions
{
 if( -e "INPUTS/$testname.actions") {
   open(ACTIONS,"<","INPUTS/$testname.actions");
   print "INPUTS/$testname.actions \n" if ($verb);
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
# $log = "2> /dev/null";
# $log = "";
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
 #   $return_value = `$command_line`;   # launch the yambo job
     alarm 0;                   # cancel the alarm
 };
 if ($verb ge 2) { print "--------------------\n"};
 if ($@) {
   die unless $@ eq "alarm\n"; # propagate unexpected errors
 }
 $test_end   = [gettimeofday]; 
 $elapsed = tv_interval($test_start, $test_end);
 if($return_value == 0) {
   if ($elapsed > $run_duration) 
   {
    print tlog "FAILED (Runtime above $run_duration secs.)\n";
    print elog "$testdir-$branch/$dir_name/$run_filename\t FAILED (Runtime above $run_duration secs.)\n"
   }
   else
   {
    printf tlog "%8.1f s\n", $elapsed;
   }
 } else {
   print tlog "FAILED (exit code $return_value)\n";
 }
 $dumb = system("pkill yambo") ;
 $dumb = system("pkill ypp") ;
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
   print elog "$testdir-$branch/$dir_name/$run_filename:\t $file not FOUND\n" if ($elapsed < $run_duration); 
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
 $ref_filename = "REFERENCE/".$run_filename; 
 #
 #print elog "**** Test: $testname \n";
 #print elog "****     > $action $run_filename \n";
 #
 if($action =~ /dbcomp/) 
 {
   $DB = $file;
   $run_filename = "o-$testname.$run_filename";
   $ref_filename = "REFERENCE/".$run_filename; 
   if(! -e "$ref_filename" ) {
     $ref_filename = "REFERENCE/".$testname."/".$run_filename; 
     print elog "$testdir-$branch/$dir_name/$run_filename:\t $ref_filename not FOUND\n" if ($elapsed < $run_duration); 
     #print elog "****     > $ref_filename NOT FOUND \n";
     if ($fail=~"no") {$fail="yes"};
   }
   if(-e "$testname/$DB" ) {
     $system_command = "$ncdump_exec -v $VAR $testname/$DB | $awk -f $scripts_dir/ndb2o.awk | head -n 10000 > $run_filename" ;
     #print "$system_command \n";
     system($system_command);
   }
   else {
     print elog "$testdir-$branch/$dir_name/$run_filename:\t $testname/$DB not FOUND\n" if ($elapsed < $run_duration); 
     #print elog "****     > $testname/$DB NOT FOUND \n";
     if ($fail=~"no") {$fail="yes"};
   };
   printf tlog "%-10s %-15s %-3s %-45s","check",$VAR,"in",$DB;
 }
 else
 { 
   printf tlog "%-10s %-65s",$action,$run_filename;
 }
 #
 if(! -e "$ref_filename" and $action =~ /docomp/) {
   $ref_filename = "REFERENCE/".$testname."/".$run_filename; 
   if (! -e "$ref_filename") {
     print elog "$testdir-$branch/$dir_name/$run_filename:\t $run_filename not FOUND\n" if ($elapsed < $run_duration); 
     #print elog "****     > $ref_filename NOT FOUND \n";
     print tlog "\t [ $color_start{red} FAIL $color_end{red} ] \n"; 
     if ($fail=~"no") {$fail="yes"};
     $failures++;
     $dir_failures++;
     return;
   }
 }
 if (! -e "$run_filename") {
   print tlog "\t [ $color_start{red} FAIL $color_end{red} ] \n"; 
   print elog "$testdir-$branch/$dir_name/$run_filename:\t $run_filename not FOUND\n" if ($elapsed < $run_duration); 
   #print elog "****     > $run_filename NOT FOUND \n";
   $test_succeeded = 0;
   $failures++;
   $dir_failures++;
   if ($fail=~"no") {$fail="yes"};
   return;
 }
 #
 # Strip comment lines from files (since they often differ, 
 # for instance, logo length)
 #
 #if(-e "$ref_filename" ) {
 #  open(REF,"<","$ref_filename");
 #  @ref = <REF>;
 #  @refclean = grep(!/#/, @ref);
 #  open(REFCLEAN,">","ref_$file");
 #  while ($line = shift(@refclean)) {
 #    @cols = split(" ",$line);
 #    if ( $#cols+1 > 1) {$line=join(" ",$cols[1],$cols[2],$cols[3],$cols[4],$cols[5],$cols[6],$cols[7],$cols[8],$cols[9],$cols[10]," \n")};
 #    print REFCLEAN $line;
 #  }; 
 #  close(REFCLEAN);
 #};
 ##
 #if(-e "$run_filename" ) {
 #  open(RUN,"<","$run_filename");
 #  @run = <RUN>;
 #  @runclean = grep(!/#/, @run);
 #  open(RUNCLEAN,">","run_$file");
 #  while ($line = shift(@runclean)) {
 #    @cols = split(" ",$line);
 #    if ( $#cols+1 > 1) {$line=join(" ",$cols[1],$cols[2],$cols[3],$cols[4],$cols[5],$cols[6],$cols[7],$cols[8],$cols[9],$cols[10]," \n")};
 #    print RUNCLEAN $line;
 #  }; 
 #  close(RUNCLEAN);
 #};
 #
 # Run the modified Abinit fldiff script
 #
 #$system_command = "/usr/bin/perl $scripts_dir/fldiff.pl $tolerance run_$file ref_$file YAMBO";
 #
 # Run the statistics diff script
 #
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
   print elog "$testdir-$branch/$dir_name/$run_filename:\t $fldiff_output\n" if ($elapsed < $run_duration); 
   print tlog "\t [ $color_start{red} FAIL $color_end{red} ] \n"; 
   print tlog "\t $fldiff_output \n"; 
   $test_succeeded = 0;
   if ($fail=~"no") {$fail="yes"};
   $failures++;
   $dir_failures++;
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
 if ( ! $default_parallel and $N>1) {
  $PAR_field[6]="X_q_0_ROLEs= \"k.c.v\"";
  $PAR_field[7]="X_finite_q_ROLEs= \"q.k.c.v\"";
  $PAR_field[8]="X_all_q_ROLEs= \"q.k.c.v\"";
  $PAR_field[9]="SE_ROLEs= \"q.qp.b\"";
  $PAR_field[10]="BS_ROLEs= \"k.eh.t\"";
  $PAR_field[11]="RT_ROLEs= \"k.b.q.qp\"";
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
 if( -e "INPUTS/$testname.run") {
   #
   open(RUN,"<","INPUTS/$testname.run");
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
  if ( $default_parallel ){ 
   $RUN_spec[1]="default";
   return;
  };
  #if ( -e "GAMMA" and $np>2){ 
  #  #@CPUs= qw(1 2 4)
  #  $Nr=0;
  #  return;
  #}
  #
  # GW & Lifetimes
  #
  if ( $LIFE=="1" or ( $GW=="1" and $EM1D=="1" ) or ($COHSEX=="1" and $COLL=="0") or ($COHSEX=="1" and $COLL=="1" and $EM1S=="0") ) { 
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
  }}}}}}}$Nr=$ir;return}
  #
  # Standard linear-response (G-space)
  #
  if ( $OPTICS=="1" and $CHI=="1" ) { 
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
  }}}}}$Nr=$ir;return}
  #
  # EM1S
  #
  if ($GW=="0" and $EM1S=="1" and $BSE=="0" and $COLL=="0") { 
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
  }}}}}$Nr=$ir;return}
  #
  # BSE
  #
  if ($BSE=="1" and $EM1S=="0") { 
   foreach $k (@CPUs){ foreach $eh (@CPUs){ foreach $t (@CPUs){
     $CONDITION="no";
     $t_max=($eh+1)/2;
     if ($k*$eh*$t==$np){ $CONDITION="yes"};
     if ( -e "GAMMA" and ( $k>1 or $t>$t_max ) ){ $CONDITION="no"};
     if ( $CONDITION=~"yes"){
      $ir++;
      $RUN_spec[$ir]="BS_CPU=\"$k.$eh.$t\"";
     };
   }}};
   $Nr=$ir;
   return;
  }
  #
  # BSE and EM1S
  #
  if ($BSE=="1" and $EM1S=="1" ) { 
   foreach $q (@CPUs){ foreach $k (@CPUs){ foreach $c (@CPUs){ foreach $v (@CPUs){
   foreach $kp (@CPUs){ foreach $eh (@CPUs){ foreach $t (@CPUs){
     $CONDITION="no";
     $t_max=($eh+1)/2;
     if ($q*$k*$c*$v==$np and $kp*$eh*$t==$np){ $CONDITION="yes"};
     if ( $eh<$t){ $CONDITION="no"};
     if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
     if ( -e "GAMMA" and ( $k>1 or $kp>1 or ($t>$t_max))){ $CONDITION="no"};
     if ( -e "NO_VALENCE" and $v>1){ $CONDITION="no"};
     if ( -e "NO_CONDUCTION" and $c>1){ $CONDITION="no"};
     if ( $CONDITION=~"yes"){
      $ir++;
      $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\" BS_CPU=\"$kp.$eh.$t\"";
     };
   }}}}}}};
   $Nr=$ir;
   return;
  }
  #
  # HF, SC or e-p
  #
  if ( (($HF=="1" and $GW=="0") or $SC=="1" or ($GW=="1" and $EP=="1")) and $COLL=="0" and $NEGF=="0" ) { 
   foreach $q (@CPUs){ foreach $qp (@CPUs){ foreach $b (@CPUs){
     $CONDITION="no";
     if ($q*$qp*$b==$np){ $CONDITION="yes"};
     if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
     if ( $CONDITION=~"yes"){
      $ir++;
      $RUN_spec[$ir]="SE_CPU=\"$q.$qp.$b\"";
     };
   }}};
   $Nr=$ir;
   return;
  }
  #
  # RT
  #
  if ($SC=="1" and $NEGF=="1" and $COLL=="0") {
   foreach $k (@CPUs){ foreach $b (@CPUs){ foreach $q (@CPUs){ foreach $qp (@CPUs){
     $CONDITION="no";
     if ($k*$b*$q*${qp}==$np){ $CONDITION="yes"};
     if ( -e "GAMMA" and $k>1){ $CONDITION="no"};
     if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
     if ( $CONDITION=~"yes"){
      $ir++;
      $RUN_spec[$ir]="RT_CPU=\"$k.$b.$q.${qp}\"";
  }}}}}$Nr=$ir;return}
  #
  # EM1S+Collisions
  #
  if ($EM1S=="1" and $COLL=="1") { 
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
       $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\" RT_CPU=\"$k.$b.$q.${qp}\"";
      }
      else
      {
       $ir++;
       $RUN_spec[$ir]="X_all_q_CPU=\"$q.$k.$c.$v\" SE_CPU=\"$q.$qp.$b\"";
      };
     };
   }}}}}}};
   $Nr=$ir;
   return;
  }
  #
  # COLLISIONS
  #
  if ($COLL=="1" ) { 
   foreach $q (@CPUs){ foreach $qp (@CPUs){ foreach $b (@CPUs){
     $CONDITION="no";
     if ($q*$qp*$b==$np){ $CONDITION="yes"};
     if ( -e "GAMMA" and $q>1){ $CONDITION="no"};
     if ( $CONDITION=~"yes"){
      $ir++;
      $RUN_spec[$ir]="SE_CPU=\"$q.$qp.$b\"";
  }}}}$Nr=$ir;return}
 }
}
