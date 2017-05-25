#
# OMP scaling
#
# date:     mar 22 mar 2016, 17.38.01, CET
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
  --with-blas-libs=" -Wl,--start-group -lmkl_intel_lp64 -lmkl_core -lmkl_intel_thread -Wl,--end-group -lpthread -lm -ldl" \
  --with-lapack-libs="-Wl,--start-group -lmkl_intel_lp64 -lmkl_core -lmkl_intel_thread -Wl,--end-group -lpthread -lm -ldl" \
  --enable-etsf-io \
  --with-fft-path="/s3_home/aferretti/codes/fftw-3.3.3" \
  --enable-time-profile \
  --enable-open-mp \
  --enable-msgs-comps


#
#        Xo          X       Dipoles      Sgm_c      Sgm_x
#
 1      
 2      59m42        2m44       3m02        6m13      1m31
 4      35m22        2m56       2m53        3m13      0m59

 8      21m22        2m47       3m11        1m53      0m43
 8 v2   20m29        2m46       2m50        1m57      0m39

16      17m24        2m52       3m16        1m39      3m14

