# hello_jobstep

For each job step launched with srun, this program prints the hardware thread IDs that each MPI rank and OpenMP thread runs on, and the GPU IDs that each rank/thread has access to.

(Code has been adapted for Pawsey Supercomputing Centre purposes and documentation, but original code and repository come from ORNL [documentation for Crusher Supercomputer] (https://docs.olcf.ornl.gov/systems/crusher_quick_start_guide.html))

## Compiling

To compile, you'll need to have HIP and MPI installed, and you'll need to use an OpenMP-capable compiler. Modify the Makefile accordingly.

### Currently working Compiler + MPI + HIP Combinations

- CC (c++ Cray Compiler) + CrayMPICH
	- Modules needed for compilation on Setonix:
		`module load PrgEnv-cray rocm craype-accel-amd-gfx90a`

## Usage

To run, set the `OMP_NUM_THREADS` environment variable and launch the executable with `srun`. For example...

```
$ export OMP_NUM_THREADS=4
$ srun -A stf016 -t 10 -N 2 -n 4 -c 4 --threads-per-core=1 --gpus-per-node=4 ./hello_jobstep | sort
MPI 000 - OMP 000 - HWT 000 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 000 - OMP 001 - HWT 001 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 000 - OMP 002 - HWT 002 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 000 - OMP 003 - HWT 003 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 001 - OMP 000 - HWT 016 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 001 - OMP 001 - HWT 017 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 001 - OMP 002 - HWT 018 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 001 - OMP 003 - HWT 019 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 002 - OMP 000 - HWT 000 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 002 - OMP 001 - HWT 001 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 002 - OMP 002 - HWT 002 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 002 - OMP 003 - HWT 003 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 003 - OMP 000 - HWT 016 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 003 - OMP 001 - HWT 017 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 003 - OMP 002 - HWT 018 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 003 - OMP 003 - HWT 019 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
```

The different GPU IDs reported by the example program are:

* `GPU_ID` is the node-level (or global) GPU ID read from `ROCR_VISIBLE_DEVICES`. If this environment variable is not set (either by the user or by Slurm), the value of `GPU_ID` will be set to `N/A`.
* `RT_GPU_ID` is the HIP runtime GPU ID (as reported from, say `hipGetDevice`).
* `Bus_ID` is the physical bus ID associated with the GPUs. Comparing the bus IDs is meant to definitively show that different GPUs are being used.

> NOTE: Although the two GPU IDs (`GPU_ID` and `RT_GPU_ID`) are the same in the example above, they do not have to be. See Documented Guides for intended cluster for such examples.
