#include <math.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <float.h>

#define GOOD_FEATURE_LAMBDA_TH 10
#define LK_ACCURACY_TH 0.03
#define LK_MAX_ITER 20
#define LK_MAX_WIN 25
#define MAX_LEVEL 10
#define MAX_IMAGE_SIZE_1D 1000000

void calcSubSampleAvg(double *src, int sizeY, int sizeX, double *dest, int destSizeY, int destSizeX);
void calcImgBlur(double *src, int sizeY, int sizeX, double *dest);
void calcImgResize(double *src, int sizeY, int sizeX, double *dest, int dstSizeY, int dstSizeX);
void calcGradient(double *src, int sizeY, int sizeX, double *dX, double *dY);
void calcGradient(char *src, int sizeY, int sizeX, char *dX, char *dY);
void calcSobel(double *src, int sizeX, int sizeY, double *dx, double *dy);
void calcGoodFeature(double *dX, double *dY, int sizeY, int sizeX, int winSize, double* lambda, double* tr, double* det, 
	double* c_xx, double* c_xy, double* c_yy);
void calcGoodFeature(char *dX, char *dY, int sizeY, int sizeX, int winSize, float* lambda, float* tr, float* det);
void calcMinEigenValue(char *dX, char *dY, int sizeY, int sizeX, float* lambda);
void calcAreaSum(int *src, int sizeY, int sizeX, int sizeSum, int *ret);
void calcAreaSum(double *src, int sizeY, int sizeX, int sizeSum, double *ret);
void calcPyrLKTrack(double** iP, double** iDxP, double** iDyP, double** jP, const int* imgDims, int pLevel,
	double* fPnt, int nFeatures, int winSize, 
	double* newFPnt, char* valid);
void calcPyrLKTrack(double** iP, double** iDxP, double** iDyP, double** jP, const int* imgDims, int pLevel,
	double* fPnt, int nFeatures, int winSize, 
	double* newFPnt, char* valid,
	double accuracy_th, int iter);
void calcLKTrack(double* imgI, double* iDx, double* iDy, double* imgJ, const int* imdims, 
	double* c_xx, double* c_xy, double* c_yy,
	double* fPnt, double* initPnt, int nFeatures, int winSize,      
        double* newFPnt, char* valid, 
	double accuracy_th, int max_iter);
void calcLKTrack(double* imgI, double* iDx, double* iDy, double* imgJ, const int* imdims, 
	double* c_xx, double* c_xy, double* c_yy,
	double* fPnt, double* initPnt, int nFeatures, int winSize,      
        double* newFPnt, char* valid);
void calcPyrLKTrackWInit(double** iP, double** iDxP, double** iDyP, double** jP, const int* imgDims, int pLevel, 
        double* fPnt, int nFeatures, int winSize, 
        double* newFPnt, double* initFPnt,
        char* valid, double accuracy_th, int max_iter);
void calcPyrLKTrackWInit(double** iP, double** jP, const int* imgDims, int pLevel, 
        double* fPnt, int nFeatures, int winSize, 
        double* newFPnt, double* initFPnt,
        char* valid, double accuracy_th, int max_iter);
