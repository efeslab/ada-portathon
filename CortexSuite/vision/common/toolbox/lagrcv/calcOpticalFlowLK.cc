
/* compile with 
   mex calcOpticalFlowPyrLK.cc -I/usr/local/opencv/include -L/usr/local/opencv/lib -lcxcore -lcv
*/

#include "mex.h"
#include "opencv/cv.h"
#include "opencv/highgui.h"
#include <stdio.h>
#include <math.h>

#define WIN_SIZE 10
#define PYR_LEVELS 3

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  // usage: [ newpoints status pyr1 ] = 
  //     calcOpticalFlowPyrLK(im1,im2,oldpoints,pyr1)
  // images must be single-channel, 8-bit
  // DO NOT PASS SAME IMAGE IN TWICE!

  char *im1_ptr = (char*)mxGetPr(prhs[0]);
  char *im2_ptr = (char*)mxGetPr(prhs[1]);
  const int *imdims = mxGetDimensions(prhs[0]);
  int flags = 0;
  int max_iter;

  if(nrhs>3){
	max_iter=(int)mxGetScalar(prhs[3]);
  }else{
	max_iter=20;
  }

  /* images */
  IplImage *im1 = 
    cvCreateImageHeader(cvSize(imdims[0], imdims[1]), IPL_DEPTH_8U, 1);
  IplImage *im2 = 
    cvCreateImageHeader(cvSize(imdims[0], imdims[1]), IPL_DEPTH_8U, 1);
  im1->imageData = im1_ptr;
  im2->imageData = im2_ptr;

  /* coordinate arrays */
  CvPoint2D32f *oldpoints = (CvPoint2D32f*)mxGetPr(prhs[2]);
  const int *pointsdim = mxGetDimensions(prhs[2]);
  int npoints = pointsdim[1];
  plhs[0] = mxCreateNumericMatrix(2, npoints, mxSINGLE_CLASS, mxREAL);
  CvPoint2D32f *newpoints = (CvPoint2D32f*)mxGetPr(plhs[0]);

  /* status array */
  plhs[1] = mxCreateNumericMatrix(1, npoints, mxUINT8_CLASS, mxREAL);
  char *status = (char*)mxGetPr(plhs[1]);
  
  cvCalcOpticalFlowLK(im1, im2, 
                         cvSize(WIN_SIZE, WIN_SIZE), velx, vely
                         status, 
                         NULL,
                         cvTermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS,max_iter,0.03),
                         flags
                         );
}
