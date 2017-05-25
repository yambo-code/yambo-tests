#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;hBN/RT/ all',
},
{
KEYS        => 'all hard',
MPI_CPU     => '4',
PAR_MODE     => 'loop',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;WSe2/RT/ all ;hBN/SC/ all ;LiF/GW-OPTICS/ all ;H2/OPTICS/ all ;H2/RT/ all ;H2/SC/ all ;C6H3Cl3/ all ;Si_wire/OPTICS/ all ;Si_bulk/RT/ all ;Si_surface/OPTICS/ all ;H_chain/2.05/ all ;H_chain/2.5/ all ;MoS2/pwscf/OPTICS/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;MoS2/abinit/OPTICS/Without-SOC-sp2/ all ;Al_bulk/GW-OPTICS/ all ;SiH4/ all ;hBN/RT/ all ;Si_bulk/ELPH/ELPH_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Iron/abinit/With-SOC/ all ; ',
},
{
KEYS        => 'all hard',
THREADS     => '2',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;WSe2/RT/ all ;hBN/SC/ all ;LiF/GW-OPTICS/ all ;H2/OPTICS/ all ;H2/RT/ all ;H2/SC/ all ;C6H3Cl3/ all ;Si_wire/OPTICS/ all ;Si_bulk/RT/ all ;Si_surface/OPTICS/ all ;H_chain/2.05/ all ;H_chain/2.5/ all ;MoS2/pwscf/OPTICS/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;MoS2/abinit/OPTICS/Without-SOC-sp2/ all ;Al_bulk/GW-OPTICS/ all ;SiH4/ all ;hBN/RT/ all ;Si_bulk/ELPH/ELPH_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Iron/abinit/With-SOC/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;WSe2/RT/ all ;hBN/SC/ all ;LiF/GW-OPTICS/ all ;H2/OPTICS/ all ;H2/RT/ all ;H2/SC/ all ;C6H3Cl3/ all ;Si_wire/OPTICS/ all ;Si_bulk/RT/ all ;Si_surface/OPTICS/ all ;H_chain/2.05/ all ;H_chain/2.5/ all ;MoS2/pwscf/OPTICS/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;MoS2/abinit/OPTICS/Without-SOC-sp2/ all ;Al_bulk/GW-OPTICS/ all ;SiH4/ all ;hBN/RT/ all ;Si_bulk/ELPH/ELPH_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Iron/abinit/With-SOC/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '4',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/SC/ all ;WSe2/RT/ all ;hBN/SC/ all ;LiF/GW-OPTICS/ all ;H2/OPTICS/ all ;H2/RT/ all ;H2/SC/ all ;C6H3Cl3/ all ;Si_wire/OPTICS/ all ;Si_bulk/RT/ all ;Si_surface/OPTICS/ all ;H_chain/2.05/ all ;H_chain/2.5/ all ;MoS2/pwscf/OPTICS/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;MoS2/abinit/OPTICS/Without-SOC-sp2/ all ;Al_bulk/GW-OPTICS/ all ;SiH4/ all ;hBN/RT/ all ;Si_bulk/ELPH/ELPH_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Iron/abinit/With-SOC/ all ; ',
},
);
