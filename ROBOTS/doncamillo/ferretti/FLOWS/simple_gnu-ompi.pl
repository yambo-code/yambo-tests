#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 CONFIG      => "gnu-ompi.sh",
 KEYS        => "nopj hard",
 MPI_CPU     => 12,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 8,
 PAR_MODE    => "loop",
},
{
 ACTIVE      => "yes",
 THREADS     => 12,
},
{
 MPI_CPU     => 12,
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 6,
 THREADS     => 2,
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
);

