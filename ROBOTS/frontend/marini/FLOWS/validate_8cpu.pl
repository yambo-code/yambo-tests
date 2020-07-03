#!/usr/bin/perl
#
@flow = (
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
 MPI_CPU     => 4,
 PAR_MODE    => "loop",
},
{
 ACTIVE      => "no",
 THREADS     => 8,
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 8,
 SLK_CPU     => 4,
 PAR_MODE    => "random",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 8,
 THREADS     => 2,
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
);

