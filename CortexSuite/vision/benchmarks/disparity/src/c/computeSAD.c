/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "disparity.h"

void computeSAD(I2D *Ileft, I2D* Iright_moved, F2D* SAD)
{
    int rows, cols, i, j, diff;
    
    rows = Ileft->height;
    cols = Ileft->width;

    for(i=0; i<rows; i++)
    {
        for(j=0; j<cols; j++)
        {
            diff = subsref(Ileft,i,j) - subsref(Iright_moved,i,j);
            subsref(SAD,i,j) = diff * diff;
        }
    }
    
    return;
}

