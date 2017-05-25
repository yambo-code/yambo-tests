#!/usr/bin/perl
#
# Copyright (C) 2015-2016 A. Marini and C. Hogan
#
# TODO:
# Check that a branch exists
# Capture output of which
# Substitute dircopy,timing etc
# User defined hosts
# Cross compiling
#
use Getopt::Long;
use File::Find;
use File::Spec;
use File::Copy;
use File::Path 'rmtree';
#use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
use Cwd 'abs_path';
use Cwd;
use Net::Domain qw(hostname hostfqdn hostdomain domainname);
#
# Identify the host
#
$host=hostname().".".hostdomain();
if(!hostdomain()){ $host=hostname() };
$listtests="default";
# Flush output
$|=1;
# Default precision
$prec=0.01;
$project="none"; # default
# Glob available configurations
# Check here that CONF exists, etc
# Also, if no branches found, give error
opendir(DIR,"./CONFIGURATIONS/$host");
@files = grep { (!/^\./) && -f "./CONFIGURATIONS/$host/$_" } readdir(DIR);
closedir DIR;
$conf_avail = join(" ", @files);
#
# date
#
my $ret = &GetOptions("h"           => \$help,
            "m=s"            => \$material,
            "i=s"            => \$select_input_file,
            "np=i"           => \$np_single,
            "np_min=i"       => \$np_min,
            "np_max=i"       => \$np_max,
            "nt=i"           => \$nt,
            "nl=i"           => \$nl,
            "def_par"        => \$default_parallel,
            "rand_par"       => \$random_parallel,
            "openmp_is_off"  => \$openmp_is_off,
            "par_conf=i"     => \$par_conf,
            "l:s"            => \$listtests,
            "d=s"            => \$download,
            "c"              => \$clean,
            "compile"        => \$compile,
            "e"              => \$extended,
            "par_only"       => \$par_only,
            "u"              => \$upload_logs,
            "b"              => \$backup_logs,
            "v+"             => \$verb,
            "a"              => \$add_outputs,
            "conf=s"         => \$select_conf_file,
            "branch=s"       => \$branch,
            "gpl=s"          => \$is_GPL,
            "tests=s"        => \$tests,
            "theme=s"        => \$theme,
            "prec=s"         => \$prec,
            "p=s"            => \$project,
            "host=s"         => \$my_host,
            "a=s"            => \$tol,
            "t=s"            => \$tag);
 
