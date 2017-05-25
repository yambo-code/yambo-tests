#
# OMP scaling
#
# date:     mer 23 mar 2016, 11.20.12, CET
# version:  yambo 4.0.2 Revision 5541
#
# machine:  hydra, s3node33-s3node36  (4 nodes)
#           Intel(R) Xeon(R) CPU E5-2640 v3 @ 2.60GHz
#           Intel compilation, psxe_2015, mkl 
# running:  MPI-4
#
# tests:    aGNR, modified as follows:
#           NGsBlkXp= 4 Ry;   BndsRnXp=128,  GbndRnge=128, %QPkrange= 1| 1|  29|32|
#

./configure \
  FC=ifort \
  F77=ifort \
  CC=icc \
  PFC=mpiifort  \
  --with-blas-libs="-L/opt/intel/mkl/lib/intel64 -lmkl_intel_lp64  -lmkl_sequential -lmkl_core" \
  --with-lapack-libs="-L/opt/intel/mkl/lib/intel64 -lmkl_intel_lp64  -lmkl_sequential -lmkl_core" \
  --enable-etsf-io \
  --with-fft-path="/s3_home/aferretti/codes/fftw-3.3.3" \
  --enable-time-profile \
  --enable-open-mp \
  --enable-msgs-comps


#
#        Xo          X       Dipoles      Sgm_c      Sgm_x       WALL
#
 1      58m16        1m45       3m34       12m11      2m01      83m31
 2      29m09        1m50       3m15        6m19      1m24      45m25
 4      23m19        1m45       3m17        3m46      1m13      38m58

 8      15m00        1m45       3m07        1m58      1m21      26m15
 8      15m30        1m44       3m09        1m58      1m21      26m27

12      13m56        1m45       3m13        1m33      1m17      26m04 
16      13m42        1m48       3m08        1m46      1m26      26m05

