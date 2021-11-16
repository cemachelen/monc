#! /bin/bash

#Script to compile Monc on ARC4:
. /nobackup/cemac/cemac.sh
# Note default svn does not work
module switch intel gnu/8.3.0
module load fftw netcdf hdf5 fcm
module load svn
module load rose
module load mosrs
. mosrs-setup-gpg-agent

fcm make -j4 -f fcm-make/monc-arc4-gnu.cfg -f fcm-make/casim_socrates.cfg -N --ignore-lock
