COMP   = CC

CFLAGS = -std=c++11 -fopenmp --rocm-path=${ROCM_PATH} -x hip

#------
#=== Additiona flags for compililation at specific systems in ORNL
#-- For spock, bones. Use:
#CFLAGSADD = -D__HIP_ARCH_GFX908__=1 --offload-arch=gfx908
#-- For borg,crusher,frontier. Use:
#CFLAGSADD = -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a

#=== Additional flags for compilation at specific systems in Pawsey
#-- For mulan. Use:
#CFLAGSADD = -D__HIP_ARCH_GFX908__=1 --offload-arch=gfx908
#-- For joey,setonix. Use:
CFLAGSADD = -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a

#=== Additional flags for compilation at specific systems in CSC
#-- For Lumi. Use:
#CFLAGSADD = -D__HIP_ARCH_GFX90A__=1 --offload-arch=gfx90a

#=== Additional flags for testing
#-- For Testing. Use:
#CFLAGSADD =

# Add flags or throw error if cluster has not been identified
ifndef CFLAGSADD
	$(error Please set CFLAGSADD for the compilation host)
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
