CC=${TARGET_CC}
RISCV_FLAGS=-I/home/ada/portathon/freedom-u-sdk/riscv-gnu-toolchain/riscv-glibc/sunrpc/

patricia: patricia.c patricia_test.c
ifeq ($(CC), $(riscvgcc))
	$(CC) -static patricia.c patricia_test.c $(RISCV_FLAGS) -O3 -o patricia
else
	$(CC) -static patricia.c patricia_test.c -O3 -o patricia
endif
clean:
	rm -rf patricia output*
