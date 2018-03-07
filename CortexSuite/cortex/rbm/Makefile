CC = $(riscvgcc)
LDFLAGS = -lm

INCLUDES = -I$(CURDIR)/includes -I$(CURDIR)
COMPILE_C = $(CC) $(CFLAGS) -O2 $(INCLUDES)
COMMON_SRC := $(wildcard $(CURDIR)/*.c)
C_SRC := $(wildcard $(CURDIR)/includes/*.c)

compile: small medium large

run-all: run-small run-medium run-large

small: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) -DUSERS=10 -DTEST_USERS=10 -DMOVIES=10 -DLOOPS=20 -o rbm-small $(LDFLAGS)

medium: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) -DUSERS=100 -DTEST_USERS=100 -DMOVIES=100 -DLOOPS=20 -o rbm-medium $(LDFLAGS)

large: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) -DUSERS=100 -DTEST_USERS=100 -DMOVIES=100 -DLOOPS=200 -o rbm-large $(LDFLAGS)

run-small:
	$(qemu) ./rbm-small | tee ../results/rbm.small

run-medium:
	$(qemu) ./rbm-medium  | tee ../results/rbm.medium

run-large:
	$(qemu) ./rbm-large  | tee ../results/rbm.large

clean:
	-rm rbm-small rbm-medium rbm-large out.txt
