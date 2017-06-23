#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;hBN/SC/ all ;MoS2/pwscf/RT/ all ;H2/SC/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;hBN/SC/ all ;MoS2/pwscf/RT/ all ;H2/SC/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '4',
PAR_MODE     => 'loop',
ACTIVE      => 'yes',
TESTS     => 'hBN/RT/ all ;MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
THREADS     => '8',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;hBN/SC/ all ;MoS2/pwscf/RT/ all ;H2/SC/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;hBN/SC/ all ;MoS2/pwscf/RT/ all ;H2/SC/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;hBN/SC/ all ;MoS2/pwscf/RT/ all ;H2/RT/ all ;H2/SC/ all ; ',
},
);
