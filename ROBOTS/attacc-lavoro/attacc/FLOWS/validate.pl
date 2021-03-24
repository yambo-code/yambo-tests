#!/usr/bin/perl
#
#General RUN descriptor & Automatic flows of calculations
#--------------------------------------------------------
#{
# BRANCH      => "PATH", #Full path to the yambo source to test (SAVED)
# CONFIG      => "gfortran_slk.sh", # (SAVED)
# ACTIVE      => "yes", # can be yes or no
# MPI_CPU     => "NP",
# SLK_CPU     => "NM",
# THREADS     => "NT",
# TESTS       => "hBN/GW-OPTICS", #  (SAVED)
# KEYS        => "nopj elph hard bse rpa", # (SAVED)
# PAR_MODE    => "TEXT", # (TEXT can be default, random, loop)
#},
#
@flow = (
{
 ACTIVE      => "yes",
 TESTS       => "all",
 CONFIG      => "gfortran_linux.sh",
 KEYS        => "all",
},
{
 ACTIVE      => "yes",
 TESTS       => "all",
 MPI_CPU     => 4,
 PAR_MODE    => "default",
 CONFIG      => "gfortran_linux.sh",
 KEYS        => "all",
},
{
 ACTIVE      => "yes",
 TESTS       => "all",
 MPI_CPU     => 1,
 THREADS     => 2,
 CONFIG      => "gfortran_linux.sh",
 KEYS        => "all",
}
);