sub usage {


 print <<EndOfUsage

   Running on host: $host
   Available confs: $conf_avail
   Syntax: run_me.pl <ARGS>
           < > are variable parameters, [ ] are optional, | indicates choice
           
   where <ARGS> must include at least one of:
             -h                    This help & svn status
             -l       [<SET>]      List available SETs (-l) or input files for a SET (-l <SET>)
             -c                    Clean
             -d        <SET>|all   Download & Update the core databases 
             -compile              Compile the sources
             -tests  <TESTS>|all   List* of tests to perform, or all "-tests all"
             -theme  <THEME>       Use predefined list of tests, defined in THEMES/ directory

   (test options)
             -gpl    <yes/no>      Test only GPL features              (default: no)
             -p     <PROJ>|all     Test also yambo project PROJ or all (default: none)
             -e                    Extended tests                      (default: skip Hard tests)
             -conf  <NAME>         Use configuration NAME              (default: precompiled execs)
             -prec  <PREC>         Precision of data comparisons       (default: 0.01 = 1% of MAX value)

   (parallel options)
             -np     <N>           Fixed number of CPU used
             -np_min <N>           Minimum number of CPU used
             -np_max <N>           Maximum number of CPU used
             -nt     <T>           # of OMP threads
             -nl     <L>           # of CPU used for linear algebra
             -def_par              Use the default parallelization scheme
             -rand_par             Use randomly generated parallel structures
             -openmp_is_off        Switch openmp off
             -par_only             Runs only tests flagged by a [P]

	 (miscellaneous options)
             -v [-v]               Verbose output (use -v -v for extra verbosity)
             -u                    Create LOG dir and UPLOAD the LOGs at the end
             -b                    Create LOG dir and BACKUP the LOGs at the end
             -a                    Add and remove REFERENCE files (do not overwrite) 
             -t                    Run tag

 * <TESTS> has form: "<SET1> {<input1> [<input2>]|all}; <SET2> {<input1> [<input2>]|all}"
                      where <SET1> is a path within the tests folder 
                        and <input1> <input2>.. is a list of inputs (or all)
                       e.g. -tests "Si_bulk/GW/2x2x2 01_init 02_eels ; Al111 all" 


EndOfUsage
  ;
  exit;
}
# Die if unknown options or no options are given.
die usage() unless $help or ($listtests !~"default") or $clean or $download or $compile or $material or $tests or $theme or $upload_logs or $backup_logs;
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
   $system_command = "svn st | grep -v '.gz' | grep -v 'SAVE/ns.' | grep -v 'elph_gkkp' | grep -v '";
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
# The -l:s means optional argument to -l: "default"|""|$listtests
#
if(!$listtests){  # -l without options, "default" is overwritten
   $cmd="./scripts/driver.pl -l";
   if ($project) {$cmd="./scripts/driver.pl -l -p $project"};
   if ($par_only) {$cmd="./scripts/driver.pl -l -p $project -par_only"};
   system ($cmd);
   die "Done.\n";
}
if($listtests and $listtests !~ "default"){  # -l with options, but not the default
   print "Available input files for $listtests are: ";
   find(\&inputs, "./tests");
   sub inputs {
      my $fullpath = $File::Find::name;
      # Contains material + $input_folder/00 but not INPUT/00_X.conf etc
      if($fullpath =~ m|$listtests/$input_folder/\d\d| and $fullpath !~ m|$input_folder/\d\d\*.\w| ) {
         my @subdirs = File::Spec->splitdir( $fullpath );
         push (@testlist,@subdirs[-1]);
      };
   }
   print join(" ", sort @testlist)."\n"; 
   die "Done.\n";
}
#
# Prepare logs
#
@months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
@days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year=$year+1900;
my $date="Date:$days[$wday]-$mday-$months[$mon]-$year Time:$hour-$min";
$TEST_dir="$host-$mday-$months[$mon]-$days[$wday]";
if ($tag) {$TEST_dir="$host-$mday-$months[$mon]-$days[$wday]-$tag";};
#
$TEST_subdir="NP1";
if ($np_min)    {$TEST_subdir="NP$np_min-$np_max"};
if ($np_single) {$TEST_subdir="NP$np_single"};
if ($nt)        {$TEST_subdir="$TEST_subdir-NT$nt"};
if ($nl)        {$TEST_subdir="$TEST_subdir-NL$nl"};
if ($openmp_is_off) {$TEST_subdir="$TEST_subdir-OpenMPoff"};
# Local directories to collect logs
if ($backup_logs){
   system("mkdir -p $TEST_dir");
   if (!$tests and !$theme) { 
    &quick_backup;
    die "\n";
    };
   if ($compile) {system("mkdir -p $TEST_dir/compilation")};
   system("mkdir -p $TEST_dir/$TEST_subdir");
}else{
   $TEST_dir=".";
   $TEST_subdir=".";
};
#
# Clean and exit
#
if($clean){ 
   print "Cleaning...\n";
   $cmd="./scripts/driver.pl -c";
   $cmd.= " -v" if ($verb);
   system("$cmd");
   $cmd="rm -f Tests* *log  scripts/find_the_diff.o scripts/find_the_diff scripts/Makefile";
   system("$cmd");
   die "Test databases/outputs and local logfiles removed.\n";
};

print "\n----- Starting Yambo test-suite ----- \n";
#
# Check (optional) external programs
#
# 1. find_the_diff
print " - Check requirements :\n";
$make_find_the_diff=1;  #compile
if(-e "./scripts/find_the_diff") {
  if(-x "./scripts/find_the_diff") {
     system("./scripts/find_the_diff > /dev/null");
     if ( $? != -1 ) {
        print "        find_the_diff : found\n";
        $make_find_the_diff=0;  #dont compile
     }
  }
  else { print "        find_the_diff : not found\n"};
};
# 2. system ncdump is available
$system_ncdump = `which ncdump`; chomp($system_ncdump);
if(-e $system_ncdump) { 
  print "               ncdump : found\n";
} else { print "               ncdump : not found\n"};
# 3. ncftpput
$ncftpput = `which ncftpput`; chomp($ncftpput);
if(-e $ncftpput) { 
  print "             ncftpput : found\n";
} else { print "             ncftpput : not found\n"};
# 4. txt2html
$txt2html = `which txt2html`; chomp($txt2html);
if(-e $txt2html) { 
  print "             txt2html : found\n";
} else { print "             txt2html : not found\n"};


