//#include "ImageHandler.h"
#include "BmpHandler.h"
#include "SystemMatrices.h"
#include "SRREngine.h"
#include <string.h>


double*** LR;
BITMAPFILEHEADER hdr;
BITMAPINFOHEADER infoHdr;

HRESULT LoadLR()
{
  HRESULT hr = SUCCESS;
  //new emily
#ifdef NEW_EMILLY
  char img[16][50] = { "Emily Frame 0.bmp", "Emily Frame 1.bmp", "Emily Frame 2.bmp", "Emily Frame 3.bmp",
    "Emily Frame 4.bmp", "Emily Frame 5.bmp", "Emily Frame 6.bmp", "Emily Frame 7.bmp",
    "Emily Frame 29.bmp", "Emily Frame 39.bmp", "Emily Frame 40.bmp", "Emily Frame 43.bmp",
    "Emily Frame 44.bmp", "Emily Frame 45.bmp", "Emily Frame 51.bmp", "Emily Frame 54.bmp" };
  char path1[50] = "./LR/NewEmilly/";
#endif

  // new text
#ifdef NEW_TEXT
  char img[16][50] = { "TextCropped0.bmp", "TextCropped1.bmp", "TextCropped2.bmp", "TextCropped3.bmp",
    "TextCropped4.bmp", "TextCropped5.bmp", "TextCropped6.bmp", "TextCropped7.bmp",
    "TextCropped8.bmp", "TextCropped9.bmp", "TextCropped10.bmp", "TextCropped11.bmp",
    "TextCropped12.bmp", "TextCropped13.bmp", "TextCropped14.bmp", "TextCropped15.bmp" };
  char path1[50] = "./LR/NewText/";
#endif

  //BookCase
#ifdef BOOKCASE
  char img[16][50] = { "o_762e7e8ed9e5ddc7-0.bmp", "o_762e7e8ed9e5ddc7-1.bmp", "o_762e7e8ed9e5ddc7-2.bmp", "o_762e7e8ed9e5ddc7-3.bmp",
    "o_762e7e8ed9e5ddc7-4.bmp", "o_762e7e8ed9e5ddc7-5.bmp", "o_762e7e8ed9e5ddc7-6.bmp", "o_762e7e8ed9e5ddc7-7.bmp",
    "o_762e7e8ed9e5ddc7-8.bmp", "o_762e7e8ed9e5ddc7-9.bmp", "o_762e7e8ed9e5ddc7-10.bmp", "o_762e7e8ed9e5ddc7-11.bmp",
    "o_762e7e8ed9e5ddc7-12.bmp", "o_762e7e8ed9e5ddc7-13.bmp", "o_762e7e8ed9e5ddc7-14.bmp", "o_762e7e8ed9e5ddc7-15.bmp" };
  char path1[50] = "./LR/BookCase/";
#endif

  //Light House
#ifdef LIGHTHOUSE
  char img[16][50] = { "o_771dd3c88771fc6e-0.bmp", "o_771dd3c88771fc6e-1.bmp", "o_771dd3c88771fc6e-2.bmp",
    "o_771dd3c88771fc6e-3.bmp", "o_771dd3c88771fc6e-4.bmp", "o_771dd3c88771fc6e-5.bmp",
    "o_771dd3c88771fc6e-6.bmp", "o_771dd3c88771fc6e-7.bmp", "o_771dd3c88771fc6e-8.bmp" };
  char path1[50] = "./LR/LightHouse/";
#endif

  //Face
#ifdef FACE
  char img[16][50] = { "o_83e8a8ce5b6586e1-0.bmp", "o_83e8a8ce5b6586e1-1.bmp", "o_83e8a8ce5b6586e1-2.bmp", "o_83e8a8ce5b6586e1-3.bmp",
    "o_83e8a8ce5b6586e1-4.bmp", "o_83e8a8ce5b6586e1-5.bmp", "o_83e8a8ce5b6586e1-6.bmp", "o_83e8a8ce5b6586e1-7.bmp",
    "o_83e8a8ce5b6586e1-8.bmp", "o_83e8a8ce5b6586e1-9.bmp", "o_83e8a8ce5b6586e1-10.bmp", "o_83e8a8ce5b6586e1-11.bmp",
    "o_83e8a8ce5b6586e1-12.bmp", "o_83e8a8ce5b6586e1-13.bmp", "o_83e8a8ce5b6586e1-14.bmp", "o_83e8a8ce5b6586e1-15.bmp" };
  char path1[50] = "./LR/face_adyoron/";
#endif

  //eia
#ifdef EIA
  char img[16][50] = { "o_c1f56de21dab198c-0.bmp", "o_c1f56de21dab198c-1.bmp", "o_c1f56de21dab198c-2.bmp", "o_c1f56de21dab198c-3.bmp",
    "o_c1f56de21dab198c-4.bmp", "o_c1f56de21dab198c-5.bmp", "o_c1f56de21dab198c-6.bmp", "o_c1f56de21dab198c-7.bmp",
    "o_c1f56de21dab198c-8.bmp", "o_c1f56de21dab198c-9.bmp", "o_c1f56de21dab198c-10.bmp", "o_c1f56de21dab198c-11.bmp",
    "o_c1f56de21dab198c-12.bmp", "o_c1f56de21dab198c-13.bmp", "o_c1f56de21dab198c-14.bmp", "o_c1f56de21dab198c-15.bmp" };
  char path1[50] = "./LR/eia/";
#endif

  //eia2
#ifdef EIA2
  char img[16][50] = { "o_14a746fe4596e5fe-0.bmp", "o_14a746fe4596e5fe-1.bmp", "o_14a746fe4596e5fe-2.bmp", "o_14a746fe4596e5fe-3.bmp",
    "o_14a746fe4596e5fe-4.bmp", "o_14a746fe4596e5fe-5.bmp", "o_14a746fe4596e5fe-6.bmp", "o_14a746fe4596e5fe-7.bmp",
    "o_14a746fe4596e5fe-8.bmp", "o_14a746fe4596e5fe-9.bmp", "o_14a746fe4596e5fe-10.bmp", "o_14a746fe4596e5fe-11.bmp",
    "o_14a746fe4596e5fe-12.bmp", "o_14a746fe4596e5fe-13.bmp", "o_14a746fe4596e5fe-14.bmp", "o_14a746fe4596e5fe-15.bmp" };
  char path1[50] = "./LR/eia2/";
#endif

  //alpaca
#ifdef ALPACA
  char img[16][50] = { "Alpaca Frame 0.bmp", "Alpaca Frame 1.bmp", "Alpaca Frame 2.bmp", "Alpaca Frame 3.bmp",
    "Alpaca Frame 19.bmp", "Alpaca Frame 5.bmp", "Alpaca Frame 6.bmp", "Alpaca Frame 7.bmp",
    "Alpaca Frame 8.bmp", "Alpaca Frame 9.bmp", "Alpaca Frame 10.bmp", "Alpaca Frame 11.bmp",
    "Alpaca Frame 20.bmp", "Alpaca Frame 13.bmp", "Alpaca Frame 14.bmp", "Alpaca Frame 15.bmp" };
  char path1[50] = "./LR/alpaca/";
#endif

#ifdef ALPACA2
  char img[16][50] = { "Alpaca Frame 0.bmp", "Alpaca Frame 25.bmp", "Alpaca Frame 30.bmp", "Alpaca Frame 1.bmp",
    "Alpaca Frame 8.bmp", "Alpaca Frame 38.bmp", "Alpaca Frame 16.bmp", "Alpaca Frame 7.bmp",
    "Alpaca Frame 32.bmp", "Alpaca Frame 19.bmp", "Alpaca Frame 21.bmp", "Alpaca Frame 28.bmp",
    "Alpaca Frame 33.bmp", "Alpaca Frame 13.bmp", "Alpaca Frame 20.bmp", "Alpaca Frame 41.bmp" };
  char path1[50] = "./LR/alpaca/";
#endif

  //disc
#ifdef DISC
  char img[16][50] = {"diskCropped0.bmp","diskCropped1.bmp","diskCropped2.bmp","diskCropped3.bmp",
    "diskCropped4.bmp","diskCropped5.bmp","diskCropped6.bmp","diskCropped7.bmp",
    "diskCropped8.bmp","diskCropped9.bmp","diskCropped10.bmp","diskCropped11.bmp",
    "diskCropped12.bmp","diskCropped13.bmp","diskCropped14.bmp","diskCropped15.bmp"};
  char path1[50] = "./LR/diskFrames/";
#endif

  //disc
#ifdef SYNTHETIC1
  char img[16][50] = {"Output0.bmp","Output1.bmp","Output2.bmp","Output3.bmp",
    "Output4.bmp","Output5.bmp","Output6.bmp","Output7.bmp",
    "Output8.bmp","Output9.bmp","Output10.bmp","Output11.bmp",
    "Output12.bmp","Output13.bmp","Output14.bmp","Output15.bmp"};
  char path1[50] = "./LR/synthetic1/";
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
  if (!LR) return FAIL;
  for(i = 0; i<l*l; i++)
  {
    char path[50] = "";
    strcpy(path, path1);
    const char* str = strcat(path, img[i]);
    unsigned char* BmpImage = LoadBitmapFile(str, &infoHdr, &hdr);
    if (!BmpImage) return FAIL;
    ConvertRGBtoGrayScale(BmpImage, LR[i], y_dim, x_dim);
    if (BmpImage) free(BmpImage);
    //hr = LoadYUVImage(LR[i], str, n/l, n/l);
    if(hr == FAIL) break;
  }
  return hr;
}

