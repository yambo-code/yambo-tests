#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
# CPU_CONF     => "SAMPLE_conf.cpu",
# CONFIG      => "default.sh",
 TESTS       => "MoS2/pwscf/RT 00_init 01_fix_symm 02_init 03_bands_interp; Beryllium/YPP  00_init 01_ypp 02_ypp",
# TESTS       => "Iron/pwscf/Without-SOC; hBN/RT",
# TESTS       => "Si_bulk/MAGNETIC; Si_bulk/ELPH/QP_CTL; Si_bulk/ELPH/base_for_BSE; Si_bulk/ELPH/OPTICS; Si_bulk/GW-OPTICS; Si_bulk/RT; C6H3Cl3",
#TESTS       => "hBN/RT 01_init 06_td_sex_on_the_fly",
#TESTS       => "Al111 01_init 02_eels",
#TESTS       => "H2/RT 00_init 00_ypp 01_init 04_init 05_alda",
# KEYS        => "all hard",
 KEYS        => "rt nopj hard",
},
{
 ACTIVE      => "no",
 MPI_CPU     => 2,
# CPU_CONF     => "SAMPLE_conf.cpu",
 PAR_MODE    => "default",
},
{
# ACTIVE      => "yes",
 MPI_CPU     => 4,
# MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 4,
# MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => 4,
# MPI_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "loop",
},
{
 ACTIVE      => "no",
 THREADS     => $SYSTEM_NP_half,
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP,
 SLK_CPU     => $SYSTEM_NP_half,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP,
 THREADS     => $SYSTEM_NP_half,
 SLK_CPU     => $SYSTEM_SLK,
 PAR_MODE    => "default",
},
);
