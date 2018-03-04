//function W = mex_template(X,Y);

#include <math.h>
#include <mex.h>
//#include <matrix.h>
//#include "mex_util.cpp"

//#define PI 3.1415927

void mexFunction(int nargout, mxArray *out[], int nargin, const mxArray 
*in[]) {
    //reading in
    const mxArray *X = in[0];
    double *pr = mxGetPr(X);
    int *ir = mxGetIr(X);
    int *jc = mxGetJc(X);
    int m = mxGetM(X);
    int n = mxGetN(X);
    
    mxArray *cell_1 = mxGetCell(cell_input,0);
    mxGetData()
    mxGetNumberOfDimensions()
    mxGetDimensions()
    mxGetNumberOfElements()
    
    //sparse array reading
    int i,j,k;
    double x;
    for (j=0;j<n;j++)
        for (k=jc[j]; k!=jc[j+1]; k++) {
            i = ir[k];
            x = pr[k];
            //x = X(i,j);
        }
    
    //printing variables & debugging
    int nnz = jc[n];
    mexPrintf("nnz = %d\n",nnz);
    double z = 0.15;
    mexPrintf("z = %1.3g \n",z);
    mexErrMsgTxt("Stopped\n");
    
    //common functions
    fabs(x) // absolute value of float x
    
    //writing out
    mxArray *W = mxCreateSparse(m, n, nnz, mxREAL);

    
    mxArray *args[2];
    args[0] = (mxArray*) prhs[0];
    args[1] = mxCreateDoubleScalar(2.0);
    mexCallMATLAB(1, plhs, 2, args, "sum");

    //allocating, desallocating
    int *ind = (int*)mxCalloc(n,sizeof(int));
    mxFree(ind);
}