/********************************
Author: Sravanthi Kota Venkata
********************************/

#include "texture.h"
#include <math.h>

int vrstartx, vrfinishx, vrstarty, vrfinishy;
extern params data;
int* candlistx, *candlisty;
int *atlas;
int anotherpass=0,maxcand = 40;
F2D *target, *result;
int *xloopout, *yloopout;
int *xloopin, *yloopin;

double compare_rest(F2D *image,int x, int y, F2D *tar,int x1, int y1, params* data);

/*********************************
This is the main texture synthesis function. Called just once
from main to generate image from 'image' into 'result'.
Synthesis parameters (image and neighborhood sizes) are in global
'data-> structure.
*********************************/

//void create_texture(F2D *image, F2D *result, params *data)
void create_texture(F2D *image, params *data)
{
    int i,j,k, ncand, bestx,besty;
    double diff,curdiff;
    int tsx,tsy;

    candlistx = (int*)malloc(sizeof(int)*(data->localx*(data->localy+1)+1));
    candlisty = (int*)malloc(sizeof(int)*(data->localx*(data->localy+1)+1));

//    printf("total = %d\t%d\t%d\n", data->localx, data->localy, (data->localx*(data->localy+1)+1));

//    if(!anotherpass) init(result, image,data);
    if(!anotherpass) init(image,data);
    
    for(i=0;i<data->heightout-data->localy/2;i++)
    {
        for(j=0;j<data->widthout;j++)
        {
            // First, create a list of candidates for particular pixel.
            if(anotherpass) ncand = create_all_candidates(j,i, data);
            else  ncand = create_candidates(j,i, data);

            // If there are multiple candidates, choose the best based on L_2 norm

            if(ncand > 1)
            {
                diff = 1e10;
                for(k=0;k<ncand;k++)
                {
                    curdiff = compare_neighb(image, arrayref(candlistx,k),arrayref(candlisty,k),result,j,i, data);
                    curdiff += compare_rest(image,arrayref(candlistx,k),arrayref(candlisty,k),target,j,i,data);
                    if(curdiff < diff)
                    {
                        diff = curdiff;
                        bestx = arrayref(candlistx,k);
                        besty = arrayref(candlisty,k);
                    }
                }
            }
            else
            {
                bestx = arrayref(candlistx,0);
                besty = arrayref(candlisty,0);
            }

            // Copy the best candidate to the output image and record its position
            // in the atlas (atlas is used to create candidates)

            asubsref(result,a(j,i,data->widthout)+R) = asubsref(image,a(bestx,besty,data->widthin)+R);
//            asubsref(result,a(j,i,data->widthout)+G) = asubsref(image,a(bestx,besty,data->widthin)+G);
//            asubsref(result,a(j,i,data->widthout)+B) = asubsref(image,a(bestx,besty,data->widthin)+B);
            arrayref(atlas,aa(j,i)) = bestx;
            arrayref(atlas,aa(j,i)+1) = besty;
        }
    }
    
    // Use full neighborhoods for the last few rows. This is a small
    // fraction of total area - can be ignored for optimization purposes.

    for(;i<data->heightout;i++)
    {
        for(j=0;j<data->widthout;j++)
        {
            ncand = create_all_candidates(j,i,data);
            if(ncand > 1)
            {
                diff = 1e10;
                for(k=0;k<ncand;k++)
                {
                    curdiff = compare_full_neighb(image, arrayref(candlistx,k),arrayref(candlisty,k),result,j,i, data);
                    if(curdiff < diff)
                    {
                        diff = curdiff;
                        bestx = arrayref(candlistx,k);
                        besty = arrayref(candlisty,k);
                    }
                }
            }
            else
            {
                bestx = arrayref(candlistx,0);
                besty = arrayref(candlisty,0);
            }
   
            asubsref(result,a(j,i,data->widthout)+R) = asubsref(image,a(bestx,besty,data->widthin)+R);
//            asubsref(result,a(j,i,data->widthout)+G) = asubsref(image,a(bestx,besty,data->widthin)+G);
//            asubsref(result,a(j,i,data->widthout)+B) = asubsref(image,a(bestx,besty,data->widthin)+B);
            arrayref(atlas,aa(j,i)) = bestx;
            arrayref(atlas,aa(j,i)+1) = besty;
        }
    }

    /*********************************
    End of main texture synthesis loop
    *********************************/

    for(i=0;i<data->localy/2;i++)
    {
        for(j=0;j<data->widthout;j++)
        {
            ncand = create_all_candidates(j,i,data);
            if(ncand > 1)
            {
                diff = 1e10;
                for(k=0;k<ncand;k++)
                {
                    curdiff = compare_full_neighb(image,arrayref(candlistx,k),arrayref(candlisty,k),result,j,i, data);
                    if(curdiff < diff)
                    {
                        diff = curdiff;
                        bestx = arrayref(candlistx,k);
                        besty = arrayref(candlisty,k);
                    }
                }
            }
            else
            {
                bestx = arrayref(candlistx,0);
                besty = arrayref(candlisty,0);
            }
   
            asubsref(result,a(j,i,data->widthout)+R) = asubsref(image,a(bestx,besty,data->widthin)+R);
//            asubsref(result,a(j,i,data->widthout)+G) = asubsref(image,a(bestx,besty,data->widthin)+G);
//            asubsref(result,a(j,i,data->widthout)+B) = asubsref(image,a(bestx,besty,data->widthin)+B);
            arrayref(atlas,aa(j,i)) = bestx;
            arrayref(atlas,aa(j,i)+1) = besty;
        }
    }
}

