#ifndef APP_H
#define APP_H

#include <stdio.h>
#include <math.h>
#include <stdlib.h>


#define	HRESULT	int
#define	SUCCESS	0
#define	FAIL	1
//#define n		384  //Size of HR image in X and Y directions

//#define m		192
//#define n		192

#ifdef NEW_TEXT
#define l		4	//Decimation Factor
#define x_dim	(48)  
#define y_dim	(48)
#endif

#ifdef NEW_EMILLY
#define l		4	//Decimation Factor
#define x_dim	(128)  
#define y_dim	(96)
#endif

#ifdef BOOKCASE
#define l		4	//Decimation Factor
#define x_dim	(320)  
#define y_dim	(240)
#endif

#ifdef LIGHTHOUSE
#define l		3	//Decimation Factor
#define x_dim	(64)  
#define y_dim	(96)
#endif

#ifdef FACE
#define l		4	//Decimation Factor
#define x_dim	(32)  
#define y_dim	(30)
#endif

#ifdef EIA
#define l		4	//Decimation Factor
#define x_dim	(64)  
#define y_dim	(64)
#endif

#ifdef EIA2
#define l		4	//Decimation Factor
#define x_dim	(88)  
#define y_dim	(88)
#endif

#ifdef ALPACA
#define l		4	//Decimation Factor
#define x_dim	(128)  
#define y_dim	(96)
#endif

#ifdef ALPACA2
#define l		4	//Decimation Factor
#define x_dim	(128)  
#define y_dim	(96)
#endif

#ifdef DISC
#define l		4	//Decimation Factor
#define x_dim	(48)  
#define y_dim	(48)
#endif

#ifdef SYNTHETIC1
#define l		4	//Decimation Factor
#define x_dim	(48)  
#define y_dim	(35)
#endif


   

extern double** A00;
extern double** A10;
extern double** A01;
extern double** A11;
extern double** Abar10;
extern double** A0bar1;
extern double** A1bar1;
extern double** Abar11;
extern double** Abar1bar1;


extern double*** LR;

extern double** AT00;
extern double** AT10;
extern double** AT01;
extern double** AT11;
extern double** ATbar10;
extern double** AT0bar1;
extern double** AT1bar1;
extern double** ATbar11;
extern double** ATbar1bar1;

HRESULT LoadLR();
HRESULT WriteHR();
void AllocMemToA();
void FreeMemOfA();
void AllocImgMem();
void FreeImgMem();

#endif
