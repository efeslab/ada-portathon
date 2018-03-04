//#include <BmpHandler.h>
#include "MotionEstimation.h"
#include "BmpHandler.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <conio.h>

#ifdef NEW_EMILLY
#define l		4	//Decimation Factor
#define x_dim	(128)  
#define y_dim	(96)   
#endif

#ifdef SYNTHETIC1
#define l		4	//Decimation Factor
#define x_dim	(48)  
#define y_dim	(35)   
#endif

#ifdef ALPACA
#define l		4	//Decimation Factor
#define x_dim	(128)  
#define y_dim	(96)   
#endif

#ifdef BOOKCASE
#define l		4	//Decimation Factor
#define x_dim	(320)  
#define y_dim	(240)   
#endif

#define max(a, b)	(a>b?a:b)


double*** LR;
BITMAPFILEHEADER hdr;
BITMAPINFOHEADER infoHdr;


int LoadLR()
{
//	HRESULT hr = SUCCESS;
	//new emily
#ifdef NEW_EMILLY
	char img[16][50] = { "Emily Frame 0.bmp", "Emily Frame 1.bmp", "Emily Frame 2.bmp", "Emily Frame 3.bmp",
	"Emily Frame 4.bmp", "Emily Frame 5.bmp", "Emily Frame 6.bmp", "Emily Frame 7.bmp",
	"Emily Frame 29.bmp", "Emily Frame 39.bmp", "Emily Frame 40.bmp", "Emily Frame 43.bmp",
	"Emily Frame 44.bmp", "Emily Frame 45.bmp", "Emily Frame 51.bmp", "Emily Frame 54.bmp" };
	char path1[50] = "./LR/NewEmilly/";
#endif

	//synthetic1
#ifdef SYNTHETIC1
	char img[16][50] = { "Output0.bmp", "Output1.bmp", "Output2.bmp", "Output3.bmp",
		"Output4.bmp", "Output5.bmp", "Output6.bmp", "Output7.bmp",
		"Output8.bmp", "Output9.bmp", "Output10.bmp", "Output11.bmp",
		"Output12.bmp", "Output13.bmp", "Output14.bmp", "Output15.bmp" };
	char path1[50] = "./LR/synthetic1/";
#endif

	//alpaca
#ifdef ALPACA
	char img[16][50] = { "Alpaca Frame 0.bmp", "Alpaca Frame 25.bmp", "Alpaca Frame 30.bmp", "Alpaca Frame 1.bmp",
	"Alpaca Frame 8.bmp", "Alpaca Frame 38.bmp", "Alpaca Frame 16.bmp", "Alpaca Frame 7.bmp",
	"Alpaca Frame 32.bmp", "Alpaca Frame 19.bmp", "Alpaca Frame 21.bmp", "Alpaca Frame 28.bmp",
	"Alpaca Frame 33.bmp", "Alpaca Frame 13.bmp", "Alpaca Frame 20.bmp", "Alpaca Frame 41.bmp" };
	char path1[50] = "./LR/alpaca/";
#endif

	//BookCase
#ifdef BOOKCASE
	char img[16][50] = { "o_762e7e8ed9e5ddc7-0.bmp", "o_762e7e8ed9e5ddc7-1.bmp", "o_762e7e8ed9e5ddc7-2.bmp", "o_762e7e8ed9e5ddc7-3.bmp",
	"o_762e7e8ed9e5ddc7-4.bmp", "o_762e7e8ed9e5ddc7-5.bmp", "o_762e7e8ed9e5ddc7-6.bmp", "o_762e7e8ed9e5ddc7-7.bmp",
	"o_762e7e8ed9e5ddc7-8.bmp", "o_762e7e8ed9e5ddc7-9.bmp", "o_762e7e8ed9e5ddc7-10.bmp", "o_762e7e8ed9e5ddc7-11.bmp",
	"o_762e7e8ed9e5ddc7-12.bmp", "o_762e7e8ed9e5ddc7-13.bmp", "o_762e7e8ed9e5ddc7-14.bmp", "o_762e7e8ed9e5ddc7-15.bmp" };
	char path1[50] = "./LR/BookCase/";
#endif

	int i, j;
	//sizes
	LR = (double ***)calloc((l*l), sizeof(double**));
	for (i = 0; i < (l*l); i++)
	{
		LR[i] = (double **)calloc(y_dim, sizeof(double*));
	}

	for (i = 0; i < (l*l); i++)
	{
		for (j = 0; j < y_dim; j++)
		{
			LR[i][j] = (double *)calloc(x_dim, sizeof(double));
		}
	}
	if (!LR) return -1;
	for (i = 0; i<l*l; i++)
	{
		char path[50] = "";
		strcpy(path, path1);
		strcat(path, img[i]);
		unsigned char* BmpImage = LoadBitmapFile(path, &infoHdr, &hdr);
		if (!BmpImage) return -1;
		ConvertRGBtoGrayScale(BmpImage, LR[i], y_dim, x_dim);
		if (BmpImage) free(BmpImage);
		//hr = LoadYUVImage(LR[i], str, n/l, n/l);
		//if (hr == FAIL) -1;
	}
	return 1;
}
void Bidirectional_ME(Image* IM1, Image* IM2, Opts Opts, double* dx, double* dy)
{
	//MotionVectors MV1, MV2;
	// Forward ME
	//printf("FORWARD ME\n");
	
	double dx1, dy1, dx2, dy2;

	Motion_Est(IM1, IM2, Opts, &dx1, &dy1);
	//Backward ME
	//printf("\nBACKWARD ME ME\n");
	Motion_Est(IM2, IM1, Opts, &dx2, & dy2);

	//Motion Refinement
	/**dx = (dx1 -dx2)/2;
	*dy = (dy1 -dy2)/2;*/

	//Motion Refinement
	*dx = max(dx1, -dx2);
	*dy = max(dy1, -dy2);
}

