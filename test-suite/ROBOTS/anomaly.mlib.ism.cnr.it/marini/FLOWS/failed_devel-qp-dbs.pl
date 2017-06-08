#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/SC/ all ;WSe2/RT/ all ;Iron/pwscf/ all ;MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/SC/ all ;WSe2/RT/ all ;Iron/pwscf/ all ;MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
THREADS     => '2',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/SC/ all ;WSe2/RT/ all ;Iron/pwscf/ all ;MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/SC/ all ;WSe2/RT/ all ;Iron/pwscf/ all ;MoS2/pwscf/RT/ all ; ',
},
);
