#ifndef MOTIONESTIMATION_H
#define MOTIONESTIMATION_H

#include "App.h"

typedef struct MotionVector {
	double x;
	double y;
}MV;

extern MV mv[l*l];

HRESULT GetMotionVectors();
#endif
