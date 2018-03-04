
/* compile with 
   mex goodFeaturesToTrack.cc -I/usr/local/opencv/include -L/usr/local/opencv/lib -lcxcore -lcv
mex test.cc -L/home/ikkjin/LagrMatlab/opencv/matlab -llagrcv -I/home/ikkjin/LagrMatlab/opencv/matlab/
*/

#include "mex.h"
#include "lagrcv.h"
#include <stdio.h>
#include <math.h>

#define MAX_CORNERS 500
#define MAX_SIZE 700

// TODO: add number of corners parameter
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  // usage: [ features numvalid ] = 
  //   goodFeaturesToTrack(image, quality, mindist, mask)
  // image must be single-channel, 8-bit
  // quality = minimum acceptable ratio of eigenvalues
  // mindist = minimum distance between corners
  // mask (optional) = bitmap mask "region of interest" (MUST BE uint8 TYPE!)  

  char *image = (char*)mxGetPr(prhs[0]);
  char *sum;
  //  int imdims[] = { (int)d_imdims[0], (int)d_imdims[1] };
  const int *imdims = mxGetDimensions(prhs[0]);

  plhs[0] = mxCreateNumericMatrix(imdims[0], imdims[1], mxINT8_CLASS, mxREAL);

  sum = (char*)mxGetPr(plhs[0]);

  calcAreaSum(image, imdims[0], imdims[1], 8, sum);
}
