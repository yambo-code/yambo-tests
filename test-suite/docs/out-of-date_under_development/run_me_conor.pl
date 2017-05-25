#!/usr/bin/perl
#
# Copyright (C) 2015 A. Marini and C. Hogan
#
# TODO:
# Substitute dircopy,timing etc
# Cross compiling
#
# Perl modules not installed:
# - Fermi: File::Which File::Copy::Recursive
# - Cluster: timing ..  use Time::HiRes qw(gettimeofday tv_interval);   # Not widely supported
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
#
my $ret = &GetOptions("h|H|help"           => \$help,
            "l:s"            => \$listtests,
            "c"              => \$clean,
            "d=s"            => \$download,
            "compile"        => \$compile,
            "tests=s"        => \$tests,
            "theme=s"        => \$theme,
            "input"          => \$run_input_checks,
            "p=s"            => \$project,
            "e"              => \$extended,
            "conf=s"         => \$select_conf_file,
            "prec=s"         => \$prec,
            "np=i"           => \$np_single,
            "np_min=i"       => \$np_min,
            "np_max=i"       => \$np_max,
            "nt=i"           => \$nt,
            "def_par"        => \$default_parallel,
            "openmp_is_off"  => \$openmp_is_off,
            "branch=s"       => \$branch_path,
            "host=s"         => \$my_host,
            "v+"             => \$verb,
            "u"              => \$upload_logs,
            "a"              => \$add_outputs);
 
sub usage {

 print <<EndOfUsage

   Syntax: run_me.pl <ARGS>
           < > are variable parameters, [ ] are optional, | indicates choice
           
   where <ARGS> must include at least one of:
             -h                    Usage, unversioned files, hostname, and available configurations
             -l       [<SET>]      List available SETs (-l) or input files for a SET (-l <SET>)
             -c                    Clean
             -d        <MAT>|all   Download & Update the core databases for one material (e.g. Si_bulk)
             -compile              Compile the sources
             -tests  <TESTS>|all   List* of tests to perform, or all "-tests all"
             -theme  <THEME>       Use predefined list of tests, defined in THEMES/ directory
             -input                Run checks on input file generation
   (test options)
             -p      <PROJ>|all    Test also yambo project PROJ or all (default: none)
             -e                    Extended tests                      (default: skip Hard tests)
             -conf   <NAME>|all    Use configuration NAME              (default: precompiled execs)
             -prec   <PREC>        Precision of data comparisons       (default: 0.01 = 1% of MAX value)
   (parallel options)
             -np     <N>           Fixed number of CPU used
             -np_min <N>           Minimum number of CPU used
             -np_max <N>           Maximum number of CPU used
             -nt     <T>           # of OMP threads
             -def_par              Skip loop on parallel structures
             -openmp_is_off        Switch openmp off
   (miscellaneous options)
             -branch <BRANCH>      Select branch path                  (default: from LIST.host file)
             -host   <HOST>        Overwrite the hostname 
             -v [-v]               Verbose output (use -v -v for extra verbosity)
             -u                    Create LOG dir and upload the LOGs at the end
             -a                    Add and remove REFERENCE files (do not overwrite) 

 * <TESTS> has form: "<SET1> {<input1> [<input2>]|all}; <SET2> {<input1> [<input2>]|all}"
                      where <SET1> is a path within the tests folder 
                        and <input1> <input2>.. is a list of inputs (or all)
                       e.g. -tests "Si_bulk/GW/2x2x2 01_init 02_eels ; Al111 all" 
EndOfUsage
  ;
  exit;
}
# Die if unknown options or no options are given.
die usage() unless $help or ($listtests !~"default") or $clean or $download or $compile or $tests or $theme or $run_input_checks;
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
# Overwrite host if necessary
if($my_host){
  print "WARNING: Overwriting host:$host with user-defined $my_host. Handle with care!\n";
  $host=$my_host;
}
#
# Download and exit
#
if($download){  
   !
   print "\n";
   $cmd="./scripts/driver_conor.pl -d $download";
   system ($cmd);
   #
   #   Re-extract databases
   #
   $cmd="./scripts/driver_conor.pl -x";
   system("$cmd");
   die "Download complete.\n";
}

