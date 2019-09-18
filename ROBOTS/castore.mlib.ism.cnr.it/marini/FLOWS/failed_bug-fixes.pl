#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/MAGNETIC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;MoS2/abinit/OPTICS/With-SOC/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;MoS2/abinit/OPTICS/With-SOC/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;hBN/GW-OPTICS/ all ; ',
},
);
