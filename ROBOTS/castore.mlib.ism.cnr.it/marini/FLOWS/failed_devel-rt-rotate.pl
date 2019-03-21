#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/GW-OPTICS/ all ;MoS2/pwscf/RT/ all ;Al_bulk/GW-OPTICS/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/GW-OPTICS/ all ;MoS2/pwscf/RT/ all ;hBN/RT/ all ;Al_bulk/GW-OPTICS/ all ;Al111/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT/ all ;Iron/pwscf/Without-SOC/ all ; ',
},
);
