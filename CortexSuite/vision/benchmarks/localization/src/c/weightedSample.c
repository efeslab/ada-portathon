/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "localization.h"

I2D* weightedSample(F2D* w)
{
    I2D *bin;
    F2D *seed;
    int n, i, j;

    n = w->height;
    seed = randWrapper(n, 1);
    bin = iSetArray(n, 1, 0);

    for(i=0; i<n; i++)
    {
        for(j=0; j<n; j++)
        {
            if(asubsref(seed,j) > 0)
                asubsref(bin,j) = asubsref(bin,j) + 1;
        }
        for(j=0; j<n; j++)
            asubsref(seed,j) = asubsref(seed,j) - asubsref(w,i);
    }

    free(seed);
    return bin;
}




