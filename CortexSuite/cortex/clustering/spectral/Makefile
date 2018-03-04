.SUFFIXES: .c .u
CC= gcc
CFLAGS  = 
LDFLAGS = -lm



INCLUDES = -I$(CURDIR)/includes -I$(CURDIR)
COMPILE_C = $(CC) $(CFLAGS) -O2 $(INCLUDES)
COMMON_SRC := $(wildcard $(CURDIR)/*.c)
C_SRC := $(wildcard $(CURDIR)/includes/*.c)
SMALL = 
MEDIUM =
LARGE =

compile: small medium large

run-all: run-small run-medium run-large


small: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o spc-small $(LDFLAGS)

medium: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o spc-medium $(LDFLAGS)

large: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o spc-large $(LDFLAGS)

run-small:
	-./spc-small ../datasets/R15 600 2 15 0.707 1 2>&1 | tee ../../results/spc.small

run-medium:
	-./spc-medium ../datasets/Aggregation 788 2 7 0.707 1 2>&1 | tee ../../results/spc.medium

run-large:
	-./spc-large ../datasets/D31 1600 2 16 0.707 1 2>&1 | tee ../../results/spc.large


clean:
	-rm -f *.o spc-small spc-medium spc-large

