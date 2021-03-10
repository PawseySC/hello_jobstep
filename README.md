# hello_jobstep

For each job step launched with a job launcher, this program prints the hardware thread IDs that each MPI rank and OpenMP thread runs on, and the GPU IDs that each rank/thread has access to.

## Compiling

To compile, you'll need to have HIP and MPI installed, and you'll need to use an OpenMP-capable compiler. Modify the Makefile accordingly.

### Included MPI + Compiler + HIP Combinations

* hipcc + OpenMPI

* CC + CrayMPI

> NOTE: When using Cray's MPI, you must set `export MV2_ENABLE_AFFINITY=0` to properly use Slurm's binding flags. Otherwise, the Cray MPI binding will take precedence and might give unexpected/undesired results.

## Usage

To run, simply launch the executable with your favorite job launcher. For example...

> NOTE: Since there are 4 OpenMP threads per MPI rank, I've included `-c 8` to make sure each MPI rank has 4 physical CPU cores to spawn the 4 OpenMP threads on. The `-c` option counts hardware threads, not physical CPU cores (there are 2 hardware threads per physical core).

```
$ export OMP_NUM_THREADS=4
$ srun -p mi100 -A stf016 -t 10 -N 2 -n 4 -c 8 --cpu-bind=cores --gpus-per-node=4 ./hello_jobstep | sort
MPI   0 - OMP   0 - HWT 195 - Node lyra16 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   0 - OMP   1 - HWT  66 - Node lyra16 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   0 - OMP   2 - HWT  65 - Node lyra16 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   0 - OMP   3 - HWT  64 - Node lyra16 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   1 - OMP   0 - HWT 199 - Node lyra16 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   1 - OMP   1 - HWT  70 - Node lyra16 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   1 - OMP   2 - HWT  69 - Node lyra16 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   1 - OMP   3 - HWT  68 - Node lyra16 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   2 - OMP   0 - HWT 195 - Node lyra17 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   2 - OMP   1 - HWT  66 - Node lyra17 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   2 - OMP   2 - HWT  65 - Node lyra17 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   2 - OMP   3 - HWT  64 - Node lyra17 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   3 - OMP   0 - HWT 211 - Node lyra17 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   3 - OMP   1 - HWT 208 - Node lyra17 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   3 - OMP   2 - HWT  81 - Node lyra17 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
MPI   3 - OMP   3 - HWT  80 - Node lyra17 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c3,c6,a3,83
```

### Additional Notes

> NOTE: If the output comes out garbled, you likely don't have `ROCR_VISIBLE_DEVICES` set. This can be set manually before running, or set implicitly with the `--gpus-per-node` flag or `--ntasks-per-gpu` flag (although the latter is currently broken). It is always recommended to add a `| sort` at the end of the job step line for easier parsing (see some examples below).

> NOTE: There is a `gpu_map.sh` script included in the repo also. This can be run just before the `hello_jobstep` executable to map GPUs to node-local MPI tasks in a round-robin fashion. 

For example...

```
$ srun -p mi100 -A stf016 -t 10 -N 1 -n 6 --cpu-bind=cores ./gpu_map.sh ./hello_jobstep | sort
MPI   0 - OMP   0 - HWT 192 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c3
MPI   1 - OMP   0 - HWT 193 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
MPI   2 - OMP   0 - HWT 194 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID a3
MPI   3 - OMP   0 - HWT 195 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 83
MPI   4 - OMP   0 - HWT 196 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c3
MPI   5 - OMP   0 - HWT 197 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
```

> [OPTIONAL] An example mapping script is also included in this repo for an optional heavy-handed approach to process/thread mapping. It can be modifed and called "in front of" `hello_jobstep` (or any other executable really). The script uses `numactl` to map hardware threads and GPUs to node-local MPI ranks. NOTE: You should NOT use `--cpu-bind` with this script.

For example...

```
$ srun -p mi100 -A stf016 -t 10 -N 1 -n 4 ./example_map.sh ./hello_jobstep | sort
MPI   0 - OMP   0 - HWT  64 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c3
MPI   0 - OMP   1 - HWT  65 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c3
MPI   0 - OMP   2 - HWT  66 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c3
MPI   0 - OMP   3 - HWT  67 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c3
MPI   1 - OMP   0 - HWT  68 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
MPI   1 - OMP   1 - HWT  69 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
MPI   1 - OMP   2 - HWT  70 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
MPI   1 - OMP   3 - HWT  71 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
MPI   2 - OMP   0 - HWT  72 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID a3
MPI   2 - OMP   1 - HWT  73 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID a3
MPI   2 - OMP   2 - HWT  74 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID a3
MPI   2 - OMP   3 - HWT  75 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID a3
MPI   3 - OMP   0 - HWT  76 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 83
MPI   3 - OMP   1 - HWT  77 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 83
MPI   3 - OMP   2 - HWT  78 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 83
MPI   3 - OMP   3 - HWT  79 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 83
```
