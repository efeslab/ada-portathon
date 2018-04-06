## ADASuite: A RISC-V Benchmark Suite For Hardware-Software Co-Design

ADASuite is a heterogeneous benchmark suite intended to evaluate research
on agile application-driven system design, which is a focus of the
[Center for Applications Driving Architectures](http://adacenter.org/) (ADA).

The suite currently contains a RISC-V port of popular computer hardware and systems
benchmark suites, including all of CortexSuite, MachSuite, MiBench2, SPLASH-3, and several
PARSEC 2.1 benchmarks (Blackscholes, Fluidanimate, Freqmine, Streamcluster, and Swaptions).
In addition to completing the PARSEC ports, we hope to expand the ADASuite to include more benchmarks
in visual computing, natural language processing, virtual/augmented reality, and graph processing.

These ports were facilitated thanks to an ADA Center student hackathon. See the "README_portathon" file
for more information.

## RISC-V Tools Used

To cross-compile the benchmarks, we used RISC-V GCC 7.2.0, which targets RISC-V privileged architecture RISC-V v1.10
(rv64imafdc default) in a Linux environment (kernel  4.15.0). To test the binaries in the target environment,
we relied on emulation using RISC-V QEMU usermode.

We found SiFive's [Freedom SDK](https://github.com/sifive/freedom-u-sdk) a useful repository
of mutually-compatible RISC-V tools all in one location. 


## Building and Running

Each sub-directory contains instructions (in the README) for building and running the benchmarks.
All the benchmarks ported have options to be compiled natively or cross-compiled for RISC-V.
We have set up CortexSuite, MachSuite, MiBench2, SPLASH-3 such that all their benchmarks can be built, run, and cleaned from
their top directories. 

