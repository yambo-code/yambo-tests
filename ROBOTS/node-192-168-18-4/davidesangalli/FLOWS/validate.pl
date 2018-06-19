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
 #TESTS       => "all",
 TESTS       => "Al_bulk",
 CONFIG      => "gfortran_gnu_etsfmi_4.8.5_SP.sh",
 #KEYS        => "nopj elph sc rt kerr magnetic hard",
 KEYS        => "nopj",
},
{
 MPI_CPU     => 4,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => 4,
 PAR_MODE    => "default",
}
);
