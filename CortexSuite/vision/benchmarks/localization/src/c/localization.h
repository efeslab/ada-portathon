/********************************
Author: Sravanthi Kota Venkata
********************************/

#ifndef _LOCALIZATION_
#define _LOCALIZATION_

#include "sdvbs_common.h"

int script_localization();
F2D* eul2quat(F2D* angle);
void generateSample(F2D *w, F2D *quat, F2D *vel, F2D *pos);
F2D* get3DGaussianProb( F2D* data, F2D* mean, F2D* A);
F2D* mcl(F2D* x, F2D* sData, F2D* invConv);
F2D* quat2eul(F2D* quat);
F2D* quatConj(F2D* a);
F2D* quatMul(F2D* a, F2D* b);
F2D* quatRot(F2D* vec, F2D* rQuat);
F2D* readSensorData(I2D* index, F2D* fid, I2D* type, I2D* eof);
I2D* weightedSample(F2D* w);

#endif


