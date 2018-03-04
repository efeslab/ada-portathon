
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
  // usage: [newFeaturePnt validFlag ] = 
  //   calcOptFlowPyrLKMex(Ipyr, IdxPyr, IdyPyr, Jpyr, featurePnt, winSize, c_level, c_det, c_xx, c_xy, c_yy)
  // Ipyr, IdxPyr, IdyPyr, Jpyr: levelx1 size cell.
  // featurePnt 2xn int
  // winSize c_level int
  // c_xx c_xy c_yy: image size double*
  // image must be single-channel, 8-bit

  
  double* fPntDouble;
  const int *nFeatures;
  char* valid;
  int *fPnt, *newFPnt; 

  fPntDouble=(double*)mxGetPr(prhs[0]);
  nFeatures=mxGetDimensions(prhs[0]);
  fPnt=(int*)malloc(sizeof(int)*nFeatures[0]*nFeatures[1]);

  printf("nFeatures %d, %d", nFeatures[0], nFeatures[1]);
  //plhs[0] = mxCreateNumericMatrix(nFeatures[0], nFeatures[1], mxINT32_CLASS, mxREAL);
  plhs[0] = mxCreateNumericArray(2,nFeatures,mxINT32_CLASS, mxREAL);
  //plhs[1] = mxCreateNumericMatrix(1, nFeatures[1], mxINT32_CLASS, mxREAL);
  plhs[1] = mxCreateNumericArray(1,nFeatures+1,mxUINT8_CLASS, mxREAL);

  newFPnt = (int*)mxGetPr(plhs[0]);
  valid = (char*)mxGetPr(plhs[1]);

  //idx convert from matlab to c
  for(int i=0; i<nFeatures[1]; i++){
	fPnt[i*2]=(int)fPntDouble[i*2]-1;
	fPnt[i*2+1]=(int)fPntDouble[i*2+1]-1;
	valid[i]=1;
  }
  
  //printf("v %d %d %d", valid[0], valid[1], valid[2]);

  //idx convert from matlab to c
  for(int i=0; i<nFeatures[1]*2; i++){
  	newFPnt[i]=fPnt[i]+1;
  }
  free(fPnt);
}
