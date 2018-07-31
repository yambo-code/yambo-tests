FACTOR=2
#
a2y_4.1 -a $FACTOR -F Fe_e50_k4_noSO.o_DS2_KSS
mv SAVE/* ../Without-SOC/SAVE_backup/
#
a2y_4.1 -a $FACTOR -F Fe_e50_k4_noSO.o_DS3_KSS
mv SAVE/* ../Without-SOC/SHIFTED_grids/shift_1/SAVE/
a2y_4.1 -a $FACTOR -F Fe_e50_k4_noSO.o_DS4_KSS
mv SAVE/* ../Without-SOC/SHIFTED_grids/shift_2/SAVE/
a2y_4.1 -a $FACTOR -F Fe_e50_k4_noSO.o_DS5_KSS
mv SAVE/* ../Without-SOC/SHIFTED_grids/shift_3/SAVE/
#
a2y_bug-fixes -a $FACTOR -F Fe_e50_k4_noSO.o_DS3_KSS
mv SAVE/* ../Without-SOC/SHIFTED_grids/shift_1/FixSAVE/SAVE/
a2y_bug-fixes -a $FACTOR -F Fe_e50_k4_noSO.o_DS4_KSS
mv SAVE/* ../Without-SOC/SHIFTED_grids/shift_2/FixSAVE/SAVE/
a2y_bug-fixes -a $FACTOR -F Fe_e50_k4_noSO.o_DS5_KSS
mv SAVE/* ../Without-SOC/SHIFTED_grids/shift_3/FixSAVE/SAVE/
#
a2y_4.1 -a $FACTOR -w -F Fe_e50_k4_noSO.o_DS6_KSS
