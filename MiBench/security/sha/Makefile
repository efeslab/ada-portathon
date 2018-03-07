# By default, the code is compiled for a "big endian" machine.
# To compile on a "little endian" machine set the LITTLE_ENDIAN flag.
# To make smaller object code, but run a little slower, don't use UNROLL_LOOPS.
# To use NIST's modified SHA of 7/11/94, define USE_MODIFIED_SHA

CC = ${TARGET_CC}
CFLAGS = -O3 -Wall

sha:	sha_driver.o sha.o
	$(CC) -o $@ sha_driver.o sha.o
ifeq ($(CC), $(riscvgcc))
	/home/ada/portathon/freedom-u-sdk/toolchain/bin/riscv64-unknown-linux-gnu-strip $@
else
	strip $@
endif

clean:
	rm -rf *.o sha output*
