COMP  = hipcc
FLAGS = --amdgpu-target=gfx906,gfx908 -fopenmp

INCLUDES  = -I$(OLCF_OPENMPI_ROOT)/include -I$(ROCM_PATH)/rocm_smi/include
LIBRARIES = -L$(OLCF_OPENMPI_ROOT)/lib -lmpi -L$(ROCM_PATH)/lib -lrocm_smi64

hello_jobstep: hello_jobstep.o
	$(COMP) $(FLAGS) $(LIBRARIES) hello_jobstep.o -o hello_jobstep

hello_jobstep.o: hello_jobstep.cpp
	$(COMP) $(FLAGS) $(INCLUDES) -c hello_jobstep.cpp

.PHONY: clean

clean:
	rm -f hello_jobstep *.o
