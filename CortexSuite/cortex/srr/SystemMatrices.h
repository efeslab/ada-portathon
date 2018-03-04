#ifndef SYSTEMMATRICES_H
#define SYSTEMMATRICES_H

#include "App.h"
#include "MotionEstimation.h"

void flushShift();
void MatMul1 (double mat1[][(l*l)], double mat2[][(l*l)], double result[][(l*l)]);
void MatMul1_ (double mat1[][(l*l)], double mat2[], double result[]);
int calc(int i,int j);
void CalcShiftMat(double x, double y);
HRESULT CalculateA();

#endif
