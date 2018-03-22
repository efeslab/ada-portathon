# MiBench2
This is MiBench2 ported to RISC-V. See original MiBench2 https://github.com/impedimentToProgress/MiBench2.
We provide options to cross-compile to a RISC-V target or compile natively. 

All benchmarks include [barebench.h](barebench.h).


### Building
To build all the benchmarks in the top directory:
Native:

_make_

RISC-V:

_make CC=path/to/riscv/gcc/binary_

You can also apply the same instructions in the appropriate benchmark directory.


### Running 
To run all from the top directory:

_make run_

To run in RISC-V emulator:

_make run submit="path/to/emulator/binary"_

The same instructions work in the benchmark direstories.

### Default Settings

You can set the default compiler, submit, etc. in the Makefile.config file, which gets sourced by all benchmarks