
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
  //   calcOptFlowLKPyrWInitMex2(Ipyr, IdxPyr, IdyPyr, Jpyr, featurePnt, winSize, accuracy_th, max_iter, initFPnt)
  // Ipyr, IdxPyr, IdyPyr, Jpyr: levelx1 size cell.
  // featurePnt 2xn int
  // winSize c_level int
  // c_xx c_xy c_yy: image size double*
  // image must be double

  
  const mxArray* imgArray;
  int* imdims;
  const int *curImgDims;
  const int *nFeatures;
  double *iP[MAX_LEVEL], *iDxP[MAX_LEVEL], *iDyP[MAX_LEVEL], *jP[MAX_LEVEL];
  double *fPnt, *newFPnt, *initFPnt; 
  char* valid;
  double accuracy_th;
  int winSize, max_iter;
  const int *cellDims = mxGetDimensions(prhs[0]);

  accuracy_th=(double)mxGetScalar(prhs[6]);
  max_iter=(int)mxGetScalar(prhs[7]);
  initFPnt=(double*)mxGetPr(prhs[8]);
	
  winSize = (int)mxGetScalar(prhs[5]);
  fPnt=(double*)mxGetPr(prhs[4]);
  nFeatures=mxGetDimensions(prhs[4]);

  imdims=(int*)malloc(sizeof(int)*cellDims[0]*2);

  for(int i=0; i<cellDims[0]; i++){
        //imgArray=mxGetCell(prhs[0],i);
  	//curImgDims = mxGetDimensions(imgArray);
  	curImgDims = mxGetDimensions(mxGetCell(prhs[0],i));
  	imdims[i*2+0]= curImgDims[0];
  	imdims[i*2+1]= curImgDims[1];
  	//imdims[i][1] = curImgDims[1];

  	iP[i]= (double*)mxGetPr(mxGetCell(prhs[0],i));
  	iDxP[i]= (double*)mxGetPr(mxGetCell(prhs[1],i));
  	iDyP[i]= (double*)mxGetPr(mxGetCell(prhs[2],i));
  	jP[i]= (double*)mxGetPr(mxGetCell(prhs[3],i));
  }

  plhs[0] = mxCreateNumericMatrix(nFeatures[0], nFeatures[1], mxDOUBLE_CLASS, mxREAL);
  plhs[1] = mxCreateNumericMatrix(1, nFeatures[1], mxUINT8_CLASS, mxREAL);

  newFPnt = (double*)mxGetPr(plhs[0]);
  valid = (char*)mxGetPr(plhs[1]);

  //idx convert from matlab to c
  for(int i=0; i<nFeatures[1]; i++){
	fPnt[i*2]=(fPnt[i*2]-1)/2;
	fPnt[i*2+1]=(fPnt[i*2+1]-1)/2;
	initFPnt[i*2]=(initFPnt[i*2]-1)/2;
	initFPnt[i*2+1]=(initFPnt[i*2+1]-1)/2;
	valid[i]=1;
  }
  calcPyrLKTrackWInit( iP, iDxP, iDyP, jP, imdims, cellDims[0], fPnt, nFeatures[1], winSize, 
	 newFPnt, initFPnt, valid, accuracy_th, max_iter); 
  //idx convert from matlab to c
  for(int i=0; i<nFeatures[1]*2; i++){
	fPnt[i]=fPnt[i]*2+1;
	initFPnt[i]=initFPnt[i]*2+1;
  	newFPnt[i]=newFPnt[i]*2+1;
  }
  free(imdims);
  //free(iP);
  //free(iDxP);
  //free(iDyP);
  //free(jP);
}
