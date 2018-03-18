.SUFFIXES: .c .u
.PHONY: all small medium large clean

TOP_DIR = $(shell pwd)
COMMON = $(TOP_DIR)/common

CFLAGS  = -O2 
LDFLAGS = -lm

ifneq ($(riscv),)
        export CC=$(riscv)
	export cc=$(riscv)
	CFLAGS += -Driscv	
endif



INCLUDES = -I../../includes -I$(CURDIR)
COMPILE_C = $(CC) $(CFLAGS) -O2 $(INCLUDES)
COMMON_SRC := $(wildcard $(CURDIR)/*.c)
C_SRC := $(wildcard ../../includes/*.c)


compile: small medium large

run-all: run-small run-medium run-large

small: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o lda-small $(LDFLAGS)

medium: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o lda-medium $(LDFLAGS)

large: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o lda-large $(LDFLAGS)

run-small:
	-$(submit) ./lda-small est .1 3 settings.txt small/small_data.dat random small/result 2>&1 | tee ../results/lda.small

run-medium:
	-$(submit) ./lda-medium est .1 3 settings.txt medium/medium_data.dat random medium/results 2>&1 | tee ../results/lda.medium

run-large:
	-$(submit) ./lda-large est .1 3 settings.txt large/large_data.dat random large/results 2>&1 | tee ../results/lda.large

clean:
	-rm -f *.o lda-small lda-medium lda-large
