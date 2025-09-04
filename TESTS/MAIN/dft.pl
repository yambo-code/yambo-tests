#!/usr/bin/perl
#
use Getopt::Long;
use File::Find;
use File::Copy;
use Term::ANSIColor qw(:constants);
use File::Basename;
use Time::HiRes qw(gettimeofday tv_interval);   # Not widely supported
use Cwd 'abs_path';
use Net::Domain qw(hostname hostfqdn hostdomain domainname);
#
$pwd=abs_path();
$hostname=hostname();
#
$DIR="DFT";
find({ wanted => \&process_dir, no_chdir => 1 }, ".");
@DFT_dirs=@dirs;
#
$DIR="REFERENCE";
@dirs=();
find({ wanted => \&process_dir, no_chdir => 1 }, ".");
@REF_dirs=@dirs;
#
for $dir (@REF_dirs) {
 @files=( );
 $MATERIAL=(split("/REFERENCE",$dir))[0];
 $KIND="r-";
 find({ wanted => \&process_files, no_chdir => 0 }, "$dir");
 @in_files=@files;
 $dft="no";
 if (-d "$dir/../DFT") {
  @files=( );
  $KIND="\.files";
  find({ wanted => \&process_files, no_chdir => 0 }, "$dir/../DFT");
  $dft="ABINIT";
  @dft_files=@files;
  if( int(@dft_files) == 0) {$dft="PWSCF"};
 };
 $fh = IO::File->new( "$dir/$in_files[1]",'<');
 $metal="no";
 while ($line = <$fh>) {
  chomp($line); 
  if ($line =~ /Spin polarizations/){$N_spin=(split(":",$line))[-1]};
  if ($line =~ /Spinor components/){$N_spinors=(split(":",$line))[-1]};
  if ($line =~ /Compatible Grid/){$N_d=(split(" ",$line))[3]; if ($N_d eq ":") {$N_d=(split(" ",$line))[4]} };
  if ($line =~ /Metallic system/){$metal="yes"};
 }
 $N_d =~ s/D//;
 if ( $dft eq "no") {next};
 if ( "$dft" eq "ABINIT" and $N_d == 3)
 {
  print "Material       : $MATERIAL\n";
  print "DFT            : $dft\n";
  print "Spin components: $N_spin\n";
  print "Spinors        : $N_spinors\n";
  print "Dimension      : $N_d\n";
  print "Metallic       : $metal\n";
 }
}
die;
for $dir (@DFT_dirs) {
 @files=( );
 find({ wanted => \&process_files, no_chdir => 0 }, "$dir");
# print "\n DIRECTORY: $dir\n";
# for my $file (@files) {
#  print "file: $file\n";
# }
}

sub process_files {
 if (-f $_ and $_ =~ /$KIND/ ) { push @files,$_};
};

sub process_dir {
 if (-d $_ and $_ =~ /$DIR/) {
  $last=(split("/",$_))[-1];
  if ( $last eq $DIR ) { push @dirs,$_};
 };
}

#$options="-azri";
#if ($links){$options.="L"};
#if ($dry){$options.="n"};
#if ($delete){$options.=" --delete"};
#if ($exclude){$options.=" --exclude $exclude"};
#if ($sserver) {$src="$IPs:$src"};
#if ($dserver) {$dest="$IPd:$dest"};
#system("rsync $options $src $dest");
#
