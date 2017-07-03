#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 TESTS       => "hBN/GW-OPTICS 01_init 02_HF",
 CONFIG      => "default.sh",
# KEYS        => "all hard",
},
{
 ACTIVE      => "no",
# TESTS       => "MoS2/pwscf/RT  00_init",
# CONFIG      => "intel.sh",
# KEYS        => "all hard",
},
{
 ACTIVE      => "yes",
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
