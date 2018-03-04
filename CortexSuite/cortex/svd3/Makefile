.SUFFIXES: .c .u
CC= gcc
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
	-./a.out small.txt 2>&1 | tee ../results/svd.small

run-medium:
	-./a.out med.txt 2>&1 | tee ../results/svd.medium

run-large:
	-./a.out large.txt 2>&1 | tee ../results/svd.large

clean:
	-rm a.out
