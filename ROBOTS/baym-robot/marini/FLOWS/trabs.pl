#!/usr/bin/perl
@flow = (
{
KEYS        => 'rt hard',
#MPI_CPU     => '8',
#PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'MoS2/pwscf/RT 00* 01* 02* 07_ep',
},
{
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT 00_init 01_fix_symm 01_init 02_carriers_DB_k_ypp 02_carriers_DB_ypp 03_coll_elel 04_elel+elph_0K 07_IP_eh_space_10fs 08* 09* 10*',
},
{
KEYS        => 'elph hard',
ACTIVE      => 'no',
TESTS     => 'all',
},
);
