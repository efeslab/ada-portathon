/********************************
Author: Sravanthi Kota Venkata
********************************/

#include "tracking.h"

int main(int argc, char* argv[])
{
    int i, j, k, N_FEA, WINSZ, LK_ITER, rows, cols;
    int endR, endC;
    F2D *blurredImage, *previousFrameBlurred_level1, *previousFrameBlurred_level2, *blurred_level1, *blurred_level2;
    F2D *verticalEdgeImage, *horizontalEdgeImage, *verticalEdge_level1, *verticalEdge_level2, *horizontalEdge_level1, *horizontalEdge_level2, *interestPnt;
    F2D *lambda, *lambdaTemp, *features;
    I2D *Ic, *status;
    float SUPPRESION_RADIUS;
    F2D *newpoints;

    int numFind, m, n;
    F2D *np_temp;

    unsigned int* start, *end, *elapsed, *elt;
    char im1[100];
    int counter=2;
    float accuracy = 0.03;
    int count;
    
    if(argc < 2) 
    {
        printf("We need input image path\n");
        return -1;
    }

    sprintf(im1, "%s/1.bmp", argv[1]);

    N_FEA = 1600;
    WINSZ = 4;
    SUPPRESION_RADIUS = 10.0;
    LK_ITER = 20;

    #ifdef test
        WINSZ = 2;
        N_FEA = 100;
        LK_ITER = 2;
        counter = 2;
        accuracy = 0.1;
    #endif
    #ifdef sim_fast
        WINSZ = 2;
        N_FEA = 100;
        LK_ITER = 2;
        counter = 4;
    #endif
    #ifdef sim
        WINSZ = 2;
        N_FEA = 200;
        LK_ITER = 2;
        counter = 4;
    #endif
    #ifdef sqcif
        WINSZ = 8;
        N_FEA = 500;
        LK_ITER = 15;
        counter = 2;
    #endif
    #ifdef qcif
        WINSZ = 12;
        N_FEA = 400;
        LK_ITER = 15;
        counter = 4;
    #endif
    #ifdef cif
        WINSZ = 20;
        N_FEA = 500;
        LK_ITER = 20;
        counter = 4;
    #endif
    #ifdef vga
        WINSZ = 32;
        N_FEA = 400;
        LK_ITER = 20;
        counter = 4;
    #endif
    #ifdef wuxga
        WINSZ = 64;
        N_FEA = 500;
        LK_ITER = 20;
        counter = 4;
    #endif
    #ifdef fullhd
        WINSZ = 48;
        N_FEA = 500;
        LK_ITER = 20;
        counter = 4;
    #endif

    /** Read input image **/
    Ic = readImage(im1);
    rows = Ic->height;
    cols = Ic->width;
    
    printf("Input size\t\t- (%dx%d)\n", rows, cols);
    
    /** Start Timing **/
    start = photonStartTiming();

    
    /** IMAGE PRE-PROCESSING **/

    /** Blur the image to remove noise - weighted avergae filter **/
    blurredImage = imageBlur(Ic);

    /** Scale down the image to build Image Pyramid. We find features across all scales of the image **/
    blurred_level1 = blurredImage;                   /** Scale 0 **/
    blurred_level2 = imageResize(blurredImage);      /** Scale 1 **/


    /** Edge Images - From pre-processed images, build gradient images, both horizontal and vertical **/
    verticalEdgeImage = calcSobel_dX(blurredImage);
    horizontalEdgeImage = calcSobel_dY(blurredImage);

    /** Edge images are used for feature detection. So, using the verticalEdgeImage and horizontalEdgeImage images, we compute feature strength
        across all pixels. Lambda matrix is the feature strength matrix returned by calcGoodFeature **/
    
    lambda = calcGoodFeature(verticalEdgeImage, horizontalEdgeImage, verticalEdgeImage->width, verticalEdgeImage->height, WINSZ);
    endR = lambda->height;
    endC = lambda->width;
    lambdaTemp = fReshape(lambda, endR*endC, 1);

    /** We sort the lambda matrix based on the strengths **/
    /** Fill features matrix with top N_FEA features **/
    fFreeHandle(lambdaTemp);
    lambdaTemp = fillFeatures(lambda, N_FEA, WINSZ);
    features = fTranspose(lambdaTemp);
    
    /** Suppress features that have approximately similar strength and belong to close neighborhood **/
    interestPnt = getANMS(features, SUPPRESION_RADIUS);
    
    /** Refill interestPnt in features matrix **/
    fFreeHandle(features);
    features = fSetArray(2, interestPnt->height, 0);
    for(i=0; i<2; i++) {
        for(j=0; j<interestPnt->height; j++) {
            subsref(features,i,j) = subsref(interestPnt,j,i); 
		}
    } 
     
    end = photonEndTiming();
    elapsed = photonReportTiming(start, end);

    fFreeHandle(verticalEdgeImage);
    fFreeHandle(horizontalEdgeImage);
    fFreeHandle(interestPnt);
    fFreeHandle(lambda);
    fFreeHandle(lambdaTemp);
    iFreeHandle(Ic);
    free(start);
    free(end);

/** Until now, we processed base frame. The following for loop processes other frames **/
for(count=1; count<=counter; count++)
{
    /** Read image **/
    sprintf(im1, "%s/%d.bmp", argv[1], count);
    Ic = readImage(im1);
    rows = Ic->height;
    cols = Ic->width;
    
    /* Start timing */
    start = photonStartTiming();

    /** Blur image to remove noise **/
    blurredImage = imageBlur(Ic);
    previousFrameBlurred_level1 = fDeepCopy(blurred_level1);
    previousFrameBlurred_level2 = fDeepCopy(blurred_level2);
    
    fFreeHandle(blurred_level1);
    fFreeHandle(blurred_level2);

    /** Image pyramid **/
    blurred_level1 = blurredImage;
    blurred_level2 = imageResize(blurredImage);

    /** Gradient image computation, for all scales **/
    verticalEdge_level1 = calcSobel_dX(blurred_level1);   
    horizontalEdge_level1 = calcSobel_dY(blurred_level1); 
    
    verticalEdge_level2 = calcSobel_dX(blurred_level2); 
    horizontalEdge_level2 = calcSobel_dY(blurred_level2);
    
    newpoints = fSetArray(2, features->width, 0);
        
    /** Based on features computed in the previous frame, find correspondence in the current frame. "status" returns the index of corresponding features **/
    status = calcPyrLKTrack(previousFrameBlurred_level1, previousFrameBlurred_level2, verticalEdge_level1, verticalEdge_level2, horizontalEdge_level1, horizontalEdge_level2, blurred_level1, blurred_level2, features, features->width, WINSZ, accuracy, LK_ITER, newpoints);
    
    fFreeHandle(verticalEdge_level1);
    fFreeHandle(verticalEdge_level2);
    fFreeHandle(horizontalEdge_level1);
    fFreeHandle(horizontalEdge_level2);
    fFreeHandle(previousFrameBlurred_level1);
    fFreeHandle(previousFrameBlurred_level2);
    
    /** Populate newpoints with features that had correspondence with previous frame features **/
    np_temp = fDeepCopy(newpoints);
    if(status->width > 0 )
    {
        k = 0;
        numFind=0;
        for(i=0; i<status->width; i++)
        {
            if( asubsref(status,i) == 1)
                numFind++;
        }
        fFreeHandle(newpoints);
        newpoints = fSetArray(2, numFind, 0);

        for(i=0; i<status->width; i++)
        {
            if( asubsref(status,i) == 1)
            {
                subsref(newpoints,0,k) = subsref(np_temp,0,i);
                subsref(newpoints,1,k++) = subsref(np_temp,1,i);
            }
        }    
    }    
        
    iFreeHandle(status);
    iFreeHandle(Ic);
    fFreeHandle(np_temp);
    fFreeHandle(features);
    /** Populate newpoints into features **/
    features = fDeepCopy(newpoints);
    fFreeHandle(newpoints);
    
    /* Timing utils */
    end = photonEndTiming();
    elt = photonReportTiming(start, end);
    elapsed[0] += elt[0];
    elapsed[1] += elt[1];
    
    free(start);
    free(elt);
    free(end);   
}

#ifdef CHECK   
    /* Self checking */
    {
        int ret=0;
        float tol = 2.0;
#ifdef GENERATE_OUTPUT
        fWriteMatrix(features, argv[1]);
#endif
        ret = fSelfCheck(features, argv[1], tol); 
        if (ret == -1)
            printf("Error in Tracking Map\n");
    }
#endif
    
    photonPrintTiming(elapsed);

    fFreeHandle(blurred_level1);
    fFreeHandle(blurred_level2);
    fFreeHandle(features);

    free(elapsed);

    return 0;

}



