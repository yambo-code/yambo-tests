#!/usr/bin/perl
#
# Copyright (C) 2015 A. Marini and C. Hogan
#
use Getopt::Long;
use File::Find;
use File::Spec;
use File::Copy;
use File::Path 'rmtree';
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
use Time::HiRes qw(gettimeofday tv_interval);
use Cwd 'abs_path';
use Net::Domain qw(hostname hostfqdn hostdomain domainname);
#
# Identify the host
#
$host=hostname().".".hostdomain();
if(!hostdomain()){ $host=hostname() };
#
# date
#
#
my $ret = &GetOptions("h"           => \$help,
            "m=s"            => \$material,
            "i=s"            => \$select_input_file,
            "np=i"           => \$np_single,
            "np_min=i"       => \$np_min,
            "np_max=i"       => \$np_max,
            "nt=i"           => \$nt,
            "def_par"        => \$default_parallel,
            "openmp_is_off"  => \$openmp_is_off,
            "l"              => \$listtests,
            "d=s"            => \$download,
            "c"              => \$clean,
            "compile"        => \$compile,
            "e"              => \$extended,
            "u"              => \$upload_logs,
            "v"              => \$verb,
            "a"              => \$add_outputs,
            "conf=s"         => \$select_conf_file,
            "branch=s"       => \$branch,
            "p=s"            => \$project,
            "a=s"            => \$tol);
 
sub usage {


 print <<EndOfUsage

   Running on host: $host
   Syntax: run_me.pl [ARGS]

         where [ARGS] must include at least one of:
                   -h                 This help
                   -l                 List available tests and stop
                   -c                 Clean
                   -d     [TEST]/all  Download & Update the core databases 
                   -compile           Compile the sources
                   -m [MATERIAL]/all  Run one MATERIAL (e.g. "-m SiH4") or all standard tests. ("-m all")

         (test options)
                   -p      [PJ]       Test only this internal Project (e.g. sc,none,any)
                   -e                 Extended tests (run also Hard tests)
                   -conf  [NAME]      Use only configuration NAME (default is all)
                   -a      [TOL]      Tolerance (h)arder/(e)asier/(b)asic
                   -i     [INPUTS]    Run only the input files INPUTS for this MATERIAL (e.g. -i "01_init 02_eels")

         (parallel options)
                   -np     [N]        Fixed number of CPU used
                   -np_min [N]        Minimum number of CPU used
                   -np_max [N]        Maximum number of CPU used
                   -nt     [T]        # of OMP threads
                   -def_par           Skip loop on parallel structures
                   -openmp_is_off     Switch openmp off

	 (miscellaneous options)
                   -v                 Verbose output
                   -u                 Create LOG dir and upload the LOGs at the end
                   -a                 Add and remove REFERENCE files (do not overwrite) 


EndOfUsage
  ;
  exit;
}
# Note that driver.pl can accept the test list according to:
#                  -tests  [TESTS]      List of tests to perform
#        [TESTS] has form: "DIR1 [test1 test2 ..]; DIR2 [test1 test2...]"
#                           where DIR1 is the directory containing the material-specific tests
#                           test1 is the name of the test to perform. 
# Not used:
#            "t=s"            => \$specific_tests,
# -t      [LIST]     List of specific tests (input files)
# instead of specifying material and inputs separately
# I don't know if this functionality still works


