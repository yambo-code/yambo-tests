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
 ACTIVE      => "yes",
 MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => 4,
 PAR_MODE    => "loop",
},
{
 THREADS     => $SYSTEM_NP,
},
{
 MPI_CPU     => $SYSTEM_NP,
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
