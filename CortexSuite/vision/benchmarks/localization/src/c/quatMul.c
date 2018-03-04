/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "localization.h"

F2D* quatMul(F2D* a, F2D* b)
{
    int ra, ca, rb, cb;
    F2D *ret;
    int i, j, k=0;

    ra = a->height;
    ca = a->width;

    rb = b->height;
    cb = b->width;

    ret = fSetArray(ra, 4, 0);

    j = 0;
    for(i=0; i<ra; i++)
    {
        k = 0;
        float ai0, ai1, ai2, ai3;
        float bj0, bj1, bj2, bj3;

        ai0 = subsref(a,i,0);
        ai1 = subsref(a,i,1);
        ai2 = subsref(a,i,2);
        ai3 = subsref(a,i,3);
        
        bj0 = subsref(b,j,0);
        bj1 = subsref(b,j,1);
        bj2 = subsref(b,j,2);
        bj3 = subsref(b,j,3);
        
        subsref(ret,i,k++) = ai0*bj0 - ai1*bj1 - ai2*bj2 - ai3*bj3;
        subsref(ret,i,k++) = ai0*bj1 + ai1*bj0 + ai2*bj3 - ai3*bj2;
        subsref(ret,i,k++) = ai0*bj2 - ai1*bj3 + ai2*bj0 + ai3*bj1;
        subsref(ret,i,k++) = ai0*bj3 + ai1*bj2 - ai2*bj1 + ai3*bj0;
    
        if(rb == ra)
            j++;
    }

    return ret;
}





