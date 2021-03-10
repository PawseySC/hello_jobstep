COMP  = CC
FLAGS = -std=c++11 -fopenmp -D__HIP_PLATFORM_HCC__ -D__HIP_ROCclr__ -D__HIP_ARCH_GFX908__=1

INCLUDES  = -I$(HIP_PATH)/include
LIBRARIES = -L$(HIP_PATH)/lib -lamdhip64

hello_jobstep: hello_jobstep.o
	$(COMP) $(FLAGS) $(LIBRARIES) hello_jobstep.o -o hello_jobstep

hello_jobstep.o: hello_jobstep.cpp
	$(COMP) $(FLAGS) $(INCLUDES) -c hello_jobstep.cpp

.PHONY: clean

clean:
	rm -f hello_jobstep *.o
