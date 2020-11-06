# hello_jobstep

For each job step launched with a job launcher, this program prints the hardware thread IDs that each MPI rank and OpenMP thread runs on, and the GPU IDs that each rank/thread has access to.

## Compiling

To compile, you'll need to have HIP and MPI installed, and use a OpenMP-capable compiler.

## Usage

To run, simply launch the code with your favorite job launcher.

> OPTIONAL: There is an `example_map.sh` script that can be modified and called "in front of" `hello_jobstep` (or any other executable really). The script uses `numactl` to map hardware threads and GPUs to node-local MPI ranks.
