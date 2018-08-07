#!/usr/bin/perl
@flow = (
{
KEYS        => 'elph rt nopj hard',
ACTIVE      => 'yes',
TESTS     => 'hBN/YPP'
},
{
ACTIVE      => 'yes',
TESTS     => 'Beryllium/YPP'
},
{
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT 00_* 01_* 02_* 03_bands_interp 07_ypp_bands 07_ypp_dos_occ 08_ypp_bands_DbGd 08_ypp_dos_occ_DbGd'
},
{
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT 00_* 01_* 02_carriers_DB_ypp 02_occ_bands_elph_0K 06_carriers_DB_ypp_DbGd 06_occ_bands_elph_0K_DbGd'
},
{
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/ELPH/QP_CTL',
}
);
