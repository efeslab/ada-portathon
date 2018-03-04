/** file:        imsmooth.c
 ** author:      Andrea Vedaldi
 ** description: Smooth an image.
 **/

#include"mex.h"
#include<stdlib.h>
#include<string.h>
#include<math.h>
#include<assert.h>

#define greater(a,b) ((a) > (b))
#define min(a,b) (((a)<(b))?(a):(b))
#define max(a,b) (((a)>(b))?(a):(b))

const double win_factor = 1.5 ;
const int nbins = 36 ;

void
mexFunction(int nout, mxArray *out[], 
            int nin, const mxArray *in[])
{
  int M,N ;
  double* I_pt ;
  double* J_pt ;
  double s ;
  enum {I=0,S} ;
  enum {J=0} ;

  /* ------------------------------------------------------------------
  **                                                Check the arguments
  ** --------------------------------------------------------------- */ 
  if (nin != 2) {
    mexErrMsgTxt("Exactly two input arguments required.");
  } else if (nout > 1) {
    mexErrMsgTxt("Too many output arguments.");
  }
  
  if (!mxIsDouble(in[I]) || 
      !mxIsDouble(in[S]) ) {
    mexErrMsgTxt("All arguments must be real.") ;
  }
  
  if(mxGetNumberOfDimensions(in[I]) > 2||
     mxGetNumberOfDimensions(in[S]) > 2) {
    mexErrMsgTxt("I must be a two dimensional array and S a scalar.") ;
  }
  
  if(max(mxGetM(in[S]),mxGetN(in[S])) > 1) {
    mexErrMsgTxt("S must be a scalar.\n") ;
  }

  M = mxGetM(in[I]) ;
  N = mxGetN(in[I]) ;

  out[J] = mxCreateDoubleMatrix(M, N, mxREAL) ;
  
  I_pt   = mxGetPr(in[I]) ;
  J_pt   = mxGetPr(out[J]) ;
  s      = *mxGetPr(in[S]) ;

  /* ------------------------------------------------------------------
  **                                                         Do the job
  ** --------------------------------------------------------------- */ 
  if(s > 0.01) {
    
    int W = (int) ceil(4*s) ;
    int i ; 
    int j ;
    double* g0 = (double*) mxMalloc( (2*W+1)*sizeof(double) ) ;
    double* buffer = (double*) mxMalloc( M*N*sizeof(double) ) ;
    double acc=0.0 ;
    
    for(j = 0 ; j < 2*W+1 ; ++j) {
      g0[j] = exp(-0.5 * (j - W)*(j - W)/(s*s)) ;
      acc += g0[j] ;
    }
    for(j = 0 ; j < 2*W+1 ; ++j) {
      g0[j] /= acc ;
    }
    
    /*
    ** Convolve along the columns
    **/
    for(j = 0 ; j < N ; ++j) {
      for(i = 0 ; i < M ; ++i) {
        double* start = I_pt + max(i-W,0) + j*M ;        
        double* stop = I_pt + min(i+W,M-1) + j*M + 1 ;
        double* g = g0 + max(0, W-i) ;
        acc = 0.0 ;
        while(stop != start) acc += (*g++) * (*start++) ;
        *buffer++ = acc ;
      }
    }
    buffer -= M*N ;
    
    /*
    ** Convolve along the rows
    **/
    for(j = 0 ; j < N ; ++j) {
      for(i = 0 ; i < M ; ++i) {
        double* start = buffer + i + max(j-W,0)*M ;
        double* stop  = buffer + i + min(j+W,N-1)*M + M ;
        double* g = g0 + max(0, W-j) ;
        acc = 0.0 ;
        while(stop != start) { acc += (*g++) * (*start) ; start+=M ;}
        *J_pt++ = acc ;
      }
    }    
    mxFree(buffer) ;
    mxFree(g0) ;
  } else {
    memcpy(J_pt, I_pt, sizeof(double)*M*N) ;   
  }
}
