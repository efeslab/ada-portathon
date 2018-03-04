
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
  // usage: [dxPye dyPyr] = 
  //   calcGradientPyrMex(imagePyr)

  double *image, *retImg; 
  int newSizeY, newSizeX;
  const int *imdims;

  image=(double*)mxGetPr(prhs[0]);
  imdims = mxGetDimensions(prhs[0]);

  newSizeY=imdims[0]/2;
  newSizeX=imdims[1]/2;
  plhs[0] = mxCreateNumericMatrix(newSizeY, newSizeX, mxDOUBLE_CLASS, mxREAL);
  retImg=(double*)mxGetPr(plhs[0]);

  calcSubSampleAvg(image, imdims[0], imdims[1], retImg, newSizeY, newSizeX);
}
