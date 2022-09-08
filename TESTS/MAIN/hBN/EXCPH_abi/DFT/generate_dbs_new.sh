ABINIT="abinit_ibte"
MRGDDB="mrgddb_ibte"
MRGDV="mrgdv_ibte"
A2Y="a2y_a2y"
qkind="q_ibz"


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

echo "generate the yambo SAVE with GKKP_abinit folder"
cd io_dir_new
rm hbn_out_DS2_GKKP.nc
ln -s hbn_${qkind}_out_GSTORE.nc hbn_out_DS2_GKKP.nc
rm -rf SAVE
$A2Y -F hbn_out_DS2_WFK.nc
mkdir ../yambo_${qkind}
mv SAVE ../yambo_${qkind}
mv GKKP_abinit ../yambo_${qkind}
