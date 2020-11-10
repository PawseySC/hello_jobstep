# hello_jobstep

For each job step launched with a job launcher, this program prints the hardware thread IDs that each MPI rank and OpenMP thread runs on, and the GPU IDs that each rank/thread has access to.

## Compiling

To compile, you'll need to have HIP and MPI installed, and use a OpenMP-capable compiler. Modify the Makefile accordingly.

## Usage

To run, simply launch the executable with your favorite job launcher. 

> NOTE: `HIP_VISIBLE_DEVICES` must be set.

> [OPTIONAL]: On Lyra, the current Slurm doesn't easily allow for fine-grained process/thread placement so an example mapping script is also included in this repo. It can be modifed and called "in front of" `hello_jobstep` (or any other executable really). The script uses `numactl` to map hardware threads and GPUs to node-local MPI ranks. NOTE: You will need to use the `srun` argument `--ntasks_per_gpu` with this script.
