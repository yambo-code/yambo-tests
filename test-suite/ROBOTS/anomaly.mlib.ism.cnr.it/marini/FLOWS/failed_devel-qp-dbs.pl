#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'WSe2/RT/ all; Si_bulk/RT/ all ;Si_bulk/SC/ all',
#TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/base_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Si_bulk/SC/ all ;Si_bulk/MAGNETIC/ all ;WSe2/RT/ all ;AlAs/ all ;Diamond/ELPH1/ all ;Iron/pwscf/ all ;Iron/abinit/Without-SOC/ all ;MoS2/pwscf/RT/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;hBN/RT/ all ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/base/ all ;Si_bulk/ELPH/base_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Si_bulk/SC/ all ;WSe2/RT/ all ;AlAs/ all ;Diamond/ELPH1/ all ;Iron/pwscf/ all ;Iron/abinit/Without-SOC/ all ;MoS2/pwscf/RT/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;hBN/RT/ all ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/base/ all ;Si_bulk/ELPH/base_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Si_bulk/SC/ all ;WSe2/RT/ all ;AlAs/ all ;Diamond/ELPH1/ all ;Iron/pwscf/ all ;Iron/abinit/Without-SOC/ all ;MoS2/pwscf/RT/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;hBN/RT/ all  ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '4',
PAR_MODE     => 'loop',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/base/ all ;Si_bulk/ELPH/base_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Si_bulk/SC/ all ;WSe2/RT/ all ;AlAs/ all ;Diamond/ELPH1/ all ;Iron/pwscf/ all ;Iron/abinit/Without-SOC/ all ;MoS2/pwscf/RT/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;hBN/RT/ all ',
},
{
KEYS        => 'all hard',
THREADS     => '2',
ACTIVE      => 'no',
TESTS     => 'H2/RT/ all ;Si_bulk/RT/ all ;Si_bulk/ELPH/base/ all ;Si_bulk/ELPH/base_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Si_bulk/SC/ all ;Si_bulk/MAGNETIC/ all ;WSe2/RT/ all ;AlAs/ all ;Diamond/ELPH1/ all ;Iron/pwscf/ all ;Iron/abinit/Without-SOC/ all ;MoS2/pwscf/RT/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;hBN/RT/ all ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;Si_bulk/ELPH/base/ all ;Si_bulk/ELPH/base_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Si_bulk/SC/ all ;WSe2/RT/ all ;AlAs/ all ;Diamond/ELPH1/ all ;Iron/pwscf/ all ;Iron/abinit/Without-SOC/ all ;MoS2/pwscf/RT/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;hBN/RT/ all ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '4',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'H2/RT/ all ;Si_bulk/RT/ all ;Si_bulk/ELPH/base/ all ;Si_bulk/ELPH/base_for_BSE/ all ;Si_bulk/ELPH/BSE/ all ;Si_bulk/SC/ all ;WSe2/RT/ all ;AlAs/ all ;Diamond/ELPH1/ all ;Iron/pwscf/ all ;Iron/abinit/Without-SOC/ all ;MoS2/pwscf/RT/ all ;MoS2/abinit/OPTICS/With-SOC/ all ;MoS2/abinit/OPTICS/Without-SOC-sp1/ all ;hBN/RT/ all ',
},
);
