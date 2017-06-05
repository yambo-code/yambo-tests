#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 TESTS       => "MoS2/pwscf/RT  00_init",
 CONFIG      => "gfortran.sh",
 KEYS        => "all hard",
},
{
 TESTS       => "MoS2/pwscf/RT  00_init",
 CONFIG      => "intel.sh",
 KEYS        => "all hard",
},
{
 ACTIVE      => "no",
 MPI_CPU     => "2",
 PAR_MODE    => "default",
},
{
 ACTIVE      => "no",
 MPI_CPU     => "2",
 PAR_MODE    => "random",
 THREADS     => "2",
},
{
 ACTIVE      => "no",
 MPI_CPU     => "2",
 PAR_MODE    => "loop",
},
);
