#!/bin/bash

#------------------------------------------------------
# Sets the executable name from the first command line 
# argument to this script
#
# NOTE: You'll need to read in more command line args 
# if your executable takes arguments
#------------------------------------------------------
APP=$1

#------------------------------------------------------
# OpenMP environment variables
#
# NOTE: If you change the number of OpenMP threads, 
# you will also need to change the --physcpubind
# values below. The values given are hardware thread
# IDs, so if you want 1 OpenMP thread per physical
# core, look at the Lyra node diagram and make sure 
# to use only 1 hw thread per physical core for each 
# comma-separated value.
#------------------------------------------------------
export OMP_NUM_THREADS=4
export OMP_PLACES=cores

#------------------------------------------------------
# Set hardware thread IDs and GPUs for each node-local
# MPI rank. 
#
# NOTE: For more than 4 MPI ranks per node, 
# additional cases would need to be added.
#------------------------------------------------------
case ${SLURM_LOCALID} in
[0])
export ROCR_VISIBLE_DEVICES=0
numactl --physcpubind=64,65,66,67 $APP
  ;;

[1])
export ROCR_VISIBLE_DEVICES=1
numactl --physcpubind=68,69,70,71 $APP
  ;;

[2])
export ROCR_VISIBLE_DEVICES=2
numactl --physcpubind=72,73,74,75 $APP
  ;;

[3])
export ROCR_VISIBLE_DEVICES=3
numactl --physcpubind=76,77,78,79 $APP
  ;;

esac
