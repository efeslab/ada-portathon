/********************************
Author: Sravanthi Kota Venkata
********************************/

#include "tracking.h"

/** Perform simple interpolation around  2*winSize*2*winSize neighbourhood **/
F2D* getInterpolatePatch(F2D* src, int cols, float centerX, float centerY, int winSize)
{
    F2D *dst;
    float a, b, a11, a12, a21, a22;
    int i, j, k, srcIdx, dstIdx;
    int srcIdxx, dstIdxx;

    a = centerX - floor(centerX);
    b = centerY - floor(centerY);

    a11 = (1-a)*(1-b);
    a12 = a*(1-b);
    a21 = (1-a)*b;
    a22 = a*b;

    dst = fSetArray(1,2*winSize*2*winSize, 0);


    for(i=-winSize; i<winSize; i++)
    {
        srcIdxx = floor(centerY) + i;
        dstIdxx = i+winSize;

        for(j=-winSize; j<(winSize); j++)
        {
            srcIdx = srcIdxx * cols + floor(centerX) + j;
            dstIdx = dstIdxx * 2 * winSize + j + winSize;
            asubsref(dst,dstIdx) = asubsref(src,srcIdx)*a11 + asubsref(src,srcIdx+1)*a12 + asubsref(src,srcIdx+cols)*a21 + asubsref(src,srcIdx+1+cols)*a22;
        }
    }

    return dst;
}



