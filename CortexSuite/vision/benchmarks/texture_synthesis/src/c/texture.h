/********************************
Author: Sravanthi Kota Venkata
********************************/

#ifndef _TEXTURE_
#define _TEXTURE_

#include "sdvbs_common.h"

#define R 0
#define G 1
#define B 2
#define a(x,y,W)        (1*((y)*(W)+(x)))
#define aa(x,y) (2*((y)*data->widthout+(x)))

typedef float pixelvalue;

typedef struct
{
 double sign, diff;
 int x,y;
 int secondx, secondy;
}signature;

typedef struct{
 int localx, localy, localz;
 int widthin, widthout;
 int heightin, heightout; 
 int nfin, nfout;
}params;

void *SIGNATURES;

//void create_texture(F2D *image, F2D *result, params *data);
void create_texture(F2D *image, params *data);
I2D* parse_flags(int argc, char ** argv);
void init_params(params *data);
//void init(F2D *result, F2D *image, params* data);
void init(F2D *image, params* data);
double compare_full_neighb(F2D *image,int x, int y, F2D *image1,int x1, int y1, params* data);
double compare_neighb(F2D *image,int x, int y, F2D *image1,int x1, int y1, params* data);
int create_candidates(int x,int y, params* data);
int create_all_candidates(int x,int y, params* data);

#endif



