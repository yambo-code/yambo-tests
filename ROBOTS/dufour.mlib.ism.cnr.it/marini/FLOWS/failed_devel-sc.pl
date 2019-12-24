#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'hBN/GW-OPTICS/ all ;H_chain/2.5/ all ;H_chain/2.05/ all ;H2/OPTICS/ all ;Diamond/ELPH1/ all ;C6H3Cl3/ all ;AlAs/RT/ all ;Al_bulk/GW-OPTICS/ all ;Al111/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'hBN/GW-OPTICS/ all ;H_chain/2.5/ all ;H_chain/2.05/ all ;H2/OPTICS/ all ;Diamond/ELPH1/ all ;C6H3Cl3/ all ;AlAs/RT/ all ;Al_bulk/GW-OPTICS/ all ;Al111/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'hBN/RT/ all ;hBN/GW-OPTICS/ all ;H_chain/2.5/ all ;H_chain/2.05/ all ;H2/OPTICS/ all ;Diamond/ELPH1/ all ;C6H3Cl3/ all ;Al_bulk/GW-OPTICS/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'random',
ACTIVE      => 'yes',
TESTS     => 'hBN/RT/ all ;hBN/GW-OPTICS/ all ;H_chain/2.5/ all ;H_chain/2.05/ all ;H2/OPTICS/ all ;Diamond/ELPH1/ all ;C6H3Cl3/ all ;Al_bulk/GW-OPTICS/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'yes',
TESTS     => 'hBN/GW-OPTICS/ all ;H_chain/2.5/ all ;H_chain/2.05/ all ;H2/OPTICS/ all ;Diamond/ELPH1/ all ;C6H3Cl3/ all ;AlAs/RT/ all ;Al_bulk/GW-OPTICS/ all ;Al111/ all ; ',
},
);
