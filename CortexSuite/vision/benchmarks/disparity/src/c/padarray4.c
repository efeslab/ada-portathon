/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "disparity.h"

void padarray4(I2D* inMat, I2D* borderMat, int dir, I2D* paddedArray)
{
    int rows, cols, bRows, bCols, newRows, newCols;
    int i, j;
    int adir;
   
    adir = abs(dir); 
    rows = inMat->height;
    cols = inMat->width;
    
    bRows = borderMat->data[0];
    bCols = borderMat->data[1];
    
    newRows = rows + bRows;
    newCols = cols + bCols;
    
    if(dir ==1)
    {
        for(i=0; i<rows; i++)
            for(j=0; j<cols; j++)
                subsref(paddedArray, i, j) = subsref(inMat,i,j);
    }
    else
    {
        for(i=0; i<rows-bRows; i++)
            for(j=0; j<cols-bCols; j++)
                subsref(paddedArray, (bRows+i), (bCols+j)) = subsref(inMat,i,j);
    }
    
    return;
}

