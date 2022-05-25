ABINIT="abinit_9.6"
MRGDDB="mrgddb_9.6"
MRGDV="mrgdv_9.6"
A2Y="a2y_a2y"

rm -rf io_dir_old
mkdir  io_dir_old

echo "abinit step 1"
$ABINIT < inputs_old/01hbn.files > 01hbn.log

# Option 1
# echo "abinit step 2"
#abinit_9.2 < inputs_old/01hbn_plusq.files > 01hbn_plusq.log
#cd io_dir_old
#ln -s hbn_plusq_out_DS1_WFQ.nc  hbn_out_DS2_WFQ.nc

echo "merge databases"
$MRGDDB < inputs_old/02mrgddb.in > 02mrgddb.log
$MRGDV  < inputs_old/03mrgdv.in  > 03mrgdv.log

# Option 2
cd io_dir_old
ln -s hbn_out_DS2_WFK.nc hbn_out_DS2_WFQ.nc   # This could be replaced by an explicit calculation at k+q if needed
ln -s hbn_out_DS2_WFK    hbn_out_DS2_WFQ
cd ..

echo "abinit final step"
$ABINIT < inputs_old/04hbn_ddb.files > 04hbn_ddb.log

echo "generate the yambo SAVE"


