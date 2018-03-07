.SUFFIXES: .c .u
CC ?=
CFLAGS  = 
LDFLAGS = -lm
riscv ?=


ifneq ($(riscv),)
        CFLAGS += -Driscv
endif

INCLUDES = -I../../includes -I$(CURDIR)
COMPILE_C = $(CC) $(CFLAGS) -O2 $(INCLUDES)
COMMON_SRC := $(wildcard $(CURDIR)/*.c)
C_SRC := $(wildcard ../../includes/*.c)
SMALL = 
MEDIUM =
LARGE =

compile: small medium large

run-all: run-small run-medium run-large


small: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o pca-small $(LDFLAGS)

medium: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o pca-medium $(LDFLAGS)

large: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o pca-large $(LDFLAGS)

run-small:
	-./pca-small small.data 1593 256 R 2>&1 | tee ../results/pca.small

run-medium:
	-./pca-medium medium.data 722 800 R 2>&1 | tee ../results/pca.medium

run-large:
	-./pca-large large.data 5000 1059 R 2>&1 | tee ../results/pca.large


clean:
	-rm -f *.o pca-small pca-medium pca-large
