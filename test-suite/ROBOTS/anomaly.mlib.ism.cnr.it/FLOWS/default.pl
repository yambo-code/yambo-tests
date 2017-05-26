#!/usr/bin/perl
#
@flow = (
{
 TESTS       => "MoS2/pwscf/RT;  00_init 01_fix_symm 02_init 03_map_grid 05_collisions 08_ep_DbGd 08_ypp_plot_occ_DbGd",
# TESTS       => "MoS2/pwscf/RT 00_init 01_fix_symm 02_init 04_td_ip 04_ypp_abs",
 ACTIVE      => "yes",
 KEYS        => "all hard",
},
{
 ACTIVE      => "no",
 MPI_CPU     => "2",
 PAR_MODE    => "default",
},
{
 ACTIVE      => "no",
 MPI_CPU     => "2",
 PAR_MODE    => "random",
 THREADS     => "2",
},
{
 ACTIVE      => "no",
 MPI_CPU     => "2",
 PAR_MODE    => "loop",
},
);
