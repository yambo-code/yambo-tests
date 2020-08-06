#!/usr/bin/perl
@flow = (
{
KEYS        => 'rt hard',
#MPI_CPU     => '8',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT 00_init 01_fix_symm 02_init 03_map_grid 05_collisions 07_ep 08_ep_DbGd',
},
{
KEYS        => 'rt hard',
#MPI_CPU     => '8',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT 00_init 01_fix_symm 01_init 11_fix_symm 11_init 13_elph_0K_field_ad',
},
{
KEYS        => 'rt hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT 00_init 01_fix_symm 01_init 02_carriers_DB_ypp 02_elph_0K 02_elph_300K 03_coll_elel 04_elel+elph_0K',
},
{
KEYS        => 'rt hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT 00_init 01_fix_symm 01_init 05_E_DbGd 06_carriers_DB_ypp_DbGd 06_elph_0K 06_plot_elph_0K_DbGd',
},
);
