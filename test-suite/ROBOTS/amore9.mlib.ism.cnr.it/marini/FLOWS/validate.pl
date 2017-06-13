#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 CONFIG      => "default.sh",
 KEYS        => "nopj elph sc hard",
},
{
 MPI_CPU     => 16,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 16,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => 4,
 PAR_MODE    => "loop",
},
{
 THREADS     => 16,
},
{
 MPI_CPU     => 32,
 SLK_CPU     => 16,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 16,
 THREADS     => 2,
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
);
