#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 CONFIG      => "validate_CUDA_SP.sh",
 KEYS        => "all hard",
},
{
 MPI_CPU     => 2,
 THREADS     => 8,
 PAR_MODE    => "default",
},
{
 MPI_CPU     => 2,
 THREADS     => 8,
 PAR_MODE    => "random",
},
{
 MPI_CPU     => 2,
 THREADS     => 8,
 PAR_MODE    => "loop",
},
);
