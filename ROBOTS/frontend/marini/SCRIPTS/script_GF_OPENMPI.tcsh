#!/usr/bin/tcsh
module load gcc-8.3.1/ompi-4.0.2 slurm

#cat <<EOF > script_GF_OPENMPI_${1}_${2}_parallel.slurm
##!/bin/bash -l
##SBATCH -J Yambo-testing-${2}
##SBATCH -n 8
##SBATCH --mem=1000
##SBATCH --ntasks-per-node=8
##SBATCH --time=10-00:00:00
##SBATCH --partition=debug
##
#module load gcc-8.3.1/ompi-4.0.2 slurm
#cd /work/marini/yambo-tests/
#./driver.pl -flow ${1}_8cpu -report -branch $2 -nice -newer 300 -input -host frontend
#EOF

#cat <<EOF > script_GF_OPENMPI_${1}_${2}_serial.slurm
##!/bin/bash -l
##SBATCH -J Yambo-testing-${2}
##SBATCH -n 1
##SBATCH --mem=1000
##SBATCH --ntasks-per-node=1
##SBATCH --time=10-00:00:00
##SBATCH --partition=debug
##
#module load gcc-8.3.1/ompi-4.0.2 slurm
#cd /work/marini/yambo-tests/
#./driver.pl -flow ${1}_1cpu -report -branch $2 -nice -newer 7 -input -host frontend
#EOF

#sbatch script_GF_OPENMPI_${1}_${2}_serial.slurm
#sleep 45m 
#sbatch script_GF_OPENMPI_${1}_${2}_parallel.slurm

./driver.pl -flow ${1}_8cpu -report -branch $2 -nice -newer 300 -input -host frontend
