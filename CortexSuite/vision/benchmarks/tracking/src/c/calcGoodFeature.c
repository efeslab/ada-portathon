/********************************
Author: Sravanthi Kota Venkata
********************************/

#include "tracking.h"

/** Computes lambda matrix, strength at each pixel
    
    det = determinant( [ IverticalEdgeSq IhorzVertEdge; IhorzVertEdge IhorizontalEdgeSq] ) ;
    tr = IverticalEdgeSq + IhorizontalEdgeSq;
    lamdba = det/tr;

    Lambda is the measure of the strength of pixel
    neighborhood. By strength we mean the amount of 
    edge information it has, which translates to
    sharp features in the image.

    Input:  Edge images - vertical and horizontal
            Window size (neighborhood size)
    Output: Lambda, strength of pixel neighborhood

    Given the edge images, we compute strength based
    on how strong the edges are within each neighborhood.

**/

F2D* calcGoodFeature(F2D* verticalEdgeImage, F2D* horizontalEdgeImage, int cols, int rows, int winSize)
{
    int i, j, k, ind;
    F2D *verticalEdgeSq, *horizontalEdgeSq, *horzVertEdge;
    F2D *tr, *det, *lambda;
    F2D *cummulative_verticalEdgeSq, *cummulative_horzVertEdge, *cummulative_horizontalEdgeSq;

    verticalEdgeSq = fMallocHandle(rows, cols);
    horzVertEdge = fMallocHandle(rows, cols);
    horizontalEdgeSq = fMallocHandle(rows, cols);
    
    for( i=0; i<rows; i++)
    {
        for( j=0; j<cols; j++)
        {
            subsref(verticalEdgeSq,i,j) = subsref(verticalEdgeImage,i,j) * subsref(verticalEdgeImage,i,j);
            subsref(horzVertEdge,i,j) = subsref(verticalEdgeImage,i,j) * subsref(horizontalEdgeImage,i,j);
            subsref(horizontalEdgeSq,i,j) = subsref(horizontalEdgeImage,i,j) * subsref(horizontalEdgeImage,i,j);
        }
    }
    
    cummulative_verticalEdgeSq = calcAreaSum(verticalEdgeSq, cols, rows, winSize); 
    cummulative_horzVertEdge = calcAreaSum(horzVertEdge, cols, rows, winSize);
    cummulative_horizontalEdgeSq = calcAreaSum(horizontalEdgeSq, cols, rows, winSize);    
     
    tr = fMallocHandle(rows, cols);
    det = fMallocHandle(rows, cols);
    lambda = fMallocHandle(rows, cols);
    
    for( i=0; i<rows; i++)
    {
        for( j=0; j<cols; j++)
        {
            subsref(tr,i,j) = subsref(cummulative_verticalEdgeSq,i,j) + subsref(cummulative_horizontalEdgeSq,i,j);
            subsref(det,i,j) = subsref(cummulative_verticalEdgeSq,i,j) * subsref(cummulative_horizontalEdgeSq,i,j) - subsref(cummulative_horzVertEdge,i,j) * subsref(cummulative_horzVertEdge,i,j);
            subsref(lambda,i,j) = ( subsref(det,i,j) / (subsref(tr,i,j)+0.00001) ) ;
        }
    }
   
    fFreeHandle(verticalEdgeSq);
    fFreeHandle(horzVertEdge);
    fFreeHandle(horizontalEdgeSq);

    fFreeHandle(cummulative_verticalEdgeSq);
    fFreeHandle(cummulative_horzVertEdge);
    fFreeHandle(cummulative_horizontalEdgeSq);
    
    fFreeHandle(tr);
    fFreeHandle(det);
     
    return lambda;
}