#
# List tests and exit
# The -l:s means optional argument to -l: "default"|""|$listtests
#
if(!$listtests){  # -l without options, "default" is overwritten
   print "\n";
   $cmd="./scripts/driver_conor.pl -l";
   system ($cmd);
   die "Done.\n";
}
if($listtests and $listtests !~ "default"){  # -l with options, but not the default
   print "Available input files for $listtests are: ";
   find(\&inputs, "./tests");
   sub inputs {
      my $fullpath = $File::Find::name;
      # Contains SET + INPUTS/00 but not INPUT/00_X.conf etc
      if($fullpath =~ m|$listtests/INPUTS/\d\d| and $fullpath !~ m|INPUTS/\d\d\*.\w| ) {
         my @subdirs = File::Spec->splitdir( $fullpath );
         push (@testlist,@subdirs[-1]);
      };
   }
   print join(" ", sort @testlist)."\n"; 
   die "Done.\n";
}
#
# Clean and exit
#
if($clean){ 
   print "Cleaning...\n";
   $cmd="./scripts/driver_conor.pl -c";
   $cmd.= " -v" if ($verb);
   system("$cmd");
#  $cmd="rm -f Tests* *log  scripts/find_the_diff.o scripts/find_the_diff scripts/Makefile";
   $cmd="rm -f Tests* *log  scripts/find_the_diff.o scripts/Makefile";
   system("$cmd");
   die "Test databases/outputs and local logfiles removed.\n";
};
#
# Report usage, show extra files and exit
# Glob available configurations. Not needed if execs are in bin
#
opendir(DIR,"./CONFIGURATIONS/$host");
@files = grep { (!/^\./) && -f "./CONFIGURATIONS/$host/$_" } readdir(DIR);
closedir DIR;
$conf_avail = join("\n                  ", @files);
if($help){ 
   # Report unversioned files
   $system_command = "svn st | grep -v '.gz' | grep -v 'SAVE/ns.' | grep -v 'elph_gkkp'";
   print "Warning: some unversioned files present. Cleaning advised.\n";
   system ($system_command);
   # Report host and identified configurations
   print "\nRunning on host: $color_start{green} $host $color_end{green}\n";
   print "Available confs: $color_start{blue} $conf_avail $color_end{blue}\n";
   usage ; # dies
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
     $result = `./scripts/find_the_diff 2> /dev/null`;
     if ( $result ) {
        print "        find_the_diff : found\n";
        $make_find_the_diff=0;  #dont compile
     }
  }
} else { 
  print "        find_the_diff : not found\n";
};
# 2. system ncdump is available
$system_ncdump = `which ncdump`; chomp($system_ncdump);
if(-e $system_ncdump) { 
  print "               ncdump : found\n";
} else { print "               ncdump : not found\n"};
# 3. ncftpput
$ncftpput = `which ncftpput 2> /dev/null`; chomp($ncftpput);
if(-e $ncftpput) { 
  print "             ncftpput : found\n";
} else { print "             ncftpput : not found\n"};
# 4. txt2html
$txt2html = `which txt2html 2> /dev/null`; chomp($txt2html);
#$txt2html = which('txt2html'); 
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
$year=$year+1900;
my $date="Date:$days[$wday]-$mday-$months[$mon]-$year Time:$hour-$min";
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
$target_list_basic = "yambo ypp interfaces ";
$exec_list_basic = "yambo ypp a2y ";  # for now anyway
$project_list = "yambo_rt yambo_qed yambo_ph yambo_sc ypp_rt ypp_ph ";
$gpl_list = "yambo_ph ypp_ph ";
$is_GPL="no";

