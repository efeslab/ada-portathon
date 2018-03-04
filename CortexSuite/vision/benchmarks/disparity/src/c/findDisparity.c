/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "disparity.h"

void findDisparity(F2D* retSAD, F2D* minSAD, I2D* retDisp, int level, int nr, int nc)
{
    int i, j, a, b;
    
    for(i=0; i<nr; i++)
    {
        for(j=0; j<nc; j++)
        {
            a = subsref(retSAD,i,j);
            b = subsref(minSAD,i,j);
            if(a<b)
            {
                subsref(minSAD,i,j) = a;
                subsref(retDisp,i,j) = level;
            }
        }
    }
    return;
}


