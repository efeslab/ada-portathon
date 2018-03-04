/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "localization.h"

F2D* eul2quat(F2D* angle)
{
    F2D *ret;
    F2D *x, *y, *z;
    int k, i, j;
    int rows, cols;

    rows = angle->height;
    cols = angle->width;

    x = fDeepCopyRange(angle, 0, angle->height, 0, 1);
    y = fDeepCopyRange(angle, 0, angle->height, 1, 1);
    z = fDeepCopyRange(angle, 0, angle->height, 2, 1);

    ret = fSetArray(x->height, 4, 0);
    
    for(i=0; i<rows; i++)
    {
        float xi, yi, zi;
        k = 0;
        xi = asubsref(x,i);
        yi = asubsref(y,i);
        zi = asubsref(z,i);

        subsref(ret,i,k) = cos(xi/2)*cos(yi/2)*cos(zi/2)+sin(xi/2)*sin(yi/2)*sin(zi/2);
        k++;
        subsref(ret,i,k) = sin(xi/2)*cos(yi/2)*cos(zi/2)-cos(xi/2)*sin(yi/2)*sin(zi/2);
        k++;
        subsref(ret,i,k) = cos(xi/2)*sin(yi/2)*cos(zi/2)+sin(xi/2)*cos(yi/2)*sin(zi/2);
        k++;
        subsref(ret,i,k) = cos(xi/2)*cos(yi/2)*sin(zi/2)-sin(xi/2)*sin(yi/2)*cos(zi/2);
    }

    fFreeHandle(x);
    fFreeHandle(y);
    fFreeHandle(z);

    return ret;
}



