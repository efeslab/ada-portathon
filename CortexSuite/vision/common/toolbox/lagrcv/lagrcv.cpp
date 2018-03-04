#include "lagrcv.h"
/*
void calcImagePyr(char *src, int sizeY, int sizeX, int level, char *pyr){
	pyr=(char*) malloc(sizeof(char)*(int)sizeY*sizeX*4/3); 
	int i, startPnt, nX, nY;

	memcpy(pyr,src, sizeY*sizeX);
	nY=sizeY;
	nX=sizeX;
	for(i=0; i<level; i++){
		nY = (nY + 1) >> 1;
        	nX = (nX + 1) >> 1;
		calcSubsample(pyr, sizeY, sizeX, pyr+sizeY*sizeX)  
	}
	free(pyr);
}
*/

void calcSubSampleAvg(double *src, int sizeY, int sizeX, double *dest, int destSizeY, int destSizeX){
	int i, j, idx,
	 destI, destJ, idxDest;
	for(i=0, destI=0; destI<destSizeX; i+=2, destI++){
		for(j=0, destJ=0; destJ<destSizeY; j+=2, destJ++){
			idx=i*sizeX+j;
			idxDest=destI*destSizeY+destJ;
			dest[idxDest]=(src[idx]+src[idx+1]+src[idx+sizeY]+src[idx+sizeY+1])/4;
		}
	}
} 
void calcImgBlur(double *src, int sizeY, int sizeX, double *dest){
	double kernel[]={0.0625, 0.25, 0.375, 0.25, 0.0625};
	double *temp;
	temp=(double*) malloc(sizeof(double)*sizeY*sizeX);
	int i, j, idx, idxCol;
	for(i=2; i<sizeX-2;i++){
		idxCol=i*sizeY;
		for(j=0;j<sizeY; j++){
			idx=idxCol+j;
			temp[idx]=src[idx-2*sizeY]/16+src[idx-sizeY]/4
				+src[idx]*3/8+src[idx+sizeY]/4+src[idx+2*sizeY]/16;
		}
	}
	for(i=0; i<sizeX;i++){
		idxCol=i*sizeY;
		for(j=2;j<sizeY-2; j++){
			idx=idxCol+j;
			dest[idx]=temp[idx-2]/16+temp[idx-1]/4
				+temp[idx]*3/8+temp[idx+1]/4+temp[idx+2]/16;
		}
	}
	free(temp);
}
void calcImgResize(double *src, int sizeY, int sizeX, double *dest, int dstSizeY, int dstSizeX){
	double ker[]={ 0.0039,   0.0156,   0.0234,   0.0156,   0.0039,
    			0.0156,   0.0625,   0.0938,   0.0625,   0.0156,
    			0.0234,   0.0938,   0.1406,   0.0938,   0.0234,
    			0.0156,   0.0625,   0.0938,   0.0625,   0.0156,
    			0.0039,   0.0156,   0.0234,   0.0156,   0.0039};
	int srcI, srcJ, dstI, dstJ, srcIdx, dstIdx, idxCol_1, idxCol1, idxCol_2, idxCol2;
	for(srcI=2, dstI=1; srcI<sizeX-2; srcI+=2, dstI++){
		for(srcJ=2, dstJ=1; srcJ<sizeY-2; srcJ+=2, dstJ++){
			srcIdx=srcI*sizeY+srcJ;
			dstIdx=dstI*dstSizeY+dstJ;
			idxCol_1=srcIdx-sizeY;
			idxCol_2=srcIdx-2*sizeY;
			idxCol1=srcIdx+sizeY;
			idxCol2=srcIdx+2*sizeY;
			dest[dstIdx]=
			src[idxCol_2-2]*ker[0]+src[idxCol_1-2]*ker[1]
		+src[srcIdx-2]*ker[2]+src[idxCol1-2]*ker[3]+src[idxCol2-2]*ker[4]
			+src[idxCol_2-1]*ker[5]+src[idxCol_1-1]*ker[6]
		+src[srcIdx-1]*ker[7]+src[idxCol1-1]*ker[8]+src[idxCol2-1]*ker[9]
			+src[idxCol_2]*ker[10]+src[idxCol_1]*ker[11]
		+src[srcIdx]*ker[12]+src[idxCol1]*ker[13]+src[idxCol2]*ker[14]
			+src[idxCol_2+1]*ker[5]+src[idxCol_1+1]*ker[16]
		+src[srcIdx+1]*ker[17]+src[idxCol1+1]*ker[18]+src[idxCol2+1]*ker[19];
			+src[idxCol_2+2]*ker[20]+src[idxCol_1+2]*ker[21]
		+src[srcIdx+2]*ker[22]+src[idxCol1+2]*ker[23]+src[idxCol2+2]*ker[24];
		}
	}
}

