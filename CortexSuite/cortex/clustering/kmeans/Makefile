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
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o kmeans-small $(LDFLAGS)

medium: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o kmeans-medium $(LDFLAGS)

large: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(CFLAGS) -o kmeans-large $(LDFLAGS)

run-small:
	-./kmeans-small ../datasets/yeast 1484 8 10 2>&1 | tee ../../results/kmeans.small

run-medium:
	-./kmeans-medium ../datasets/finland 13467 2 15 2>&1 | tee ../../results/kmeans.medium

run-large:
	-./kmeans-large ../datasets/MINST 10000 748 10 2>&1 | tee ../../results/kmeans.large


clean:
	-rm -f *.o kmeans-small kmeans-medium kmeans-large

