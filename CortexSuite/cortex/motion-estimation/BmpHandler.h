#pragma once
//#include "App.h"
//#include <windows.h>
#include <stdint.h>

#ifndef _WINGDI_
#define _WINGDI_
#pragma pack(1)
typedef struct tagBITMAPFILEHEADER {
	int16_t    bfType;
	int32_t    bfSize;
	int16_t    bfReserved1;
	int16_t    bfReserved2;
	int32_t	   bfOffBits;
} BITMAPFILEHEADER;

typedef struct tagBITMAPINFOHEADER{
	int32_t      biSize;
	int32_t      biWidth;
	int32_t      biHeight;
	int16_t      biPlanes;
	int16_t      biBitCount;
	int32_t      biCompression;
	int32_t      biSizeImage;
	int32_t      biXPelsPerMeter;
	int32_t      biYPelsPerMeter;
	int32_t      biClrUsed;
	int32_t      biClrImportant;
} BITMAPINFOHEADER;
# pragma pack()

/*typedef struct
{
    int16_t 		bfType;
    unsigned int   	bfSize;
    unsigned int   	bfReserved;
    unsigned int   	bfOffBits;
}BITMAPFILEHEADER;

typedef struct
{
    unsigned int  	biSize;
    int   			biWidth;
    int   			biHeight;
    int16_t 		biPlanes;
    int16_t			biBitCount;
    unsigned int  	biCompression;
    unsigned int  	biSizeImage;
    int   			biXPelsPerMeter;
    int   			biYPelsPerMeter;
    unsigned int  	biClrUsed;
    unsigned int  	biClrImportant;
}BITMAPINFOHEADER;

typedef struct
{
    unsigned char rgbBlue;
    unsigned char rgbGreen;
    unsigned char rgbRed;
    unsigned char rgbReserved;
}RGBQUAD;*/

#endif

unsigned char *LoadBitmapFile(const char *filename, BITMAPINFOHEADER *bitmapInfoHeader, BITMAPFILEHEADER *bitmapFileHeader);
void WriteBMPFile(const char *filename, BITMAPINFOHEADER *bitmapInfoHeader, BITMAPFILEHEADER *bitmapFileHeader, unsigned char *bitmapImage);
void ConvertRGBtoGrayScale(unsigned char* bitmapImage, double** grayscale, int y, int x);
void ConvertGrayScaletoRGB(unsigned char* bitmapImage, double*** grayscale, int y, int x);
