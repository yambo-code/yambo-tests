#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
# CONFIG      => "default.sh",
 TESTS       => "hBN/GW-OPTICS 01_init 02_HF",
 CPU_CONF    => "4.1.cpu",
# KEYS        => "all hard",
},
{
# ACTIVE      => "no",
# MPI_CPU     => 4,
 CPU_CONF    => "4.2.cpu",
# PAR_MODE    => "default",
},
{
# MPI_CPU     => 8,
 CPU_CONF    => "4.3.cpu",
# PAR_MODE    => "default",
},
);
