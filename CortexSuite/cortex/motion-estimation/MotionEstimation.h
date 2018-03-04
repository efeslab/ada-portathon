//#define SYNTHETIC1

typedef struct
{
	double* dx;
	double* dy;
	int x_length;
	int y_length;
}MotionVectors;

typedef struct
{
	double* data;
	int x_length;
	int y_length;
}Image;


typedef struct
{
	int BlockSize;
	int SearchLimit;
}Opts;

void Motion_Est(Image* IM1, Image* IM2, Opts Opts, double* dx, double* dy);
