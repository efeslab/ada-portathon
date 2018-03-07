.SUFFIXES: .c .u
CC= $(riscvgcc)
CFLAGS  = -O2
LDFLAGS = -lm



INCLUDES = -I$(CURDIR)/includes -I$(CURDIR)
COMPILE_C = $(CC) $(CFLAGS) -O2 $(INCLUDES)
COMMON_SRC := $(wildcard $(CURDIR)/*.c)
C_SRC := $(wildcard $(CURDIR)/includes/*.c)
SMALL = -DSYNTHETIC1
MEDIUM = -DALPACA
LARGE = -DBOOKCASE

compile: small medium large

run-all: run-small run-medium run-large

small: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(SMALL) $(CFLAGS) -o srr-small $(LDFLAGS)

medium: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(MEDIUM) $(CFLAGS) -o srr-medium $(LDFLAGS)

large: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(LARGE) $(CFLAGS) -o srr-large $(LDFLAGS)

run-small:
	$(runqemu) ./srr-small 2>&1 | tee ../results/srr.small

run-medium:
	$(runqemu) ./srr-medium 2>&1 | tee ../results/srr.medium

run-large:
	$(runqemu) ./srr-large 2>&1 | tee ../results/srr.large

clean:
	-rm -f srr-small srr-medium srr-large
