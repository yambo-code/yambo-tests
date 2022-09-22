#!/bin/bash

ABINIT="abinit_ibte"
MRGDDB="mrgddb_ibte"
MRGDV="mrgdv_ibte"
A2Y="a2y_excph"

# Control the two possible options from here
# So far only expand="yes" generates usable GKKP_expanded
expand="yes" # "no"

qkind="q_ibz" # "q_ibz"
if [ "$expand" == "yes" ] ; then qkind="q_bz" ; fi

if ! test -f io_dir_new/hbn_out_DS1_WFK.nc || ! test -f io_dir_new/hbn_out_DS2_WFK.nc ; then
  rm -rf io_dir_new
  mkdir  io_dir_new
  echo "abinit step 1"
  $ABINIT < inputs_new/01hbn.files > 01hbn_new.log
fi

if ! test -f io_dir_new/hbn_DDB || ! test -f io_dir_new/hbn_DVDB ; then
  echo "merge databases"
  $MRGDDB < inputs_new/02mrgddb.in > 02mrgddb_new.log
  $MRGDV  < inputs_new/03mrgdv.in  > 03mrgdv_new.log
fi

if ! test -f io_dir_new/hbn_${qkind}_out_GSTORE.nc ; then
  echo "abinit final step $qkind"
  $ABINIT < inputs_new/04hbn_ddb_${qkind}.files > 04hbn_ddb_${qkind}_new.log
fi

WFK_file="hbn_out_DS2"
folder="../../AllSymm"
if [ "$expand" == "yes" ] ; then
  WFK_file="hbn_wfk_expanded_out"
  folder="../../NoSymm"
  if ! test -f io_dir_new/hbn_wfk_expanded_out_WFK.nc ; then
    echo "expand wfs"
    $ABINIT < inputs_new/05_wfk_expand.files > 05_wfk_expand.log
  fi
fi

GKKP_file="GKKP"
if [ "$qkind" == "q_bz" ] ; then GKKP_file="GKKP_expanded" ; fi

echo "generate the yambo SAVE with GKKP_abinit folder"
cd io_dir_new
rm -rf ${WFK_file}_GKKP.nc
if ! test -f ${WFK_file}_GKKP.nc ; then ln -s hbn_${qkind}_out_GSTORE.nc ${WFK_file}_GKKP.nc ; fi
rm -rf SAVE
$A2Y -F ${WFK_file}_WFK.nc
if test -d SAVE ; then
  rm -rf $folder/SAVE
  rm -rf $folder/02_bse_allq
  rm -rf $folder/03_excph_lifetimes
  mv SAVE $folder/
  rm -rf $folder/$GKKP_file
  mv GKKP_abinit $folder/$GKKP_file
fi
