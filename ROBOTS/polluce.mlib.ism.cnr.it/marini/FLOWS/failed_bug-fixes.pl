#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
CONFIG      => 'default.sh',
TESTS     => ' ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;Si_bulk/RT/ all ;Si_bulk/GW-OPTICS/ all ;MoS2/pwscf/RT/ all ;hBN/GW-OPTICS/ all ;Al_bulk/GW-OPTICS/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '4',
PAR_MODE     => 'loop',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/GW-OPTICS/ all ;Al_bulk/GW-OPTICS/ all ; ',
},
{
KEYS        => 'all hard',
THREADS     => '4',
ACTIVE      => 'no',
TESTS     => ' ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => ' ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => ' ',
},
);