HRESULT WriteHR()
{
  //unsigned char Arr[n][n] = {0};
  HRESULT hr = SUCCESS;
  //int Iindex,Jindex;

  unsigned char* bitmapImage = (unsigned char*)calloc(3 * x_dim*y_dim*(l*l), sizeof (unsigned char));
  if (!bitmapImage) return FAIL;
  ConvertGrayScaletoRGB(bitmapImage, f, y_dim, x_dim);
  infoHdr.biHeight = y_dim*l;
  infoHdr.biWidth = x_dim*l;
  infoHdr.biSizeImage = infoHdr.biHeight*infoHdr.biWidth*infoHdr.biBitCount/8;
  hdr.bfSize = hdr.bfOffBits + infoHdr.biSizeImage;

  WriteBMPFile("Output.bmp", &infoHdr, &hdr, bitmapImage);
  if (bitmapImage)
  {
    free(bitmapImage);
    bitmapImage = 0;
  }

  return hr;
}

void AllocMemToA()
{
  A00 = (double **)calloc((l*l), sizeof(double *));
  AT00 = (double **)calloc((l*l), sizeof(double *));

  int i;

  for(i = 0; i<(l*l); i++)
  {
    A00[i] = (double *)calloc((l*l), sizeof(double));
    AT00[i] = (double *)calloc((l*l), sizeof(double));
  }

  A01 = (double **)calloc((l*l), sizeof(double *));
  AT01 = (double **)calloc((l*l), sizeof(double *));
  for(i = 0; i<(l*l); i++)
  {
    A01[i] = (double *)calloc((l*l), sizeof(double));
    AT01[i] = (double *)calloc((l*l), sizeof(double));
  }

  A10 = (double **)calloc((l*l), sizeof(double *));
  AT10 = (double **)calloc((l*l), sizeof(double *));
  for(i = 0; i<(l*l); i++)
  {
    A10[i] = (double *)calloc((l*l),sizeof(double));
    AT10[i] = (double *)calloc((l*l),sizeof(double));
  }

  A11 = (double **)calloc((l*l), sizeof(double *));
  AT11 = (double **)calloc((l*l), sizeof(double *));
  for(i = 0; i<(l*l); i++)
  {
    A11[i] = (double *)calloc((l*l), sizeof(double));
    AT11[i] = (double *)calloc((l*l), sizeof(double));
  }

  A0bar1 = (double **)calloc((l*l), sizeof(double *));
  AT0bar1 = (double **)calloc((l*l), sizeof(double *));
  for(i = 0; i<(l*l); i++)
  {
    A0bar1[i] = (double *)calloc((l*l), sizeof(double));
    AT0bar1[i] = (double *)calloc((l*l), sizeof(double));
  }

  Abar10 = (double **)calloc((l*l), sizeof(double *));
  ATbar10 = (double **)calloc((l*l), sizeof(double *));
  for(i = 0; i<(l*l); i++)
  {
    Abar10[i] = (double *)calloc((l*l), sizeof(double));
    ATbar10[i] = (double *)calloc((l*l), sizeof(double));
  }

  Abar1bar1 = (double **)calloc((l*l), sizeof(double *));
  ATbar1bar1 = (double **)calloc((l*l), sizeof(double *));
  for(i = 0; i<(l*l); i++)
  {
    Abar1bar1[i] = (double *)calloc((l*l), sizeof(double));
    ATbar1bar1[i] = (double *)calloc((l*l), sizeof(double));
  }

  A1bar1 = (double **)calloc((l*l), sizeof(double *));
  AT1bar1 = (double **)calloc((l*l), sizeof(double *));
  for(i = 0; i<(l*l); i++)
  {
    A1bar1[i] = (double *)calloc((l*l), sizeof(double));
    AT1bar1[i] = (double *)calloc((l*l), sizeof(double));
  }

  Abar11 = (double **)calloc((l*l), sizeof(double *));
  ATbar11 = (double **)calloc((l*l), sizeof(double *));
  for(i = 0; i<(l*l); i++)
  {
    Abar11[i] = (double *)calloc((l*l), sizeof(double));
    ATbar11[i] = (double *)calloc((l*l), sizeof(double));
  }

}

