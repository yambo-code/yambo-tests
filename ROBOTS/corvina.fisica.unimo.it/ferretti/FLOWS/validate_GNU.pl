#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 TESTS       => "all",
 CONFIG      => "gnu_SP.sh",
 KEYS        => "all hard",
 MPI_CPU     => 8,
 THREADS     => 2,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 4,
 THREADS     => 4,
 PAR_MODE    => "random",
},
);
