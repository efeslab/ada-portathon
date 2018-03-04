/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "localization.h"

F2D* readSensorData(I2D* index, F2D* fid, I2D* type, I2D* eof)
{
    F2D *retData;
    int rows, i, j, k;
    int atype=-1, aindex;

    aindex = asubsref(index, 0);

    asubsref(index,0) = asubsref(index,0) + 1;
    rows = fid->height;
    asubsref(type,0) = 0;
    retData = fSetArray(1, 8, 0);
    
    if( asubsref(index,0) > (rows-1) )
        asubsref(eof,0) = 1;
    else
    {
        if( asubsref(index,0) == rows)
            asubsref(eof,0) = 1;
        else
            asubsref(eof,0) = 0;

        k = asubsref(index,0);
        atype = subsref(fid, k, 1);
        if( (atype == 1) || (atype == 2) || (atype == 3) )
        {
            for(i=0; i<3; i++)
            {
                asubsref(retData,i) = subsref(fid,k,(i+2));
            }
        }
        if( atype == 4 )
        {
            for(i=0; i<3; i++)
            {
                asubsref(retData,i) = subsref(fid,k,(i+2));
            }
            for(i=3; i<8; i++)
            {
                asubsref(retData,i) = subsref(fid,k+1,(i-3));
            }
            aindex = aindex + 1;
        }
        aindex = aindex + 1;
    }

    asubsref(index,0) = aindex;
    asubsref(type, 0) = atype;

    return retData;
}