#
# Check the requested configuration exists, if any
#
if($select_conf_file){
   if(!-e "CONFIGURATIONS/$host/$select_conf_file") {
      print "Couldn't find conf file $select_conf_file in ./CONFIGURATIONS/$host/. Stopping.\n" and exit;
   }
}
#
# Initialize parallelism
#
#if(!$project){ $project="any" };   # "any" never gets used later...
if(!$nt){ $nt="1" };
if(!$nl){ $nl="1" };
if(!$np_min){ $np_min="1" };
if(!$np_max){ $np_max=$np_min };
if($np_single) { 
  $np_min="$np_single";
  $np_max="$np_single";
  };
#
# Initialization of sources
#
$target_list_basic = "yambo ypp interfaces ";
$exec_list_basic = "yambo ypp a2y p2y ";
#
$project_list = "yambo_rt yambo_qed yambo_kerr yambo_ph yambo_sc yambo_magnetic yambo_pl yambo_nl ypp_sc ypp_magnetic ypp_rt ypp_ph ypp_nl";
$input_folder = "INPUTS";
#
if(!$is_GPL){ $is_GPL="no";}
#
if($is_GPL eq "yes"){
  $project_list = "yambo_kerr yambo_ph ypp_ph ";
  $input_folder = "INPUTS-GPL";
}
#
# Build the list of tests: -tests "list" / -tests all / -theme / 
# -theme 		Populate from THEMES/ folder
# -tests "list"		User defined list
# -tests all		All possible tests
#
if($tests and $theme){ die "Select only one of -tests or -theme option"};
if($tests){
  # If I find SAVE and $input_folder, treat as a working test dir.
  # Could also exclude BROKEN/HARD here.
  if($tests eq "all"){
    find(\&testdirs, "./tests");
    sub testdirs {
      my $fullpath = $File::Find::name;
      if($fullpath =~ m|INPUTS$|){    # The only folder ending ../$input_folder
         if ( -d "SAVE" || -d "SAVE_backup"){		      # Check ./SAVE also present
         $testdir = substr($fullpath,8,-7); 
         $alltests .= "$testdir all; ";
         }
      }
    }
    $tests = $alltests;
    print " - Test selection     : full suite\n";
  } 
  else {
    print " - Test selection     : from input\n";
  }
}
if($theme){
    open(THEME,"<","THEMES/$theme") or die "Error opening theme file THEMES/$theme\n";
    while($line = <THEME>) {
      chomp $line;
      $tests .= $line."; ";
    }
    print        " - Test selection     : from theme file $theme\n";
}
if($tests){
  @dummy= split(/\s*;\s*/, $tests);
  $numtests = @dummy; # Number of elements
  print "            Available : $numtests\n";
  print "                        ".join("\n                        ",@dummy)."\n" unless $alltests;
}
print " - Projects           : $project\n";
print " - Precision          : $prec\n";
#---------------------------#
# Loop on BRANCHES
#---------------------------#
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
      print "Skipping branch: $branchdir\n" if ($verb);
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
   print " - Branch path        : $branchdir\n" if ($verb);
   print "          shortname   : $dir\n" if ($verb);

   #
   # Define list of required executables
   #
   $target_list = $target_list_basic; $exec_list = $exec_list_basic;
   # If project = all or user-selected 
   if ($project !~ "none") { $target_list .= $project_list; $exec_list .= $project_list }

   #-------------------------------#
   # Loop on CONFIGURATIONS 
   #-------------------------------#
   $conf_done_once="";
   LOOP_CONF: foreach $conf_path (<CONFIGURATIONS/$host/*>){
      #
      # Options: all/$select_conf_file/precompiled (default)
      # If one conf has been given in input, ignore all the others
      #
      $conf_file = (split(/\//, $conf_path))[-1];
      $conf_bin  = "bin-$conf_file";
      if($select_conf_file){
         if (not $conf_file =~ $select_conf_file and $select_conf_file ne "all"){ next LOOP_CONF};
      } 
      else {
         # If $select_conf_file is not specified, run only once using bin 
         if($conf_done_once) {next LOOP_CONF};
         $conf_file = "precompiled";
         $conf_bin  = "bin";
         $conf_done_once="true"; 
      }
      print " - Using yambo source : $BRANCH \n";
      print "        configuration : $conf_file \n";
      print "              bin dir : $conf_bin \n";
      #
      # Compile the code if requested
      #
      if($compile) {
         chdir $BRANCH;
         print "                      > Updating ...";
         system("chdir $BRANCH; git pull 2>&1");
         print "                      > Configuring sources...";
         # Configure and compilation logs (full paths)
         if($backup_logs){
            $conf_logfile = "$cwd/$TEST_dir/compilation/".$dir."-".$conf_file."_config.log";
            $comp_logfile = "$cwd/$TEST_dir/compilation/".$dir."-".$conf_file."_compile.log";
         } else {
            $conf_logfile = "$cwd/Tests-".$dir."-".$conf_file."_config.log";
            $comp_logfile = "$cwd/Tests-".$dir."-".$conf_file."_compile.log";
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
         #
         # Basic check that configure worked
         #
         if (-e "Makefile"){ print "success.\n"}
         else {
            print "FAILED! Skipping.\n";
            next LOOP_CONF;
         }
         #
         # Compile the required executables, log the output
         # Split the targets or use system in some way for refreshed output, but redirecting standard error (tee?)
         #
         print " - Requested targets  : $target_list\n ";

         print "                      > Compiling : ";
         open( COMPLOGFILE,'>',$comp_logfile);
         @executables = split(/ /, $target_list);
         while($make_exec = shift(@executables)) {
           print "$make_exec ...";
           $result = `make -j $make_exec 2>&1`;
           print COMPLOGFILE $result;
         }
         close(COMPLOGFILE);
         print "done.\n";
         #
         # Copy executables to a config-dependent directory
         # This will OVERWRITE any existing files
         #
         $cmd = "rm -fr $conf_bin; cp -fr bin $conf_bin";
         system("$cmd");
      }  
      #
      # Check the yambo executables exist
      # If not $compile, use existing executables
      #
      chdir $cwd;
      print " -  Executable checks : ";
      @executables = split(/ /, $exec_list);
      while($check_exec = shift(@executables)) {
         if( -x "$BRANCH/$conf_bin/$check_exec") { print "($check_exec $color_start{green}OK$color_end{green}) "};
         if(!-x "$BRANCH/$conf_bin/$check_exec") { print "($check_exec $color_start{red}FAIL$color_end{red})"};
      }
      print "\n";
      if(! -x "$BRANCH/$conf_bin/yambo"){  
         # Should decide on test behaviour if some fails are present
         # Create separate .error files?
         print "Core executable missing from $BRANCH, skipping...\n";
         next LOOP_BRANCH; 
      }
      #
      # Run the input file generation tests in Inputs testdir
      #
      if($check_input_generation) {
        chdir('./tests/Inputs');
        print "AAAAB\n";
        @yambo_flags = ('-i','-r',
#        	'-x','-p p','
#		'-g n','-g s','-g g',
#		'-o g','-o c',
#		'-k hartree','-k alda',
#		'-y h'	,'',
 		);
#       while(($flag,$label) = splice(@yambo_flags,0,2)) {
#       Run setup first
        while($flag = shift(@yambo_flags)) {
          $flag_ = ($flag =~ s/\w/_/);
          $ref_file1 = "yambo.in_".$flag_;
          $cmd = "$BRANCH/$conf_bin/yambo $flag -F yambo.in_run_".$flag_;
#         if(!-x "$BRANCH/$conf_bin/$check_exec") { next; }
#          $result = `$BRANCH/$conf_bin/yambo $flag -F yambo.in_$label`;
          print "AAAA $cmd\n";
          system("$cmd 2>/dev/null  ; ls");
          fldiff yambo.in_run_$flag_ $ref_file1;
          $ref_file2 = "yambo.in_".$flag."_-V_all";
          $cmd = "$BRANCH/$conf_bin/yambo $flag -F yambo.in_run_$flag_";
          system("$cmd 2>/dev/null  ; ls");
        }
        chdir $cwd;
      }
      #
      # Run the tests through driver.pl, looping over CPUs. 
      #
      if ($tests) {   
         # Try to compile the find_the_diff fortran code if necessary
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
         if(!-e "$BRANCH/$conf_bin/ncdump" and !-e $system_ncdump) { die "No ncdump executable found.\n"} ;

         chdir $cwd;
         for (my $NP=$np_min; $NP<= $np_max ; $NP++){
            $cmd="./scripts/driver.pl -c";
            system("$cmd");
            $ROOT="./scripts/driver.pl -b $dir-$conf_file -k -np $NP -nt $nt -nl $nl -prec $prec";
            if ($NP>1) 		{$ROOT.=" -mpi mpirun";}
            if ($tol) 		{$ROOT.=" -t $tol";}
            if ($openmp_is_off) {$ROOT .= " -openmp_is_off"};
            if ($verb eq 1) 	{$ROOT.=" -v";}
            if ($verb ge 2) 	{$ROOT.=" -v -v";}
            if ($default_parallel) {$ROOT.=" -def_par";}
            if ($random_parallel)  {$ROOT.=" -rand_par";}
            if ($add_outputs) 	{$ROOT.=" -a";}
            if ($extended) 	{$ROOT.=" -hard";}
            if ($par_only) 	{$ROOT.=" -par_only";}
            # Launch driver.pl $BRANCH/$conf_bin for the executable
            # Always pass in $project; never $exec
            $system_command = "$ROOT -p $project -path '$BRANCH/$conf_bin' -tests \"$tests\" -gpl \"$is_GPL\" ";
            print "$system_command \n" if ($verb);
            system ($system_command);
         } # end parallel
      } # end $tests
   } # End LOOP_CONF configurations
   # 
   # LOG handling
   # 
   if ($backup_logs){
      my $o_file=$TEST_subdir.'-outputs_and_reports-'.$dir.'-'.$conf_file.'-'.$host;
      $cmd = "find . -name 'o-*' -o -name 'r-*' | grep -v 'REFERENCE' | xargs tar cvf $o_file.tar";
      system ($cmd);
      $cmd = "rm -f $o_file.tar.gz; gzip $o_file.tar";
      system ($cmd);
      foreach $conf_file (<ERROR*.log>) {
         $cmd = "cat < $conf_file >>  $TEST_dir/ERROR-$TEST_dir";
         print $cmd."\n" if ($verb);
         system ($cmd);
         };
      foreach $conf_file (<*.log>) {
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

print "\nDone.\n";
#
sub quick_backup
{
 my $o_file="outputs_and_reports-$host-$mday-$months[$mon]-$days[$wday]_$hour-$min";
 $cmd = "find . -name 'o-*' -o -name 'r-*' | grep -v 'REFERENCE' > list";
 system ($cmd);
 $cmd = "tar cvf $o_file.tar -T list";
 system ($cmd);
 $cmd = "rm -f $o_file.tar.gz list; gzip $o_file.tar";
 system ($cmd);
 foreach $conf_file (<ERROR*.log>) {
    $cmd = "cat < $conf_file >>  $TEST_dir/ERROR-$TEST_dir";
    print $cmd."\n" if ($verb);
    system ($cmd);
    };
 foreach $conf_file (<*.log>) {
    $cmd = "txt2html < $conf_file > $TEST_dir/$conf_file.html";
    print $cmd."\n" if ($verb);
    $cmd = "cp $conf_file $TEST_dir";
    print $cmd."\n" if ($verb);
    system ($cmd);
    };
 foreach $conf_file (<*outputs_and_reports*gz>) {
    $cmd="mv $conf_file $TEST_dir/$conf_file";
    system("$cmd");
    };
}
