
/* compile with 
   mex calcOpticalFlowPyrLK.cc -I/usr/local/opencv/include -L/usr/local/opencv/lib -lcxcore -lcv
*/

#include "mex.h"
#include "opencv/cv.h"
#include "opencv/highgui.h"
#include <stdio.h>
#include <math.h>

#define WIN_SIZE 8
#define PYR_LEVELS 3

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  // usage: [ newpoints status pyr1 ] = 
  //     calcOpticalFlowPyrLK(im1,im2,oldpoints,pyr1)
  // images must be single-channel, 8-bit
  // DO NOT PASS SAME IMAGE IN TWICE!

  char *im1_ptr = (char*)mxGetPr(prhs[0]);
  char *im2_ptr = (char*)mxGetPr(prhs[1]);
  const int *imdims = mxGetDimensions(prhs[0]);
  IplImage *pyr1 = 0, *pyr2 = 0;
  int flags = 0;
  bool clearPyr1 = false;
  int max_iter;

  max_iter=30;

  /* images */
  IplImage *im1 = 
    cvCreateImageHeader(cvSize(imdims[0], imdims[1]), IPL_DEPTH_8U, 1);
  IplImage *im2 = 
    cvCreateImageHeader(cvSize(imdims[0], imdims[1]), IPL_DEPTH_8U, 1);
  im1->imageData = im1_ptr;
  im2->imageData = im2_ptr;

  /* allocate pyramids */
  pyr1 = cvCreateImageHeader(cvSize(imdims[0],imdims[1]), IPL_DEPTH_8U, 1);
  pyr2 = cvCreateImageHeader(cvSize(imdims[0],imdims[1]), IPL_DEPTH_8U, 1);
  // reuse pyramid if given
  if (nrhs > 3) {
    pyr1->imageData = (char*)mxGetPr(prhs[3]);
    flags |= CV_LKFLOW_PYR_A_READY;
  } else {
    clearPyr1 = true;
    cvCreateData(pyr1);
  }

  // pyr2 will be reused, so allocate in return value
  plhs[2] = mxCreateNumericMatrix(imdims[0], imdims[1], mxUINT8_CLASS, mxREAL);
  pyr2->imageData = (char*)mxGetPr(plhs[2]);

  /* coordinate arrays */
  CvPoint2D32f *oldpoints = (CvPoint2D32f*)mxGetPr(prhs[2]);
  const int *pointsdim = mxGetDimensions(prhs[2]);
  int npoints = pointsdim[1];
  plhs[0] = mxCreateNumericMatrix(2, npoints, mxSINGLE_CLASS, mxREAL);
  CvPoint2D32f *newpoints = (CvPoint2D32f*)mxGetPr(plhs[0]);

  /* status array */
  plhs[1] = mxCreateNumericMatrix(1, npoints, mxUINT8_CLASS, mxREAL);
  char *status = (char*)mxGetPr(plhs[1]);
  
  cvCalcOpticalFlowPyrLK(im1, im2, 
                         pyr1, pyr2,
                         oldpoints, newpoints, npoints,
                         cvSize(WIN_SIZE, WIN_SIZE), PYR_LEVELS,
                         status, 
                         NULL,
                         cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS,max_iter,0.03),
                         flags
                         );
  if (clearPyr1) 
    cvReleaseImage(&pyr1);
}
