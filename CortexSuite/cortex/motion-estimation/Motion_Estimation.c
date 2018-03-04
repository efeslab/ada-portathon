#include "MotionEstimation.h"
#include "FullSearch.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

double median(double *num, int length)
{
	int i, j, flag = 1;    // set flag to 1 to start first pass
	double temp;             // holding variable
	int numLength = length;
	//for (int i = 0; i < numLength; i++)
	//	printf("num[%d] = %lf\n", i, num[i]);


	for (i = 1; (i <= numLength) && flag; i++)
	{
		flag = 0;
		for (j = 0; j < (numLength - 1); j++)
		{
			if (num[j + 1] > num[j])      // ascending order simply changes to <
			{
				temp = num[j];             // swap elements
				num[j] = num[j + 1];
				num[j + 1] = temp;
				flag = 1;               // indicates that a swap occurred.
			}
		}
	}

	//for (int i = 0; i < numLength; i++)
	//	printf("num[%d] = %lf\n", i, num[i]);

	return num[length / 2];   //arrays are passed to functions by address; nothing is returned
}

void Motion_Est(Image* img_ref, Image* img_test, Opts Opts, double* dx, double* dy)
{
	int BlockSize = Opts.BlockSize;
	int SearchLimit = Opts.SearchLimit;

	MotionVectors MV;

	int N = (int)floor((double) img_ref->x_length / BlockSize)*BlockSize;
	int M = (int)floor((double)img_ref->y_length / BlockSize)*BlockSize;

	//[M N C] = size(img_ref);
	//int L = (int)floor((double)BlockSize / 2);

	MV.x_length = (int)floor((double)(N - 2 * SearchLimit) / BlockSize);
	MV.y_length = (int)floor((double)(M - 2 * SearchLimit) / BlockSize);

	MV.dx = (double *)calloc((MV.x_length)*(MV.y_length), sizeof(double));
	MV.dy = (double *)calloc((MV.x_length)*(MV.y_length), sizeof(double));

	Image block;
	block.x_length = img_test->x_length;
	block.y_length = img_test->y_length;
	int ctr = 0;
	int i, j;
	for (i = SearchLimit; i < M - SearchLimit; i += BlockSize)
	{
		for (j = SearchLimit; j < N - SearchLimit; j += BlockSize)
		{
			block.data = (img_test->data + i*(img_test->x_length) + j);
			FullSearch(&block, img_ref, i, j, SearchLimit, BlockSize, &MV.dx[ctr], &MV.dy[ctr]);
			ctr++;
		}
	}

	//for (int i = 0; i < ctr; i++)
	//	printf("dx = %lf\tdy = %lf\n", MV->dx[i], MV->dy[i]);
	//	printf("dx = %lf\tdy = %lf\n", median(MV.dx, ctr), median(MV.dy, ctr));
	*dx = median(MV.dx, ctr); 
	*dy = median(MV.dy, ctr);
}