void FreeMemOfA()
{
  int i;
  for(i = 0;i<(l*l);i++)
  {
    free(A00[i]);
    free(AT00[i]);
    free(A01[i]);
    free(AT01[i]);
    free(A10[i]);
    free(AT10[i]);
    free(A11[i]);
    free(AT11[i]);
    free(A0bar1[i]);
    free(AT0bar1[i]);
    free(Abar10[i]);
    free(ATbar10[i]);
    free(Abar1bar1[i]);
    free(ATbar1bar1[i]);
    free(A1bar1[i]);
    free(AT1bar1[i]);
    free(Abar11[i]);
    free(ATbar11[i]);

  }

  free(A00);
  free(AT00);
  free(A01);
  free(AT01);
  free(A10);
  free(AT10);
  free(A11);
  free(AT11);
  free(A0bar1);
  free(AT0bar1);
  free(Abar10);
  free(ATbar10);
  free(Abar1bar1);
  free(ATbar1bar1);
  free(A1bar1);
  free(AT1bar1);
  free(Abar11);
  free(ATbar11);


}

void AllocImgMem()
{
  int i, j;
  f = (double ***) calloc((y_dim)+2,sizeof(double**));
  for(i = 0; i<(y_dim)+2; i++)
  {
    f[i] = (double **) calloc((x_dim)+2, sizeof(double*));
  }

  for(i = 0;i<(y_dim)+2; i++)
  {
    for(j = 0;j<(x_dim)+2; j++)
    {
      f[i][j] = (double *) calloc((l*l),sizeof(double));
    }
  }
}

