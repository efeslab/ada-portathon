/********************************
Author: Sravanthi Kota Venkata
********************************/

#ifndef _SCRIPT_TRACK_
#define _SCRIPT_TRACK_

#include "sdvbs_common.h"

F2D* calcAreaSum(F2D* src, int cols, int rows, int winSize);
F2D* calcGoodFeature(F2D* dX, F2D* dY, int cols, int rows, int winSize);
I2D* calcPyrLKTrack(F2D* ip1, F2D* ip2, F2D* idxp1, F2D* idxp2, F2D* idyp1, F2D* idyp2, F2D* jp1, F2D* jp2, F2D* fPnt, int nFeatures, int winSize, float accuracy, int maxIter, F2D* newPnt);
F2D *getANMS (F2D *points, float r);
F2D* getInterpolatePatch(F2D* src, int cols, float centerX, float centerY, int winSize);
float polynomial(int d, F2D* a, F2D* b, int dim);
I2D* sortInd(F2D* input, int dim);
F2D* fillFeatures(F2D* lambda, int N_FEA, int win);

#endif

