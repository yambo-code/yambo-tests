#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 TESTS       => "hBN/GW-OPTICS 01_init", 
# CONFIG      => "default.sh",
 KEYS        => "nopj elph hard",
},
{
 MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "loop",
},
{
 THREADS     => $SYSTEM_NP_half,
},
{
 MPI_CPU     => $SYSTEM_NP,
 SLK_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => $SYSTEM_NP_half,
 THREADS     => $SYSTEM_NP_half,
 SLK_CPU     => $SYSTEM_SLK,
 PAR_MODE    => "default",
},
);
