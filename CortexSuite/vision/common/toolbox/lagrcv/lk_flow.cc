
/* compile with 
   lk_flow.cc -I/usr/local/opencv/include -L/usr/local/opencv/lib -lcxcore -lcv
*/

#include "mex.h"
#include "opencv/cv.h"
#include "opencv/highgui.h"
#include <stdio.h>
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  // usage: [ velx vely ] = lk_flow(image1,image2,winsize)
  // images must be single-channel, 8-bit

  const int *backwards_imdims = mxGetDimensions(prhs[0]);
  int imdims[2] = { backwards_imdims[1], backwards_imdims[0] };
  int winsize = (int)mxGetScalar(prhs[2]);
  plhs[0] = mxCreateNumericArray(2, imdims, mxSINGLE_CLASS, mxREAL);
  plhs[1] = mxCreateNumericArray(2, imdims, mxSINGLE_CLASS, mxREAL);

  printf("imsize %d %d\n", imdims[0], imdims[1]);

  IplImage *im1 = 
    cvCreateImageHeader(cvSize(imdims[0], imdims[1]), IPL_DEPTH_8U, 1);
  IplImage *im2 = 
    cvCreateImageHeader(cvSize(imdims[0], imdims[1]), IPL_DEPTH_8U, 1);
  IplImage *flow_x = 
    cvCreateImageHeader(cvSize(imdims[0], imdims[1]), IPL_DEPTH_32F, 1);
  IplImage *flow_y = 
    cvCreateImageHeader(cvSize(imdims[0], imdims[1]), IPL_DEPTH_32F, 1);
  
  im1->imageData = (char*)mxGetPr(prhs[0]);
  im2->imageData = (char*)mxGetPr(prhs[1]);
  flow_x->imageData = (char*)mxGetPr(plhs[0]);
  flow_y->imageData = (char*)mxGetPr(plhs[1]);

  cvCalcOpticalFlowLK(im1, im2, cvSize(winsize,winsize), flow_x, flow_y);

  for (int row = 0; row < imdims[0]; row += 10) {
    for (int col = 0; col < imdims[1]; col += 10) {
      cvLine(im1, cvPoint(col,row),
             cvPoint(int(col + flow_x->imageData[imdims[1] * row + col]), 
                     int(row + flow_y->imageData[imdims[1] * row + col])),
             CV_RGB(1,0,0),
             1,
             CV_AA,
             0);
             
    }
  }

  cvDestroyAllWindows();
  cvNamedWindow("imfoo",CV_WINDOW_AUTOSIZE);
  //  IplImage *myim = cvLoadImage("lena.jpg", -1);
    cvShowImage("imfoo",im1);
  //    cvShowImage("imfoo",myim);
    cvWaitKey(0);

  //  cvCircle(flow_x, cvPoint( 40, 20), 15, CV_RGB(10,100,100), 5);

  /*
  FILE* filefx = fopen("fx.pgm", "w");
  FILE* filefy = fopen("fy.pgm", "w");
  fprintf(filefx, "P5\n%d %d\n255\n", imdims[1], imdims[0]);
  fprintf(filefy, "P5\n%d %d\n255\n", imdims[1], imdims[0]);
  float *ptr = (float*)flow_x->imageData;
  for (int i = 0; i < imdims[1] * imdims[0]; i++) {
    //    if (fabs(++ptr*) > 0.1) 
    if (fabs(*ptr++) > 0.1) fprintf(filefx, "1");
    else fprintf(filefx, "0");
  }
  fclose(filefx);
  fclose(filefy);
  */
}
