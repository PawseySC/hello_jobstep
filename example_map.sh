#!/bin/bash

export APP=$1

lrank=$(($SLURM_PROCID % 4))
export OMP_NUM_THREADS=4
export OMP_PLACES=cores

case ${lrank} in
[0])
export HIP_VISIBLE_DEVICES=0,1
numactl --physcpubind=64,65,66,67 $APP
  ;;

[1])
export HIP_VISIBLE_DEVICES=2,3
numactl --physcpubind=68,69,70,71 $APP
  ;;
esac
