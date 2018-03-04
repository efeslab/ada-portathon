/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "localization.h"
#include <math.h>

F2D* quat2eul(F2D* quat)
{
    F2D *retEul;
    int i, j, k;
    int rows, cols;

    rows = quat->height;
    cols = quat->width;

    retEul = fSetArray(rows, 3, 0);

    for(i=0; i<rows; i++)
    {
        float temp, temp1, temp2, temp3, temp4;
        float quati2, quati3, quati1, quati0;

        quati0 = subsref(quat,i,0);
        quati1 = subsref(quat,i,1);
        quati2 = subsref(quat,i,2);
        quati3 = subsref(quat,i,3);

        temp = 2 *quati2 * quati3 + quati0 * quati1;
        temp1 = pow(quati0,2) - pow(quati1,2) - pow(quati2,2) + pow(quati3,2);
        temp2 = -2*quati1 * quati2 + quati0 * quati3;
        temp3 = 2*quati1 * quati2 + quati0 * quati3;
        temp4 = pow(quati0,2) + pow(quati1,2) - pow(quati2,2) - pow(quati3,2);
        
        asubsref(retEul,k++) = atan2(temp, temp1);
        asubsref(retEul,k++) = asin(temp2);
        asubsref(retEul,k++) = atan2(temp3, temp4);
    }

    return retEul;
}




