/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "localization.h"

F2D* mcl(F2D* x, F2D* sData, F2D* invConv)
{
    int i, j;
    F2D *retW, *retX, *sum;
    float sumVal;

    retX = fDeepCopy(x);
    retW = get3DGaussianProb(retX, sData, invConv);
    sum = fSum(retW);
    if(sum->height == 1 && sum->width ==1)
    {
        sumVal = asubsref(sum,0);
        for(i=0; i<retW->height; i++)
            for(j=0; j<retW->width; j++)
                subsref(retW,i,j) = subsref(retW,i,j)/sumVal;
    }
    else
        retW = fMdivide(retW, sum);

    fFreeHandle(retX);
    fFreeHandle(sum);

    return retW;
}


