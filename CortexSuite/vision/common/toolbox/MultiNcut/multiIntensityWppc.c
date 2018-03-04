/*================================================================
* function w = multiIntensityWppc(image,pi,pj,rMin,sigmaX,sigmaIntensite,valeurMinW,
*                                 subgrid,nrSubgrid,ncSubgrid,subpi)
* Input:
*   [pi,pj] = index pair representation for MALTAB sparse matrices
* Output:
*   w = affinity with IC at [pi,pj]
*

imageX,wiInOriginalImage,wwj,rMin,dataWpp.sigmaX,sigmaI,minW,subgrid{1,i},p(i),q(i),wi{i}


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
    int nr, nc, np, nW, total;
    int i, j, k, t, ix, iy, jx, jy, nrSubgrid, ncSubgrid;
	int *ir, *jc;
	int squareDistance;
    /*	unsigned long *pi, *pj, *subpi; */
	unsigned int *pi, *pj, *subpi;
	double *w, *subgrid, *tmp;

	double temp,a1,a2,wij;
	double rMin;
	double sigmaX, sigmaIntensite,valeurMinW;
	double *image;
    
    /* check argument */
    if (nargin<11) {
        mexErrMsgTxt("Eleven input arguments required");
    }
    if (nargout>1) {
        mexErrMsgTxt("Too many output arguments");
    }

    /* get edgel information */
	nr = mxGetM(in[0]);
	nc = mxGetN(in[0]);
    	np = nr * nc;
    /*printf("size: %d, %d, %d\n", nc, nr, np); */
    image = mxGetPr(in[0]);

 
    /*get subgrid information*/
    
    tmp = mxGetData(in[8]);
    nrSubgrid = (int)tmp[0];

    /* printf("image end = %f ", image[np-1]); */
    
    tmp = mxGetData(in[9]);
    ncSubgrid = (int)tmp[0];
    
    if (nrSubgrid* ncSubgrid != mxGetM(in[7])*mxGetN(in[7])) {
          mexErrMsgTxt("Error in the size of the subgrid");
          }
    subgrid = mxGetData(in[7]);
    nW = nrSubgrid * ncSubgrid;
    
    
    
    
    /* get new index pair */
    if (!mxIsUint32(in[1]) | !mxIsUint32(in[2])) {
        mexErrMsgTxt("Index pair shall be of type UINT32");
    }
    if (mxGetM(in[2]) * mxGetN(in[2]) != nW + 1) {
        mexErrMsgTxt("Wrong index representation");
    }
    pi = mxGetData(in[1]);
    pj = mxGetData(in[2]);    
    subpi = mxGetData(in[10]);
    
    /* create output */
    out[0] = mxCreateSparse(nW,nW,pj[nW],mxREAL);
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
    for (j=0; j<nW; j++) { 
     
        t= (int)subgrid[j]-1;  /*on parcourt tous les pixels de la sous-grille dans la grille d'origine*/ 
        if ( (t<0) || (t>np-1)) {printf("badddddd!");}
	/*     printf("t = %d\n",t);
	       printf("j = %d\n",j); */
        jc[j] = total;
        jx = t / nr; /* col */
        jy = t % nr; /* row */
     /*  printf("pj[j+1] = %d\n",pj[j+1]); */
       
        for (k=pj[j]; k<pj[j+1]; k++) {
         /* printf("k = %d\n",k); */
            i = pi[k]-1;
            ix = i / nr; 
            iy = i % nr;
            squareDistance = (ix-jx)*(ix-jx)+(iy-jy)*(iy-jy);/*abs(ix-jx)+abs(iy-jy);*/
            if (squareDistance <= rMin) { wij = 1;}
            else {
              temp = image[i]-image[t];
           wij = exp(- squareDistance * a1 - temp*temp * a2 );
		   /*if(wij < valeurMinW)
		      wij = 0;*/
              /*wij = exp( - temp*temp * a2 );*/
		    }
          
            ir[total] = (int)subpi[k];
            
           /* if (ir[total] >5000*5000 ) {printf("trouble! [%d,%d]\n",k,(int)subpi[k]);} */
                
		     w[total] = wij;
		   
		     total = total + 1;
				
	  } /* i */

 
    } /* j */
        
    jc[nW] = total;
}  
