/*================================================================
* function w = intensityWppc(image,pi,pj,rMin,sigmaX,sigmaIntensite,valeurMinW )
* Input:
*   [pi,pj] = index pair representation for MALTAB sparse matrices
* Output:
*   w = affinity with IC at [pi,pj]
*

pixels i and j (corresponding to the sampling in pi,pj) are fully connected when d(i,j) <= rmin;

% test sequence
f = synimg(10);
[i,j] = cimgnbmap(size(f),2);
[ex,ey,egx,egy] = quadedgep(f);
a = affinityic(ex,ey,egx,egy,i,j)
show_dist_w(f,a);

* Stella X. Yu, Nov 19, 2001.
*=================================================================*/

# include "mex.h"
# include "math.h"

void mexFunction(
    int nargout,
    mxArray *out[],
    int nargin,
    const mxArray *in[]
)
{
    /* declare variables */
    int nr, nc, np, total;
    int i, j, k, ix, iy, jx, jy;
	int *ir, *jc;
	int squareDistance;
    /* unsigned long *pi, *pj; */
unsigned int *pi, *pj;
	double *w;

	double temp,a1,a2,wij;
	double rMin;
	double sigmaX, sigmaIntensite,valeurMinW;
	double *image;
    
    /* check argument */
    if (nargin<7) {
        mexErrMsgTxt("Four input arguments required");
    }
    if (nargout>1) {
        mexErrMsgTxt("Too many output arguments");
    }

    /* get edgel information */
	nr = mxGetM(in[0]);
	nc = mxGetN(in[0]);
    	np = nr * nc;

    image = mxGetPr(in[0]);


    
    /* get new index pair */
    if (!mxIsUint32(in[1]) | !mxIsUint32(in[2])) {
        mexErrMsgTxt("Index pair shall be of type UINT32");
    }
    if (mxGetM(in[2]) * mxGetN(in[2]) != np + 1) {
        mexErrMsgTxt("Wrong index representation");
    }
    pi = mxGetData(in[1]);
    pj = mxGetData(in[2]);    

    /* create output */
    out[0] = mxCreateSparse(np,np,pj[np],mxREAL);
    if (out[0]==NULL) {
	    mexErrMsgTxt("Not enough memory for the output matrix");
	}
	w = mxGetPr(out[0]);
	ir = mxGetIr(out[0]);
	jc = mxGetJc(out[0]);
	
	rMin = mxGetScalar(in[3]);
	sigmaX = mxGetScalar(in[4]);
	sigmaIntensite= mxGetScalar(in[5]);
	valeurMinW = mxGetScalar(in[6]);

	a1 = 1.0/ (sigmaX*sigmaX);
	a2 = 1.0 / (sigmaIntensite*sigmaIntensite );

    /* computation */ 
    total = 0;
    for (j=0; j<np; j++) {            

        jc[j] = total;
        jx = j / nr; /* col */
        jy = j % nr; /* row */
        
        for (k=pj[j]; k<pj[j+1]; k++) {
        
            i = pi[k];
          
            if (i==j) {
                wij= 1; /*voir*/
            
            } else {        
                ix = i / nr; 
                iy = i % nr;

		squareDistance = (ix-jx)*(ix-jx)+(iy-jy)*(iy-jy);
		
	           temp = image[i]-image[j];
		   wij = exp(- squareDistance * a1 - temp*temp * a2 );
		   /*if(wij < valeurMinW)
		      wij = -0.1;*/
            }
		ir[total] = i;

		w[total] = wij;
		total = total + 1;
			
	  } /* i */

    } /* j */
        
    jc[np] = total;
}
  
