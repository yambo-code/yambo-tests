#!/usr/bin/perl
#
#General RUN descriptor & Automatic flows of calculations
#--------------------------------------------------------
#{
# ACTIVE      => "yes", # can be yes or no
# MPI_CPU     => "NP",
# SLK_CPU     => "NM",
# PAR_MODE    => "TEXT", # (TEXT can be default, random, loop)
# THREADS     => "NT",
# THEME       => "G_parallelization", # (SAVED)
# CONFIG      => "gfortran_slk.sh", # (SAVED)
# TESTS       => "hBN/GW-OPTICS", #  (SAVED)
# KEYS        => "nopj elph hard bse rpa", # (SAVED)
#},
#
@flow = (
{
 ACTIVE      => "yes",
 TESTS       => "Dummy",
},
{
 ACTIVE      => "no",
 MPI_CPU     => "2",
 PAR_MODE    => "default",
},
{
 ACTIVE      => "no",
 THREADS     => "2",
},
);
