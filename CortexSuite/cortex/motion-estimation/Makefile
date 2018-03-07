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
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(SMALL) $(CFLAGS) -o me-small $(LDFLAGS)

medium: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(MEDIUM) $(CFLAGS) -o me-medium $(LDFLAGS)

large: $(C_SRC)
	$(COMPILE_C) $(COMMON_SRC) $(C_SRC) $(LARGE) $(CFLAGS) -o me-large $(LDFLAGS)

run-small:
	$(runqemu) ./me-small 2>&1 | tee ../results/me.small

run-medium:
	$(runqemu) ./me-medium 2>&1 | tee ../results/me.medium

run-large:
	$(runqemu) ./me-large 2>&1 | tee ../results/me.large

clean:
	-rm -f *.o me-small me-medium me-large
