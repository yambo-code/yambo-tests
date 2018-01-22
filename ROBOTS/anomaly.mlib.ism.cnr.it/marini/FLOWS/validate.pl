#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
# CONFIG      => "default.sh",
 TESTS       => "all",
 KEYS        => "all",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "loop",
},
{
 THREADS     => "4",
},
{
 MPI_CPU     => $SYSTEM_NP,
 SLK_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => $SYSTEM_NP_half,
 THREADS     => "2",
 SLK_CPU     => $SYSTEM_SLK,
 PAR_MODE    => "default",
},
);
