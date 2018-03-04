/********************************

Author: Sravanthi Kota Venkata
********************************/

#include "tracking.h"

/** Find the position and values of the top N_FEA features 
	from the lambda matrix **/

F2D* fillFeatures(F2D* lambda, int N_FEA, int win)
{
    int i, j, k, l;
    int rows = lambda->height;
    int cols = lambda->width;
    F2D* features;

	features = fSetArray(3, N_FEA, 0);

	/** init array **/
    for(i=0; i<N_FEA; i++)
    {
        subsref(features, 0, i) = -1.0;
        subsref(features, 1, i) = -1.0;
        subsref(features, 2, i) = 0.0;
    }
    

	/** 
		Find top N_FEA values and store them in 
        features array along with row and col information 
		It should be possible to make this algorithm better
		if we use a pointer-based data structure,
		but have not implemented due to MATLAB compatibility
	**/ 

	for (i=win; i<rows-win; i++)
	{
		for (j=win; j<cols-win; j++)
		{
            float currLambdaVal = subsref(lambda,i,j);
			if (subsref(features, 2, N_FEA-1) > currLambdaVal)
				continue;
			
			for (k=0; k<N_FEA; k++) 
			{
				if (subsref(features, 2, k) < currLambdaVal) 
				{
					/** shift one slot **/
					for (l=N_FEA-1; l>k; l--)
					{
						subsref(features, 0, l) = subsref(features, 0, l-1);
						subsref(features, 1, l) = subsref(features, 1, l-1);
						subsref(features, 2, l) = subsref(features, 2, l-1);
					}	
					
        			subsref(features, 0, k) = j * 1.0;
        			subsref(features, 1, k) = i * 1.0;
        			subsref(features, 2, k) = currLambdaVal;
					break;
				}
			}
		}
	}

    return features;
}
