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
find({ wanted => \&process_dir, no_chdir => 1 }, ".");
sub process_dir {
 if (-d $_ and $_ =~ /DFT/) {
  $last=(split("/",$_))[-1];
  if ( $last eq "DFT" ) { push @dirs,$_};
 };
}
#
for $dir (@dirs) {
 @files=( );
 find({ wanted => \&process_files, no_chdir => 0 }, "$dir");
 sub process_files {
  if (-f $_ and $_ =~ /in/ ) { push @files,$_};
 };
 print "\n DIRECTORY: $dir\n";
 for my $file (@files) {
  print "file: $file\n";
 }
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
