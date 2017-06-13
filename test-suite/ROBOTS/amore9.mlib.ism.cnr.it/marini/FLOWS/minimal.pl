#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "no",
# CONFIG      => "default.sh",
 TESTS       => "PA_chain; Al_bulk/GW-OPTICS; WSe2/RT; hBN/SC; Diamond/ELPH1",
 KEYS        => "all hard",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 8,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 8,
 PAR_MODE    => "random",
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "loop",
},
{
 ACTIVE      => "yes",
 THREADS     => 8,
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 8,
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "yes",
 MPI_CPU     => 8,
 THREADS     => 4,
 SLK_CPU     => 4,
 PAR_MODE    => "default",
},
);
