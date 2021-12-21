COMP   = CC

CFLAGS = -std=c++11 -fopenmp --rocm-path=${ROCM_PATH} -x hip

# Compile for specific systems
ifeq ($(LMOD_SYSTEM_NAME),spock)
    CFLAGS += -D__HIP_ARCH_GFX908__=1 --offload-arch=gfx908
    $(info $(LMOD_SYSTEM_NAME))
else ifeq ($(LMOD_SYSTEM_NAME),bones)
    CFLAGS += -D__HIP_ARCH_GFX908__=1 --offload-arch=gfx908
    $(info $(LMOD_SYSTEM_NAME))
else ifeq ($(LMOD_SYSTEM_NAME),borg)
    CFLAGS += -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a
    $(info $(LMOD_SYSTEM_NAME))
else ifeq ($(LMOD_SYSTEM_NAME),crusher)
    CFLAGS += -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a
    $(info $(LMOD_SYSTEM_NAME))
else ifeq ($(LMOD_SYSTEM_NAME),frontier)
    CFLAGS += -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a
    $(info $(LMOD_SYSTEM_NAME))
else
    $(error $(LMOD_SYSTEM_NAME) not a recognized system. Exiting...)
endif

LFLAGS = -fopenmp --rocm-path=${ROCM_PATH}

INCLUDES  = -I${ROCM_PATH}/include
LIBRARIES = -L${ROCM_PATH}/lib -lamdhip64

hello_jobstep: hello_jobstep.o
	${COMP} ${LFLAGS} ${LIBRARIES} hello_jobstep.o -o hello_jobstep

hello_jobstep.o: hello_jobstep.cpp
	${COMP} ${CFLAGS} ${INCLUDES} -c hello_jobstep.cpp

.PHONY: clean

clean:
	rm -f hello_jobstep *.o
