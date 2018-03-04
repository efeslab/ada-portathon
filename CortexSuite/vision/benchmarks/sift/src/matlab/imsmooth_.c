#include<stdlib.h>
#include<string.h>
#include<math.h>
#include "imsmooth.h"

#define greater(a,b) ((a) > (b))
#define min(a,b) (((a)<(b))?(a):(b))
#define max(a,b) (((a)>(b))?(a):(b))

const double win_factor = 1.5 ;
const int nbins = 36 ;

float* imsmooth(float* I_pt_, float dsigma)
{
  int M,N ;
  float *I_pt ;
  float* J_pt_, *J_pt ;
  float* out_, *out;
  float s ;
  enum {I=0,S} ;
  enum {J=0} ;

  /* ------------------------------------------------------------------
  **                                                Check the arguments
  ** --------------------------------------------------------------- */ 

  M = (int)in_[0];
  N = (int)in_[1];

  out_ = fMallocHandle(M, N);
    J_pt_ = &(out_[0]);
    J_pt = &(J_pt_[4]);
    s = dsigma;
    

  /* ------------------------------------------------------------------
  **                                                         Do the job
  ** --------------------------------------------------------------- */ 
  if(s > 0.01) 
  {
    
    int W = (int) ceil(4*s) ;
    int i ; 
    int j ;
    float* g0_, *g0, *buffer_, *buffer, acc;
    g0_ = fMallocHandle(1, 2*W+1);
    g0 = &(g0_[4]);
    buffer_ = fMallocHandle(M, N);
    acc=0.0 ;
    
    for(j = 0 ; j < 2*W+1 ; ++j) 
    {
      g0[j] = exp(-0.5 * (j - W)*(j - W)/(s*s)) ;
      acc += g0[j] ;
    }

    for(j = 0 ; j < 2*W+1 ; ++j) 
    {
      g0[j] /= acc ;
    }
    
    /*
    ** Convolve along the columns
    **/

    for(j = 0 ; j < N ; ++j) 
    {
      for(i = 0 ; i < M ; ++i) 
      {
        float* start = I_pt + max(i-W,0) + j*M ;        
        float* stop = I_pt + min(i+W,M-1) + j*M + 1 ;
        float* g = g0 + max(0, W-i) ;
        acc = 0.0 ;
        while(stop != start) acc += (*g++) * (*start++) ;
        *buffer++ = acc ;
      }
    }
    buffer -= M*N ;
    
    /*
    ** Convolve along the rows
    **/
    for(j = 0 ; j < N ; ++j) 
    {
      for(i = 0 ; i < M ; ++i) 
      {
        float* start = buffer + i + max(j-W,0)*M ;
        float* stop  = buffer + i + min(j+W,N-1)*M + M ;
        float* g = g0 + max(0, W-j) ;
        acc = 0.0 ;
        while(stop != start) { acc += (*g++) * (*start) ; start+=M ;}
        *J_pt++ = acc ;
      }
    }    
    free(buffer) ;
    free(g0) ;
  } 
  else 
  {
    memcpy(J_pt, I_pt, sizeof(double)*M*N) ;   
  }
  return J_pt_;
}
