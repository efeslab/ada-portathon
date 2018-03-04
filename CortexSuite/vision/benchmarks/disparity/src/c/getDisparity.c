/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "disparity.h"

I2D* getDisparity(I2D* Ileft, I2D* Iright, int win_sz, int max_shift)
{
    I2D* retDisp;
    int nr, nc, k;
    I2D *halfWin;
    int half_win_sz, rows, cols;
    F2D *retSAD, *minSAD, *SAD, *integralImg;
    I2D* IrightPadded, *IleftPadded, *Iright_moved;
    
    nr = Ileft->height;
    nc = Ileft->width;
    half_win_sz=win_sz/2;
    
    
    minSAD = fSetArray(nr, nc, 255.0*255.0);
    retDisp = iSetArray(nr, nc,max_shift);
    halfWin = iSetArray(1,2,half_win_sz);

        if(win_sz > 1)
        {
            IleftPadded = padarray2(Ileft, halfWin);
            IrightPadded = padarray2(Iright, halfWin);
        }
        else
        {
            IleftPadded = Ileft;
            IrightPadded = Iright;
        }
    
    rows = IleftPadded->height;
    cols = IleftPadded->width;
    SAD = fSetArray(rows, cols,255);
    integralImg = fSetArray(rows, cols,0);
    retSAD = fMallocHandle(rows-win_sz, cols-win_sz);
    Iright_moved = iSetArray(rows, cols, 0);
    
    for( k=0; k<max_shift; k++)
    {    
        correlateSAD_2D(IleftPadded, IrightPadded, Iright_moved, win_sz, k, SAD, integralImg, retSAD);
        findDisparity(retSAD, minSAD, retDisp, k, nr, nc);
    }
    
    fFreeHandle(retSAD);
    fFreeHandle(minSAD);
    fFreeHandle(SAD);
    fFreeHandle(integralImg);
    iFreeHandle(halfWin);
    iFreeHandle(IrightPadded);
    iFreeHandle(IleftPadded);
    iFreeHandle(Iright_moved);
     
    return retDisp;
}

