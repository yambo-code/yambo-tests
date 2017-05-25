
#
# OMP scaling
#
# date:     sab 28 mag 2016, 21.20.38, CEST
# version:  yambo 4.0.2 Revision 13600 Hash 166c0d7
#
# machine:  Fermi, 128 BGQ nodes
# running:  MPI-256
#
# tests:    AGNR, modified as follows:
#           NGsBlkXp= 3 Ry;   BndsRnXp=256,  GbndRnge=512, %QPkrange= 1| 8|  29|32|
#

#
#       WF-IO         Xo          X       Dipoles      Sgm_x      Sgm_c  
#
 1      14m13       37m03        2m42       9m09       37m00    230m00
 2      14m19       19m18        1m50       7m31       18m58    116m00 
 4      14m41       10m06        1m16       6m44       10m05     58m50  
 8      14m44        5m14        1m00       6m21        5m19     30m 4        
16      14m21        3m15        0m55       6m10       12m24     16m10

#
# MPI scaling
# running:  OMP-16 per task (32 per BGQ node)
#
 128    07m01        6m15        0m54       4m36       24m29     31m11
 256    14m21        3m15        0m55       6m10       12m24     16m10
 512    07m24        1m56        0m57       3m12        6m14      8m12            
1024    14m21        0m59        0m56       5m00        3m06      4m16
2048    14m15        0m29        0m56       4m48        1m34      2m19
4096    14m47        0m18        1m00       4m44        0m47      1m25

#
# MPI scaling
# running:  OMP-16 per task (32 per BGQ node) with dipfast
#
 256    20m15        3m15        2m13       6m42       12m12     16m19
 512    19m30        1m57        2m12       5m52        6m14      8m59


