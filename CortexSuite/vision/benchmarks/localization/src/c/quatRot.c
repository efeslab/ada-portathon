/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "localization.h"

F2D* quatRot(F2D* vec, F2D* rQuat)
{
    F2D *ret;
    int nr, i, j, k, rows, cols;
    F2D *tv, *vQuat, *temp, *temp1;
    F2D *retVec;

    nr = vec->height;
    tv = fSetArray(nr, 1, 0);
    vQuat = fHorzcat(tv, vec);
    temp = quatMul(rQuat, vQuat);
    temp1 = quatConj(rQuat);
    retVec = quatMul(temp, temp1);

    rows = retVec->height;
    cols = retVec->width;

    ret = fSetArray(rows, 3, 0);

    for(i=0; i<rows; i++)
    {
        k = 0;
        for(j=1; j<4; j++)
        {
            subsref(ret,i,k) = subsref(retVec,i,j);
            k++;
        }
    }

    fFreeHandle(tv);
    fFreeHandle(vQuat);
    fFreeHandle(temp);
    fFreeHandle(temp1);
    fFreeHandle(retVec);
        
    return ret;
}


