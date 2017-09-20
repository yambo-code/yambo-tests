#!/bin/bash

#rm qpt_mesh*.txt

string=$( cat output/01gs.out | grep wk  )

string=$( echo $string | tr '()' ' ' )
string=$( echo $string | tr 'wk' ' ' )
string=$( echo $string | tr 'k' ' ' )
string=$( echo $string | tr '=' ' ' )
string=$( echo $string | tr ',' ' ' )

i1=0
for number in $string; do
  i1=$( echo "$i1+1" | bc );
  vector[$i1]=$number;
done

nmax=$(echo "$i1/2" | bc)
nkpt=$(echo "$i1/10" | bc)
echo $nkpt > qpt_mesh_pwscf.txt
echo > qpt_mesh_yambo.txt
for (( i0=1 ; $i0<=$nmax ; i0=$i0+5  )); do
  i1=$( echo "$i0+1" | bc );
  i2=$( echo "$i1+1" | bc );
  i3=$( echo "$i2+1" | bc ); 
  echo ${vector[$i1]}"  "${vector[$i2]}"  "${vector[$i3]} >> qpt_mesh_pwscf.txt
#  echo ${vector[$i1]}"  "${vector[$i2]}"  "${vector[$i3]} >> qpt_mesh_yambo.txt
  yambo_q1=$(echo "scale=6; ${vector[$i1]}/(-1.)" | bc)
  yambo_q2=$(echo "scale=6; ${vector[$i2]}/(-1.)" | bc)
  yambo_q3=$(echo "scale=6; ${vector[$i3]}/(-1.)" | bc)
  echo $yambo_q1" | "$yambo_q2" | "$yambo_q3 >> qpt_mesh_yambo.txt
done