void calcGradient(double *src, int sizeY, int sizeX, double *dX, double *dY){
	int i, j, idx;
	for(i=1; i<sizeX; i++){
		for(j=1; j<sizeY; j++){
			idx=i*sizeY+j;
			dX[idx]=src[idx]-src[idx-sizeY];
			dY[idx]=src[idx]-src[idx-1];
		}
	}
}
void calcGradient(char *src, int sizeY, int sizeX, char *dX, char *dY){
	int i, j, idx;
	for(i=1; i<sizeX; i++){
		for(j=1; j<sizeY; j++){
			idx=i*sizeY+j;
			dX[idx]=src[idx]-src[idx-sizeY];
			dY[idx]=src[idx]-src[idx-1];
		}
	}
}
void calcSobel(double *src, int sizeY, int sizeX, double *dX, double *dY){
	//char kernelV[9]={-1, -2, -1, 0, 0, 0, 1, 2, 1};
	//char kernelH[9]={-1, 0, 1, -2, 0, 2, -1, 0, 1};
	//const int kerSize=3;
	int i, j, idx, idxPrevCol, idxNextCol;
	for(i=1; i<sizeX-1; i++){
		for(j=1; j<sizeY-1; j++){
			idx=i*sizeY+j;
			idxPrevCol=idx-sizeY;
			idxNextCol=idx+sizeY;
			dX[idx]=src[idxPrevCol-1]*-0.0938f+src[idxPrevCol]*-0.3125f+src[idxPrevCol+1]*-0.0938f
				+src[idxNextCol-1]*0.0938f+src[idxNextCol]*0.3125f+src[idxNextCol+1]*0.0938f;
			dY[idx]=src[idxPrevCol-1]*-0.0938f+src[idx-1]*-0.3125f+src[idxNextCol-1]*-0.0938f
				+src[idxPrevCol+1]*0.0938f+src[idx+1]*0.3125f+src[idxNextCol+1]*0.0938f;
/*
			dX[idx]=(src[idxPrevCol-1]*-1+src[idxPrevCol]*-2+src[idxPrevCol+1]*-1
				+src[idxNextCol-1]*1+src[idxNextCol]*2+src[idxNextCol+1]*1)*0.0625;
			dY[idx]=(src[idxPrevCol-1]*-1+src[idx-1]*-2+src[idxNextCol-1]*-1
				+src[idxPrevCol+1]*1+src[idx+1]*2+src[idxNextCol+1]*1)*0.0625;
*/
		}
	}
}

void calcGoodFeature(double *dX, double *dY, int sizeY, int sizeX, int winSize, double* lambda, double* tr, double* det,
	double* c_xx, double* c_xy, double* c_yy){
	double *xx, *xy, *yy;
	int i,j,idx;
	xx=(double*)malloc(sizeof(double)*sizeY*sizeX);
	xy=(double*)malloc(sizeof(double)*sizeY*sizeX);
	yy=(double*)malloc(sizeof(double)*sizeY*sizeX);
	for(idx=0; idx<sizeX*sizeY; idx++){
		xx[idx]=dX[idx]*dX[idx];
		xy[idx]=dX[idx]*dY[idx];
		yy[idx]=dY[idx]*dY[idx];
	}
	calcAreaSum(xx, sizeY, sizeX, winSize, c_xx);
	calcAreaSum(xy, sizeY, sizeX, winSize, c_xy);
	calcAreaSum(yy, sizeY, sizeX, winSize, c_yy);
	for(idx=0; idx<sizeX*sizeY; idx++){
		tr[idx]=c_xx[idx]+c_yy[idx];
		det[idx]=c_xx[idx]*c_yy[idx]-c_xy[idx]*c_xy[idx];
		lambda[idx]=det[idx]/(tr[idx] + 0.00001);
	}
	free(xx);
	free(xy);
	free(yy);
}
void calcGoodFeature(char *dX, char *dY, int sizeY, int sizeX, int winSize, float* lambda, float* tr, float* det){
	int *xx, *xy, *yy;
	int *c_xx, *c_xy, *c_yy;
	int i,j,idx;
	xx=(int*)malloc(sizeof(int)*sizeY*sizeX);
	xy=(int*)malloc(sizeof(int)*sizeY*sizeX);
	yy=(int*)malloc(sizeof(int)*sizeY*sizeX);
	c_xx=(int*)malloc(sizeof(int)*sizeY*sizeX);
	c_xy=(int*)malloc(sizeof(int)*sizeY*sizeX);
	c_yy=(int*)malloc(sizeof(int)*sizeY*sizeX);
	for(i=0; i<sizeX; i++){
		for(j=0; j<sizeY; j++){
			idx=i*sizeY+j;
			xx[idx]=dX[idx]*dX[idx];
			xy[idx]=dX[idx]*dY[idx];
			yy[idx]=dY[idx]*dY[idx];
		}
	}
	calcAreaSum(xx, sizeY, sizeX, winSize, c_xx);
	calcAreaSum(xy, sizeY, sizeX, winSize, c_xy);
	calcAreaSum(yy, sizeY, sizeX, winSize, c_yy);
	for(i=0; i<sizeX; i++){
		for(j=0; j<sizeY; j++){
			idx=i*sizeY+j;
			tr[idx]=c_xx[idx]+c_yy[idx];
			det[idx]=c_xx[idx]*c_yy[idx]-c_xy[idx]*c_xy[idx];
			lambda[i*sizeY+j]=det[idx]/(tr[idx] + 0.00001);
		}
	}
}
void calcMinEigenValue(char *dX, char *dY, int sizeY, int sizeX, float* lambda){
	int xx, xy, yy;
	int tr;
	int i,j;
	for(i=0; i<sizeX; i++){
		for(j=0; j<sizeY; j++){
			xx=dX[i*sizeY+j]*dX[i*sizeY+j];
			xy=dX[i*sizeY+j]*dY[i*sizeY+j];
			yy=dY[i*sizeY+j]*dY[i*sizeY+j];
			tr=xx+yy;
			lambda[i*sizeY+j]=(float)(tr-pow((xx-yy)*(xx-yy)+4*xy*xy,0.5))/2;
		}
	}
}

