#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT/ all ;MoS2/P2Y/ all ;hBN/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/GW-OPTICS/ all ;MoS2/pwscf/RT/ all ;MoS2/P2Y/ all ;hBN/RT/ all ; ',
},
);
