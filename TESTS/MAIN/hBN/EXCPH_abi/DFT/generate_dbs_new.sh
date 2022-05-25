ABINIT="abinit_ibte"
MRGDDB="mrgddb_ibte"
MRGDV="mrgdv_ibte"
A2Y="a2y_a2y"

rm -rf io_dir_new
mkdir  io_dir_new

echo "abinit step 1"
$ABINIT < inputs_new/01hbn.files > 01hbn_new.log

echo "merge databases"
$MRGDDB < inputs_new/02mrgddb.in > 02mrgddb_new.log
$MRGDV  < inputs_new/03mrgdv.in  > 03mrgdv_new.log

echo "abinit final step"
$ABINIT < inputs_new/04hbn_ddb.files > 04hbn_ddb_new.log

echo "generate the yambo SAVE"