#
# Build the list of tests: -tests "list" / -tests all / -theme / 
# -theme 		Populate from THEMES/ folder
# -tests "list"		User defined list
# -tests all		All possible tests
#
if($tests and $theme){ die "Select only one of -tests or -theme option"};
if($tests){
  # If I find SAVE and INPUTS, treat as a working test dir.
  # Could also exclude BROKEN/HARD here.
  if($tests eq "all"){
    find(\&testdirs, "./tests");
    sub testdirs {
      my $fullpath = $File::Find::name;
      if($fullpath =~ m|INPUTS$|){    # The only folder ending ../INPUTS
         if(-d "SAVE"){		      # Check ./SAVE also present
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
      if( $line =~ /^#/ ) { next }; # Ignore commented lines
      chomp $line;
      $tests .= $line."; ";
    }
    print        " - Test selection     : from theme file $theme\n";
}
if($tests){
  @dummy= split(/\s*;\s*/, $tests);
  $numtests = @dummy; # Number of elements
  print "           Total sets : $numtests\n";
  print "                        ".join("\n                        ",@dummy)."\n" unless $alltests;
}
print " - Projects           : $project\n";
print " - Precision          : $prec\n";
#---------------------------#
# Loop on BRANCHES
#---------------------------#
if($branch_path){
  @branches = ("$branch_path");
} else {
  open(BRANCHES_file,"<","BRANCHES/LIST.$host") or die "\nNo BRANCHES/LIST.$host file found. Create or use -branch option.\n";
  @branches = <BRANCHES_file>;
  close(BRANCHES_file);
}
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
   print "Running branch: $branchdir\n" if ($verb);
   print "     shortname: $dir\n" if ($verb);
   if ($dir=~m/gpl/ix) {$is_GPL="yes"};

   #
   # Define list of required executables
   #
   $target_list = $target_list_basic; $exec_list = $exec_list_basic;
   if ($is_GPL =~ "yes") { $target_list .= $gpl_list; $exec_list .= $gpl_list}
   else{
      # If project = all or user-selected 
      if ($project !~ "none") { $target_list .= $project_list; $exec_list .= $project_list }
   }

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
        print "\n--- Configuration and compilation --- \n";
        print "                      > Configuring sources...";
         chdir $BRANCH;
         # Configure and compilation logs (full paths)
         if($upload_logs){
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
#        dircopy("bin",$conf_bin);
         $cmd = "cp -fr bin $conf_bin";
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
      if($run_input_checks) {
        print "\n--- Input file generation checks ---- \n";
        chdir('./tests/Al111');
        @yambo_flags = ('-r',
         	'-p p','-x',
 		'-g n','-g s','-g g',
 		'-o g','-o c',
 		'-k hartree','-k alda',
 		'-y h'	,
		'-p p -g n -x -y h',
 		);
        $verball = " -V all";
        $verball_ = "-Vall";
#       Run setup first without checking
        $run_filev = "yambo.in_run-i-Vall";
        $cmd = "$BRANCH/$conf_bin/yambo -i -V all -F $run_filev";
        system("$cmd 2>/dev/null");
        print($cmd) if ($verb);
        $cmd = "$BRANCH/$conf_bin/yambo -F $run_filev";
        system("$cmd 2>/dev/null");
        print($cmd) if ($verb);
        # Identify parallel configuration
        open RUN, '<', $run_filev;
        my @setup = <RUN>;
        close RUN;
        $is_serial="no"; $is_omp="no"; $is_mpi="no";
        foreach (@setup) {
           if(m/Serial/ && m/Build/) {$is_serial="yes"};  # on $_
           if(m/OpenMP/ && m/Build/) {$is_omp="yes"};
           if(m/MPI/    && m/Build/) {$is_mpi="yes"};
        }
        print " - Detected environment : Serial($is_serial) OpenMP($is_omp) MPI($is_mpi)\n";
        print " - Checking flags       :\n";
        while($flag = shift(@yambo_flags)) {
          ($flag_ = $flag) =~ s/\s+//g;  #Strip spaces 
          printf("   > %20s %7s ...",$flag,$verball); 
          $run_file  = "yambo.in_run".$flag_;
          $run_filev = "yambo.in_run".$flag_."-Vall";
          $ref_file  = "yambo.in_ref".$flag_;
          $ref_filev = "yambo.in_ref".$flag_."-Vall";
#         print "CHECK $flag_ $run_filev $ref_filev\n";
          $refdir = "./INPUTGEN/";
          # Generate the test input file
          $cmd = "$BRANCH/$conf_bin/yambo $flag $verball -F $run_filev";
          system("$cmd 2>/dev/null");
          print "Running $cmd \n" if ($verb); 
          # Read to arrays  
          if(open RUN, '<', $run_filev) {
            @run1 = <RUN>; 
            close RUN;
          } else {
            print "  No RUN file $run_filev \n";
            next;
          }
          $file = $refdir.$ref_filev;
          if(open REF, '<', $file) {
            @ref1 = <REF>;
            close REF;
          } 
          else {
            print "  No REF file $ref_filev \n";
            next;
          }
          # Strip LOGO from the run and ref files
          print "Stripping LOGO \n" if ($verb); 
          @run2 = grep {! /^# / } @run1;  
          @ref2 = grep {! /^# / } @ref1;  
          # Strip [PARALLEL] and [OPENMP/..] from the REF depending on the conf
          @ref3 = @ref2;
          if($is_mpi eq "no")    { @ref3 = grep { !/\[PARALLEL\]/ } @ref2 };
          @ref4 = @ref3;
          # For OpenMP substitute the value in both REF and RUN
          if($is_omp eq "no") { @ref4 = grep { !/\[OPENMP/ }     @ref3 }; 
          if($is_omp eq "yes") { 
               s/Threads\s*=\s*\d\s+#/Threads= VAL         #/ for @ref4 ;
               s/Threads\s*=\s*\d\s+#/Threads= VAL         #/ for @run2 ;
          }
          # Just checks
          open RUN,'>',$run_filev."-stripped"; print RUN @run2; close RUN;
          open REF,'>',$ref_filev."-stripped"; print REF @ref4; close REF;
          # Use a hash to compare array elements. Might need to strip %'s
          @union = @intersection = @difference = ();
          %count = ();
          foreach $element (@run2, @ref4) { $count{$element}++ }
          foreach $element (keys %count) {
             push @union, $element;
             push @{ $count{$element} > 1 ? \@intersection : \@difference }, $element;
          }
          $numdiff = @difference;
          # Report differences
          if($numdiff gt 0) {
             print " $color_start{red} $numdiff $color_end{red} differences\n";
#            print @difference if ($verb); 
             print @difference; 
          } else {
             print " $color_start{green} OK $color_end{green}\n";
          }
        }
        chdir $cwd;
      }
      #
      # Run the tests through driver_conor.pl, looping over CPUs. 
      #
      if ($tests) {   
        print "\n--- Launching tests ----------------- \n";
         # Try to compile the find_the_diff fortran code if necessary
         if($make_find_the_diff){
           print " -     Compiling diff :";
           $cmd="cp $BRANCH/config/setup scripts/Makefile";
           print "\n$cmd \n" if ($verb);
#          system("$cmd");
           $result = `$cmd 2>/dev/null`;
           chdir "scripts";
           $cmd="./make_the_makefile.sh";
           print "$cmd \n" if ($verb);
#          system("$cmd");
           $result = `$cmd 2>/dev/null`;
           $cmd="./make";
           print "$cmd \n" if ($verb);
#          system("$cmd");
           $result = `$cmd 2>/dev/null`;
           chdir "../";
           print " done \n";
         }
         # Check find_the_diff is available
         if(! -e "./scripts/find_the_diff") { die "Missing ./scripts/find_the_diff executable. Make it manually.\n"};
         # Check ncdump is available
         if(!-e "$BRANCH/$conf_bin/ncdump" and !-e $system_ncdump) { die "No ncdump executable found.\n"} ;

         chdir $cwd;
         for (my $NP=$np_min; $NP<= $np_max ; $NP++){
            $cmd="./scripts/driver_conor.pl -c";
            system("$cmd");

            $ROOT="./scripts/driver_conor.pl -b $dir-$conf_file -k -np $NP -nt $nt -prec $prec -host $host";
            if ($NP>1) 		{$ROOT.=" -mpi mpirun";}
            if ($tol) 		{$ROOT.=" -t $tol";}
            if ($openmp_is_off) {$ROOT .= " -openmp_is_off"};
            if ($verb eq 1) 	{$ROOT.=" -v";}
            if ($verb ge 2) 	{$ROOT.=" -v -v";}
            if ($default_parallel) {$ROOT.=" -def_par";}
            if ($add_outputs) 	{$ROOT.=" -a";}
            if ($dd_outputs) 	{$ROOT.=" -a";}
            if ($extended) 	{$ROOT.=" -hard";}

            # Launch driver_conor.pl $BRANCH/$conf_bin for the executable
            # Always pass in $project; never $exec
            $system_command = "$ROOT -p $project -path '$BRANCH/$conf_bin' -tests \"$tests\" ";
            print "Launching: $system_command\n\n" if ($verb);
# System will pass STDERR to STDOUT
            system ($system_command);
# Backticks will capture all STDERR from yambo runs, but loses live timing and colour.
#           $result = `$system_command 2> /dev/null`;
#           print $result;
         } # end parallel
      } # end $tests
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
#
if ($upload_logs){
   $cmd="./scripts/driver_conor.pl -u $TEST_dir";
   system("$cmd");
};

print "\nDone.\n";
