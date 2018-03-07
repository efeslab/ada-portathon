.SUFFIXES: .c .u
CC= $(riscvgcc)
CFLAGS  = 
LDFLAGS = -lm



INCLUDES = -I$(CURDIR)/includes -I$(CURDIR)
COMPILE_C = $(CC) $(CFLAGS) -O2 $(INCLUDES)
COMMON_SRC := $(wildcard $(CURDIR)/*.c)
C_SRC := $(wildcard $(CURDIR)/includes/*.c)

compile:
	gcc -lm main.c common/*.c $(C_SRC) svd.c svd2.c sortSVDResult.c $(LDFLAGS)

run-all: run-small run-medium run-large

run-small:
	$(runqemu) ./a.out small.txt 2>&1 | tee ../results/svd.small

run-medium:
	$(runqemu) ./a.out med.txt 2>&1 | tee ../results/svd.medium

run-large:
	$(runqemu) ./a.out large.txt 2>&1 | tee ../results/svd.large

clean:
	-rm a.out
