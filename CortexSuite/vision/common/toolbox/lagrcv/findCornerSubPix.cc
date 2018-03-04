
/* compile with 
   mex findCornerSubPix.cc -I/usr/local/opencv/include -L/usr/local/opencv/lib -lcxcore -lcv
*/

#include "mex.h"
#include "opencv/cv.h"
#include "opencv/highgui.h"
#include <stdio.h>
#include <math.h>

//#define MAX_CORNERS 500
#define WIN_SIZE 5

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  // usage: [ features ] = 
  //   findCornerSubPix(image, features)
  // image must be single-channel, 8-bit

  char *image_pr = (char*)mxGetPr(prhs[0]);
  const int *imdims = mxGetDimensions(prhs[0]);
  IplImage *image = 
    cvCreateImageHeader(cvSize(imdims[0], imdims[1]), IPL_DEPTH_8U, 1);
  image->imageData = image_pr;

  const int *feature_dims = mxGetDimensions(prhs[1]);
  int nfeatures = feature_dims[1];
  plhs[0] = mxCreateNumericMatrix(2, nfeatures, mxSINGLE_CLASS, mxREAL);
  CvPoint2D32f *newfeatures = (CvPoint2D32f*)mxGetPr(plhs[0]);
  CvPoint2D32f *oldfeatures = (CvPoint2D32f*)mxGetPr(prhs[1]);
  //  plhs[0] = mxDuplicateArray(prhs[1]);
  //  CvPoint2D32f *newfeatures = (CvPoint2D32f*)mxGetPr(plhs[0]);
  memcpy(newfeatures, oldfeatures, sizeof(float)*2*nfeatures);

  cvFindCornerSubPix(image, newfeatures, nfeatures, 
                     cvSize(WIN_SIZE,WIN_SIZE),
                     cvSize(-1,-1),
                     cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS,20,0.03));
}
