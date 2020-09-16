#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'no',
TESTS     => 'SiH4/ all ;Si_wire/OPTICS/ all ;Si_surface/OPTICS/ all ;Si_bulk/SC/ all ;Si_bulk/RT/ all ;Si_bulk/PBE0/ all ;Si_bulk/MAGNETIC/ all ;Si_bulk/GW-OPTICS/ all ;Si_bulk/ELPH/QP_CTL/ all ;Si_bulk/ELPH/OPTICS/ all ;Si_bulk/ELPH/base_for_BSE/ all ;Si_bulk/ELPH/base/ all ;PA_chain/ all ;MoS2/pwscf/RT/ all ;MoS2/pwscf/OPTICS/Without-SOC-sp2/ all ;MoS2/pwscf/OPTICS/Without-SOC-sp1/ all ;MoS2/pwscf/OPTICS/With-SOC/ all ;MoS2/P2Y/ all ;MoS2/abinit/OPTICS/Without-SOC-sp2/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/A2Y/SP4/ all ;MoS2/A2Y/SP1/ all ;LiF/GW-OPTICS/ all ;Iron/pwscf/Without-SOC/ all ;Iron/pwscf/With-SOC/ all ;Iron/abinit/Without-SOC/ all ;Iron/abinit/With-SOC/ all ;He/GW/ all ;hBN/YPP/ all ;hBN/SC/ all ;hBN/RT/ all ;hBN/NONDIAGCELL/ all ;hBN/NL/small/ all ;hBN/GW-SHIFTED/SHIFTED/ all ;hBN/GW-SHIFTED/REGULAR/ all ;hBN/GW-SELF/ all ;hBN/GW-OPTICS/ all ;hBN/GW-ANISOTROPY/ all ;H_chain/2.5/ all ;H_chain/2.05/ all ;H2/RT/ all ;H2/OPTICS/ all ;Diamond/ELPH1/ all ;C6H3Cl3/ all ;Black-Phosphorus/RT/ all ;Beryllium/YPP/ all ;Benzene/GW-OPTICS/ all ;AlAs/RT/ all ;Al_bulk/GW-OPTICS/ all ;Al111/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'Si_wire/OPTICS/ all ;Si_surface/OPTICS/ all ;Si_bulk/RT/ all ;MoS2/P2Y/ all ;hBN/RT/ all ;hBN/NONDIAGCELL/ all ;hBN/NL/small/ all ;hBN/GW-SHIFTED/SHIFTED/ all ;Benzene/GW-OPTICS/ all ;AlAs/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'no',
TESTS     => 'Si_wire/OPTICS/ all ;Si_surface/OPTICS/ all ;Si_bulk/SC/ all ;Si_bulk/RT/ all ;MoS2/P2Y/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;hBN/RT/ all ;hBN/NONDIAGCELL/ all ;hBN/NL/small/ all ;hBN/GW-SHIFTED/SHIFTED/ all ;Benzene/GW-OPTICS/ all ;AlAs/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_wire/OPTICS/ all ;Si_surface/OPTICS/ all ;Si_bulk/RT/ all ;MoS2/P2Y/ all ;hBN/RT/ all ;hBN/NONDIAGCELL/ all ;hBN/NL/small/ all ;hBN/GW-SHIFTED/SHIFTED/ all ;Benzene/GW-OPTICS/ all ;AlAs/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '2',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_wire/OPTICS/ all ;Si_surface/OPTICS/ all ;Si_bulk/RT/ all ;Iron/pwscf/Without-SOC/ all ;hBN/RT/ all ;hBN/NONDIAGCELL/ all ;hBN/NL/small/ all ;hBN/GW-SHIFTED/SHIFTED/ all ;hBN/GW-OPTICS/ all ;Benzene/GW-OPTICS/ all ;AlAs/RT/ all ; ',
},
);