void calcAreaSum(double *src, int sizeY, int sizeX, int winSize, double *ret){
/**/
  const int MAX_COLS = 1024;
  double *a_array[MAX_COLS], *b_array[MAX_COLS];
  double a1[MAX_COLS], a1sum;

  int nave = winSize;
  int nave_half = (int)floor((nave+1)/2)-1;

  double *a_ptr = src;

  int nx = sizeY;
  int ny = sizeX;

  double *b_ptr = ret;

  // Construct array pointers
  for (int iy = 0; iy < ny; iy++) {
    a_array[iy] = a_ptr + iy*nx;
    b_array[iy] = b_ptr + iy*nx;
  }

  // Initialize a1 array
  for (int i = 0; i < nx+nave; i++)
    a1[i] = 0.0;
  // Sum over cols:
  for (int iy = 0; iy < ny; iy++) {
    // Copy col into temp array:
    for (int ix = 0; ix < nx; ix++)
      a1[ix+nave_half] = a_array[iy][ix];

    a1sum = 0.0;
    for (int i = 0; i < nave; i++)
      a1sum += a1[i];

    for (int ix = 0; ix < nx; ix++) {
      b_array[iy][ix] = a1sum;
      a1sum += a1[ix+nave]-a1[ix];
    }
  }
  // Re-initialize a1 array
  for (int i = 0; i < ny+nave; i++)
    a1[i] = 0.0;
  // Sum over rows:
  for (int ix = 0; ix < nx; ix++) {
    // Copy row into temp array:
    for (int iy = 0; iy < ny; iy++)
      a1[iy+nave_half] = b_array[iy][ix];

    a1sum = 0.0;
    for (int i = 0; i < nave; i++)
      a1sum += a1[i];

    for (int iy = 0; iy < ny; iy++) {
      b_array[iy][ix] = a1sum;
      a1sum += a1[iy+nave]-a1[iy];
    }
  }
/**/
	// 8n^2+2n
/*
	// 10n^2
	int idx, idxCol, idx_1, idx_win, idx_Y, idx_win_Y;
	double* sum=(double*)malloc(sizeof(double)*sizeX*sizeY);
	//sum up along Y
	for(idx=idxCol=0; idx<(sizeX*sizeY); idxCol=idx){
		sum[idx]=src[idx];
		idx++;
		for(idx_1=idx-1;idx<(idxCol+winSize);idx++,
							idx_1++){
			sum[idx]=sum[idx_1]+src[idx];
		}
		for(idx_win=idx-winSize;idx<(idxCol+sizeY);idx++,
							idx_1++,
							idx_win++){
			sum[idx]=sum[idx_1]+src[idx]-src[idx_win];
		}
	}
	//sum up along X
	for(idx=0;idx<sizeY;idx++){
		ret[idx]=sum[idx];
	}
	for(idx_Y=idx-sizeY;idx<(winSize*sizeY);idx++,
						idx_Y++){
		ret[idx]+=sum[idx]+ret[idx_Y];
	}
	for(idx_win_Y=idx-winSize*sizeY;idx<(sizeX*sizeY); idx++,
							idx_win_Y++,
							idx_Y++){
		ret[idx]+=sum[idx]+ret[idx_Y]-sum[idx_win_Y];
	}
	free(sum);
/**/
/*
	// 8n^2+2n
	int i,j;
	int idx,idxCol;
	int idxDelta[4];
	double* sum=(double*)malloc(sizeof(double)*sizeX*sizeY);
	int halfSize=(int)winSize/2;
	ret[0]=src[0];
	for(i=1; i<sizeY; i++){
		sum[i]=src[i]+sum[i-1];
	}
	for(i=1; i<sizeX; i++){
		idx=i*sizeY;
		sum[idx]=src[idx]+sum[idx-sizeY];
	}
	for(i=1; i<sizeX; i++){
		for(j=1; j<sizeY; j++){
			idx=i*sizeY+j;
			sum[idx]=src[idx] 
				+ sum[idx-1]
				+ sum[idx-sizeY]
				- sum[idx-sizeY-1];
		}
	}
	idxDelta[0]=halfSize*sizeY+halfSize;
	idxDelta[1]=-halfSize*sizeY+halfSize;
	idxDelta[2]=halfSize*sizeY-halfSize;
	idxDelta[3]=-halfSize*sizeY-halfSize;
	for(i=halfSize; i<sizeX-halfSize; i++){
		for(j=halfSize; j<sizeY-halfSize; j++){
			idx=i*sizeY+j;
			ret[i*sizeY+j]=sum[idx+idxDelta[0]]-sum[idx+idxDelta[1]]-sum[idx+idxDelta[2]]+sum[idx+idxDelta[3]];
		}
	}
	free(sum);
/**/
} 
void calcAreaSum(int *src, int sizeY, int sizeX, int sizeSum, int *ret){
	// 8n^2+2n
	int i,j;
	int idx,idxCol;
	int idxDelta[4];
	int *sum;
	sum=(int*)malloc(sizeof(int)*sizeY*sizeX);
	int halfSize=(int)sizeSum/2;
	ret[0]=src[0];
	for(i=1; i<sizeY; i++){
		sum[i]=src[i]+sum[i-1];
	}
	for(i=0; i<sizeX; i++){
		idx=i*sizeY;
		sum[idx]=src[idx]+sum[idx-sizeY];
	}
	for(i=1; i<sizeX; i++){
		for(j=1; j<sizeY; j++){
			idx=i*sizeY+j;
			sum[idx]=src[idx] 
				+ sum[idx-1]
				+ sum[idx-sizeY]
				- sum[idx-sizeY-1];
		}
	}
/*
	for(i=0; i<sizeX; i++){
		for(j=0; j<sizeY; j++){
			idx=i*sizeY+j;
			sum[idx]=src[idx] 
				+ ((j>0)?sum[idx-1]:0)
				+ ((i>0)?sum[idx-sizeY]:0)
				- ((i>0&&j>0)?sum[idx-sizeY-1]:0);
		}
	}
*/
	idxDelta[0]=halfSize*sizeY+halfSize;
	idxDelta[1]=-halfSize*sizeY+halfSize;
	idxDelta[2]=halfSize*sizeY-halfSize;
	idxDelta[3]=-halfSize*sizeY-halfSize;
	for(i=halfSize; i<sizeX-halfSize; i++){
		for(j=halfSize; j<sizeY-halfSize; j++){
			idx=i*sizeY+j;
			ret[i*sizeY+j]=sum[idx+idxDelta[0]]-sum[idx+idxDelta[1]]-sum[idx+idxDelta[2]]+sum[idx+idxDelta[3]];
		}
	}

	free(sum);
} 


