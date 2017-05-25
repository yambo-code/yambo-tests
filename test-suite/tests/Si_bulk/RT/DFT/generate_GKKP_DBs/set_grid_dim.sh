#!/bin/bash
#
q_in=2
q_out=2
#
sed -i "s/$q_in $q_in $q_in/$q_out $q_out $q_out/g" input/*.in
#
sed -i "s/nq1=$q_in, nq2=$q_in, nq3=$q_in/nq1=$q_out, nq2=$q_out, nq3=$q_out/g" input/*.in