// Creates a list of valid candidates for given pixel using only L-shaped causal area

int create_candidates(int x,int y, params* data)
{
    int address,i,j,k,n = 0;
    for(i=0;i<=data->localy/2;i++)
    {
        for(j=-data->localx/2;j<=data->localx/2;j++)
        {
            if(i==0 && j>=0) 
                continue;
            address = aa( arrayref(xloopout,x+j), arrayref(yloopout,y-i) );
            arrayref(candlistx,n) = arrayref(atlas,address) - j;
            arrayref(candlisty,n) = arrayref(atlas,address+1) + i;

            if( arrayref(candlistx,n) >= vrfinishx || arrayref(candlistx,n) < vrstartx) 
            {
                arrayref(candlistx,n) = vrstartx + (int)(drand48()*(vrfinishx-vrstartx));
                arrayref(candlisty,n) = vrstarty + (int)(drand48()*(vrfinishy-vrstarty));
                n++;
                continue;
            }

            if( arrayref(candlisty,n) >= vrfinishy )
            {
                arrayref(candlisty,n) = vrstarty + (int)(drand48()*(vrfinishy-vrstarty));
                arrayref(candlistx,n) = vrstartx + (int)(drand48()*(vrfinishx-vrstartx));
                n++;
                continue;
            }
            
            for(k=0;k<n;k++)
            {
                if( arrayref(candlistx,n) == arrayref(candlistx,k) && arrayref(candlisty,n) == arrayref(candlisty,k))
                { 
                    n--; 
                    break;
                }
            }
            n++;
        }
    }
        
    return n;
}

// Created a list of candidates using the complete square around the pixel

int create_all_candidates(int x,int y, params* data)
{
    int address,i,j,k,n = 0;
    for(i=-data->localy/2;i<=data->localy/2;i++)
    {
        for(j=-data->localx/2;j<=data->localx/2;j++)
        {
            if(i==0 && j>=0) 
                continue;
//            printf("Entering = (%d,%d)\n", i,j);
            address = aa( arrayref(xloopout,x+j), arrayref(yloopout,y-i) );
            arrayref(candlistx,n) = arrayref(atlas,address)-j;
            arrayref(candlisty,n) = arrayref(atlas,address+1)+i;

            if( arrayref(candlistx,n) >= vrfinishx || arrayref(candlistx,n) < vrstartx) 
            {
                arrayref(candlistx,n) = vrstartx + (int)(drand48()*(vrfinishx-vrstartx));
                arrayref(candlisty,n) = vrstarty + (int)(drand48()*(vrfinishy-vrstarty));
                n++;
//                printf("1: (%d,%d)\t%d\n", i,j,n);
                continue;
            }

            if( arrayref(candlisty,n) >= vrfinishy || arrayref(candlisty,n) < vrstarty)
            {
                arrayref(candlisty,n) = vrstarty + (int)(drand48()*(vrfinishy-vrstarty));
                arrayref(candlistx,n) = vrstartx + (int)(drand48()*(vrfinishx-vrstartx));
                n++;
//                printf("2: (%d,%d)\t%d\n", i,j,n);
                continue;
            }

            for(k=0;k<n;k++)
            {
                if( arrayref(candlistx,n) == arrayref(candlistx,k) && arrayref(candlisty,n) == arrayref(candlisty,k) )
                { 
                    n--; 
//                    printf("3: (%d,%d)\t%d\n", i,j,n);
                    break;
                }
            }
            n++;
//            printf("4: (%d,%d)\t%d\n", i,j,n);
        }
    }
    
    return n;
}

// Initializes the output image and atlases to a random collection of pixels