void getInterpolatePatch(double* srcImg, int* srcDims, double centerX, double centerY, int winSize, double* dstImg){
	double a, b, a11, a12, a21, a22, b1, b2;
	int srcIdxX, srcIdx;
	int dstIdxX, dstIdx;
	a=centerX-(double)((int)centerX);
	b=centerY-(double)((int)centerY);
	a11=(1.f-a)*(1.f-b);
	a12=a*(1.f-b);
	a21=(1.f-a)*b;
	a22=a*b;
	b1=1.f-b;
	b2=b;
	
	for(int i=-winSize; i<winSize; i++){
		srcIdxX=(int)centerX+i;
		dstIdxX=i+winSize;
		for(int j=-winSize; j<winSize; j++){
			srcIdx=(int)srcIdxX*srcDims[0]+(int)centerY+j;
			dstIdx=dstIdxX*2*winSize+j+winSize;
			dstImg[dstIdx]=srcImg[srcIdx]*a11
				+srcImg[srcIdx+1]*a12
				+srcImg[srcIdx+srcDims[0]]*a21
				+srcImg[srcIdx+srcDims[0]+1]*a22;
		}
	}
}
void calcPyrLKTrack(double** iP, double** iDxP, double** iDyP, double** jP, const int* imgDims, int pLevel, 
        double* fPnt, int nFeatures, int winSize, 
	double* newFPnt, char* valid){
        calcPyrLKTrack( iP, iDxP,  iDyP,  jP, imgDims,  pLevel, 
         fPnt,  nFeatures,  winSize, 
	 newFPnt,  valid, LK_ACCURACY_TH,  LK_MAX_ITER);
}
void calcPyrLKTrackWInit(double** iP, double** jP, const int* imgDims, int pLevel, 
        double* fPnt, int nFeatures, int winSize, 
	double* newFPnt, double* initFPnt,
	char* valid, double accuracy_th, int max_iter){

	double x, y, eX, eY, dX, dY, mX, mY, prevMX, prevMY, c_xx, c_xy, c_yy, c_det, dIt;
	double* iPatch, *jPatch, *iDxPatch, *iDyPatch;
	int level, winSizeSq, winSizeSqWBorder;
	int i, k, idx;
	int imgSize[2];
	
        static const double rate[]={1, 0.5, 0.25, 0.125, 0.0625, 0.03125};
	winSizeSq=4*winSize*winSize;
	winSizeSqWBorder=4*(winSize+1)*(winSize+1);

	iPatch=(double*) malloc(sizeof(double)*winSizeSqWBorder);
	jPatch=(double*) malloc(sizeof(double)*winSizeSq);
	iDxPatch=(double*) malloc(sizeof(double)*winSizeSqWBorder);
	iDyPatch=(double*) malloc(sizeof(double)*winSizeSqWBorder);

	for(i=0; i<nFeatures; i++){
		dX=(initFPnt[i*2+0]-fPnt[i*2+0])*rate[pLevel];
		dY=(initFPnt[i*2+1]-fPnt[i*2+1])*rate[pLevel];
		x=fPnt[i*2+0]*rate[pLevel];//half size of real level
		y=fPnt[i*2+1]*rate[pLevel];
		for(level=pLevel-1; level>=0; level--){
			x+=x; y+=y; dX+=dX; dY+=dY;
			imgSize[0]=imgDims[level*2+0]; //y,x		
			imgSize[1]=imgDims[level*2+1]; //y,x		
			
			c_xx=c_xy=c_yy=0;
			//when feature goes out to the boundary.
			if((x-winSize-1)<0 || (y-winSize-1)<0 
			|| (y+winSize+1+1)>=imgSize[0] || (x+winSize+1+1)>=imgSize[1]){ 
				//winSize+1due to interpolation
				//error or skip the level??
				valid[i]=0;
				break;
			} 

			getInterpolatePatch(iP[level], imgSize, x, y, winSize+1, iPatch); //to calculate iDx, iDy
			calcSobel(iPatch, (winSize+1)*2, (winSize+1)*2, iDxPatch, iDyPatch);
 			for(k=0; k <(winSize*2); k++ ){
                		memcpy( iPatch + k*winSize*2, iPatch + (k+1)*(winSize+1)*2 + 1, winSize*2 );
                		memcpy( iDxPatch + k*winSize*2, iDxPatch + (k+1)*(winSize+1)*2 + 1, winSize*2 );
                		memcpy( iDyPatch + k*winSize*2, iDyPatch + (k+1)*(winSize+1)*2 + 1, winSize*2 );
			}

			for(idx=0; idx<winSizeSq;idx++){
				c_xx+=iDxPatch[idx]*iDxPatch[idx];
				c_xy+=iDxPatch[idx]*iDyPatch[idx];
				c_yy+=iDyPatch[idx]*iDyPatch[idx];
			}
			c_det=c_xx*c_yy-c_xy*c_xy;
			if(c_det/(c_xx+c_yy+0.00000001)<GOOD_FEATURE_LAMBDA_TH){
				//just skip?
				valid[i]=0;
				break;
			}
			c_det=1/c_det;
			for(k=0; k<max_iter; k++){
				if((x+dX-winSize)<0 || (y+dY-winSize)<0 
				|| (y+dY+winSize+1)>=imgSize[0] || (x+dX+winSize+1)>=imgSize[1]){ 
					//winSize+1due to interpolation
					//error or skip the level??
					valid[i]=0;
					break;
				}	 
				getInterpolatePatch(jP[level], imgSize, x+dX, y+dY, winSize, jPatch);
				eX=eY=0;
				for(idx=0;idx<winSizeSq;idx++){
					dIt=iPatch[idx]-jPatch[idx];
					eX+=dIt*iDxPatch[idx];
					eY+=dIt*iDyPatch[idx];
				}
				mX=c_det*(eX*c_yy-eY*c_xy);
				mY=c_det*(-eX*c_xy+eY*c_xx);
				dX+=mX;
				dY+=mY;
				if((mX*mX+mY*mY)<accuracy_th) break;
 				if( k>0 && (mX + prevMX) < 0.01 && (mX+prevMX) > -0.01
				&& (mY + prevMY) < 0.01 && (mY+prevMY) > -0.01)
               		        {
                    			dX -= mX*0.5f;
                    			dY -= mY*0.5f;
                    			break;
                		}
				prevMX=mX;
				prevMY=mY;
			}
			if(k==max_iter){
				valid[i]=0;
			}
		}
		newFPnt[i*2+0]=fPnt[i*2+0]+dX;
		newFPnt[i*2+1]=fPnt[i*2+1]+dY;
/*
		if(valid[i]
		|| (x+dX-winSize)<0 || (y+dY-winSize)<0 
		|| (y+dY+winSize+1)>=imgSize[0] || (x+dX+winSize+1)>=imgSize[1]){ 
			newFPnt[i*2+0]=fPnt[i*2+0]+dX;
			newFPnt[i*2+1]=fPnt[i*2+1]+dY;
			getInterpolatePatch(jP[0], imgSize, newFPnt[i*2+0], newFPnt[i*2+0], winSize, jPatch);
			dIt=0;
			for(idx=0;idx<winSizeSq;idx++){
				dIt+=(iPatch[idx]-jPatch[idx])*(iPatch[idx]-jPatch[idx]);
			}
			if(dIt>winSizeSq*50000){
				valid[i]=0;
			}
		}else{
			newFPnt[i*2+0]=0;
			newFPnt[i*2+1]=0;
		}
*/
	}
	free(iPatch);
	free(jPatch);
	free(iDxPatch);
	free(iDyPatch);
}
void calcPyrLKTrackWInit(double** iP, double** iDxP, double** iDyP, double** jP, const int* imgDims, int pLevel, 
        double* fPnt, int nFeatures, int winSize, 
	double* newFPnt, double* initFPnt,
	char* valid, double accuracy_th, int max_iter){

	double x, y, eX, eY, dX, dY, mX, mY, prevMX, prevMY, c_xx, c_xy, c_yy, c_det, dIt;
	double* iPatch, *jPatch, *iDxPatch, *iDyPatch;
	int level, winSizeSq;
	int i, k, idx;
	int imgSize[2];
	
        static const double rate[]={1, 0.5, 0.25, 0.125, 0.0625, 0.03125};
	winSizeSq=4*winSize*winSize;

	iPatch=(double*) malloc(sizeof(double)*winSizeSq);
	jPatch=(double*) malloc(sizeof(double)*winSizeSq);
	iDxPatch=(double*) malloc(sizeof(double)*winSizeSq);
	iDyPatch=(double*) malloc(sizeof(double)*winSizeSq);

	for(i=0; i<nFeatures; i++){
		dX=(initFPnt[i*2+0]-fPnt[i*2+0])*rate[pLevel];
		dY=(initFPnt[i*2+1]-fPnt[i*2+1])*rate[pLevel];
		x=fPnt[i*2+0]*rate[pLevel];//half size of real level
		y=fPnt[i*2+1]*rate[pLevel];
		for(level=pLevel-1; level>=0; level--){
			x+=x; y+=y; dX+=dX; dY+=dY;
			imgSize[0]=imgDims[level*2+0]; //y,x		
			imgSize[1]=imgDims[level*2+1]; //y,x		
			
			c_xx=c_xy=c_yy=0;
			//when feature goes out to the boundary.
			if((x-winSize)<0 || (y-winSize)<0 
			|| (y+winSize+1)>=imgSize[0] || (x+winSize+1)>=imgSize[1]){ 
				//winSize+1due to interpolation
				//error or skip the level??
				valid[i]=0;
				break;
			} 

			getInterpolatePatch(iP[level], imgSize, x, y, winSize, iPatch);
			getInterpolatePatch(iDxP[level], imgSize, x, y, winSize, iDxPatch);
			getInterpolatePatch(iDyP[level], imgSize, x, y, winSize, iDyPatch);

			for(idx=0; idx<winSizeSq;idx++){
				c_xx+=iDxPatch[idx]*iDxPatch[idx];
				c_xy+=iDxPatch[idx]*iDyPatch[idx];
				c_yy+=iDyPatch[idx]*iDyPatch[idx];
			}
			c_det=c_xx*c_yy-c_xy*c_xy;
			if(c_det/(c_xx+c_yy+0.00000001)<GOOD_FEATURE_LAMBDA_TH){
				//just skip?
				valid[i]=0;
				break;
			}
			c_det=1/c_det;
			for(k=0; k<max_iter; k++){
				if((x+dX-winSize)<0 || (y+dY-winSize)<0 
				|| (y+dY+winSize+1)>=imgSize[0] || (x+dX+winSize+1)>=imgSize[1]){ 
					//winSize+1due to interpolation
					//error or skip the level??
					valid[i]=0;
					break;
				}	 
				getInterpolatePatch(jP[level], imgSize, x+dX, y+dY, winSize, jPatch);
				eX=eY=0;
				for(idx=0;idx<winSizeSq;idx++){
					dIt=iPatch[idx]-jPatch[idx];
					eX+=dIt*iDxPatch[idx];
					eY+=dIt*iDyPatch[idx];
				}
				mX=c_det*(eX*c_yy-eY*c_xy);
				mY=c_det*(-eX*c_xy+eY*c_xx);
				dX+=mX;
				dY+=mY;
				if((mX*mX+mY*mY)<accuracy_th) break;
 				if( k>0 && (mX + prevMX) < 0.01 && (mX+prevMX) > -0.01
				&& (mY + prevMY) < 0.01 && (mY+prevMY) > -0.01)
               		        {
                    			dX -= mX*0.5f;
                    			dY -= mY*0.5f;
                    			break;
                		}
				prevMX=mX;
				prevMY=mY;
			}
			if(k==max_iter){
				valid[i]=0;
			}
		}
		newFPnt[i*2+0]=fPnt[i*2+0]+dX;
		newFPnt[i*2+1]=fPnt[i*2+1]+dY;
/*
		if(valid[i]
		|| (x+dX-winSize)<0 || (y+dY-winSize)<0 
		|| (y+dY+winSize+1)>=imgSize[0] || (x+dX+winSize+1)>=imgSize[1]){ 
			newFPnt[i*2+0]=fPnt[i*2+0]+dX;
			newFPnt[i*2+1]=fPnt[i*2+1]+dY;
			getInterpolatePatch(jP[0], imgSize, newFPnt[i*2+0], newFPnt[i*2+0], winSize, jPatch);
			dIt=0;
			for(idx=0;idx<winSizeSq;idx++){
				dIt+=(iPatch[idx]-jPatch[idx])*(iPatch[idx]-jPatch[idx]);
			}
			if(dIt>winSizeSq*50000){
				valid[i]=0;
			}
		}else{
			newFPnt[i*2+0]=0;
			newFPnt[i*2+1]=0;
		}
*/
	}
	free(iPatch);
	free(jPatch);
	free(iDxPatch);
	free(iDyPatch);
}
void calcPyrLKTrack(double** iP, double** iDxP, double** iDyP, double** jP, const int* imgDims, int pLevel, 
        double* fPnt, int nFeatures, int winSize, 
	double* newFPnt, char* valid, double accuracy_th, int max_iter){

	double x, y, eX, eY, dX, dY, mX, mY, c_xx, c_xy, c_yy, c_det, dIt;
	double* iPatch, *jPatch, *iDxPatch, *iDyPatch;
	int level, winSizeSq;
	int i, k, idx;
	int imgSize[2];
	
        static const double rate[]={1, 0.5, 0.25, 0.125, 0.0625, 0.03125};
	winSizeSq=4*winSize*winSize;

	iPatch=(double*) malloc(sizeof(double)*winSizeSq);
	jPatch=(double*) malloc(sizeof(double)*winSizeSq);
	iDxPatch=(double*) malloc(sizeof(double)*winSizeSq);
	iDyPatch=(double*) malloc(sizeof(double)*winSizeSq);

	for(i=0; i<nFeatures; i++){
		dX=0;
		dY=0;
		x=fPnt[i*2+0]*rate[pLevel];//half size of real level
		y=fPnt[i*2+1]*rate[pLevel];
		for(level=pLevel-1; level>=0; level--){
			x+=x; y+=y; dX+=dX; dY+=dY;
			imgSize[0]=imgDims[level*2+0]; //y,x		
			imgSize[1]=imgDims[level*2+1]; //y,x		
			
			c_xx=c_xy=c_yy=0;
			//when feature goes out to the boundary.
			if((x-winSize)<0 || (y-winSize)<0 
			|| (y+winSize+1)>=imgSize[0] || (x+winSize+1)>=imgSize[1]){ 
				//winSize+1due to interpolation
				//error or skip the level??
				valid[i]=0;
				break;
			} 

			getInterpolatePatch(iP[level], imgSize, x, y, winSize, iPatch);
			getInterpolatePatch(iDxP[level], imgSize, x, y, winSize, iDxPatch);
			getInterpolatePatch(iDyP[level], imgSize, x, y, winSize, iDyPatch);

			for(idx=0; idx<winSizeSq;idx++){
				c_xx+=iDxPatch[idx]*iDxPatch[idx];
				c_xy+=iDxPatch[idx]*iDyPatch[idx];
				c_yy+=iDyPatch[idx]*iDyPatch[idx];
			}
			c_det=c_xx*c_yy-c_xy*c_xy;
			if(c_det/(c_xx+c_yy+0.00000001)<GOOD_FEATURE_LAMBDA_TH){
				valid[i]=0;
				break;
			}
			c_det=1/c_det;
			for(k=0; k<max_iter; k++){
				if((x+dX-winSize)<0 || (y+dY-winSize)<0 
				|| (y+dY+winSize+1)>=imgSize[0] || (x+dX+winSize+1)>=imgSize[1]){ 
					//winSize+1due to interpolation
					//error or skip the level??
					valid[i]=0;
					break;
				}	 
				getInterpolatePatch(jP[level], imgSize, x+dX, y+dY, winSize, jPatch);
				eX=eY=0;
				for(idx=0;idx<winSizeSq;idx++){
					dIt=iPatch[idx]-jPatch[idx];
					eX+=dIt*iDxPatch[idx];
					eY+=dIt*iDyPatch[idx];
				}
				mX=c_det*(eX*c_yy-eY*c_xy);
				mY=c_det*(-eX*c_xy+eY*c_xx);
				dX+=mX;
				dY+=mY;
				if((mX*mX+mY*mY)<accuracy_th) break;
			}
		}
		newFPnt[i*2+0]=fPnt[i*2+0]+dX;
		newFPnt[i*2+1]=fPnt[i*2+1]+dY;
/*
		if(valid[i]
		|| (x+dX-winSize)<0 || (y+dY-winSize)<0 
		|| (y+dY+winSize+1)>=imgSize[0] || (x+dX+winSize+1)>=imgSize[1]){ 
			newFPnt[i*2+0]=fPnt[i*2+0]+dX;
			newFPnt[i*2+1]=fPnt[i*2+1]+dY;
			getInterpolatePatch(jP[0], imgSize, newFPnt[i*2+0], newFPnt[i*2+0], winSize, jPatch);
			dIt=0;
			for(idx=0;idx<winSizeSq;idx++){
				dIt+=(iPatch[idx]-jPatch[idx])*(iPatch[idx]-jPatch[idx]);
			}
			if(dIt>winSizeSq*50000){
				valid[i]=0;
			}
		}else{
			newFPnt[i*2+0]=0;
			newFPnt[i*2+1]=0;
		}
*/
	}
	free(iPatch);
	free(jPatch);
	free(iDxPatch);
	free(iDyPatch);
}
void getPatch(double* srcImg, const int* srcDims, double centerX, double centerY, int winSize, double** dstImg){
	int srcIdxX, srcIdxY, dstIdxX;
	srcIdxY=(int)centerY-winSize;
	for(int i=-winSize; i<winSize; i++){
		srcIdxX=(int)centerX+i;
		dstIdxX=i+winSize;
		dstImg[dstIdxX]=srcImg+srcIdxX*winSize*2+srcIdxY;
	}
}
void calcLKTrack(double* imgI, double* iDx, double* iDy, double* imgJ, const int* imdims,
	double* c_xx, double* c_xy, double* c_yy,
        double* fPnt, double* initPnt, int nFeatures, int winSize,
        double* newFPnt, char* valid){
	calcLKTrack( imgI, iDx, iDy, imgJ, imdims,
		c_xx, c_xy, c_yy,
		fPnt, initPnt, nFeatures, winSize, 
        	newFPnt, valid, LK_ACCURACY_TH, LK_MAX_ITER);
}
void calcLKTrack(double* imgI, double* iDx, double* iDy, double* imgJ, const int* imdims, 
	double* c_xx, double* c_xy, double* c_yy,
        double* fPnt, double* initPnt, int nFeatures, int winSize, 
        double* newFPnt, char* valid, 
        double accuracy_th, int max_iter){
	double x, y, eX, eY, dX, dY, mX, mY, c_det, dIt;
	double* iPatch[LK_MAX_WIN], *iDxPatch[LK_MAX_WIN], *iDyPatch[LK_MAX_WIN];
	double*  jPatch;
	int level, winSizeSq;
	int i, k, idxCol, idxRow, idx;
	int imgSize[2];

	jPatch=(double*) malloc(sizeof(double)*winSizeSq);
	winSizeSq=4*winSize*winSize;
	imgSize[0]=imdims[0];
	imgSize[1]=imdims[1];
	for(i=0; i<nFeatures; i++){
		x=fPnt[i*2+0];//half size of real level
		y=fPnt[i*2+1];
		dX=initPnt[i*2+0]-x;
		dY=initPnt[i*2+1]-y;
//printf("input dx dy %.2f %.2f:", dX, dY);
			
		//when feature goes out to the boundary.
		if((x-winSize)<0 || (y-winSize)<0 
		|| (y+winSize)>=imdims[0] || (x+winSize)>=imdims[1]){ 
			//error or skip the level??
			valid[i]=0;
			continue;
		} 

		getPatch(imgI, imdims, x, y, winSize, iPatch);
		getPatch(iDx, imdims, x, y, winSize, iDxPatch);
		getPatch(iDy, imdims, x, y, winSize, iDyPatch);

		idx=(int)x*imdims[0]+(int)y;
		c_det=c_xx[i]*c_yy[i]-c_xy[i]*c_xy[i];
		if(c_det/(c_xx[i]+c_yy[i]+0.00000001)<GOOD_FEATURE_LAMBDA_TH*100){
			valid[i]=0;
			continue;
		}
		c_det=1/c_det;
		for(k=0; k<max_iter; k++){
			if((x+dX-winSize)<0 || (y+dY-winSize)<0 
			|| (y+dY+winSize+1)>=imdims[0] || (x+dX+winSize+1)>=imdims[1]){ 
				//winSize+1due to interpolation
				//error or skip the level??
				valid[i]=0;
				break;
			}	 
			getInterpolatePatch(imgJ, imgSize, x+dX, y+dY, winSize, jPatch);
			eX=eY=0;
			for(idxCol=0;idxCol<2*winSize;idxCol++){
				for(idxRow=0;idxRow<2*winSize;idxRow++){
					dIt=iPatch[idxCol][idxRow]-jPatch[idxCol*winSize*2+idxRow];
					eX+=dIt*iDxPatch[idxCol][idxRow];
					eY+=dIt*iDyPatch[idxCol][idxRow];
				}
			}
			mX=c_det*(eX*c_yy[i]-eY*c_xy[i]);
			mY=c_det*(-eX*c_xy[i]+eY*c_xx[i]);
			dX+=mX;
			dY+=mY;
			if((mX*mX+mY*mY)<accuracy_th) break;
		}
		if(k==max_iter){
			valid[i]=0;
		}
		newFPnt[i*2+0]=x+dX;
		newFPnt[i*2+1]=y+dY;
	}
	free(jPatch);
}

