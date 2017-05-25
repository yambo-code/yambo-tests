#!/usr/bin/perl
#
# Copyright (C) 2015 A. Marini and C. Hogan
#
use Getopt::Long;
use File::Find;
use File::Spec;
use Time::HiRes qw(gettimeofday tv_interval);
use Cwd 'abs_path';
use Net::Domain qw(hostname hostfqdn hostdomain domainname);
#
# Identify the host
#
$host=hostname().".".hostdomain();
if(!hostdomain()){ $host=hostname() };
#
my $ret = &GetOptions("h"           => \$help,
            "m=s"            => \$material,
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
            "conf=s"         => \$conf_file,
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
                   -conf  [NAME]/all  Use only configuration NAME (use "-conf all" to loop)
                   -a      [TOL]      Tolerance (h)arder/(e)asier/(b)asic

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
# Not used:
#            "t=s"            => \$specific_tests,
# -t      [LIST]     List of specific tests (input files)


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
   $cmd="rm -f Tests* *log";
   system("$cmd");
   die "Test databases/outputs and local logfiles removed.\n";
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
# Date and time
@months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
@days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year=$year+1900;
my $date="Date:$days[$wday]-$mday-$months[$mon]-$year Time:$hour-$min";
my $TEST_dir="$host-$mday-$months[$mon]-$days[$wday]";
#
#my $TEST_subdir="$mday-$months[$mon]-$days[$wday]-$hour-$min-$sec-NP$np_min-$np_max-NT$nt";
my $TEST_subdir="NP$np_min-$np_max-NT$nt";
if ($openmp_is_off) {$TEST_subdir="$TEST_subdir-OpenMPoff"};
# Check the following line, I'm not sure if it's correct
if ($compile) {$TEST_subdir="compilation"};
#system("mkdir -p $TEST_dir");
#system("mkdir -p $TEST_dir/$TEST_subdir");
if ($upload_logs){
 system("mkdir -p $TEST_dir");
 system("mkdir -p $TEST_dir/$TEST_subdir");
}else{
 $TEST_dir=".";
 $TEST_subdir=".";
};
#
$is_GPL="no";
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
   # $dir is used in name of report file, / swapped with _
   # $BRANCH is the absolute path to the branch
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
   #-------------------------------#
   # Loop on CONFIGURATIONS 
   #-------------------------------#
   LOOP_CONF: foreach $file (<CONFIGURATIONS/$host/*>){
      #
      # If one conf has been given in input, ignore all the others
      #
      if ($conf_file){
         if (not $file =~ $conf_file){ next LOOP_CONF};
      };
      #
      # Compile the code if requested
      #
      if($compile) {
         print " - Compiling yambo with: $file \n";
         print "                 branch: $BRANCH \n";
         chdir $BRANCH;
         $file_=$file;
         $file_ =~ s/\//_/;
         $cmd="test -e Makefile && make clean_all";
         system("$cmd");
         # Run each config script
         $cmd="$cwd/$file > $cwd/$TEST_dir/$TEST_subdir/".$dir."-".$file_."_config.log";
         system("$cmd");
         if ($is_GPL =~ "no") {
            if ($project =~ "none") {
               $cmd="make yambo ypp interfaces > $cwd/$TEST_dir/$TEST_subdir/".$dir."-".$file_."_compile.log";
            }
            else{
               $cmd="make yambo yambo_rt yambo_qed yambo_ph yambo_sc ypp ypp_rt ypp_ph interfaces > $cwd/$TEST_dir/$TEST_subdir/".$dir."-".$file_."_compile.log";
            }
         }
         else {
            $cmd="make yambo yambo_ph ypp ypp_ph interfaces> $cwd/$TEST_dir/$TEST_subdir/".$dir."-".$file_."_compile.log";
         }
         system("$cmd");
      }
      #
      # Otherwise check at least the yambo executable exists
      #
      else {
         if(! -e $BRANCH."/bin/yambo"){  
            print "No executables present in $BRANCH, skipping...\n";
            next LOOP_BRANCH; 
         }
      }
      #
      # Run the tests, looping over CPUs. If no $material present, only compilation is checked.
      #
      if ($material) {   
         chdir $cwd;
         for (my $NP=$np_min; $NP<= $np_max ; $NP++){
            $cmd="./scripts/driver.pl -c";
            system("$cmd");
            $ROOT="./scripts/driver.pl -b $dir -k -np $NP -nt $nt";
            if ($NP>1) {$ROOT="./scripts/driver.pl -b $dir -k -np $NP -nt $nt -mpi mpirun";}
            if ($tol) {$ROOT="$ROOT -t $tol";}
            if ($openmp_is_off) {$ROOT="$ROOT -openmp_is_off";}
            if ($verb) {$ROOT="$ROOT -v";}
            if ($default_parallel) {$ROOT="$ROOT -def_par";}
            if ($add_outputs) {$ROOT="$ROOT -a";}
            if ($dd_outputs) {$ROOT="$ROOT -a";}
            #-------------------------------#
            # Loop on TESTS using $BRANCH/bin for the executable
            #-------------------------------#
            &run_the_tests;
         }
      }
   } # End LOOP_CONF configurations
   # 
   # LOG handling
   # 
   if ($upload_logs){
      my $o_file=$TEST_subdir.'-outputs_and_reports-'.$dir.'-'.$host;
      $cmd = "find . -name 'o-*' -o -name 'r-*' | grep -v 'REFERENCE' | xargs tar cvf $o_file.tar";
      system ($cmd);
      $cmd = "rm -f $o_file.tar.gz; gzip $o_file.tar";
      system ($cmd);
      foreach $file (<Tests*log>) {
         $cmd = "txt2html < $file > $file.html";
         print $cmd."\n" if ($verb);
         system ($cmd);
         $cmd="mv $file $TEST_dir/$TEST_subdir";
         system ($cmd);
         };
      foreach $file (<Tests*error>) {
         $cmd="mv $file $TEST_dir/$TEST_subdir";
         system ($cmd);
         };
      foreach $file (<*outputs_and_reports*gz>) {
         $cmd="mv $file $TEST_dir/$file";
         system("$cmd");
         };
      foreach $file (<*.html>) {
         $cmd="mv $file $TEST_dir/$TEST_subdir-$file";
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
#
sub run_the_tests
{
foreach $dir (<*>,<*/*>,<*/*/*>,<*/*/*/*>,<*/*/*/*/*>,<*/*/*/*/*/*>) {      # Glob all files
 if (-d $dir."/SAVE" && -d $dir."/INPUTS" )
  {
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
     $system_command = "$ROOT -p $project -path '$BRANCH/bin' -tests '$file all'";
     print "$system_command \n" if ($verb);
     system ($system_command);
    }
   }
  }
}
}
