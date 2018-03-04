/********************************
Author: Sravanthi Kota Venkata
********************************/

#include "tracking.h"

/** Compute the sum of pixels over pixel neighborhood.
    Neighborhood = winSize*winSize 
    This will be useful when we compute the displacement
    of the neighborhood across frames instead of tracking each pixel.

    Input:  src Image
            # rows, cols, size of window
    Output: windowed-sum image, ret.

    Example:
    
    winSize = 4, cols = 8, rows = 16
    nave_half = 2, nave = 4
    Say, the first row of the image is:
                3 8 6 2 4 8 9 5
    a1 =    0 0 3 8 6 2 4 8 9 5 0 0 (append nave_half zeros to left and right border)
    asum =  (sum the first nave # pixels - 0 0 3 8 ) = 11
    ret(0,0) =  11
    For ret(0,1), we need to move the window to the right by one pixel and subtract
    from a1sum the leftmost pixel. So, we add value 6 and subtract value at a1(0,0), = 0 here.
    ret(0,1) = 17 = a1sum
    For ret(0,2), a1sum - a1(0,1) + a1(2+nave) = 17 - 0 + 2 = 19 = a1sum
    For ret(0,3), a1sum - a1(0,2) + a1(3+nave) = 19 - 3 + 4 = 20 = a1sum

    We proceed this way for all the rows and then perform summantion across all cols.
**/
F2D* calcAreaSum(F2D* src, int cols, int rows, int winSize)
{
    int nave, nave_half, i, j, k;
    F2D *ret, *a1;
    float a1sum;
    
    nave = winSize;
    nave_half = floor((nave+1)/2);

    ret = fMallocHandle(rows, cols);
    a1 = fSetArray(1, cols+nave,0);

    for(i=0; i<rows; i++)
    {
        for(j=0; j<cols; j++) {
            asubsref(a1,j+nave_half) = subsref(src,i,j);
		}
        a1sum = 0;
        for(k=0; k<nave; k++) {
            a1sum += asubsref(a1,k);
		}
        for(j=0; j<cols; j++)
        {
            subsref(ret,i,j) = a1sum;
            a1sum += asubsref(a1,j+nave) - asubsref(a1,j);
        }
    }
    fFreeHandle(a1);

    a1 = fSetArray(1, rows+nave,0);
    for(i=0; i<cols; i++)
    {
        for(j=0; j<rows; j++) {
            asubsref(a1,j+nave_half) = subsref(ret,j,i);
		}
        a1sum = 0;
        for(k=0; k<nave; k++) {
            a1sum += asubsref(a1,k);
		}
        for(j=0; j<rows; j++)
        {
            subsref(ret,j,i) = a1sum;
            a1sum += asubsref(a1,j+nave) - asubsref(a1,j);
        }
    }
    fFreeHandle(a1);

    return ret; 
}
