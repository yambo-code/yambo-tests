#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 TESTS       => "all",
 CONFIG      => "default_par_io.sh",
 KEYS        => "all hard",
},
{
 ACTIVE      => "yes",
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
 MPI_CPU     => 8,
 PAR_MODE    => "loop",
},
{
 ACTIVE      => "no",
 THREADS     => "4",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 8,
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 2,
 THREADS     => "2",
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
);
