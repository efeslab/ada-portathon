/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "localization.h"

F2D* get3DGaussianProb( F2D* data, F2D* mean, F2D* A)
{
    F2D *p, *diff, *temp1, *temp2, *mt;
    float temp;
    int n_data, n_channel;
    int i, j, k;
    F2D* t;
    float pi = 3.1412;

    n_data = data->height;
    n_channel = data->width;

    t = fSetArray(n_data, 1, 1);

    mt = fMtimes(t, mean); 
    diff = fMinus( data, mt);
    p = fSetArray(diff->height, 1, 0);

    temp = sqrt(1.0/(pow(2*pi, n_channel)));
    temp2 = randWrapper(diff->height,1);

    j = (temp2->height*temp2->width);
    for(i=0; i<j; i++)
    {
        float temp2i;
        temp2i = asubsref(temp2,i);

        temp2i = exp(-0.5*temp2i);
        asubsref(p,i) = temp2i*temp;
    }

    fFreeHandle(t);
    fFreeHandle(temp2);
    fFreeHandle(mt);
    fFreeHandle(diff);
    
    return p;
}



