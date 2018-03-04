/********************************
Author: Sravanthi Kota Venkata
********************************/

#include <stdio.h>
#include <stdlib.h>
#include "localization.h"

int main(int argc, char* argv[])
{
    int n, i, j, k, icount=-1;
    F2D* fid;
    float gyroTimeInterval=0.01;
    float acclTimeInterval=0.01;

    float STDDEV_GPSVel=0.5;
    float STDDEV_ODOVel=0.1;
    float STDDEV_ACCL=1;
    float M_STDDEV_GYRO=0.1;
    float M_STDDEV_POS=0.1;
    float M_STDDEV_VEL=0.02;

    F2D *pos, *vel;
    float pi = 3.1416;
    F2D *eul1, *eul2, *quat;
    F2D *sData, *gyro, *norm_gyro, *angleAlpha;
    F2D *quatDelta, *Opos, *temp_STDDEV_GPSPos, *w;
    F2D *qConj, *orgWorld, *accl, *gtemp;
    F2D *gravity, *t1;
    I2D *tStamp, *sType, *isEOF;
    I2D *index;
    int rows, cols;
    F2D *resultMat;
    F2D *STDDEV_GPSPos;
    F2D *ones, *randW;

    unsigned int* start, *endC, *elapsed, *elt;
    char im1[100];

    if(argc < 2) 
    {
        printf("We need input image path\n");
        return -1;
    }

    sprintf(im1, "%s/1.txt", argv[1]);
    fid = readFile(im1);
    n = 1000;

    #ifdef test
        n = 3;
        gyroTimeInterval = 0.1;
        acclTimeInterval = 0.1;
        M_STDDEV_VEL = 0.2;
    #endif
    #ifdef sim_fast
        n = 3;
    #endif
    #ifdef sim
        n = 10;
    #endif
    #ifdef sqcif
        n = 800;
    #endif
    #ifdef qcif
        n = 500;
    #endif
    #ifdef vga
        n = 2000;
    #endif
    #ifdef wuxga
        n = 3000;
    #endif

    resultMat = fSetArray(3,fid->height, 0);

    pos = fSetArray(n, 3, 0);
    vel = fSetArray(n, 3, 0);
    ones = fSetArray(n,1,1);
   
    {
        int j;
        F2D *randn;
        randn = randWrapper(n,3);

        for(i=0; i<n; i++)
            for(j=0; j<3; j++)
                subsref(vel, i, j) += subsref(randn,i,j) * STDDEV_ODOVel;

        fFreeHandle(randn);
    }

    /** Start Timing **/ 
    start = photonStartTiming(); 
 
    {
        F2D *eulAngle, *randn;
        eulAngle = fSetArray(n, 3, 0);
        randn = randWrapper(n,1);

        for(i=0; i<n; i++)
        {
            subsref(eulAngle, i, 2) = subsref(randn, i, 0) * 2 * pi;
        }
    
        eul1 = eul2quat(eulAngle); 
        fFreeHandle(eulAngle);

        eulAngle = fSetArray(1, 3, 0);
        subsref(eulAngle, 0, 0) = pi;
        eul2 = eul2quat(eulAngle);
        
        fFreeHandle(randn);
        fFreeHandle(eulAngle);
    }
    
    quat = quatMul(eul1, eul2);
    fFreeHandle(eul1);
    fFreeHandle(eul2);

    i=0;
    index = iSetArray(1,1,-1);
    sType = iSetArray(1,1,-1);
    isEOF = iSetArray(1,1,-1);
    
    /** Timing utils **/   
    endC = photonEndTiming();
    elapsed = photonReportTiming(start, endC);
    free(start);
    free(endC);

    rows =0;
    cols = 5;
    STDDEV_GPSPos = fSetArray(3,3,0);
    randW = randnWrapper(n,3);

    while(1)
    {
        icount=icount+1;
        
        /*     
        S = 4
        A = 3
        G = 2
        V = 1
        */

        sData = readSensorData(index, fid, sType, isEOF);    
        rows++;


        /** Start Timing **/ 
        start = photonStartTiming(); 

        if( asubsref(sType,0) ==2)
        {

        //Motion model
            
            {
                int i;
                F2D *t, *t1;
                F2D *abc, *abcd;
                int qD_r=0, qD_c=0;
                F2D *cosA, *sinA;
                
                t = fDeepCopyRange(sData, 0, 1, 0, 3);
                gyro = fMtimes(ones, t);
                abc = fMallocHandle(gyro->height, gyro->width);
                t1 = fDeepCopy(randW);
                                
                for(i=0; i<(n*3); i++)
                {
                    asubsref(t1,i) = asubsref(randW,i) * M_STDDEV_GYRO;
                    asubsref(gyro, i) += asubsref(t1,i);
                    asubsref(abc, i) = pow(asubsref(gyro, i), 2);
                }
                fFreeHandle(t1);
                abcd = fSum2(abc, 2);

                norm_gyro = fMallocHandle(abcd->height,abcd->width);
                angleAlpha = fMallocHandle(abcd->height, abcd->width);

                for(i=0; i<(abcd->height*abcd->width); i++)
                {
                    asubsref(norm_gyro, i) = sqrt(asubsref(abcd,i));
                    asubsref(angleAlpha,i) = asubsref(norm_gyro,i) * gyroTimeInterval;
                }

                qD_r += angleAlpha->height + gyro->height;
                qD_c += angleAlpha->width + 3;
                
                fFreeHandle(t);
                fFreeHandle(abcd); 
                
                cosA = fSetArray(angleAlpha->height, angleAlpha->width, 0);
                sinA = fSetArray(angleAlpha->height, angleAlpha->width, 0);

                for(i=0; i<(cosA->height*cosA->width); i++)
                    asubsref(cosA,i) = cos( asubsref(angleAlpha,i) /2 );
 
                for(i=0; i<(sinA->height*sinA->width); i++)
                    asubsref(sinA,i) = sin( asubsref(angleAlpha,i) /2 );
    
                
                fFreeHandle(abc);
                abc = fSetArray(1,3,1);
                t1 = fMtimes(norm_gyro, abc);
                t = ffDivide(gyro, t1);
                fFreeHandle(t1);

                abcd = fMtimes(sinA, abc);
                t1 = fTimes(t, abcd);
                quatDelta = fHorzcat(cosA, t1);
                
                fFreeHandle(abcd);
                fFreeHandle(t);
                fFreeHandle(t1);
                fFreeHandle(abc);

                t = quatMul(quat, quatDelta);
                fFreeHandle(quat);
                fFreeHandle(quatDelta);
                quat = fDeepCopy(t);
                
                fFreeHandle(t);
                fFreeHandle(norm_gyro);
                fFreeHandle(gyro);
                fFreeHandle(angleAlpha);
                fFreeHandle(cosA);
                fFreeHandle(sinA);

            }            
       }

     if( asubsref(sType,0) ==4)
     {
         //Observation
        
        float tempSum=0;
        F2D *Ovel;
        float OvelNorm;
        int i;


        asubsref(STDDEV_GPSPos, 0) = asubsref(sData, 6);
        asubsref(STDDEV_GPSPos, 4) = asubsref(sData,7);
        asubsref(STDDEV_GPSPos, 8) = 15;

        Opos = fDeepCopyRange(sData, 0, 1, 0, 3);
 
        //Initialize
         
        for(i=0; i<(pos->height*pos->width); i++)
            tempSum += asubsref(pos,i);

        if(tempSum == 0)
        {
            F2D *t, *t1;
            t = fMtimes( randW, STDDEV_GPSPos);
            t1 = fMtimes(ones, Opos);

            for(i=0; i<(pos->height*pos->width); i++)
                asubsref(pos,i) = asubsref(t,i) + asubsref(t1,i);

            fFreeHandle(t);
            fFreeHandle(t1);
        }
        else 
        {
            int rows, cols;
            int mnrows, mncols;

            rows = STDDEV_GPSPos->height;
            cols = STDDEV_GPSPos->width;

            temp_STDDEV_GPSPos = fSetArray(rows,cols,1);
            for( mnrows=0; mnrows<rows; mnrows++)
            {
                for( mncols=0; mncols<cols; mncols++)
                {
                    subsref(temp_STDDEV_GPSPos,mnrows,mncols) = pow(subsref(STDDEV_GPSPos,mnrows,mncols),-1);
                }
            }

            w = mcl(pos, Opos , temp_STDDEV_GPSPos);
            generateSample(w, quat, vel, pos);
        }
        fFreeHandle(Opos);

        //compare direction
        Ovel = fDeepCopyRange(sData, 0, 1, 3, 3);
        OvelNorm=2;//1.1169e+09;
    
        if (OvelNorm>0.5)
        {
            F2D *t;
            t = fDeepCopy(Ovel);
            fFreeHandle(Ovel);
            /* This is a double precision division */
            Ovel = fDivide(t, OvelNorm);
            qConj = quatConj(quat);
            fFreeHandle(t);
            
            {
                t = fSetArray(1,3,0);
                subsref(t,0,0) = 1;
                orgWorld = quatRot(t, qConj);
                fFreeHandle(t);
                fFreeHandle(qConj);
                t = fSetArray(3,3,0);
                asubsref(t,0) = 1;
                asubsref(t,4) = 1;
                asubsref(t,8) = 1;
               
                {
                    int i;
                    for(i=0; i<(t->height*t->width); i++)
                        asubsref(t, i) = asubsref(t,i)/STDDEV_GPSVel;
                    w = mcl( orgWorld, Ovel, t);
                    generateSample(w, quat, vel, pos);
                }

                fFreeHandle(t);
                fFreeHandle(w);
                fFreeHandle(orgWorld);
            }
        }
        fFreeHandle(Ovel);
    }
    
    if( asubsref(sType,0) ==1)
    {
        //Observation
        F2D *Ovel;
        F2D *t, *t1, *t2;
        float valVel;

        t = fSetArray(vel->height, 1, 0);

        for(i=0; i<vel->height; i++)
        {
            subsref(t,i,0) = sqrt(pow(subsref(vel,i,0),2) + pow(subsref(vel,i,1),2) + pow(subsref(vel,i,2),2));
        }

        Ovel = fSetArray(1, 1, asubsref(sData,0));
        valVel = 1.0/STDDEV_ODOVel;

        t1 = fSetArray(1,1,(1.0/STDDEV_ODOVel));
        w = mcl (t, Ovel, t1);
        generateSample(w, quat, vel, pos);

        
        fFreeHandle(w);
        fFreeHandle(t);
        fFreeHandle(t1);
        fFreeHandle(Ovel);
    }
    
    if( asubsref(sType,0) ==3)
    {
        //Observation
        F2D *t;
        t = fSetArray(1, 3, 0);
        asubsref(t,2) = -9.8;

        accl = fDeepCopyRange(sData, 0, 1, 0, 3);
        gtemp = fMtimes( ones, t); 
        gravity = quatRot(gtemp, quat);

        fFreeHandle(gtemp);
        fFreeHandle(t);
        t = fSetArray(3,3,0);
        asubsref(t,0) = 1;
        asubsref(t,4) = 1;
        asubsref(t,8) = 1;
        
        {                
            int i;
            for(i=0; i<(t->height*t->width); i++)
                asubsref(t,i) = asubsref(t,i)/STDDEV_ACCL;
            w = mcl( gravity, accl, t);
        }
        
        generateSample(w, quat, vel, pos);
        fFreeHandle(t);
        //Motion model
        t = fMtimes(ones, accl);
        fFreeHandle(accl);

        accl = fMinus(t, gravity);
        
        fFreeHandle(w);
        fFreeHandle(gravity);
        fFreeHandle(t);

        {
            //pos=pos+quatRot(vel,quatConj(quat))*acclTimeInterval+1/2*quatRot(accl,quatConj(quat))*acclTimeInterval^2+randn(n,3)*M_STDDEV_POS;            
            
            F2D *s, *is;
            int i;
            is = quatConj(quat);
            s = quatRot(vel, is);
            fFreeHandle(is);

            for(i=0; i<(s->height*s->width); i++)
            {
                asubsref(s,i) = asubsref(s,i)*acclTimeInterval;   //+(1/2);
            }
            is = fPlus(pos, s);
            fFreeHandle(pos);
            pos = fDeepCopy(is);
            fFreeHandle(is);
            fFreeHandle(s);

            /** pos_ above stores: pos+quatRot(vel,quatConj(quat))*acclTimeInterval **/
            
            is = quatConj(quat);
            s = quatRot(accl, is);
            t = fDeepCopy(s);
            for(i=0; i<(s->height*s->width); i++)
            {
                asubsref(t,i) = 1/2*asubsref(s,i)*acclTimeInterval*acclTimeInterval;
            }

            /** t_ above stores: 1/2*quatRot(accl,quatCong(quat))*acclTimeInterval^2 **/

            fFreeHandle(s);
            fFreeHandle(is);
            s = randnWrapper(n,3);

            for(i=0; i<(s->height*s->width); i++)
            {
                asubsref(s,i) = asubsref(s,i) * M_STDDEV_POS;
            }

            /** s_ above stores: randn(n,3)*M_STDDEV_POS **/

            is = fPlus(pos, t);
            fFreeHandle(pos);
            pos = fPlus(is, s);

            fFreeHandle(s);
            fFreeHandle(t);
            fFreeHandle(is);
        
//            vel=vel+accl*acclTimeInterval+randn(n,3)*M_STDDEV_VEL; %??
            
            t = fDeepCopy(accl);
            for(i=0; i<(accl->height*accl->width); i++)
                asubsref(t,i) = asubsref(accl,i) * acclTimeInterval;
            
            is = fPlus(vel, t);

            fFreeHandle(accl);
            fFreeHandle(t);
            s = randnWrapper(n,3);
            for(i=0; i<(s->height*s->width); i++)
            {
                asubsref(s,i) = asubsref(s,i) * M_STDDEV_VEL;
            }

            fFreeHandle(vel);
            vel = fPlus(is, s);
            fFreeHandle(is);
            fFreeHandle(s);
       }

    }

    /** Timing utils **/   
    endC = photonEndTiming();
    elt = photonReportTiming(start, endC);
    elapsed[0] += elt[0];
    elapsed[1] += elt[1];

    free(start);
    free(endC);
    free(elt);

        // Self check
        {
            F2D* temp;
            float quatOut=0, velOut=0, posOut=0;
            int i;

            for(i=0; i<(quat->height*quat->width); i++)
                quatOut += asubsref(quat, i);

            for(i=0; i<(vel->height*vel->width); i++)
                velOut += asubsref(vel, i);
            
            for(i=0; i<(pos->height*pos->width); i++)
                posOut += asubsref(pos, i);
            
            subsref(resultMat,0,icount) = quatOut;
            subsref(resultMat,1,icount) = velOut;
            subsref(resultMat,2,icount) = posOut;
        }

        fFreeHandle(sData);

    
        if (asubsref(isEOF,0) == 1)
           break;
    }

    printf("Input size\t\t- (%dx%dx%d)\n", rows, cols, n);
#ifdef CHECK   
    
    // Self checking - use expected.txt from data directory
    {
        int ret=0;
        float tol = 2.0;
#ifdef GENERATE_OUTPUT
        fWriteMatrix(resultMat, argv[1]);
#endif
        ret = fSelfCheck(resultMat, argv[1], tol);
        if (ret == -1)
            printf("Error in Localization\n");
    }
    // Self checking done
#endif

    photonPrintTiming(elapsed);
    fFreeHandle(STDDEV_GPSPos);
    free(elapsed);
    iFreeHandle(index);
    iFreeHandle(sType);
    iFreeHandle(isEOF);
    fFreeHandle(fid);
    fFreeHandle(resultMat);
    fFreeHandle(pos);
    fFreeHandle(vel);
    fFreeHandle(quat);
    fFreeHandle(ones);
    fFreeHandle(randW);
    
    return 0;

}



