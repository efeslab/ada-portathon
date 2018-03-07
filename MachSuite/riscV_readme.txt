Overview:
===================================
We created a top level Makefile.variables file. This file
lets the user choose which compiler they want ($CC or $riscgcc)

Next, we changed each individual app Makefile with the following:
1) we include the Makefile.variables file (which pulls in the compiler)
2) we replaced all the "CC" instances with "compiler"

Effectively, this lets the user compiler all the programs with his/her
favorite compiler at a higher level.

This is also a simple enough method to be incorporated at a high level
Makefile, if the MachSuite developers want to do that.


Porting problems faced:
==================================
aes: 	No problem
bfs:	No problem
fft:	No problem	
gemm: 	No problem
kmp:	No problem
md:	No problem
nw:	No problem
sort:	No problem
spmv:	No problem
stencil:No problem
viterbi:No problem


backprop: didn't work on x86 to begin with...


