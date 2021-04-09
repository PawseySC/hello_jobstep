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

> NOTE: Since there are 4 OpenMP threads per MPI rank, I've included `-c 8` to make sure each MPI rank has 4 physical CPU cores to spawn the 4 OpenMP threads on. The `-c` option counts hardware threads, not physical CPU cores (there are 2 hardware threads per physical core).

> NOTE: RT_GPU_ID shows the "HIP runtime" numbering of the GPUs and GPU_ID shows the "node-level" numbering of the GPUs. The node-level numbering is what you would intuitively think of - the values 0, 1, 2, and 3 on a Lyra node - but as labeled by the HIP runtime, the GPUs visible to each MPI rank are numbered starting from 0. So if 2 MPI ranks have 2 GPUs available to them, MPI 0 might have GPUs 0 and 1 and MPI 1 might have GPUs 2 and 3. But the HIP runtime (as seen from `hipGetDevice`) will show GPU IDs 0 and 1 for both MPI ranks. This is not to say that both MPI ranks have access to the same 2 GPUs; just that the runtime labels the GPUs this way. In fact, the Bus ID for each GPU can be used to verify the MPI ranks do, in fact, have access to different GPUs.

> NOTE: If the value of GPU_ID is reported as "N/A", the environment varible `ROCR_VISIBLE_DEVICES` is not set. The program will still run fine without it - it's really only there to try to capture the node-level GPU IDs rather than the runtime GPU IDs. But the Bus IDs can be used to verify different GPUs. If desired though, `ROCR_VISIBLE_DEVICES` can be set manually before running, or set implicitly with the `--gpus-per-node` flag or `--ntasks-per-gpu` flag (although the latter is currently broken - see below for work around). It is always recommended to add a `| sort` at the end of the job step line for easier parsing (see some examples below).

### [OPTIONAL] `gpu_map.sh`

There is a `gpu_map.sh` script included in the repo also. This can be run just before the `hello_jobstep` executable to map GPUs to node-local MPI tasks in a round-robin fashion. 

For example...

```
$ export OMP_NUM_THREADS=1
$ srun -p mi100 -A stf016 -t 10 -N 1 -n 6 --cpu-bind=cores ./gpu_map.sh ./hello_jobstep | sort
MPI   0 - OMP   0 - HWT 192 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c3
MPI   1 - OMP   0 - HWT 193 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
MPI   2 - OMP   0 - HWT 194 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID a3
MPI   3 - OMP   0 - HWT 195 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 83
MPI   4 - OMP   0 - HWT 196 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c3
MPI   5 - OMP   0 - HWT 197 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
```

### [OPTIONAL] `example_map.sh`

An example mapping script is also included in this repo for an optional heavy-handed approach to process/thread mapping. It can be modifed and called "in front of" `hello_jobstep` (or any other executable really). The script uses `numactl` to map hardware threads and GPUs to node-local MPI ranks. 

> NOTE: You should NOT use `--cpu-bind` with this script. You also do not need to set `OMP_NUM_THREADS` since it is set in the script.

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

### [OPTIONAL] `fix.sh`

As mentioned above, the `--ntasks-per-gpu` flag is currently broken. As a work around, you can use the flag with this script run in front of the executable. It simply unsets `CUDA_VISIBLE_DEVICES`, which *somehow* interferes with the `ROCM_VISIBLE_DEVICES` environment variable that this flag sets. For example...

```
$ export OMP_NUM_THREADS=1
$ srun -p mi100 -A stf016 -t 10 -N 1 -n 2 --cpu-bind=cores --gpus-per-node=4 --ntasks-per-gpu=1 ./fix.sh ./hello_jobstep | sort
MPI   0 - OMP   0 - HWT 192 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c3
MPI   1 - OMP   0 - HWT 193 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
MPI   2 - OMP   0 - HWT 194 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID a3
MPI   3 - OMP   0 - HWT 195 - Node lyra14 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 83
```

> NOTE: This would have failed without the `fix.sh` script.