//void init(F2D *result, F2D *image, params* data)
void init(F2D *image, params* data)
{
    int i,j,tmpx,tmpy;
    vrstartx = data->localx/2; vrstarty = data->localy/2;
    vrfinishx = data->widthin-data->localx/2;
    vrfinishy = data->heightin-data->localy/2;
    for(i=0;i<data->heightout;i++)
    {
        for(j=0;j<data->widthout;j++)
        {
            if(
            asubsref(target,a(j,i,data->widthout)+R) == 1.0
//            && asubsref(target,a(j,i,data->widthout)+G) == 1.0
//            && asubsref(target,a(j,i,data->widthout)+B) == 1.0
            )
            {
                tmpx = vrstartx + (int)(drand48()*(vrfinishx-vrstartx));
                tmpy = vrstarty + (int)(drand48()*(vrfinishy-vrstarty));
                if(!anotherpass)
                {
                    arrayref(atlas,aa(j,i)) = tmpx; 
                    arrayref(atlas,aa(j,i)+1) = tmpy;
                    asubsref(result,a(j,i,data->widthout)+R) = asubsref(image,a(tmpx,tmpy,data->widthin)+R);
//                    asubsref(result,a(j,i,data->widthout)+G) = asubsref(image,a(tmpx,tmpy,data->widthin)+G);
//                    asubsref(result,a(j,i,data->widthout)+B) = asubsref(image,a(tmpx,tmpy,data->widthin)+B);
                }
            }
        }
    }
    
    return;
}


// Compares two square neighborhoods, returns L_2 difference

double compare_full_neighb(F2D *image,int x, int y, F2D *image1,int x1, int y1, params* data)
{
    double tmp,res = 0;
    int i,j,addr,addr1;
    for(i=-(data->localy/2);i<=data->localy/2;i++)
    {
        for(j=-(data->localx/2);j<=data->localx/2;j++)
        {
            if( !( i > 0 && y1 > data->localy && y1+i < data->heightout) )
            {
                addr = a(x+j,y+i,data->widthin);
                addr1 = a( arrayref(xloopout,x1+j), arrayref(yloopout,y1+i), data->widthout);

                tmp = asubsref(image,addr+R) - asubsref(image1,addr1+R);
                res += tmp*tmp;
//                tmp = asubsref(image,addr+G) - asubsref(image1,addr1+G);
//                res += tmp*tmp;
//                tmp = asubsref(image,addr+B) - asubsref(image1,addr1+B);
//                res += tmp*tmp;
            }
        }
    }

    return res;
}

// Compares two L-shaped neighborhoods, returns L_2 difference

double compare_neighb(F2D *image,int x, int y, F2D *image1,int x1, int y1, params* data)
{
    double tmp,res = 0;
    int i,j,addr1,addr;
    for(i=-(data->localy/2);i<0;i++)
    {
        for(j=-(data->localx/2);j<=data->localx/2;j++)
        {
            addr = a(x+j,y+i,data->widthin);
            addr1 = a( arrayref(xloopout,x1+j), arrayref(yloopout,y1+i), data->widthout);

            tmp = asubsref(image,addr+R) - asubsref(image1,addr1+R);
            res += tmp*tmp;
//            tmp = asubsref(image,addr+G) - asubsref(image1,addr1+G);
//            res += tmp*tmp;
//            tmp = asubsref(image,addr+B) - asubsref(image1,addr1+B);
//            res += tmp*tmp;
        }
    }
 
    for(j=-(data->localx/2);j<0;j++)
    {
        addr = a(x+j,y,data->widthin);
        addr1 = a( arrayref(xloopout,x1+j), y1, data->widthout);

        tmp = asubsref(image,addr+R) - asubsref(image1,addr1+R);
        res += tmp*tmp;
//        tmp = asubsref(image,addr+G) - asubsref(image1,addr1+G);
//        res += tmp*tmp;
//        tmp = asubsref(image,addr+B) - asubsref(image1,addr1+B);
//        res += tmp*tmp;
    }

    return res;
}

double compare_rest(F2D *image,int x, int y, F2D *tar,int x1, int y1, params* data)
{
    double tmp,res = 0;
    int i,j,addr,addr1;

    for(i=(data->localy/2);i>0;i--)
    {
        for(j=-(data->localx/2);j<=data->localx/2;j++)
        {
            addr = a(x+j,y+i,data->widthin);
            addr1 = a( arrayref(xloopout,x1+j), arrayref(yloopout,y1+i), data->widthout);

            if( asubsref(tar,addr1+R) != 1.0) //KVS?
            {
                tmp = asubsref(image,addr+R) - asubsref(tar,addr1+R);
                res += tmp*tmp;
//                tmp = asubsref(image,addr+G) - asubsref(tar,addr1+G);
//                res += tmp*tmp;
//                tmp = asubsref(image,addr+B) - asubsref(tar,addr1+B);
//                res += tmp*tmp;
            }
        }
    }
 
    for(j=(data->localx/2);j>0;j--)
    {
        addr = a(x+j,y,data->widthin);
        addr1 = a( arrayref(xloopout,x1+j), y1, data->widthout);
        if( asubsref(tar,addr1+R) != 1.0)   // KVS?
        {
            tmp = asubsref(image,addr+R) - asubsref(tar,addr1+R);
            res += tmp*tmp;
//            tmp = asubsref(image,addr+G) - asubsref(tar,addr1+G);
//            res += tmp*tmp;
//            tmp = asubsref(image,addr+B) - asubsref(tar,addr1+B);
//            res += tmp*tmp;
        }
    }

    return res;
}

