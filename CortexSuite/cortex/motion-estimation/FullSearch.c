#include "MotionEstimation.h"
#include "FullSearch.h"
#include <math.h>
#include <stdlib.h>

void Taylor_App(Image* block, Image* block_ref, int BlockSize, double* MVx_frac, double* MVy_frac)
{
	double A[4] = { 0 };
	double rhs[2] = { 0 };
	double* dfx = (double*)calloc(BlockSize*BlockSize, sizeof(double));
	double* dfy = (double*)calloc(BlockSize*BlockSize, sizeof(double));
	double* z = (double*)calloc(BlockSize*BlockSize, sizeof(double));

	// get gradient of block_ref
	int i, j;
	for (i = 0; i < BlockSize; i++)
	{
		for (j = 0; j < BlockSize; j++)
		{
			if (j == 0)
				dfx[i*BlockSize + j] = (block_ref->data[i*(block_ref->x_length) + j + 1] - block_ref->data[i*(block_ref->x_length) + j]);
			else if (j == (BlockSize - 1))
				dfx[i*BlockSize + j] = (block_ref->data[i*(block_ref->x_length) + j] - block_ref->data[i*(block_ref->x_length) + j - 1]);
			else
				dfx[i*BlockSize + j] = (block_ref->data[i*(block_ref->x_length) + j + 1] - block_ref->data[i*(block_ref->x_length) + j - 1])/2;

			if (i == 0)
				dfy[i*BlockSize + j] = (block_ref->data[(i + 1)*(block_ref->x_length) + j] - block_ref->data[i*(block_ref->x_length) + j]);
			else if (i == (BlockSize - 1))
				dfy[i*BlockSize + j] = (block_ref->data[i*(block_ref->x_length) + j] - block_ref->data[(i - 1)*(block_ref->x_length) + j]);
			else
				dfy[i*BlockSize + j] = (block_ref->data[(i+1)*(block_ref->x_length) + j] - block_ref->data[(i-1)*(block_ref->x_length) + j]) / 2;

			z[i*BlockSize + j] = (block->data[i*(block->x_length) + j] - block_ref->data[i*(block_ref->x_length) + j]);
		}
	}

	for (i = 0; i < BlockSize; i++)
	{
		for (j = 0; j < BlockSize; j++)
		{
			A[0] += (dfx[i*BlockSize + j] * dfx[i*BlockSize + j]);
			A[1] += (dfx[i*BlockSize + j] * dfy[i*BlockSize + j]);
			A[2] = A[1];
			A[3] += (dfy[i*BlockSize + j] * dfy[i*BlockSize + j]);

			rhs[0] += (z[i*BlockSize + j] * dfx[i*BlockSize + j]);
			rhs[1] += (z[i*BlockSize + j] * dfy[i*BlockSize + j]);
		}
	}

	//solve the linear equation A*[dx dy] = rhs
	double detA = A[0] * A[3] - A[1] * A[2];

	if (!detA) return;

	double Ainv[4] = { 0 };
	Ainv[0] = A[3] / detA;
	Ainv[1] = -A[2] / detA;
	Ainv[2] = -A[1] / detA;
	Ainv[3] = A[0] / detA;

	*MVx_frac = Ainv[0] * rhs[0] + Ainv[1] * rhs[1];
	*MVy_frac = Ainv[2] * rhs[0] + Ainv[3] * rhs[1];

}

void FullSearch(Image* block, Image* img_ref, int yc, int xc, int SearchLimit, int BlockSize, double* dx, double* dy)
{
	int xt, yt, x_min = 0, y_min = 0;
	double SADmin = 100000.0;
	double MVx_int = 0, MVy_int = 0;
	double* block_ref;
	int i, j, ii, jj;
	for (i = -SearchLimit; i < SearchLimit; i++)
	{
		for (j = -SearchLimit; j < SearchLimit; j++)
		{
			xt = xc + j;
			yt = yc + i;

			block_ref = img_ref->data + yt*(img_ref->x_length) + xt;
			//SAD = sum(abs(Block(:) - Block_ref(:))) / (BlockSize ^ 2);
			double SAD = 0;
			for (ii = 0; ii < BlockSize; ii++)
			{
				for (jj = 0; jj < BlockSize; jj++)
				{
					SAD += abs(block->data[ii*(block->x_length) + jj] - block_ref[ii*(img_ref->x_length) + jj]);
					//SAD += abs((block->data[ii*(block->x_length) + jj] * block->data[ii*(block->x_length) + jj]) - (block_ref[ii*(img_ref->x_length) + jj] * block_ref[ii*(img_ref->x_length) + jj]));
				}
			}

			SAD = SAD / (BlockSize*BlockSize);
			if (SAD < SADmin)
			{
				SADmin = SAD;
				x_min = xt;
				y_min = yt;
			}
			//MVx_int = xc - x_min;
			//MVy_int = yc - y_min;
			MVx_int = x_min - xc;
			MVy_int = y_min - yc;
		}
	}

	Image block_ref1;
	double MVx_frac = 0, MVy_frac = 0;
	block_ref1.x_length = img_ref->x_length;
	block_ref1.y_length = img_ref->y_length;
	
	block_ref1.data = img_ref->data + y_min*(img_ref->x_length) + x_min;
	//block_ref1.data = img_ref->data + yc*(img_ref->x_length) + xc;
	Taylor_App(block, &block_ref1, BlockSize, &MVx_frac, &MVy_frac);
	*dx = MVx_int + MVx_frac;
	//*dx = MVx_frac;
	*dy = MVy_int + MVy_frac;
	//*dy = MVy_frac;
}