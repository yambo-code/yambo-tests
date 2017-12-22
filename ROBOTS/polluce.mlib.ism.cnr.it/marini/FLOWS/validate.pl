#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "no",
 CONFIG      => "default_plus_slepc.sh",
 KEYS        => "all hard",
},
{
 ACTIVE      => "no",
 MPI_CPU     => 8,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 8,
 PAR_MODE    => "random",
},
{
 ACTIVE      => "no",
 MPI_CPU     => 4,
 PAR_MODE    => "loop",
},
{
 ACTIVE      => "no",
 THREADS     => 8,
},
{
 MPI_CPU     => 8,
 SLK_CPU     => 4,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => 8,
 THREADS     => 2,
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
);
