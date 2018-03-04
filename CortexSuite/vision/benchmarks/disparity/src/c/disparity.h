/********************************
Author: Sravanthi Kota Venkata
********************************/

#ifndef _DISP_
#define _DISP_

#include "sdvbs_common.h"
void computeSAD(I2D *Ileft, I2D* Iright_moved, F2D* SAD);
I2D* getDisparity(I2D* Ileft, I2D* Iright, int win_sz, int max_shift);
void finalSAD(F2D* integralImg, int win_sz, F2D* retSAD);
void findDisparity(F2D* retSAD, F2D* minSAD, I2D* retDisp, int level, int nr, int nc);
void integralImage2D2D(F2D* SAD, F2D* integralImg);
void correlateSAD_2D(I2D* Ileft, I2D* Iright, I2D* Iright_moved, int win_sz, int disparity, F2D* SAD, F2D* integralImg, F2D* retSAD);
I2D* padarray2(I2D* inMat, I2D* borderMat);
void padarray4(I2D* inMat, I2D* borderMat, int dir, I2D* paddedArray);

#endif


