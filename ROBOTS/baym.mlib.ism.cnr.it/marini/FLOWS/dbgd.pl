#!/usr/bin/perl
@flow = (
{
KEYS        => 'rt',
ACTIVE      => 'no',
TESTS     => 'hBN/RT',
#TESTS     => 'hBN/RT 01* 02_collisions_sex 08* 09* 10* 11* 12* 13*',
},
{
KEYS        => 'rt',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT',
#TESTS     => 'Si_bulk/RT 00_init 01* 05* 06_elph_0K_DbGd 06_carriers_DB_ypp_DbGd 06_fit_elph_0K_DbGd 06_occ_bands_elph_0K_DbGd',
},
{
KEYS        => 'rt',
ACTIVE      => 'yes',
TESTS     => 'MoS2/pwscf/RT',
},
{
KEYS        => 'elph',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/ELPH/base_for_BSE;Si_bulk/ELPH/OPTICS',
},
{
KEYS        => 'none',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/GW-OPTICS',
},
);
