#!/bin/bash

#------------------------------------------------------
# You'll need to read in more command line args if your
# executable takes arguments
#------------------------------------------------------
APP=$1

#------------------------------------------------------
# The number of node-local MPI ranks
# The `--ntasks_per_node` flag to srun should be used
#------------------------------------------------------
lrank=$(($SLURM_PROCID % $SLURM_NTASKS_PER_NODE))

#------------------------------------------------------
# Ideally, the number of hardware threads set below
# for each rank with numactl should be the same as
# OMP_NUM_THREADS
#------------------------------------------------------
export OMP_NUM_THREADS=4
export OMP_PLACES=cores

#------------------------------------------------------
# Set hardware threads and GPUs for each node-local
# MPI rank. NOTE: For more than 4 MPI ranks per node, 
# additional cases would need to be added.
#------------------------------------------------------
case ${lrank} in
[0])
export HIP_VISIBLE_DEVICES=0
numactl --physcpubind=64,65,66,67 $APP
  ;;

[1])
export HIP_VISIBLE_DEVICES=1
numactl --physcpubind=68,69,70,71 $APP
  ;;

[2])
export HIP_VISIBLE_DEVICES=2
numactl --physcpubind=72,73,74,75 $APP
  ;;

[3])
export HIP_VISIBLE_DEVICES=3
numactl --physcpubind=76,77,78,79 $APP
  ;;

esac