#
# Die if unknown options or no options are given.
#
die usage() unless $help or $listtests or $clean or $download or $compile or $material;
#
# Check, if STDOUT is a terminal. If not, not ANSI sequences are emitted.
#
if(-t STDOUT) {
     $color_start{blue}="\033[34m";
     $color_end{blue}="\033[0m";
     $color_start{red}="\033[31m";
     $color_end{red}="\033[0m";
     $color_start{green}="\033[32m";
     $color_end{green}="\033[0m";
}
# The location of the test-suite directory
my $cwd=abs_path();
#
# Report usage, show extra files and exit
#
if($help){ 
   $system_command = "svn st | grep -v '.gz' | grep -v 'SAVE/ns.' | grep -v 'elph_gkkp'";
   print "Warning: some unversioned files present. Cleaning advised.\n";
   system ($system_command);
   usage ;
   die "\n";
};
#
# Download and exit
#
if($download){  
   !
   print "\n";
   $cmd="./scripts/driver.pl -d $download";
   system ($cmd);
   #
   #   Re-extract databases
   #
   $cmd="./scripts/driver.pl -x";
   system("$cmd");
   die "Download complete.\n";
}
#
# List tests and exit
#
if($listtests){
   print "\n";
   $cmd="./scripts/driver.pl -l";
   system ($cmd);

   if($material){
      print "Available test input files for $material are:";
      find(\&inputs, "./tests");
      sub inputs {
         my $fullpath = $File::Find::name;
         # Contains material + INPUTS/00 but not .conf etc
         if($fullpath =~ m|$material.*INPUTS/\d\d| and $fullpath !~ m|\.\w| ) {
            my @subdirs = File::Spec->splitdir( $fullpath );
            print @subdirs[-1]." ";
         };
      }
      print "\n"; }
    else {
       print "Add -m [...] to list available tests for a particular material.\n";
    }
   die "Done.\n";
}
#
# Clean and exit
#
if($clean){ 
   print "Cleaning...\n";
   $cmd="./scripts/driver.pl -c";
   system("$cmd");
   $cmd="rm -f Tests* *log  scripts/find_the_diff.o scripts/Makefile";
#  $cmd="rm -f Tests* *log scripts/find_the_diff  scripts/find_the_diff.o scripts/Makefile";
   system("$cmd");
   die "Test databases/outputs and local logfiles removed.\n";
};
#
# Check find_the_diff exists (does it need to be cleaned?)
#
$make_find_the_diff=1;  #compile
if(-e "./scripts/find_the_diff") {
  print "Checking Fortran program ./scripts/find_the_diff ... ";
  if(-x "./scripts/find_the_diff") {
     system("./scripts/find_the_diff > /dev/null");
     if ( $? != -1 ) {
        print "ok $? \n";
        $make_find_the_diff=0;  #dont compile
     }
  }
  else { print "not found. Compiling.\n";}
};
#
# Initialize parallelism
#
if(!$project){ $project="any" };   # "any" never gets used later...
if(!$nt){ $nt="1" };
if(!$np_min){ $np_min="1" };
if(!$np_max){ $np_max=$np_min };
if($np_single) { 
  $np_min="$np_single";
  $np_max="$np_single";
  };
#
# Prepare logs
#
@months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
@days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $date="Date:$days[$wday]-$mday-$months[$mon]-$year Time:$hour-$min";
$year=$year+1900;
my $TEST_dir="$host-$mday-$months[$mon]-$days[$wday]";
my $TEST_subdir="NP$np_min-$np_max-NT$nt";
if ($openmp_is_off) {$TEST_subdir="$TEST_subdir-OpenMPoff"};
# Local directories to collect logs
if ($upload_logs){
   system("mkdir -p $TEST_dir");
   system("mkdir -p $TEST_dir/compilation");
   system("mkdir -p $TEST_dir/$TEST_subdir");
}else{
   $TEST_dir=".";
   $TEST_subdir=".";
};
#
# Initialization of sources
#
$target_list = "yambo ypp interfaces ";
$exec_list = "yambo ypp a2y ";  # for now anyway
$project_list = "yambo_rt yambo_qed yambo_ph yambo_sc ypp_rt ypp_ph ";
$gpl_list = "yambo_ph ypp_ph ";
$is_GPL="no";
# Select specific test
if($material){
  if($select_input_file) {$input_file_list = $select_input_file}
  else {$input_file_list = "all"};
  # Can't select for all materials (at present)
  if($material =~ "all") {$input_file_list = "all"}
}

