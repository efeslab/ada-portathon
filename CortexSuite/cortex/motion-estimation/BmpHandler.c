#include "BmpHandler.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define l 4

unsigned char *LoadBitmapFile(const char *filename, BITMAPINFOHEADER *bitmapInfoHeader, BITMAPFILEHEADER *bitmapFileHeader)
{
	FILE *filePtr; //our file pointer
	//our bitmap file header
	unsigned char *bitmapImage;  //store image data
	//int imageIdx = 0;  //image index counter
	//unsigned char tempRGB;  //our swap variable

	//open filename in read binary mode
	filePtr = fopen(filename, "rb");
	if (filePtr == NULL) {
        printf("Could not open the file\n");
    	return NULL;
    }

	//read the bitmap file header
	fread(bitmapFileHeader, sizeof(BITMAPFILEHEADER), 1, filePtr);

	//verify that this is a bmp file by check bitmap id
	if (bitmapFileHeader->bfType != 0x4D42)
	{
		fclose(filePtr);
		return NULL;
	}

	//read the bitmap info header
	fread(bitmapInfoHeader, sizeof(BITMAPINFOHEADER), 1, filePtr);

	//move file point to the begging of bitmap data
	fseek(filePtr, bitmapFileHeader->bfOffBits, SEEK_SET);

	//allocate enough memory for the bitmap image data
	bitmapImage = (unsigned char*)calloc((bitmapFileHeader->bfSize - bitmapFileHeader->bfOffBits), 1);

	//verify memory allocation
	if (!bitmapImage)
	{
		free(bitmapImage);
		fclose(filePtr);
		return NULL;
	}

	//read in the bitmap image data
	//fread(bitmapImage, 1, bitmapInfoHeader->biSize, filePtr);
	fread(bitmapImage, 1, (bitmapFileHeader->bfSize - bitmapFileHeader->bfOffBits), filePtr);

	//make sure bitmap image data was read
	if (bitmapImage == NULL)
	{
		fclose(filePtr);
		return NULL;
	}

	//swap the r and b values to get RGB (bitmap is BGR)


	//close file and return bitmap iamge data
	fclose(filePtr);
	return bitmapImage;
}

void ConvertRGBtoGrayScale(unsigned char* bitmapImage, double** grayscale, int y, int x)
{
	int i = 0;
	int j = 0;
	int imageIdx = 0;
	for (i = 0; i < y; i++)
		for (j = 0; j < x; j++)
		{
			grayscale[y - i - 1][j] = (double)((66 * bitmapImage[imageIdx + 2] + 129 * bitmapImage[imageIdx + 1] + 25 * bitmapImage[imageIdx] + 128) >> 8); //+ 16;
			//grayscale[y - i - 1][j] = (double)((66 * bitmapImage[imageIdx + 2] + 129 * bitmapImage[imageIdx + 1] + 25 * bitmapImage[imageIdx]));
			imageIdx += 3;
		}
}

void ConvertGrayScaletoRGB(unsigned char* bitmapImage, double*** grayscale, int y, int x)
{
	int i = 0;
	int j = 0;
	int k = 0;
	int imageIdx = 0;
	int temp = 0;

	double max = 0;
	double min = 0;

	for (i = 0; i < y; i++)
		for (j = 0; j < x; j++)
			for (k = 0; k < l*l; k++)
			{
				if (grayscale[i+1][j][k] > max) max = grayscale[i+1][j][k];
				if (grayscale[i+1][j][k] < min) min = grayscale[i+1][j][k];
			}

	printf("MAX IS: %lf MIN IS: %lf\n", max, min);
	for (i = 0; i < y; i++)
		for (j = 0; j < x; j++)
			for (k = 0; k < (l*l); k++)
			{
				temp = (int)((grayscale[i + 1][j + 1][k] - min) * 255 / (max - min));
				int Yindex = i*l + (int)floor((double)k / l);
				int Xindex = j*l + k%l;
				imageIdx = 3*((x*l)*(y*l - Yindex - 1) + Xindex);

				bitmapImage[imageIdx + 2] = (unsigned char)((298 * (temp - 16) + 128) >> 8); //temp;// 
				bitmapImage[imageIdx + 1] = (unsigned char)((298 * (temp - 16) + 128) >> 8); //temp;//
				bitmapImage[imageIdx] = (unsigned char)((298 * (temp - 16) + 128) >> 8); //temp;//
				//imageIdx += 3;
			}
	
}

void WriteBMPFile(const char *filename, BITMAPINFOHEADER *bitmapInfoHeader, BITMAPFILEHEADER *bitmapFileHeader, unsigned char *bitmapImage)
{
	FILE *filePtr; //our file pointer
	//our bitmap file header
	 //store image data

	//open filename in read binary mode
	filePtr = fopen(filename, "wb");
	if (filePtr == NULL)
		return;

	//read the bitmap file header
	fwrite(bitmapFileHeader, sizeof(BITMAPFILEHEADER), 1, filePtr);
	
	//read the bitmap info header
	fwrite(bitmapInfoHeader, sizeof(BITMAPINFOHEADER), 1, filePtr);
	
	//read in the bitmap image data
	fwrite(bitmapImage, 1, bitmapInfoHeader->biSizeImage, filePtr);
	fclose(filePtr);
	//free(bitmapImage);
	
}