void FreeImgMem()
{
  int i, j;
  for(i = 0;i<(y_dim)+2; i++)
  {
    for(j = 0;j<(x_dim)+2; j++)
    {
      free(f[i][j]);
    }
  }
  for(i = 0; i<(y_dim)+2; i++)
  {
    free(f[i]);
  }
  free(f);
}

int main(int argc, char *argv[])
{
  //**Timing**/
  unsigned int* start, *stop, *elapsed;


  HRESULT hr;
  //__int64 start = 0, end = 0, freq = 0;
  //float timeSec = 0.0f;
  hr = LoadLR();
  if(hr == FAIL)
  {
    printf("UNABLE TO LOAD IMAGE!!");
    return 1;
  }
  hr = GetMotionVectors();
  if(hr == FAIL)
  {
    printf("ERROR WHILE MOTION ESTIMATION!!");
    return 1;
  }
  AllocMemToA();
  AllocImgMem();

  //QueryPerformanceCounter((LARGE_INTEGER *)&start);

  start = photonStartTiming();
  hr = CalculateA();
  if(hr == FAIL)
    printf("SYSTEM MATRICES COMPUTATION FAILURE!!");
  /*for(int i =0; i<(l*l); i++)
    {
    for(int j =0; j<(l*l); j++)
    printf("%f    ", A00[i][j]);
    printf("\n");
    }*/
  hr = SRREngine123();
  if(hr == FAIL)
    printf("ENGINE FAILURE!!");

  stop = photonEndTiming();
  elapsed = photonReportTiming(start,stop);
  photonPrintTiming(elapsed);


  /*QueryPerformanceCounter((LARGE_INTEGER *)&end);
    QueryPerformanceFrequency((LARGE_INTEGER *)&freq);
    timeSec = (((end - start) * 1.0) / freq);*/

  FreeMemOfA();
  hr = WriteHR();
  FreeImgMem();
  //printf("\nTotal Time  :  %f \nAverage Time  :  %f\n", timeSec, timeSec/(l*l-1));
  //getch();
  return 0;
}
