/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "disparity.h"

void finalSAD(F2D* integralImg, int win_sz, F2D* retSAD)
{
    int endR, endC;
    int i, j, k;
    
    endR = integralImg->height;
    endC = integralImg->width;
    
    k = 0;
    for(j=0; j<(endC-win_sz); j++)
    {
        for(i=0; i<(endR-win_sz); i++)
        {
            subsref(retSAD,i,j) = subsref(integralImg,(win_sz+i),(j+win_sz)) + subsref(integralImg,(i+1) ,(j+1)) - subsref(integralImg,(i+1),(j+win_sz)) - subsref(integralImg,(win_sz+i),(j+1));
        }
    }

    return;
}

