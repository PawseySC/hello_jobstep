# hello_jobstep

For each job step launched with a job launcher, this program prints the hardware thread IDs that each MPI rank and OpenMP thread runs on, and the GPU IDs that each rank/thread has access to.

## Compiling

To compile, you'll need to have HIP and MPI installed, and you'll need to use an OpenMP-capable compiler. Modify the Makefile accordingly.

### MPI + Compiler + HIP Combinations

<b>CrayMPI + Cray Clang + ROCm  --> Makefile.crayMPI.crayClang</b>
* Requires ROCm <= v3.8 due to incompatibilities with the latest Cray compilers

<b>CrayMPI + hipcc + ROCm       --> Makefile.crayMPI.hipcc</b>

<b>OpenMPI + hipcc + ROCm       --> Makefile.openMPI.hipcc</b>

## Usage

To run, simply launch the executable with your favorite job launcher. 

> NOTE: `HIP_VISIBLE_DEVICES` must be set.

> [OPTIONAL] An example mapping script is also included in this repo for an optional heavy-handed approach to process/thread mapping. It can be modifed and called "in front of" `hello_jobstep` (or any other executable really). The script uses `numactl` to map hardware threads and GPUs to node-local MPI ranks. NOTE: You will need to use the `srun` argument `--ntasks_per_gpu` with this script.
