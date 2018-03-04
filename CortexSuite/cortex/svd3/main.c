/*
 * SVD for latent semantic analysis
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "common/sdvbs_common.h"


#define MIN(X,Y) ((X) < (Y) ? (X) : (Y))

/* Functions declarations */
int svd(F2D *, F2D *, F2D *);
void sortSVDResult(F2D *, F2D *, F2D *);

void printMatrix(F2D *m)
{
	int i = 0, j = 0;
	for (i = 0; i < m->height; i++)
	{
		for (j = 0; j < m->width; j++)
			printf("%6.2f ", subsref(m, i, j));

		printf("\n");
	}
}

void printFloatSubMatrix(F2D *m, int size)
{
	int i = 0, j = 0;
	for (i = 0; i < size; i++)
	{
		for (j = 0; j < size; j++)
			printf("%6.2f ", subsref(m, i, j));

		printf("\n");
	}
}

void printIntSubMatrix(I2D *m, int size)
{
	int i = 0, j = 0;
	for (i = 0; i < size; i++)
	{
		for (j = 0; j < size; j++)
			printf("%3d ", subsref(m, i, j));

		printf("\n");
	}
}


int main(int argc, char **argv)
{
	if (argc != 2)
	{
		printf("Usage: ./a.out [input]\n");
		return 1;
	}
  //** Timing **//
  unsigned int *start, *stop, *elapsed;
	char * inputPath = argv[1];

	printf("Input = %s.\n", inputPath);

	// Initialize u,s,v
	F2D * u = readFile(inputPath);
	F2D * s = fSetArray(1, u->width, 0);
	F2D * v = fSetArray(u->width, u->width, 0);

  start = photonStartTiming();
	printf("Starting SVD...\n");
	svd(u, s, v);
	printf("Sorting SVD result...\n");
	sortSVDResult(u, s, v);

	// Display SVD result
	/*
	printf("U:\n");
	printMatrix(u);
	printf("S:\n");
	printMatrix(s);
	printf("V:\n");
	printMatrix(v);
	*/

	// Multiply singular values to U and V
	int i, j;
	for (i = 0; i < s->width; i++)
	{
		for (j = 0; j < u->height; j++)
			subsref(u, j, i) = subsref(u, j, i) * subsref(s, 0, i);
		for (j = 0; j < v->height; j++)
					subsref(v, j, i) = subsref(v, j, i) * subsref(s, 0, i);
	}
  stop = photonEndTiming();

	fWriteMatrix(u, "result", "result_U.txt");
	fWriteMatrix(v, "result", "result_V.txt");


	free(u);
	free(s);
	free(v);

  elapsed = photonReportTiming(start,stop);
  photonPrintTiming(elapsed);
  return 0;
}
