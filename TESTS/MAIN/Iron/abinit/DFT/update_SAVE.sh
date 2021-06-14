FACTOR=2
a2y=a2y_fx        # a2y_4.1
more="_converted" # ""
kind="WFK.nc"     # "KSS"
#
$a2y -a $FACTOR -F Fe_e50_k4_noSO.o_DS2_${kind}
mv SAVE/* ../Without-SOC/SAVE_backup${more}/
echo "Updated main SAVE"
#
$a2y -a $FACTOR -F Fe_e50_k4_noSO.o_DS3_${kind}
mv SAVE/* ../Without-SOC/SHIFTED_grids/shift_1/SAVE${more}/
echo "Updated SAVE shift 1"
$a2y -a $FACTOR -F Fe_e50_k4_noSO.o_DS4_${kind}
mv SAVE/* ../Without-SOC/SHIFTED_grids/shift_2/SAVE${more}/
echo "Updated SAVE shift 2"
$a2y -a $FACTOR -F Fe_e50_k4_noSO.o_DS5_${kind}
mv SAVE/* ../Without-SOC/SHIFTED_grids/shift_3/SAVE${more}/
echo "Updated SAVE shift 3"
#
$a2y -a $FACTOR -w -F Fe_e50_k4_noSO.o_DS6_${kind}
mv SAVE/* ../Without-SOC/FINE_grid/SAVE${more}/
echo "Updated SAVE FINE grid"
#
rmdir SAVE
