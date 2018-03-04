#include"mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    uint32_t* cycles;
    plhs[0] = mxCreateNumericMatrix(1, 2, mxUINT32_CLASS, mxREAL);
    cycles = (uint32_t*)mxGetPr(plhs[0]);
    __asm__ __volatile__( "rdtsc": "=a" (cycles[0]), "=d" (cycles[1]));    
 
    return;
}
