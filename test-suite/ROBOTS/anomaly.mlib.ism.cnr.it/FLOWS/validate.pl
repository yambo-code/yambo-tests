#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 KEYS        => "all hard",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "random",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "loop",
},
{
 ACTIVE      => "yes",
 THREADS     => "2",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => $SYSTEM_NP,
 SLK_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => $SYSTEM_NP_half,
 THREADS     => "2",
 SLK_CPU     => $SYSTEM_SLK,
 PAR_MODE    => "default",
},
);
