
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
  // usage: [dxPye dyPyr] = 
  //   calcGradientPyrMex(imagePyr)

  const int *cellDims = mxGetDimensions(prhs[0]);
  double *image; 
  const mxArray* imgArray;
  mxArray *dxArray, *dyArray;
  double *dx, *dy;
  const int *imdims;

  plhs[0] = mxCreateCellArray(1, cellDims);
  plhs[1] = mxCreateCellArray(1, cellDims);

  for(int i=0; i<cellDims[0];i++){
  	imgArray= mxGetCell(prhs[0],i);
	image=mxGetPr(imgArray);
        imdims = mxGetDimensions(imgArray);

        dxArray = mxCreateNumericMatrix(imdims[0], imdims[1], mxDOUBLE_CLASS, mxREAL);
        dyArray = mxCreateNumericMatrix(imdims[0], imdims[1], mxDOUBLE_CLASS, mxREAL);
	mxSetCell(plhs[0], i, dxArray);
	mxSetCell(plhs[1], i, dyArray);
	dx=mxGetPr(dxArray);
	dy=mxGetPr(dyArray);

  	calcGradient(image, imdims[0], imdims[1], dx, dy);
  	//calcSobel(image, imdims[0], imdims[1], dx, dy);
  }
}
