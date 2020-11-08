#!/usr/bin/perl
@flow = (
{
KEYS        => 'rt',
#MPI_CPU     => '8',
#PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT 00* 01* 02* 07_ep 03_map_grid 08_ep_DbGd',
},
{
KEYS        => 'rt',
#MPI_CPU     => '8',
#PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT 00_init 01_fix_symm 01_init 02_carriers_DB_k_ypp 02_carriers_DB_ypp 02_elph_0K 02_elph_300K 05_E_DbGd 06_carriers_DB_ypp_DbGd 06_elph_0K_DbGd',
},
{
KEYS        => 'elph hard',
#MPI_CPU     => '8',
#PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'all',
},
);
