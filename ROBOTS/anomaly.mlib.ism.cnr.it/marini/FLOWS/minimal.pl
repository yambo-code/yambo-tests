#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
# CONFIG      => "default.sh",
 TESTS       => "hBN/GW-OPTICS 01_init 02_HF",
# TESTS       => "PA_chain; Al_bulk/GW-OPTICS; WSe2/RT; hBN/SC; Diamond/ELPH1",
# KEYS        => "all hard",
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "random",
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "loop",
},
{
 ACTIVE      => "no",
 THREADS     => $SYSTEM_NP_half,
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP,
 SLK_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP,
 THREADS     => $SYSTEM_NP_half,
 SLK_CPU     => $SYSTEM_SLK,
 PAR_MODE    => "default",
},
);