int main()
{
	//Read image1
	//Read image2
	Image IM1, IM2;

  //**Timing**/
  unsigned int* start,*stop, *elapsed;
  start = photonStartTiming();

	LoadLR();

	IM1.x_length = x_dim;
	IM1.y_length = y_dim;
	IM1.data = (double *)calloc(x_dim*y_dim, sizeof(double));
	
	IM2.x_length = x_dim;
	IM2.y_length = y_dim;
	IM2.data = (double *)calloc(x_dim*y_dim, sizeof(double));

	//MotionVectors MV;
	Opts opts;
	opts.BlockSize = 5;
	opts.SearchLimit = 5;

	//__int64 start = 0, end = 0, freq = 0;
	//float timeSec = 0.0f;

	//QueryPerformanceCounter((LARGE_INTEGER *)&start);

	int i, j, k;
	//int k = 1;
	for (k = 0; k < l*l; k++)
	{
		for (i = 0; i < y_dim; i++)
		{
			for (j = 0; j < x_dim; j++)
			{
				IM1.data[i*(IM1.x_length) + j] = LR[0][i][j];
				IM2.data[i*(IM2.x_length) + j] = LR[k][i][j];
			}
		}

		double dx = 0, dy = 0;
		Bidirectional_ME(&IM1, &IM2, opts, &dx, &dy);
		printf("\nImage No. K = %d\n", k);
		printf("dx = %lf\tdy = %lf\n", dx, dy);
	}

  stop = photonEndTiming();
  elapsed = photonReportTiming(start, stop);
  photonPrintTiming(elapsed);
  

	//QueryPerformanceCounter((LARGE_INTEGER *)&end);
	//QueryPerformanceFrequency((LARGE_INTEGER *)&freq);
	//timeSec = (((end - start) * 1.0) / freq);

	//printf("\nTotal Time  :  %f \nAverage Time  :  %f\n", timeSec, timeSec / (l*l - 1));
	//_getch();

	return 0;
}
