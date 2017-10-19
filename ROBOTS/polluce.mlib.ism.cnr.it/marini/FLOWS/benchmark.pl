#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 CONFIG      => "default.sh", 
 TESTS       => "AGNR",
},
{
 ACTIVE      => "no",
 MPI_CPU     => 8,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 8,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => 4,
 PAR_MODE    => "loop",
},
{
 THREADS     => 4,
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
