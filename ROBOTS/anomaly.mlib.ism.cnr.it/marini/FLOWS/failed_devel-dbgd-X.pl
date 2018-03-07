#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/GW-OPTICS/ all ;LiF/DBGd/ all ',
},
{
ACTIVE      => 'yes',
MPI_CPU     => 8,
PAR_MODE    => 'default',
},
);
