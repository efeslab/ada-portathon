
/* compile with 
rm liblagrcv.a
gcc -c lagrcv.cpp
ar rc liblagrcv.a lagrcv.o
ranlib liblagrcv.a
mex7 calcTextureMex.cc -L/home/ikkjin/LagrMatlab/opencv/matlab -llagrcv -I/home/ikkjin/LagrMatlab/opencv/matlab/
*/

#include "mex.h"
#include "lagrcv.h"
#include <stdio.h>
#include <math.h>

// TODO: add number of corners parameter
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  // usage: [IBlur] = 
  //   calcImgBlurMex(image)

  double *image, *retImg; 
  const int *imdims;

  image=(double*)mxGetPr(prhs[0]);
  imdims = mxGetDimensions(prhs[0]);

  plhs[0] = mxCreateNumericMatrix(imdims[0], imdims[1], mxDOUBLE_CLASS, mxREAL);
  retImg=(double*)mxGetPr(plhs[0]);

  calcImgBlur(image, imdims[0], imdims[1], retImg);
}
