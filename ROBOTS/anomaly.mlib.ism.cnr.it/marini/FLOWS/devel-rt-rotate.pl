#!/usr/bin/perl
@flow = (
{
KEYS        => 'elph rt nopj hard',
ACTIVE      => 'no',
TESTS     => 'hBN/YPP'
},
{
ACTIVE      => 'no',
TESTS     => 'Beryllium/YPP'
},
{
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT 00_init 01_fix_symm 02_init 03_bands_interp 03_map_grid 05_collisions 07_ep 07_ypp_bands 07_ypp_dos_occ 08_ep_DbGd 08_ypp_bands_DbGd 08_ypp_dos_occ_DbGd'
},
{
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT 00_init 01_fix_symm 01_init 02_carriers_DB_ypp 02_elph_0K 02_occ_bands_elph_0K 05_E_DbGd 06_elph_0K_DbGd 06_occ_bands_elph_0K_DbGd'
},
{
ACTIVE      => 'no',
TESTS     => 'Si_bulk/ELPH/QP_CTL',
}
);
