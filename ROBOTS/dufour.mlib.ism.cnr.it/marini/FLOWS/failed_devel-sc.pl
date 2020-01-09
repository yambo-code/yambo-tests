#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/ELPH/OPTICS/ all ;He/GW/ all ;H2/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/ELPH/OPTICS/ all ;H2/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/ELPH/OPTICS/ all ;Iron/abinit/Without-SOC/ all ;H2/RT/ all ;AlAs/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/ELPH/OPTICS/ all ;H2/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/OPTICS/ all ;H2/RT/ all ; ',
},
);
