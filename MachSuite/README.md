# MachSuite

MachSuite is a benchmark suite intended for accelerator-centric research.

These benchmarks have been modified so one has the option to cross-compile them for a
RISC-V v1.10 Linux 4.15.0 target from an x86 host.

There is a Makefile in the top direcrory as well as one within each benchmark
subdirectory.

We suggest running the benchmarks locally (from their own directory) for now.

Also, our validation approach does is not portable across machines.
For now, the final check to see if the output is correct is not performed.
We are working on fixing it. However, this should not change the computation
or behavior of the benchmarks at all.


## Licensing

All code is open source (BSD-compatible) and free to use and distribute. Please
look in the LICENSE file for details.

## Citing

If you use the code, we would appreciate it if you cite the following paper:

> Brandon Reagen, Robert Adolf, Sophia Yakun Shao, Gu-Yeon Wei, and David Brooks.
> *"MachSuite: Benchmarks for Accelerator Design and Customized Architectures."*
  2014 IEEE International Symposium on Workload Characterization.

For any questions/concerns, please email [reagen@fas.harvard.edu](reagen@fas.harvard.edu)

##Building
Native:
To build the benchmarks natively, type
_make build_

To run natively, type
_make run_

RISC-V:
To build with a RISC-V compiler, type:
_make build CC=path/to/riscv/compiler/binary_
E.g.,
_make build CC=/home/ada/portathon/freedom-u-sdk/toolchain/bin/riscv64-unknown-linux-gnu-gcc_

To run on a risc-v emulator, type:
_make run CC=path/to/riscv/compiler/binary submit="path/to/emulator/binary"_
E.g., running on RISC-V QEMU in usermode
_make run CC=path/to/riscv/compiler/binary submit="/home/ada/portathon/freedom-u-sdk/riscv-qemu/riscv64-linux-user/qemu-riscv64 -L /home/ada/portathon/freedom-u-sdk/toolchain/sysroot"_

If there is whitespace in the submit argument, remember to put the argument in double quotes.

Enjoy!!