#!/usr/bin/perl
#
@flow = (
{
 ACTIVE      => "yes",
 CONFIG      => "default.sh", 
 KEYS        => "all",
 TESTS       => "AGNR",
 CPU_CONF    => "32.2.cpu",
},
{
 ACTIVE      => "no",
 CPU_CONF    => "32.2.cpu"
},
{
 ACTIVE      => "yes",
 CPU_CONF    => "32.3.cpu"
},
{
 ACTIVE      => "no",
 CPU_CONF    => "32.4.cpu"
},
);
