
/* compile with 
   mex goodFeaturesToTrack.cc -I/usr/local/opencv/include -L/usr/local/opencv/lib -lcxcore -lcv
*/

#include "mex.h"
#include "opencv/cv.h"
#include "opencv/highgui.h"
#include <stdio.h>
#include <math.h>

#define MAX_CORNERS 500

IplImage *eigtemp = NULL, *temp2 = NULL;

// TODO: add number of corners parameter
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  // usage: [ features numvalid ] = 
  //   goodFeaturesToTrack(image, quality, mindist, mask)
  // image must be single-channel, 8-bit
  // quality = minimum acceptable ratio of eigenvalues
  // mindist = minimum distance between corners
  // mask (optional) = bitmap mask "region of interest" (MUST BE uint8 TYPE!)  

  char *image_pr = (char*)mxGetPr(prhs[0]);
  //  int imdims[] = { (int)d_imdims[0], (int)d_imdims[1] };
  const int *imdims = mxGetDimensions(prhs[0]);
  double quality = mxGetScalar(prhs[1]);
  double mindist = mxGetScalar(prhs[2]);
  bool use_roi = nrhs > 3;

  plhs[0] = mxCreateNumericMatrix(2, MAX_CORNERS, mxSINGLE_CLASS, mxREAL);
  plhs[1] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, mxREAL);

  CvPoint2D32f *corner_coords = (CvPoint2D32f*)mxGetPr(plhs[0]);
  int *corner_count = (int*)mxGetPr(plhs[1]);
  *corner_count = MAX_CORNERS;

  if (eigtemp == NULL) {
    eigtemp = cvCreateImage(cvSize(imdims[0],imdims[1]), IPL_DEPTH_32F, 1);
    temp2 = cvCreateImage(cvSize(imdims[0],imdims[1]), IPL_DEPTH_32F, 1);
  }

  IplImage *image = 
    cvCreateImageHeader(cvSize(imdims[0], imdims[1]), IPL_DEPTH_8U, 1);
  image->imageData = image_pr;

  IplImage *roimask = NULL;
  if (use_roi) {
    roimask = cvCreateImage(cvSize(imdims[0],imdims[1]), IPL_DEPTH_8U, 1);
    roimask->imageData = (char*)mxGetPr(prhs[3]);
  }

  cvGoodFeaturesToTrack(image, 
                        eigtemp, temp2, 
                        corner_coords,
                        corner_count,
                        quality, 
                        mindist, 
                        roimask
                        );
}
