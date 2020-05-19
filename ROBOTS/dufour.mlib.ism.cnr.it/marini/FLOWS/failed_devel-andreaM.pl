#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/QP_CTL/ all ;MoS2/pwscf/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/QP_CTL/ all ;MoS2/pwscf/RT/ all ;MoS2/P2Y/ all ;MoS2/A2Y/SP4/ all ;MoS2/A2Y/SP1/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/QP_CTL/ all ;MoS2/pwscf/RT/ all ;MoS2/P2Y/ all ;MoS2/A2Y/SP4/ all ;MoS2/A2Y/SP1/ all ;AlAs/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'random',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/QP_CTL/ all ;MoS2/pwscf/RT/ all ;MoS2/P2Y/ all ;MoS2/A2Y/SP4/ all ;MoS2/A2Y/SP1/ all ;Iron/abinit/Without-SOC/ all ;hBN/GW-OPTICS/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/QP_CTL/ all ;MoS2/pwscf/RT/ all ;MoS2/P2Y/ all ;MoS2/A2Y/SP4/ all ;MoS2/A2Y/SP1/ all ; ',
},
);
