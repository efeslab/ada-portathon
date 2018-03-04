
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

#ifndef MAX_LEVEL
#	define MAX_LEVEL 5
#endif
// TODO: add number of corners parameter
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  // usage: [newFeaturePnt validFlag ] = 
  //   calcOptFlowLKMex(I, Idx, Idy, J, c_xx, c_xy, c_yy, featurePnt, initialPnt, winSize, accuracy_th, max_iter)
  // featurePnt 2xn int
  // winSize c_level int
  // c_xx c_xy c_yy: image size double*
  // image must be double

  
  const int* imdims;
  const int *nFeatures;
  double *imgI, *iDx, *iDy, *imgJ, *c_xx, *c_xy, *c_yy;
  double *fPnt, *initPnt, *newFPnt; 
  char* valid;
  double accuracy_th;
  int winSize, max_iter;

  if (nrhs > 10) {
  	accuracy_th=(double)mxGetScalar(prhs[10]);
  	max_iter=(int)mxGetScalar(prhs[11]);
  }
	
  winSize = (int)mxGetScalar(prhs[9]);
  initPnt=(double*)mxGetPr(prhs[8]);
  fPnt=(double*)mxGetPr(prhs[7]);
  c_xx=(double*)mxGetPr(prhs[6]);
  c_xy=(double*)mxGetPr(prhs[5]);
  c_yy=(double*)mxGetPr(prhs[4]);
  imgJ=(double*)mxGetPr(prhs[3]);
  iDy=(double*)mxGetPr(prhs[2]);
  iDx=(double*)mxGetPr(prhs[1]);
  imgI=(double*)mxGetPr(prhs[0]);
  nFeatures=mxGetDimensions(prhs[7]);
  imdims=mxGetDimensions(prhs[0]);

  plhs[0] = mxCreateNumericMatrix(nFeatures[0], nFeatures[1], mxDOUBLE_CLASS, mxREAL);
  plhs[1] = mxCreateNumericMatrix(1, nFeatures[1], mxUINT8_CLASS, mxREAL);

  newFPnt = (double*)mxGetPr(plhs[0]);
  valid = (char*)mxGetPr(plhs[1]);

  //idx convert from matlab to c
  for(int i=0; i<nFeatures[1]; i++){
	fPnt[i*2]=fPnt[i*2]-1;
	fPnt[i*2+1]=fPnt[i*2+1]-1;
	initPnt[i*2]=initPnt[i*2]-1;
	initPnt[i*2+1]=initPnt[i*2+1]-1;
	valid[i]=1;
  }
  if(nrhs>10){
	calcLKTrack( imgI, iDx, iDy, imgJ, imdims, 
	 c_xx, c_xy, c_yy,
	 fPnt, initPnt, nFeatures[1], winSize, 
	 newFPnt, valid, accuracy_th, max_iter); 
  }else{	
	calcLKTrack( imgI, iDx, iDy, imgJ, imdims,
	 c_xx, c_xy, c_yy,
	 fPnt, initPnt, nFeatures[1], winSize, 
	 newFPnt, valid); 
  }
  //idx convert from matlab to c
  for(int i=0; i<nFeatures[1]*2; i++){
	fPnt[i]=fPnt[i]+1;
	initPnt[i]=initPnt[i]+1;
  	newFPnt[i]=newFPnt[i]+1;
  }
}
