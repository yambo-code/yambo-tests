#!/usr/bin/perl
@flow = (
{
KEYS        => 'nopj',
ACTIVE      => 'yes',
TESTS     => 'hBN/YPP'
},
{
KEYS        => 'nopj',
ACTIVE      => 'yes',
TESTS     => 'Beryllium/YPP'
},
{
KEYS        => 'rt',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT 00_* 01_* 02_* 03_bands_interp 07_ypp_bands 07_ypp_dos_occ 08_ypp_bands_DbGd 08_ypp_dos_occ_DbGd'
},
{
KEYS        => 'rt',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT 00_* 01_* 02_carriers* 02_occ_bands_elph_0K 06_carriers_DB_ypp_DbGd 06_occ_bands_elph_0K_DbGd'
},
);
