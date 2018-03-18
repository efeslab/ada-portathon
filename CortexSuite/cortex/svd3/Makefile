.SUFFIXES: .c .u
CFLAGS  = 
LDFLAGS = -lm

ifneq ($(riscv),)
        export CC=$(riscv)
	export cc=$(riscv)
	CFLAGS += -Driscv
endif

INCLUDES = -I$(CURDIR)/../../includes -I$(CURDIR)
COMPILE_C = $(CC) $(CFLAGS) -O2 $(INCLUDES)
COMMON_SRC := $(wildcard $(CURDIR)/*.c)
C_SRC := $(wildcard ../../includes/*.c)


compile:
	$(COMPILE_C) -lm main.c common/*.c $(C_SRC) svd.c svd2.c sortSVDResult.c $(LDFLAGS)

run-all: run-small run-medium run-large

run-small:
	-$(submit) ./a.out small.txt 2>&1 | tee ../results/svd.small

run-medium:
	-$(submit) ./a.out med.txt 2>&1 | tee ../results/svd.medium

run-large:
	-$(submit) ./a.out large.txt 2>&1 | tee ../results/svd.large

clean:
	-rm a.out
