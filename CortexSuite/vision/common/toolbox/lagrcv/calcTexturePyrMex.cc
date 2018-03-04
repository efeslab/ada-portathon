
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
  // usage: [ lambda tr det c_xx c_xy c_yy] = 
  //   calcTexturePyrMex(dxPyr, dyPyr, winSize, level)
  // image is assumed to be double 
  // the lowest level is 1

  const int *cellDims = mxGetDimensions(prhs[0]);
  int level=0; 
  char winSize = (char )mxGetScalar(prhs[2]);
  double *dx, *dy;
  const mxArray* dxArray, * dyArray;
  const int *imdims;
  double *tr, *det, *lambda, *c_xx, *c_xy, *c_yy;

  if (nrhs > 3) level = (int)mxGetScalar(prhs[3])-1;

  dxArray= mxGetCell(prhs[0],level);
  dyArray= mxGetCell(prhs[1],level);
  dx=mxGetPr(dxArray);
  dy=mxGetPr(dyArray);
  imdims = mxGetDimensions(dxArray);

  plhs[0] = mxCreateNumericMatrix(imdims[0], imdims[1], mxDOUBLE_CLASS, mxREAL);
  plhs[1] = mxCreateNumericMatrix(imdims[0], imdims[1], mxDOUBLE_CLASS, mxREAL);
  plhs[2] = mxCreateNumericMatrix(imdims[0], imdims[1], mxDOUBLE_CLASS, mxREAL);
  plhs[3] = mxCreateNumericMatrix(imdims[0], imdims[1], mxDOUBLE_CLASS, mxREAL);
  plhs[4] = mxCreateNumericMatrix(imdims[0], imdims[1], mxDOUBLE_CLASS, mxREAL);
  plhs[5] = mxCreateNumericMatrix(imdims[0], imdims[1], mxDOUBLE_CLASS, mxREAL);

  lambda = (double*)mxGetPr(plhs[0]);
  tr = (double*)mxGetPr(plhs[1]);
  det = (double*)mxGetPr(plhs[2]);
  c_xx = (double*)mxGetPr(plhs[3]);
  c_xy = (double*)mxGetPr(plhs[4]);
  c_yy = (double*)mxGetPr(plhs[5]);

  calcGoodFeature(dx, dy, imdims[0], imdims[1], winSize,  lambda, tr, det, c_xx, c_xy, c_yy);

}
