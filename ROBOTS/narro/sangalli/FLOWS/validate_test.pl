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
 TESTS       => "hBN/SC",
 # CONFIG      => "gfortran_internal_SP.sh",
 KEYS        => "sc",
 #KEYS        => "nopj",
},
{
 MPI_CPU     => 2,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => 2,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 1,
 THREADS     => 2,
}
);
