/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "disparity.h"

int main(int argc, char* argv[])
{
    int rows = 32;
    int cols = 32;
    I2D *imleft, *imright, *retDisparity;

    unsigned int *start, *endC, *elapsed;
    
    int i, j;
    char im1[100], im2[100], timFile[100];
    int WIN_SZ=8, SHIFT=64;
    FILE* fp;
    
    if(argc < 2)
    {
        printf("We need input image path and output path\n");
        return -1;
    }

    sprintf(im1, "%s/1.bmp", argv[1]);
    sprintf(im2, "%s/2.bmp", argv[1]);
    
    imleft = readImage(im1);
    imright = readImage(im2);

    rows = imleft->height;
    cols = imleft->width;

#ifdef test
    WIN_SZ = 2;
    SHIFT = 1;
#endif
#ifdef sim_fast
    WIN_SZ = 4;
    SHIFT = 4;
#endif
#ifdef sim
    WIN_SZ = 4;
    SHIFT = 8;
#endif

    start = photonStartTiming();
    retDisparity = getDisparity(imleft, imright, WIN_SZ, SHIFT);
    endC = photonEndTiming();

    printf("Input size\t\t- (%dx%d)\n", rows, cols);
#ifdef CHECK   
    /** Self checking - use expected.txt from data directory  **/
    {
        int tol, ret=0;
        tol = 2;
#ifdef GENERATE_OUTPUT
        writeMatrix(retDisparity, argv[1]);
#endif
        ret = selfCheck(retDisparity, argv[1], tol);
        if (ret == -1)
            printf("Error in Disparity Map\n");
    }
    /** Self checking done **/
#endif

    elapsed = photonReportTiming(start, endC);
    photonPrintTiming(elapsed);
    
    iFreeHandle(imleft);
    iFreeHandle(imright);
    iFreeHandle(retDisparity);
    free(start);
    free(endC);
    free(elapsed);

    return 0;
}
