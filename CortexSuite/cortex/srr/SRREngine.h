#ifndef SRRENGINE_H
#define SRRENGINE_H

#include "App.h"
#include "MotionEstimation.h"
#define ALPHA 2.5

extern double*** f;

void MatMul (double** mat1, double mat2[], double result[]);
void MatMul_ (double** mat1, double** mat2, double result[(l*l)][(l*l)]);
void MatAdd(double mat1[],double mat2[]);
void MatSub(double mat1[],double mat2[], double res[]);
//void Invert2(double *mat, double *dst);
void GaussSeidel(double** A1,double* X,double* Y);
void Gauss(int rn, int pn);
void get_g(int rn,int pn);
void flush_b();
void flush_arr(double temp[]);
void get_b(int rn);
void modify_b(int rn, int pn);
void solve_pixel(int rn, int pn);
void solve_row(int rn);
HRESULT SRREngine123();
#endif
