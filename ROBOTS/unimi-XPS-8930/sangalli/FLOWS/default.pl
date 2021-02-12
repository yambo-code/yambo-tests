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
 BRANCH      => "/home/marini/Yambo/sources/git/yambo/branches/SLK",
 TESTS       => "hBN/GW-OPTICS 01_init",
 ACTIVE      => "yes",
},
{
 CONFIG      => "gfortran_all_external.sh",
 ACTIVE      => "yes",
 MPI_CPU     => "2",
 PAR_MODE    => "default",
},
{
 CONFIG      => "gfortran_all_external_slk.sh",
 ACTIVE      => "yes",
 MPI_CPU     => "2",
 PAR_MODE    => "default",
 THREADS     => "2",
},
);
