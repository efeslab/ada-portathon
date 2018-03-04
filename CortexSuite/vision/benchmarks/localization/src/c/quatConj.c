/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "localization.h"

F2D* quatConj(F2D* a)
{
    F2D* retQuat;
    int rows, cols;
    int i, j, k;

    rows = a->height;
    cols = a->width;
    retQuat = fSetArray(rows, 4, 0);

    for(i=0; i<rows; i++)
    {
        k=0;
        subsref(retQuat,i,k++) = subsref(a,i,0);
        subsref(retQuat,i,k++) = -subsref(a,i,1);
        subsref(retQuat,i,k++) = -subsref(a,i,2);
        subsref(retQuat,i,k) = -subsref(a,i,3);
    }

    return retQuat;
}



