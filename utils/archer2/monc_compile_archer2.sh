#!/usr/bin/env bash                                                             

keywrdfile=$( sed "s|= |= $( pwd -P )\/fcm-make\/|g" fcm-make/keyword.cfg )
if [ ! -f ~/.metomi/fcm/keyword.cfg ]; then
  mkdir -p ~/.metomi/fcm
  echo ${keywrdfile} > ~/.metomi/fcm/keyword.cfg
else
  if cat ~/.metomi/fcm/keyword.cfg | grep -q -v "${keywrdfile}"; then
    echo ${keywrdfile} >> ~/.metomi/fcm/keyword.cfg
  fi
fi

compiler=gnu
#compiler=cray                                                                  

export PATH=$PATH:/work/y07/shared/umshared/bin
export PATH=$PATH:/work/y07/shared/umshared/software/bin
. mosrs-setup-gpg-agent

if [ $compiler == "gnu" ]; then
  module swap PrgEnv-cray PrgEnv-gnu
  module swap gcc gcc/9.3.0
fi

module load petsc/3.14.2

module load cray-dsmml
module load cray-fftw/3.3.8.9
module load cray-mpich/8.1.4
module load cray-netcdf-hdf5parallel

module load atp
export ATP_ENABLED=1

if [ $compiler == "gnu" ]; then
  fcmconfig="fcm-make/monc-cray-gnu.cfg"
elif [ $compiler == "cray" ]; then
  fcmconfig="fcm-make/monc-cray-cray.cfg"
fi

echo "Compile options: "
echo "(1)   MONC Standalone,"
echo "(2)   MONC with CASIM,"
echo "(3)   MONC with SOCRATES,"
echo "(4)   MONC with CASIM and SOCRATES"
echo ""
echo "Select which option [1-4]: "
read compileoption

case $compileoption in
1)
  fcm make -j4 -f $fcmconfig
  ;;
2)
  fcm make -j4 -f $fcmconfig -f fcm-make/casim.cfg
  ;;
3)
  fcm make -j4 -f $fcmconfig -f fcm-make/socrates.cfg
  ;;
4)
  fcm make -j4 -f $fcmconfig -f fcm-make/casim_socrates.cfg
  ;;
*)
  echo "Unexpected compilation option. Should be an integer in the range 1-4"
  ;;
esac
