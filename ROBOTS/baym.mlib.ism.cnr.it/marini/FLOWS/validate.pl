#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "no",
# CONFIG      => "default.sh",
 TESTS       => "all",
 KEYS        => "all",
},
{
 ACTIVE      => "no",
 MPI_CPU     => 8,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "no",
 MPI_CPU     => 8,
 PAR_MODE    => "random",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 8,
 PAR_MODE    => "loop",
},
{
 ACTIVE      => "no",
 THREADS     => "4",
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP,
 SLK_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP_half,
 THREADS     => "2",
 SLK_CPU     => $SYSTEM_SLK,
 PAR_MODE    => "default",
},
);
