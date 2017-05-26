#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/MAGNETIC/ all ;MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/MAGNETIC/ all ;MoS2/pwscf/RT/ all ;hBN/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/MAGNETIC/ all ;WSe2/RT/ all ;MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '4',
PAR_MODE     => 'loop',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;Si_bulk/MAGNETIC/ all ;MoS2/pwscf/RT/ all ;hBN/RT/ all ; ',
},
{
KEYS        => 'all hard',
THREADS     => '2',
ACTIVE      => 'yes',
TESTS     => 'H2/RT/ all ;Si_bulk/SC/ all ;Si_bulk/MAGNETIC/ all ;WSe2/RT/ all ;MoS2/pwscf/RT/ all ;hBN/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/MAGNETIC/ all ;MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '4',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'H2/RT/ all ;Si_bulk/SC/ all ;Si_bulk/MAGNETIC/ all ;WSe2/RT/ all ;MoS2/pwscf/RT/ all ;hBN/RT/ all ; ',
},
);
