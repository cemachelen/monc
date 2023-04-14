#!/bin/bash
#SBATCH --job-name=MONC_straka_4core
#SBATCH --output=%x.o%j
  # %x gives job-name (SLURM_JOB_NAME)
  # %j gives jobid (individual SLURM_JOB_ID)
  # %A gives jobid (master     SLURM_ARRAY_JOB_ID)
  # %a gives array task id number
  #  https://slurm.schedmd.com/sbatch.html
#SBATCH --open-mode=append
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --account=n02-NES015868
#SBATCH --partition=standard
#SBATCH --reservation=shortqos
#SBATCH --qos=short

echo Starting job
compiler=gnu
#compiler=cray

module purge

if [ $compiler == "gnu" ]; then
  module load PrgEnv-gnu
  module load gcc
fi

module load craype
module load craype-x86-rome
module load --notuasked libfabric
module load craype-network-ofi
module load cray-dsmml
module load perftools-base
module load xpmem
module load cray-mpich
module load cray-libsci
module load load-epcc-module
module load epcc-setup-env
module load bolt
module load cray-hdf5-parallel
module load petsc/3.14.2
module load cray-dsmml
module load cray-fftw/3.3.8.9
module load cray-netcdf-hdf5parallel
export OMP_NUM_THREADS=1

module list
pwd

if [ ! -d checkpoint_files ]; then mkdir checkpoint_files; fi
if [ ! -d monc_stdout ]; then mkdir monc_stdout; fi
if [ ! -d diagnostic_files ]; then mkdir diagnostic_files; fi

# set env variables for submission command
config_path='tests/straka_short.mcf'
checkpoint_fn="checkpoint_files/straka_dump.nc"

srun --unbuffered --cpu-bind=cores --distribution=block:block --hint=nomultithread ./build/bin/monc_driver.exe --config=$config_path  --checkpoint_file=$checkpoint_fn
