/********************************
Author: Sravanthi Kota Venkata
********************************/

#include "tracking.h"

/** calcPyrLKTrack tries to find the displacement (translation in x and y) of features computed in the previous frame.
    To compute the displacement, we interpolate the existing feature position around the pixel neighborhood.
    For better results, we perform interpolatations across all pyramid levels.

    Input:  Previous frame blurred images, vertical and horizontal
            Current frame edge images, vertical and horizontal
            Current frame blurred images, for level 0 and 1
            Number of features from previous frame
            Window size
            Accuracy
            Number of iterations to compute motion vector
            Features from the previous frame
            currentFrameFeatures, Populate the current frame features' displacements
    Output: Number of valid features

**/

I2D* calcPyrLKTrack(F2D* previousImageBlur_level1, F2D* previousImageBlur_level2, F2D* vertEdge_level1, F2D* vertEdge_level2, F2D* horzEdge_level1, F2D* horzEdge_level2, F2D* currentImageBlur_level1, F2D* currentImageBlur_level2, F2D* previousFrameFeatures, int nFeatures, int winSize, float accuracy, int max_iter, F2D* currentFrameFeatures)
{
    int idx, level, pLevel, i, j, k, winSizeSq;
    I2D *valid;
    F2D *rate, *iPatch, *jPatch, *iDxPatch;
    F2D *iDyPatch;
    float tr, x, y, dX, dY, c_xx, c_yy, c_xy;
    int imgSize_1, imgSize_2;
    float mX, mY, dIt, eX, eY, c_det;
    I2D *imgDims;

    imgDims = iMallocHandle(2, 2);
    subsref(imgDims,0,0) = previousImageBlur_level1->height;
    subsref(imgDims,0,1) = previousImageBlur_level1->width;
    subsref(imgDims,1,0) = previousImageBlur_level2->height;
    subsref(imgDims,1,1) = previousImageBlur_level2->width;

    pLevel = 2;
    rate = fMallocHandle(1, 6);

    asubsref(rate,0) = 1;
    asubsref(rate,1) = 0.5;
    asubsref(rate,2) = 0.25;
    asubsref(rate,3) = 0.125;
    asubsref(rate,4) = 0.0625;
    asubsref(rate,5) = 0.03125;
    
    winSizeSq = 4*winSize*winSize;
    valid = iSetArray(1,nFeatures, 1);

    /** For each feature passed from previous frame, compute the dx and dy, the displacements **/
    for(i=0; i<nFeatures; i++)
    {
        dX = 0;
        dY = 0;

        /** Compute the x and y co-ordinate values at "pLevel" **/
        x = subsref(previousFrameFeatures,0,i) * asubsref(rate,pLevel);
        y = subsref(previousFrameFeatures,1,i) * asubsref(rate,pLevel);
        c_det = 0;

        /** For each pyramid level, try to find correspondence.
            We look for the correspondence in a given window size
            , (winSize x winSize) neighborhood **/
        for(level = pLevel-1; level>=0; level--)
        {
            x = x+x;
            y = y+y;
            dX = dX + dX;
            dY = dY + dY;
            imgSize_1 = subsref(imgDims,level,0);
            imgSize_2 = subsref(imgDims,level,1);

            c_xx = 0;
            c_xy = 0;
            c_yy = 0;
        
            if((x-winSize)<0 || (y-winSize)<0 || (y+winSize+1)>=imgSize_1 || (x+winSize+1)>=imgSize_2)
            {
                asubsref(valid,i) = 0;
                break;
            }

            /** Perform interpolation. Use co-ord from previous
                frame and use the images from current frame **/

            if(level ==0)
            {
                iPatch = getInterpolatePatch(previousImageBlur_level1, imgSize_2, x, y, winSize);
                iDxPatch = getInterpolatePatch(vertEdge_level1, imgSize_2, x, y, winSize);
                iDyPatch = getInterpolatePatch(horzEdge_level1, imgSize_2, x, y, winSize);
            }
            if(level ==1)
            {
                iPatch = getInterpolatePatch(previousImageBlur_level2, imgSize_2, x, y, winSize);
                iDxPatch = getInterpolatePatch(vertEdge_level2, imgSize_2, x, y, winSize);
                iDyPatch = getInterpolatePatch(horzEdge_level2, imgSize_2, x, y, winSize);
            }

            /** Compute feature strength in similar way as calcGoodFeature **/
            for(idx=0; idx<winSizeSq; idx++)
            {
                c_xx += asubsref(iDxPatch,idx) * asubsref(iDxPatch,idx);
                c_xy += asubsref(iDxPatch,idx) * asubsref(iDyPatch,idx);
                c_yy += asubsref(iDyPatch,idx) * asubsref(iDyPatch,idx);
            }
            
            c_det = (c_xx * c_yy -c_xy * c_xy);
            tr = c_xx + c_yy;

            if((c_det/(tr+0.00001)) < accuracy)
            {
                asubsref(valid,i) = 0;
                fFreeHandle(iPatch);
                fFreeHandle(iDxPatch);
                fFreeHandle(iDyPatch);
                break;
            }
            c_det = 1/c_det;

            /** We compute dX and dY using previous frame and current
                frame images. For this, the strength is computed at each
                pixel in the new image.  **/
            for(k=0; k<max_iter; k++)
            {
                if( (x+dX-winSize)<0 || (y+dY-winSize)<0 || (y+dY+winSize+1)>=imgSize_1 || (x+dX+winSize+1)>=imgSize_2)
                {
                    asubsref(valid,i) = 0;
                    break;
                }
                
                if(level == 0)
                    jPatch = getInterpolatePatch(currentImageBlur_level1, imgSize_2, x+dX, y+dY, winSize);
                if(level == 1)
                    jPatch = getInterpolatePatch(currentImageBlur_level2, imgSize_2, x+dX, y+dY, winSize);
                
                eX = 0;
                eY = 0;
                for(idx=0; idx<winSizeSq; idx++)
                {
                    dIt = asubsref(iPatch,idx) - asubsref(jPatch,idx);
                    eX += dIt * asubsref(iDxPatch,idx);
                    eY += dIt * asubsref(iDyPatch,idx);
                }
                
                mX = c_det * (eX * c_yy - eY * c_xy);
                mY = c_det * (-eX * c_xy + eY * c_xx);
                dX = dX + mX;
                dY = dY + mY;
            
                if( (mX*mX+mY*mY) < accuracy)
                {
                    fFreeHandle(jPatch);
                    break;
                }
                
                fFreeHandle(jPatch);
            }

            fFreeHandle(iPatch);
            fFreeHandle(iDxPatch);
            fFreeHandle(iDyPatch);
        }

        subsref(currentFrameFeatures,0,i) = subsref(previousFrameFeatures,0,i) + dX;
        subsref(currentFrameFeatures,1,i) = subsref(previousFrameFeatures,1,i) + dY;
        
    }

    fFreeHandle(rate);
    iFreeHandle(imgDims);
    return valid;
}



