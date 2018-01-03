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
sub PROFILE{
############
&CWD_save;
chdir("@_[0]");
if (not -d "TESTS") {
 @TARGZ = glob("*_ALL*");
 &command("tar xzf $TARGZ[0]");
}
my @dirs = ( "TESTS" );
my @files;
find( sub { push @files, $File::Find::name if /l-/ }, @dirs );
#
$ntests_by_ncpu=0;
#
for $file (@files) 
{
 if ("$file" =~ /.sw/ ) {next};
 if (-d $file) {next};
 &PROFILE_scan_the_log($file);
}
#
&CWD_go;
#
# Reports
#
&command("rm -fr PROFILING");
#
for $itest (1...$ntests_by_ncpu) {
 #
 if (not $PROF_test[$itest]->{CPU} eq 1) {next};
 #
 $testname=$PROF_test[$itest]->{TEST_NAME};
 $par_conf=$PROF_test[$itest]->{PAR_CONF};
 $prof_folder=$PROF_test[$itest]->{TEST_FOLDER};
 #
 print "\n Found ... $prof_folder $testname $par_conf\n";
 #
 $prof_folder=~ s/\//_/gs;
 #
 if ($profile) {
  #
  # Directories
  #
  &command("mkdir -p PROFILING");
  &command("mkdir -p PROFILING/$prof_folder");
  &command("mkdir -p PROFILING/$prof_folder/$testname");
  &command("mkdir -p PROFILING/$prof_folder/$testname/$par_conf");
  $current_dir="PROFILING/$prof_folder/$testname";
  #
  $legend_file ="$current_dir/LEGEND.dat";
  open($legend_log, '>>',$legend_file);
 }else{
  next;
 }
 #
 print $legend_log "\n\n";
 print $legend_log "PARALLEL CONFIGURATION: $PROF_test[$itest]->{PAR_CONF}\n";
 print $legend_log "MPI CPU's : $PROF_test[$itest]->{N_CPU}\n";
 print $legend_log "THREADS   : $PROF_test[$itest]->{N_T}\n";
 print $legend_log "PAR STR.  : $PROF_test[$itest]->{SHORT_PAR_STRUCTURE}";
 print $legend_log "$PROF_test[$itest]->{PAR_STRUCTURE}";
 #
 $tot_time_file ="$current_dir/TOTAL_TIME_vs_PAR_CONF.dat";
 open($tot_time_log, '>>',$tot_time_file);
 #
 &PROF_data_dump( { FOLDER => "$PROF_test[$itest]->{TEST_FOLDER}", TESTNAME => "$PROF_test[$itest]->{TEST_NAME}", PAR_CONF => "$PROF_test[$itest]->{PAR_CONF}"} );
 #
 close($legend_log);
 close($tot_time_log);
}
}
sub PROFILE_scan_the_log{
#########################
my @paths=split('\/',$file);
my $NP=scalar(@paths);
my $log=$paths[$NP-1];
$testname=(split('-',$paths[$NP-2]))[0];
$par_conf=(split($testname.'-',$paths[$NP-2]))[1];
if ( $paths[$NP-3] =~ /ROBOT/ ) {
 $testfolder = "$paths[$NP-5]"."/$paths[$NP-4]"
}else{
 $testfolder = "$paths[$NP-4]"."/$paths[$NP-3]"
}
$CPU=1;
my $OFFSET=0;
if ($log =~ /_CPU_/) { 
 $CPU=(split('_CPU_',$log))[1];
 $OFFSET=1;
 $REP = substr($file, 0, index($file, '_CPU_') );
}else{
 $REP = $file;
}
$REP =~ s/l-$testname/r-$testname/;
if (-f $REP) {
 open(REP,"<","$REP");
 my @REPLINES = <REP>;
 close(REP);
 $SHORT_PAR_STRUCTURE="";
 for $repline (@REPLINES){ 
   chomp($repline);
   if ($repline =~ /\* CPU/ or $repline =~ /MPI CPU/) {$N_CPU=(split(': ',$repline))[1] };
   if ($repline =~ /THREADS    \(max\)/) {$N_THREADS=(split(': ',$repline))[1] };
   if ($repline =~ /PARALLEL/) {
    $TXT=(split('\|',$repline))[1];
    $TXT=(split('#',$TXT))[0];
    chomp($TXT);
    $SHORT_PAR_STRUCTURE.="$TXT\n";
   };

 }
}
#
#print "FOLDER: $testfolder\n"; ###
#print "TEST: $testname\n"; ###
#print "PAR_CONF: $par_conf\n"; ###
#print "CPU: $CPU\n"; ###
$PAR_STRUCTURE="";
open(LOG,"<","$file");
my @LOGLINES = <LOG>;
close(LOG);
for $logline (@LOGLINES){ 
 @logline_pieces=split(' ',$logline);
 $time=$logline_pieces[0];
 $section_id=$logline_pieces[$OFFSET+1];
 $time =~ s/>//;
 $time =~ s/<//;
 if ($time eq "---") {$time=0};
 #
 $time =~ s/s/*1/;
 $time =~ s/m-/*60+/;
 $time =~ s/h-/*60*60+/;
 $time =~ s/m/*60+/;
 $time =~ s/h/*60*60+/;
 $test=eval("$time");
 $time=$test;
 #
 if ($logline =~ /PARALLEL/) {
  $TXT=(split('\[',$logline))[1];
  $TXT=(split('\]',$TXT))[0];
  chomp($TXT);
  $PAR_STRUCTURE.="$TXT\n";
 };
 #
 if ( $section_id =~ /\[/ and $section_id =~ /\]/)
 {
  $section_id =~ s/\[//;
  $section_id =~ s/\]//;
  $section_id = (split('\.',$section_id))[0];
  if ($section_id =~ /^[0-9,.E]+$/) {
   $section_name=join(' ',@logline_pieces[$OFFSET+2...$OFFSET+$#logline_pieces]);
   #print "SECTION: $time $section_name\n"; ###
   if ($time eq 0 ) {next};
   &PROF_data_add({ section_name => "$section_name", time => "$time"});
  };
  if ($section_id =~ /MEMORY/ and $logline =~ /TOTAL/ and not $logline =~ /allocated/) {
   $mem=(split('TOTAL:',$logline))[1];
   $mem=(split(' ',$mem))[0];
   $mem =~ s/Kb/*1/;
   $mem =~ s/Mb/*1000/;
   $mem =~ s/Gb/*1000000/;
   $test=eval("$mem");
   $mem=$test;
   #print "MEMORY: $par_conf $CPU $time $section_name $mem\n"; ###
   &PROF_data_add({ section_name => "$section_name", time => "$time", memory => "$mem"});
  };
  if ($section_id =~ /TIMING/ and $logline =~ /Time-Profile/) {
   $total_time=(split('\[Time-Profile\]:',$logline))[1];
   $total_time =~ s/s/*1/;
   $total_time =~ s/\+E/*10**/;
   $test=eval("$total_time");
   $total_time=$test;
   #print "TOTAL TIME: $total_time\n"; ###
   &PROF_data_add({ total_time => "$total_time"});
  }
  if ($section_id =~ /TIMING/ and not $logline =~ /Time-Profile/) {
   $delta_time=(split(' :',$logline))[1];
   $delta_time=(split('CPU',$delta_time))[0];
   $section_name=(split('\[TIMING\]',$logline))[1];
   $section_name=(split(' :',$section_name))[0];
   $section_name =~ s/ //gs;
   $delta_time =~ s/ //gs;
   $delta_time =~ s/s/*1/;
   if ($delta_time =~ /h/) {$delta_time =~ s/m/*60/};
   if (not $delta_time =~ /h/) {$delta_time =~ s/m/*60+/};
   $delta_time =~ s/h/*60*60+/;
   $test=eval("$delta_time");
   $delta_time=$test;
   #print "TIMING: $section_name $test $delta_time\n"; ###
   if ($delta_time eq 0 ) {next};
   &PROF_data_add({ section_name => "$section_name", delta_time => "$delta_time"});
  };
 }
};
}
sub PROF_data_dump{ 
###################
my ($args) = @_;
for $it_and_cpu (1...$ntests_by_ncpu) {
 #
 $testfolder ="$PROF_test[$it_and_cpu]->{TEST_FOLDER}";
 $testname   ="$PROF_test[$it_and_cpu]->{TEST_NAME}";
 $par_conf   ="$PROF_test[$it_and_cpu]->{PAR_CONF}";
 $CPU        ="$PROF_test[$it_and_cpu]->{CPU}";
 $total_time[$CPU] ="$PROF_test[$it_and_cpu]->{TOTAL_TIME}";
 #
 if ($args->{FOLDER} ne $testfolder) {next};
 if ($args->{TESTNAME} ne $testname) {next};
 if ($args->{PAR_CONF} ne $par_conf) {next};
 #
 $mem_file  ="$current_dir/$par_conf/MEMORY_vs_TIME_CPU_"."$CPU".".dat";
 $time_file ="$current_dir/$par_conf/TIME_vs_SECTION_CPU_"."$CPU".".dat";
 open($mem_log, '>>', $mem_file);
 open($time_log, '>>',$time_file);
 #
 #print "$PROF_test[$it_and_cpu]->{N_CPU} $total_time[$CPU]\ #CPU Nr.$CPU of $par_conf\n";
 print $tot_time_log "$PROF_test[$it_and_cpu]->{N_CPU} $total_time[$CPU]\ #CPU Nr.$CPU of $par_conf\n";
 #
 for $idata (1...$ndata[$it_and_cpu]) {
  undef $section;
  undef $delta_time;
  undef $time;
  undef $memory;
  if ( $DATA[$it_and_cpu][$idata]->{SECTION} ) {$section=$DATA[$it_and_cpu][$idata]->{SECTION}};
  if ( $DATA[$it_and_cpu][$idata]->{DELTA_TIME} ) {$delta_time=$DATA[$it_and_cpu][$idata]->{DELTA_TIME}};
  if ( $DATA[$it_and_cpu][$idata]->{TIME} ) {
   $time=$DATA[$it_and_cpu][$idata]->{TIME};
   $time_to_print=eval("$time/$total_time[$CPU]*100.");
  }
  if ( $DATA[$it_and_cpu][$idata]->{MEMORY} ) {$memory=$DATA[$it_and_cpu][$idata]->{MEMORY}};
  #
  if ($memory) {print $mem_log "$time_to_print $memory\n";} #$section\n";}
  #
  if ($delta_time) {print $time_log "$section $delta_time\n";}
 }
 close($mem_log);
 close($time_log);
 #
}
}
sub PROF_data_add{
###################
$mytest=-1;
my ($args) = @_;
for $it_and_cpu (1...$ntests_by_ncpu) {
 if ($PROF_test[$it_and_cpu]->{TEST_FOLDER} eq $testfolder and $PROF_test[$it_and_cpu]->{TEST_NAME} eq $testname 
     and $PROF_test[$it_and_cpu]->{PAR_CONF} eq $par_conf and $PROF_test[$it_and_cpu]->{CPU} eq $CPU) 
 {
  $mytest=$it_and_cpu
 }
}
if ($mytest eq -1 ) {
 $mytest = $ntests_by_ncpu +1;
 $ntests_by_ncpu++;
 $PROF_test[$mytest]->{TEST_FOLDER}="$testfolder";
 $PROF_test[$mytest]->{TEST_NAME}="$testname";
 $PROF_test[$mytest]->{PAR_CONF}="$par_conf";
 $PROF_test[$mytest]->{CPU}="$CPU";
 $PROF_test[$mytest]->{N_CPU}="$N_CPU";
 $PROF_test[$mytest]->{N_T}="$N_THREADS";
}
$PROF_test[$mytest]->{SHORT_PAR_STRUCTURE}="$SHORT_PAR_STRUCTURE";
$PROF_test[$mytest]->{PAR_STRUCTURE}="$PAR_STRUCTURE";
if ( $args->{total_time}   ) { $PROF_test[$mytest]->{TOTAL_TIME}=$args->{total_time}};
$ndata[$mytest]++;
if ( $args->{section_name} ) { $DATA[$mytest][$ndata[$mytest]]->{SECTION}= $args->{section_name}};
if ( $args->{delta_time} )   { $DATA[$mytest][$ndata[$mytest]]->{DELTA_TIME}= $args->{delta_time}};
if ( $args->{time} )         { $DATA[$mytest][$ndata[$mytest]]->{TIME}= $args->{time}};
if ( $args->{memory} )       { $DATA[$mytest][$ndata[$mytest]]->{MEMORY}= $args->{memory}};
}
1;
