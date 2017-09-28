Tests on KB performance and scaling - C Hogan 31/05/2016

 $ ./configure FC=mpixlf90_r F77=mpixlf77_r CC=bgxlc_r CPP=gcc -E FCFLAGS=-qsmp=omp:noauto -qstrict -qsuffix=f=f CFLAGS=-q64 
--enable-bluegene --enable-open-mp 
--with-blas-libs=-L/opt/ibmmath/essl/5.1/lib64 -lesslbg 
--with-lapack-libs=-L /cineca/prod/libraries/lapack/3.4.1/bgq-xl--1.0/lib -llapack --with-fft-path=/cineca/prod/libraries/fftw/3.3.3/bgq-xl--1.0


runjob --np 912 --ranks-per-node 8 --envs OMP_NUM_THREADS=8
(i.e. allowing 2Gb/MPI process)    

Ag(110)-(3x2) slab, 13L, 12Ry, 38 k-points, 1014 projectors, no spin
<11s> P0001: CPU-Threads:912(CPU)-8(threads)
<13s> P0001: CPU-Threads:X_q_0(environment)-38.6.4(CPUs)-k.c.v(ROLEs)


RESULTS ON FERMI
#
# Comparison of the 4 versions
#
With 8 threads:
Original   MOD(1):        30 min
KB         MOD(2):        15 min
KB_fast2   MOD(3):         5 min
KB         MOD(4):        16 min

#
#  OMP scaling
#
N TH    MOD(2)     MOD(3)
1       60m (EST)    17m
2       35m (EST)     8m
4       20m (EST)     5m
8       1m5           5m

#
# MPI scaling
#
ORIG MOD(1) MPI scaling
MPI    RPN    OMP    MINS
128     4      4     22.0
256     4      4     11.0
512     8      4      6.6
1024   16      4      4.2
