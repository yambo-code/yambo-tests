
the AGNR test have been slightly modified in terms of convergence parameters
wrt the file input.txt

* scaling_X_r5444     before the omp_locks implementation
* scaling_X_r5523     after the locks implementation
* scaling_X_r5541_FFTW3-MKL-OMP    using FFTW3 with multithread support (MKL)
* scaling_X_r5541_FFTW3-OMP        using FFTW3 with multithread support (native)

a descritive file README_scaling_X.txt is present inside each directory
collecting the main timings

Because of some machine instability/non-reproducibility of the data, some 
of the runs have been repeated several times (this gives somehow a hint about
the overall error bar on timing).

