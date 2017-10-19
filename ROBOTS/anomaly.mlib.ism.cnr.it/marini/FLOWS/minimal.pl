#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
# CPU_CONF     => "SAMPLE_conf.cpu",
# CONFIG      => "default.sh",
# TESTS       => "MoS2/pwscf/RT 00_init 01_fix_symm 02_init",
# TESTS       => "Iron/abinit/With-SOC 01_init 02_fix_symm 03_init 04_IP-RPA_len",
 TESTS       => "Al_bulk/GW-OPTICS 01_init",
# 03_QP",
# TESTS       => "Dummy",
#; WSe2/RT; hBN/SC; Diamond/ELPH1",
# KEYS        => "all hard",
# KEYS        => "rt hard",
},
{
 ACTIVE      => "no",
 MPI_CPU     => 2,
# CPU_CONF     => "SAMPLE_conf.cpu",
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 4,
# MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 8,
# MPI_CPU     => $SYSTEM_NP,
 PAR_MODE    => "default",
},
{
 ACTIVE      => "no",
 MPI_CPU     => $SYSTEM_NP_half,
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
