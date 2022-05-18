ABINIT="abinit_9.6"
MRGDDB="mrgddb_9.6"
MRGDV="mrgdv_9.6"
A2Y="a2y_a2y"

rm -rf io_dir
mkdir  io_dir

echo "abinit step 1"
$ABINIT < inputs/01hbn.files > 01hbn.log

# Option 1
# echo "abinit step 2"
#abinit_9.2 < inputs/01hbn_plusq.files > 01hbn_plusq.log
#cd io_dir
#ln -s hbn_plusq_out_DS1_WFQ.nc  hbn_out_DS2_WFQ.nc

echo "merge databases"
$MRGDDB < inputs/02mrgddb.in > 02mrgddb.log
$MRGDV  < inputs/03mrgdv.in  > 03mrgdv.log

# Option 2
cd io_dir
ln -s hbn_out_DS2_WFK.nc hbn_out_DS2_WFQ.nc   # This could be replaced by an explicit calculation at k+q if needed
ln -s hbn_out_DS2_WFK    hbn_out_DS2_WFQ
cd ..

echo "abinit final step"
$ABINIT < inputs/04hbn_ddb.files > 04hbn_ddb.log

echo "generate the yambo SAVE"


