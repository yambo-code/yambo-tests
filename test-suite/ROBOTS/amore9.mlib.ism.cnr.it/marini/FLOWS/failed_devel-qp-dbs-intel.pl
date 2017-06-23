#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT// all ;Si_bulk/RT// all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT// all ;Si_bulk/RT// all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '4',
PAR_MODE     => 'loop',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT// all ;Si_bulk/RT// all ; ',
},
{
KEYS        => 'all hard',
THREADS     => '4',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT// all ;Si_bulk/RT// all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT// all ;Si_bulk/RT// all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT// all ;Si_bulk/RT// all ; ',
},
);
