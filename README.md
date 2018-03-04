March 7, 2018

Welcome to the ADA Portathon!

High-level overview:

The goal of this exercise is to port benchmarks to be used within the ADA center to RISC-V.
Specifically, we will be porting the CortexSuite, MachSuite, MiBench, Splash, and PARSEC benchmarks to the latest
RISC-V privileged architecture RISC-V v1.10
(for reference, see https://raw.githubusercontent.com/riscv/riscv-isa-manual/master/release/riscv-privileged-v1.10.pdf
and https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf).

What this entails is providing options within the benchmarks to cross-compile from a host (say, x86 linux platform)
to a RISC-V linux target, in addition to compiling natively. So, we will be modifying the make or build files of
the benchmarks to add such options, trying to be compatible with the benchmarks' current run procedure. If needed,
we may create a sourcefile to be run before the makefile (to set certain environment variables). 

We will then be compiling the benchmarks to RISC-V and modifying their source code to change regions that are
incompatible with RISC-V. Sources of such incompatibility can range from use of inline x86 assembly instructions
to use of libraries that are currently not ported to RISC-V GCC. We will be attempting
to fix such incompatibilities or at least documenting which specific benchmarks are unsupported and why.

Our approach:

Compiling: We will use the latest upstreamed RISC-V GCC version 7.2.0 to compile to RISC-V.
Testing: We will use the hardware emulator QEMU to test our compiled binaries on usermode. QEMU will emulate a RISC-V
system running Linux 4.15.0. It will emulate all the required system calls via your host VM. 

We have pre-built all the latest RISC-V tools and downloaded all the benchmarks we will needed for this task on your VM.

Benchmarks are located in: /home/ada/portathon
Tools are located in: /home/ada/portathon/freedom-u-sdk

Here is where the most important RISC-V tools are located:
RISC-V GCC: /home/ada/portathon/freedom-u-sdk/toolchain/bin/riscv64-unknown-linux-gnu-gcc
RISC-V G++: /home/ada/portathon/freedom-u-sdk/toolchain/bin/riscv64-unknown-linux-gnu-g++

RISC-V QEMU usermode binary: /home/ada/portathon/freedom-u-sdk/riscv-qemu/riscv64-linux-user/qemu-riscv64
path to libraries (to be passed to QEMU): /home/ada/portathon/freedom-u-sdk/toolchain/sysroot

For convenience, we have set environment variables to map to the binaries you'll need.

$riscvgcc maps to RISC-V GCC
$riscvgpp maps to RISC-V G++

$riscvqemu maps to /home/ada/portathon/freedom-u-sdk/riscv-qemu/riscv64-linux-user/qemu-riscv64
$riscvsysroot maps to /home/ada/portathon/freedom-u-sdk/toolchain/sysroot

$runqemu maps to $riscvqemu -L $riscvsysroot

Compilation steps:

$ $riscvgcc -o [riscv_binary] [sourcecode]

Running:
$ $runqemu [riscv_binary] [args]

What to produce:
1) A log file of all bugs encountered and the fixes
2) A new README that describes what your new make and run steps are, including examples
3) A git push to the ada-portathon repo updating the sourcecode and adding the new files
