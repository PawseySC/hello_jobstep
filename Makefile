COMP   = CC

CFLAGS = -std=c++11 -fopenmp --rocm-path=${ROCM_PATH} -x hip

# Compile for specific systems in ORNL
ifeq ($(LMOD_SYSTEM_NAME),spock)
    CFLAGSADD = -D__HIP_ARCH_GFX908__=1 --offload-arch=gfx908
    $(info $(LMOD_SYSTEM_NAME))
else ifeq ($(LMOD_SYSTEM_NAME),bones)
    CFLAGSADD = -D__HIP_ARCH_GFX908__=1 --offload-arch=gfx908
    $(info $(LMOD_SYSTEM_NAME))
else ifeq ($(LMOD_SYSTEM_NAME),borg)
    CFLAGSADD = -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a
    $(info $(LMOD_SYSTEM_NAME))
else ifeq ($(LMOD_SYSTEM_NAME),crusher)
    CFLAGSADD = -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a
    $(info $(LMOD_SYSTEM_NAME))
else ifeq ($(LMOD_SYSTEM_NAME),frontier)
    CFLAGSADD = -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a
    $(info $(LMOD_SYSTEM_NAME))
endif
# Compile for specific systems in Pawsey
ifeq ($(PAWSEY_CLUSTER),mulan)
    CFLAGSADD = -D__HIP_ARCH_GFX908__=1 --offload-arch=gfx908
    $(info $(PAWSEY_CLUSTER))
else ifeq ($(PAWSEY_CLUSTER),joey)
    CFLAGSADD = -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a
    $(info $(PAWSEY_CLUSTER))
else ifeq ($(PAWSEY_CLUSTER),setonix)
    CFLAGSADD = -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a
    $(info $(PAWSEY_CLUSTER))
endif
# Add flags or throw error if cluster has not been identified
ifndef CFLAGSADD
	$(error Not LMOD_SYSTEM_NAME=$(LMOD_SYSTEM_NAME) nor PAWSEY_CLUSTER=$(PAWSEY_CLUSTER) were recognized systems. Exiting...)
else
    CFLAGS += $(CFLAGSADD)
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
