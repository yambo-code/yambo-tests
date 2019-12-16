#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/MAGNETIC/ all ;PA_chain/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'PA_chain/ all ;H_chain/2.5/ all ;H_chain/2.05/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/GW-OPTICS/ all ;PA_chain/ all ;MoS2/pwscf/RT/ all ;MoS2/abinit/OPTICS/Without-SOC-sp2/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;LiF/GW-OPTICS/ all ;hBN/SC/ all ;hBN/RT/ all ;hBN/GW-OPTICS/ all ;H_chain/2.5/ all ;H_chain/2.05/ all ;Al_bulk/GW-OPTICS/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;Si_bulk/RT/ all ;PA_chain/ all ;MoS2/pwscf/RT/ all ;MoS2/pwscf/OPTICS/Without-SOC-sp2/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;LiF/GW-OPTICS/ all ;hBN/SC/ all ;hBN/RT/ all ;hBN/GW-OPTICS/ all ;H_chain/2.5/ all ;H_chain/2.05/ all ;Al_bulk/GW-OPTICS/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'H_chain/2.5/ all ;H_chain/2.05/ all ; ',
},
);
