
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
  //   goodFeaturesToTrack(image, winSize)
  // image must be single-channel, 8-bit

  double *image; 
  int winSize = (int)mxGetScalar(prhs[1]);
  double *lambda, *tr, *det, *c_xx, *c_xy, *c_yy;
  const int *imdims;
  //double dx[360000];//[MAX_IMAGE_SIZE_1D];
  //double dy[360000];//[MAX_IMAGE_SIZE_1D];
  double *dx, *dy;

  image = (double*)mxGetPr(prhs[0]);
  imdims = mxGetDimensions(prhs[0]);
  dx=(double*)malloc(sizeof(double)*imdims[0]*imdims[1]);
  dy=(double*)malloc(sizeof(double)*imdims[0]*imdims[1]);

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

  calcSobel(image, imdims[0], imdims[1], dx, dy);
  calcGoodFeature(dx, dy, imdims[0], imdims[1], winSize, 
	lambda, tr, det, c_xx, c_xy, c_yy);
  free(dx);
  free(dy);
}
