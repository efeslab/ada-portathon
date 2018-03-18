CFLAGS = -Wall -fPIC
LDFLAGS = -lm
LIBS = blas/blas.a
SHVER = 1
OS = $(shell uname)

ifneq ($(riscv),)
        export CC=$(riscv)
	export cc=$(riscv)
	CFLAGS += -Driscv	
endif

INCLUDES = -I../../includes -I$(CURDIR)
COMPILE_C = $(CC) $(CFLAGS) -O2 $(INCLUDES)
COMMON_SRC := $(wildcard $(CURDIR)/*.c)
C_SRC := $(wildcard ../../includes/*.c)

#LIBS = -lblas

blas/blas.a: blas/*.c blas/*.h
	make -C blas OPTFLAGS='$(CFLAGS)' CC='$(CC)'

compile: small medium large

run-all: run-small run-medium run-large

small: $(C_SRC) $(LIBS)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(LIBS) $(CFLAGS) -o liblinear-tsmall $(LDFLAGS)

medium: $(C_SRC) $(LIBS)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(LIBS) $(CFLAGS) -o liblinear-tmedium $(LDFLAGS)

large: $(C_SRC) $(LIBS)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(LIBS) $(CFLAGS) -o liblinear-tlarge $(LDFLAGS)

run-small:
	-$(submit) ./liblinear-tsmall data/100M/crime_scale 2>&1 | tee ../results/libl.small
run-medium:
	-$(submit) ./liblinear-tmedium data/10B/epsilon 2>&1 | tee ../results/libl.medium

run-large:
	-$(submit) ./liblinear-tlarge data/100B/kdda 2>&1 | tee ../results/libl.large

clean:
	make -C blas clean
	-rm -f *~ tron.o linear.o train liblinear.so.$(SHVER) liblinear-tsmall liblinear-tmedium liblinear-tlarge
