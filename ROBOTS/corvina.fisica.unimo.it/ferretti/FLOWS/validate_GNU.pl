#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 CONFIG      => "gnu_SP.sh",
 KEYS        => "all hard",
},
{
 MPI_CPU     => 8,
 THREADS     => 2,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 2,
 THREADS     => 8,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => 4,
 THREADS     => 4,
 PAR_MODE    => "loop",
},
);
