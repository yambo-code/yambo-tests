#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 CONFIG      => "default.sh",
 TESTS       => "all",
 KEYS        => "all hard",
},
{
 MPI_CPU     => 8,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 8,
 PAR_MODE    => "random",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 4,
 PAR_MODE    => "loop",
},
{
 ACTIVE      => "yes",
 THREADS     => 8,
},
{
 MPI_CPU     => 8,
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 8,
 THREADS     => 2,
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
);
