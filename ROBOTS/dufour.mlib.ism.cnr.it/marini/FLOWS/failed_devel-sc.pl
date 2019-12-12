#!/usr/bin/perl
@flow = (
{
KEYS        => 'all hard',
ACTIVE      => 'yes',
TESTS     => 'Si_bulk/RT/ all ;PA_chain/ all ;He/P2Y/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'PA_chain/ all ;He/P2Y/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
PAR_MODE     => 'random',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;PA_chain/ all ;He/P2Y/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
SLK_CPU     => '4',
PAR_MODE     => 'random',
ACTIVE      => 'no',
TESTS     => 'Si_bulk/RT/ all ;PA_chain/ all ;He/P2Y/ all ;AlAs/RT/ all ; ',
},
{
KEYS        => 'all hard',
MPI_CPU     => '8',
THREADS     => '2',
SLK_CPU     => '4',
PAR_MODE     => 'default',
ACTIVE      => 'no',
TESTS     => 'PA_chain/ all ;He/P2Y/ all ; ',
},
);