#---------------------------#
# Loop on BRANCHES
#---------------------------#
print "Running tests. Check *.log files for progress.\n";
open(BRANCHES_file,"<","BRANCHES/LIST.$host");
#
@branches = <BRANCHES_file>;
LOOP_BRANCH: while($branchdir = shift(@branches)) {
   chomp $branchdir;
   # Branch record starts with / means full path
   # Branch record starts with # means skip
   # $BRANCH is the absolute path to the branch
   # $dir is short string of BRANCH for filenames, / swapped with _
   if($branchdir =~ /^#/) {
      print "Skipping branch: $branchdir\n";
      next LOOP_BRANCH; 
   }
   elsif($branchdir =~ /^\//) {
      $BRANCH=$branchdir;
      my @subdirs = File::Spec->splitdir( $branchdir );  
      # Make shortname from last two subdirs in full path
      $dir= @subdirs[-2]."_".@subdirs[-1];
   }
   else {
      $BRANCH="$cwd/../../$branchdir";
      if( ! -e "$BRANCH") { $BRANCH="$cwd/../$branchdir"; };
      if( ! -e "$BRANCH") { $BRANCH="$branchdir"; };  # Could be an error
      # Replace / with _ for filenames
      ($dir = $branchdir) =~ s/\//_/g;
   }
   if( ! -e "$BRANCH") { print "ERROR: cannot find $BRANCH, skipping!\n"; next; };
   print "Running branch: $branchdir\n";
   print "     shortname: $dir\n";
   if ($dir=~m/gpl/ix) {$is_GPL="yes"};

   #
   # Define list of required executables
   #
   if ($is_GPL =~ "yes") { $target_list .= $gpl_list; $exec_list   .= $gpl_list}
   else{
      if ($project !~ "none") { $target_list .= $project_list; $exec_list .= $project_list }
   }

   #-------------------------------#
   # Loop on CONFIGURATIONS 
   #-------------------------------#
   LOOP_CONF: foreach $conf_path (<CONFIGURATIONS/$host/*>){
      #
      # If one conf has been given in input, ignore all the others
      #

      $conf_file = (split(/\//, $conf_path))[-1];
      $conf_bin  = "bin-$conf_file";

      if ($select_conf_file){
         if (not $conf_file =~ $select_conf_file){ next LOOP_CONF};
      };
#     $conf_file_=$conf_file;
#     $conf_file_ =~ s/\//_/g;
#    $conf_bin = "bin-$conf_file_";
      print " - Using yambo configuration: $conf_path \n";
      print "                   conf bin : $conf_bin \n";
      print "                   in branch: $BRANCH \n";
      #
      # Compile the code if requested
      #
      if($compile) {
         print " - Configuring sources...";
         chdir $BRANCH;
         # Configure and compilation logs (full paths)
         if($upload_logs){
            $conf_logfile = "$cwd/$TEST_dir/compilation/".$dir."-".$conf_file."_config.log";
            $comp_logfile = "$cwd/$TEST_dir/compilation/".$dir."-".$conf_file."_compile.log";
	 } else {
            $conf_logfile = "$cwd/".$dir."-".$conf_file."_config.log";
            $comp_logfile = "$cwd/".$dir."-".$conf_file."_compile.log";
         }
         # If Makefile present, clean sources
         if(-e "Makefile") {$result = `make clean_all 2>&1`};
         #
         # Run this configure script, and log (append) the output, including STDOUT and STDERR
         # Backticks capture the output
         #
         $result = `$cwd/$conf_path 2>&1`;
         open( CONFLOGFILE,'>>',$conf_logfile);
         print CONFLOGFILE $result;
         close(CONFLOGFILE);
         print "done.\n";
         #
         # Basic check that configure worked
         #
         if (-e "Makefile"){ print " - Configure:     success.\n"}
         else {
            print " - Configure:     FAILED. Skipping.";
            next LOOP_CONF;
         }
         #
         # Compile the required executables, log the output
         # Split the targets or use system in some way for refreshed output, but redirecting standard error (tee?)
         #
         print " - Requested targets: $target_list\n ";
#        $cmd="make $target_list > $comp_logfile";
#        system("$cmd");

#        $result = `make $target_list 2>&1`;
#        open( COMPLOGFILE,'>>',$comp_logfile);
#        print COMPLOGFILE $result;
#        close(COMPLOGFILE);
#        print "done.\n";

         print "        > Compiling : ";
         open( COMPLOGFILE,'>',$comp_logfile);
      @executables = split(/ /, $target_list);
      while($make_exec = shift(@executables)) {
         print "$make_exec ";
         $result = `make $make_exec 2>&1`;
         print COMPLOGFILE $result;
      }
         close(COMPLOGFILE);
         print "done.\n";

         #
         # Copy executables to a config-dependent directory
         # This will OVERWRITE any existing files
         #
#        if(-e "bin/yambo") rmtree([ "./bin" ]);
         dircopy("bin",$conf_bin);
      }  
      #
      # Check the yambo executables exist
      # If not $compile, use existing executables
      #
      chdir $cwd;
      print "Compilation checks: $exec_list \n";
      @executables = split(/ /, $exec_list);
      while($check_exec = shift(@executables)) {
         if( -x "$BRANCH/$conf_bin/$check_exec") { print "$check_exec PASS\n"};
         if(!-x "$BRANCH/$conf_bin/$check_exec") { print "$check_exec FAIL\n"};
      }
      if(! -x "$BRANCH/$conf_bin/yambo"){  
         print "Core executables missing from $BRANCH, skipping...\n";
         next LOOP_BRANCH; 
      }
      # Compile the find_the_diff fortran code if necessary
      # This assumes setup file already present...
      if($make_find_the_diff){
         $cmd="cp $BRANCH/config/setup scripts/Makefile";
         print "$cmd \n" if ($verb);
         system("$cmd");
         chdir "scripts";
         $cmd="./make_the_makefile.sh";
         print "$cmd \n" if ($verb);
         system("$cmd");
         $cmd="./make";
         print "$cmd \n" if ($verb);
         system("$cmd");
         chdir "../";
      }
      # Check find_the_diff is available
      if(! -e "./scripts/find_the_diff") { die "Missing ./scripts/find_the_diff executable. Make it manually.\n"};
      # Check ncdump is available
      $system_ncdump = `which ncdump`; chomp($system_ncdump);
      if(!-e "$BRANCH/$conf_bin/ncdump" and !-e $system_ncdump) { print "WARNING: no ncdump executable found.\n"} ;
      #
      # Run the tests, looping over CPUs. (If no $material present, only compilation is checked.)
      #
      if ($material) {   
         chdir $cwd;
         for (my $NP=$np_min; $NP<= $np_max ; $NP++){
            $cmd="./scripts/driver.pl -c";
            system("$cmd");

#           $ROOT="./scripts/driver.pl -b $dir -k -np $NP -nt $nt";
#           if ($NP>1) {$ROOT="./scripts/driver.pl -b $dir -k -np $NP -nt $nt -mpi mpirun";}
            $ROOT="./scripts/driver.pl -b $dir-$conf_file -k -np $NP -nt $nt";
            if ($NP>1) {$ROOT="./scripts/driver.pl -b $dir-$conf_file -k -np $NP -nt $nt -mpi mpirun";}

            if ($tol) {$ROOT="$ROOT -t $tol";}
            if ($openmp_is_off) {$ROOT="$ROOT -openmp_is_off";}
#           if ($openmp_is_off) {$ROOT .= " -openmp_is_off"};
            if ($verb) {$ROOT="$ROOT -v";}
            if ($default_parallel) {$ROOT="$ROOT -def_par";}
            if ($add_outputs) {$ROOT="$ROOT -a";}
            if ($dd_outputs) {$ROOT="$ROOT -a";}
            #-------------------------------#
            # Loop on TESTS using $BRANCH/$conf_bin for the executable
            #-------------------------------#
            &run_the_tests;
         }
      }
   } # End LOOP_CONF configurations
   # 
   # LOG handling
   # 
   if ($upload_logs){
      my $o_file=$TEST_subdir.'-outputs_and_reports-'.$dir.'-'.$conf_file.'-'.$host;
      $cmd = "find . -name 'o-*' -o -name 'r-*' | grep -v 'REFERENCE' | xargs tar cvf $o_file.tar";
      system ($cmd);
      $cmd = "rm -f $o_file.tar.gz; gzip $o_file.tar";
      system ($cmd);
      foreach $conf_file (<Tests*log>) {
         $cmd = "txt2html < $conf_file > $conf_file.html";
         print $cmd."\n" if ($verb);
         system ($cmd);
         $cmd="mv $conf_file $TEST_dir/$TEST_subdir";
         system ($cmd);
         };
      foreach $conf_file (<Tests*error>) {
         open(dlog, '>', date);
         print dlog "$date\n";
         close(dlog);
         $cmd = "cat date $conf_file >> tmp; mv tmp $conf_file; txt2html < $conf_file >> $conf_file.html; rm -f date";
         print $cmd."\n" if ($verb);
         system ($cmd);
         $cmd="mv $conf_file $TEST_dir/$TEST_subdir";
         system ($cmd);
         };
      foreach $conf_file (<*outputs_and_reports*gz>) {
         $cmd="mv $conf_file $TEST_dir/$conf_file";
         system("$cmd");
         };
      foreach $conf_file (<*.html>) {
         $cmd="mv $conf_file $TEST_dir/$TEST_subdir-$conf_file";
         system("$cmd");
         };
    };
}; # End loop on BRANCHES
#
close(BRANCHES_file);
#
if ($upload_logs){
   $cmd="./scripts/driver.pl -u $TEST_dir";
   system("$cmd");
};
#
# END MAIN PROGRAM
#./scripts/driver.pl -b trunk_devel -k -np 1 -nt 1 -v -p any -path '/home/ ... /devel/bin' -tests 'Al111 all'
#
sub run_the_tests
{
foreach $dir (<*>,<*/*>,<*/*/*>,<*/*/*/*>,<*/*/*/*/*>,<*/*/*/*/*/*>) {      # Glob all files
  if (-d $dir."/SAVE" && -d $dir."/INPUTS" ) {
     my $file1 = (split(/\//, $dir))[-1];
     my $file2 = (split(/\//, $dir))[-2];
     my $file3 = (split(/\//, $dir))[-3];
     my $file4 = (split(/\//, $dir))[-4];
     my $file5 = (split(/\//, $dir))[-5];
     my $file6 = (split(/\//, $dir))[-6];
     my $file7 = (split(/\//, $dir))[-7];
     if ("$file7"eq"tests") { $mat="$file6"; $file = "$file6/$file5/$file4/$file3/$file2/$file1"};
     if ("$file6"eq"tests") { $mat="$file5"; $file = "$file5/$file4/$file3/$file2/$file1"};
     if ("$file5"eq"tests") { $mat="$file4"; $file = "$file4/$file3/$file2/$file1"};
     if ("$file4"eq"tests") { $mat="$file3"; $file = "$file3/$file2/$file1"};
     if ("$file3"eq"tests") { $mat="$file2"; $file = "$file2/$file1"};
     if ("$file2"eq"tests") { $mat="$file1"; $file = "$file1"};
     if ($extended || ( !$extended && !-f $dir."/HARD") ){
       if ( "$mat" eq "$material" or $material eq "all")  { 
#        $system_command = "$ROOT -p $project -path '$BRANCH/$conf_bin' -tests '$file all'";
         $system_command = "$ROOT -p $project -path '$BRANCH/$conf_bin' -tests '$file $input_file_list'";
         print "$system_command \n" if ($verb);
         system ($system_command);
       }
     }
  }
}
}
