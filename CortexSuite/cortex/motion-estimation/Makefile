.SUFFIXES: .c .u
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
	-$(submit) ./me-small 2>&1 | tee ../results/me.small

run-medium:
	-$(submit) ./me-medium 2>&1 | tee ../results/me.medium

run-large:
	-$(submit) ./me-large 2>&1 | tee ../results/me.large

clean:
	-rm -f *.o me-small me-medium me-large
