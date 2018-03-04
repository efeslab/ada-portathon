/********************************
Author: Sravanthi Kota Venkata
********************************/

#ifndef _MSER_
#define _MSER_

#define sref(a,i) a->data[i]

#include "sdvbs_common.h"

typedef int val_t;

typedef struct
{
    int width;
    int data[];
}iArray;

typedef struct
{
    int width;
    unsigned int data[];
}uiArray;

typedef struct
{
    int width;
    long long int unsigned data[];
}ulliArray;

int script_mser();
I2D* mser(I2D* I, int in_delta);

#endif


