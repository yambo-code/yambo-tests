#
# OMP scaling
#
# date:     gio 17 mar 2016, 14.56.25, CET
# version:  yambo 4.0.2 Revision 5523
#
# machine:  hydra, s3node37-s3node40  (4 nodes)
#           Intel(R) Xeon(R) CPU E5-2640 v3 @ 2.60GHz
#           Intel compilation, psxe_2015, mkl 
# running:  MPI-4
#
# tests:    aGNR, modified as follows:
#           NGsBlkXp= 4 Ry;   BndsRnXp=128,  GbndRnge=128, %QPkrange= 1| 1|  29|32|
#

#
#        Xo          X       Dipoles      Sgm_c      Sgm_x
#
 1      59m45        1m52       6m03       12m23      1m45
 2      29m15        1m46       3m45        6m22      1m21
 4      22m41        1m45       3m08        3m22      1m23
 8      15m04        1m46       2m56        2m11      1m22 
12      13m51        1m47       3m04        1m44      1m19

16      14m09        1m53       3m18        1m53      1m25
16      13m29        1m50       3m47        1m18      1m24
16      14m27        1m50       3m24        1m52      1m24

