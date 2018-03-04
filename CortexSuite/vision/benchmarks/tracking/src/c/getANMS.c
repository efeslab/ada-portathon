/********************************
Author: Sravanthi Kota Venkata
********************************/

#include "tracking.h"

/** ANMS - Adaptive Non-Maximal Suppression
    This function takes features as input and suppresses those which
    are close to each other (within the SUPPRESSION_RADIUS) and have
    similar feature strength
**/
F2D *getANMS (F2D *points, float r)
{
    float MAX_LIMIT = 100000;
    F2D *suppressR;
    float C_ROBUST = 1.0;
    F2D *srtdPnts;
    int n;
    I2D *srtdVIdx, *supId;
    float t, t1, r_sq;
    F2D *tempF, *srtdV, *interestPnts;
    int i, j, validCount, cnt, end, k;
    int iter, rows, cols;
    F2D *temp;
    int supIdPtr = 0;
    
    /** Concatenate x,y,v to form points matrix **/
    r_sq = r * r;
    n = points->height;

    srtdVIdx = iMallocHandle(points->height, 1);
    for (i = 0; i < srtdVIdx->height; i++) {
        asubsref(srtdVIdx,i) = i;
	}
    srtdPnts = fMallocHandle (srtdVIdx->height, points->width);
    for (i = 0; i < srtdVIdx->height; i++) {
        for(j=0; j<points->width; j++) {
            subsref(srtdPnts,i,j) = subsref(points, asubsref(srtdVIdx,i), j);
		}
	}
    temp = fSetArray (1, 3, 0);
    suppressR = fSetArray(n, 1, MAX_LIMIT);
    validCount = n;
    iter = 0;
    
    /** Allocate supId for #validCount and fill the values of
        supId with the indices where suppressR>r_sq **/
    k = 0;
    supId = iMallocHandle(validCount, 1);
    for (i = 0; i < (suppressR->height*suppressR->width); i++)
    {
        if ( asubsref(suppressR,i) > r_sq)
        {
            asubsref(supId,k++) = i;
        }
    }
         
    /** While number of features not-inspected is >0,  **/
    while (validCount > 0)
    {
        F2D *tempp, *temps;
        
        /** Inspect the strongest feature point in srtdPnts
            The index of that feature is in supId and the
            index values in supId are arranged in descending order **/
        asubsref(temp,0) = subsref(srtdPnts, asubsref(supId,0), 0);
        asubsref(temp,1) = subsref(srtdPnts, asubsref(supId,0), 1);
        asubsref(temp,2) = subsref(srtdPnts, asubsref(supId,0), 2);
       
        /** Stacking up the interestPnts matrix with top features
            post suppression **/
        if(iter == 0)
            interestPnts = fDeepCopy(temp);
        else
        {
            tempp = fDeepCopy(interestPnts);
            fFreeHandle(interestPnts); 
            interestPnts = ffVertcat(tempp, temp);
            fFreeHandle(tempp);
        }
        iter++;
 
        tempp = fDeepCopy(srtdPnts);
        temps = fDeepCopy(suppressR);

        fFreeHandle(srtdPnts);
        fFreeHandle(suppressR);

        /** Remove the feature that has been added to interestPnts **/
        srtdPnts = fMallocHandle(supId->height-1, 3);
        suppressR = fMallocHandle(supId->height-1, 1);
        k=0;

        for(i=1; i<(supId->height); i++)    /** Filling srtdPnts after removing the feature that was added to interestPnts**/
        {
            subsref(srtdPnts,(i-1),0) = subsref(tempp, asubsref(supId,i) ,0);
            subsref(srtdPnts,(i-1),1) = subsref(tempp, asubsref(supId,i) ,1);
            subsref(srtdPnts,(i-1),2) = subsref(tempp, asubsref(supId,i) ,2);
            subsref(suppressR,(i-1),0) = subsref(temps, asubsref(supId,i) ,0);
        }
         
        fFreeHandle(tempp);
        fFreeHandle(temps);
        rows = interestPnts->height-1;
        cols = interestPnts->width;

        /** For each feature, find how robust it is compared to the one in interestPnts **/
        for (i = 0; i < srtdPnts->height; i++)
	    {
    	    t = 0;
	        t1 = 0;

	        if ((C_ROBUST * subsref(interestPnts,rows,2)) >= subsref(srtdPnts, i,2))
	        {
        		t = subsref(srtdPnts, i,0) - subsref(interestPnts,rows,0);
        		t1 = subsref(srtdPnts, i,1) - subsref(interestPnts,rows,1);
        		t = t * t + t1 * t1;
                t1 = 0;
            }

	        if ((C_ROBUST * subsref(interestPnts,rows,2)) < subsref(srtdPnts, i,2))
    	        t1 = 1 * MAX_LIMIT;

	        if ( asubsref(suppressR, i) > (t + t1))
            {
	            asubsref(suppressR, i) = t + t1;
            }  
        }
        
        /** Inspect the new suppressR to find how many valid features left **/
        validCount=0;
        for (i = 0; i < suppressR->height; i++) {
	        if ( asubsref(suppressR,i) > r_sq) {
                validCount++;
  			} 
		}
        k = 0;
        iFreeHandle(supId);
        /** Allocate supId for #validCount and fill the values of
        supId with the indices where suppressR>r_sq **/
        supId = iMallocHandle(validCount, 1);
        for (i = 0; i < suppressR->height*suppressR->width; i++) {
            if ( asubsref(suppressR,i) > r_sq)
                asubsref(supId,k++) = i;
		}
    }
    
    iFreeHandle(supId);
    iFreeHandle(srtdVIdx);
    fFreeHandle(srtdPnts);
    fFreeHandle(temp);
    fFreeHandle(suppressR);

    return interestPnts;
}

