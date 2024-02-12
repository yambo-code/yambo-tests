OPTS="-a 2 -e 4"
so_kind="noSO"
ySO_kind="Without-SOC"
a2y=a2y_magn_t    # a2y_4.1
more=""           # ""
kind="WFK.nc"     # "KSS"
abinit=abinit_9.6
#
#$abinit < Fe_noSO.files > Fe_e50_k4_noSO.log 
#
$a2y $OPTS -F Fe_e50_k4_${so_kind}.o_DS2_${kind}
mv SAVE/* ../$ySO_kind/SAVE${more}/
echo "Updated main SAVE"
#
$a2y $OPTS -F Fe_e50_k4_${so_kind}.o_DS3_${kind}
mv SAVE/* ../$ySO_kind/SHIFTED_grids/shift_1/SAVE${more}/
echo "Updated SAVE shift 1"
$a2y $OPTS -F Fe_e50_k4_${so_kind}.o_DS4_${kind}
mv SAVE/* ../$ySO_kind/SHIFTED_grids/shift_2/SAVE${more}/
echo "Updated SAVE shift 2"
$a2y $OPTS -F Fe_e50_k4_${so_kind}.o_DS5_${kind}
mv SAVE/* ../$ySO_kind/SHIFTED_grids/shift_3/SAVE${more}/
echo "Updated SAVE shift 3"
#
$a2y $OPTS -w -F Fe_e50_k4_${so_kind}.o_DS6_${kind}
mv SAVE/* ../$ySO_kind/FINE_grid/SAVE${more}/
echo "Updated SAVE FINE grid"
#
rmdir SAVE
