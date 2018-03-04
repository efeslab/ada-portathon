#include "SystemMatrices.h"

double** A00;
double** A10;
double** A01;
double** A11;
double** Abar10;
double** A0bar1;
double** A1bar1;
double** Abar11;
double** Abar1bar1;

double** AT00;
double** AT10;
double** AT01;
double** AT11;
double** ATbar10;
double** AT0bar1;
double** AT1bar1;
double** ATbar11;
double** ATbar1bar1;


double BT00[(l*l)][(l*l)]       = {{0}};
double BT10[(l*l)][(l*l)]       = {{0}};
double BT01[(l*l)][(l*l)]       = {{0}};
double BT11[(l*l)][(l*l)]       = {{0}};
double BTbar10[(l*l)][(l*l)]    = {{0}};
double BT0bar1[(l*l)][(l*l)]    = {{0}};
double BT1bar1[(l*l)][(l*l)]    = {{0}};
double BTbar11[(l*l)][(l*l)]    = {{0}};
double BTbar1bar1[(l*l)][(l*l)] = {{0}};


double S00[(l*l)][(l*l)] = {{0}};
double S01[(l*l)][(l*l)] = {{0}};
double S10[(l*l)][(l*l)] = {{0}};
double S11[(l*l)][(l*l)] = {{0}};

double S00T[(l*l)][(l*l)] = {{0}};
double S01T[(l*l)][(l*l)] = {{0}};
double S10T[(l*l)][(l*l)] = {{0}};
double S11T[(l*l)][(l*l)] = {{0}};


double D1[(l*l)][(l*l)] = {{0}};
double D[(l*l)] = {0};
//double D[(l*l)][(l*l)] = {0};


void flushShift()
{
	int i,j;
    for(i = 0;i<l*l;i++)
    {
        for(j = 0;j<l*l;j++)
        {
            S00[i][j] = 0.0;
            S10[i][j] = 0.0;
            S01[i][j] = 0.0;
            S11[i][j] = 0.0;
        }
    }
}

void MatMul1 (double mat1[][(l*l)], double mat2[][(l*l)], double result[][(l*l)])
{
	int i,j,k;
    for (i = 0; i< (l*l); i++)
    {
        for (j = 0; j <(l*l); j++)
        {
            result[i][j] = 0;
            for(k = 0; k<(l*l); k++)
                result[i][j] += mat1[i][k] * mat2[k][j];
            //result[i] += mat2[j]*mat1[i][j];
        }
    }
}

//matrix multiplication function ..
void MatMul1_ (double mat1[][(l*l)], double mat2[], double result[])
{
	int i, j;
    for (i = 0; i< (l*l); i++)
    {
        result[i] = 0;
        for (j = 0; j <(l*l); j++)
        {
            result[i] += mat1[j][i] * mat2[j];
        }
    }
}

int calc(int i,int j)
{
    int k;
    if(j<0) k = ((-j/l + 1)*l+j)%l;
    else k = j%l;
    //return(i*l + floor((double)j/l)*n*l + k);
	return(i*l + floor((double)j / l)*(x_dim*l)*l + k);
}

void CalcShiftMat(double x, double y)
{
    double dx,dy;
	if (x >= 0)
		x = x - floor(x);
	else
		x = x + floor(abs(x));
	if (y >= 0)
		y = y - floor(y);
	else
		y = y + floor(abs(y));
	//y = y - floor(y);
    
    dx = x * l;
    dy = y * l;

    double dxCap, dyCap;
    dxCap = floor(dx);
    dyCap = floor(dy);

    double dxBar, dyBar;
    dxBar = dx - dxCap;
    dyBar = dy - dyCap;

    double w1,w2,w3,w4;
    w1 = (1-dxBar)*(1-dyBar);
    w2 = dxBar * (1-dyBar);
    w3 = (1-dxBar) * dyBar;
    w4 = dxBar * dyBar;

    int i, j, k = 0;
    for(i = 0;i<l;i++)
    {
        for(j = 0;j<l;j++)
        {
            int pij = 0;
			
			pij	= calc(i+dyCap,j+dxCap);
            
            if(pij<-x_dim*l*l)            {S00[k][pij+x_dim*l*l+l*l] = w1;} //lower lower
			else if (pij < -x_dim*l*l + l*l)
            {   
				if (y < 0){ S01[k][pij + x_dim*l*l] = w1; }
				else    { S00[k][pij + x_dim*l*l] = w1; }                            //lower upper or lower lower
            }
			else if (pij < -x_dim*l*l + 2 * l*l) { S01[k][pij + x_dim*l*l - l*l] = w1; }       //lower upper
            else if(pij<0)
            {   
                if(x<0) {S10[k][pij+l*l] = w1;}
                else    {S00[k][pij+l*l] = w1;}//upper lower or lower lower
            }
            else if(pij<l*l)
            {
                if(x<0 && y<0)          {S11[k][pij] = w1;}               //Can be all four
                else if(x<0 && y>=0)    {S10[k][pij] = w1;}
                else if(x>=0 && y<0)    {S01[k][pij] = w1;}
                else                    {S00[k][pij] = w1;}
            }
            else if(pij<2*l*l)
            {
                if(x<0){S11[k][pij-l*l] = w1;}           //lower upper or upper upper
                else   {S01[k][pij-l*l] = w1;}
            }
			else if (pij < x_dim*l*l)        { S10[k][pij - x_dim*l*l + l*l] = w1; }    //upper lower
			else if (pij < (x_dim*l*l + l*l))
            {
				if (y < 0) { S11[k][pij - x_dim*l*l] = w1; }
				else    { S10[k][pij - x_dim*l*l] = w1; }             //upper lower or upper upper
            }           
			else if (pij < (x_dim*l*l + 2 * l*l)){ S11[k][pij - (x_dim*l*l + l*l)] = w1; }     //upper upper
            //Inversed ...
/***/            pij = calc(i+dyCap+1,j+dxCap);
				//pij = calc(i + dyCap, j + dxCap + 1);

			if (pij < -x_dim*l*l)            { S00[k][pij + x_dim*l*l + l*l] = w2; } //lower lower
			else if (pij < -x_dim*l*l + l*l)
            {   
				if (y < 0){ S01[k][pij + x_dim*l*l] = w2; }
				else    { S00[k][pij + x_dim*l*l] = w2; }                            //lower upper or lower lower
            }
			else if (pij < -x_dim*l*l + 2 * l*l) { S01[k][pij + x_dim*l*l - l*l] = w2; }       //lower upper
            else if(pij<0)
            {   
                if(x<0) {S10[k][pij+l*l] = w2;}
                else    {S00[k][pij+l*l] = w2;}//upper lower or lower lower
            }
            else if(pij<l*l)
            {
                if(x<0 && y<0)          {S11[k][pij] = w2;}               //Can be all four
                else if(x<0 && y>=0)    {S10[k][pij] = w2;}
                else if(x>=0 && y<0)    {S01[k][pij] = w2;}
                else                    {S00[k][pij] = w2;}
            }
            else if(pij<2*l*l)
            {
                if(x<0){S11[k][pij-l*l] = w2;}           //lower upper or upper upper
                else   {S01[k][pij-l*l] = w2;}
            }
			else if (pij < x_dim*l*l)        { S10[k][pij - x_dim*l*l + l*l] = w2; }    //upper lower
			else if (pij < (x_dim*l*l + l*l))
            {
				if (y < 0) { S11[k][pij - x_dim*l*l] = w2; }
				else    { S10[k][pij - x_dim*l*l] = w2; }             //upper lower or upper upper
            }           
			else if (pij < (x_dim*l*l + 2 * l*l)){ S11[k][pij - (x_dim*l*l + l*l)] = w2; }     //upper upper
                        
/***/            pij = calc(i+dyCap,j+dxCap+1);
				//pij = calc(i + dyCap + 1, j + dxCap);

			if (pij < -x_dim*l*l)            { S00[k][pij + x_dim*l*l + l*l] = w3; } //lower lower
			else if (pij < -x_dim*l*l + l*l)
            {   
				if (y < 0){ S01[k][pij + x_dim*l*l] = w3; }
				else    { S00[k][pij + x_dim*l*l] = w3; }                            //lower upper or lower lower
            }
			else if (pij < -x_dim*l*l + 2 * l*l) { S01[k][pij + x_dim*l*l - l*l] = w3; }       //lower upper
            else if(pij<0)
            {   
                if(x<0) {S10[k][pij+l*l] = w3;}
                else    {S00[k][pij+l*l] = w3;}//upper lower or lower lower
            }
            else if(pij<l*l)
            {
                if(x<0 && y<0)          {S11[k][pij] = w3;}               //Can be all four
                else if(x<0 && y>=0)    {S10[k][pij] = w3;}
                else if(x>=0 && y<0)    {S01[k][pij] = w3;}
                else                    {S00[k][pij] = w3;}
            }
            else if(pij<2*l*l)
            {
                if(x<0){S11[k][pij-l*l] = w3;}           //lower upper or upper upper
                else   {S01[k][pij-l*l] = w3;}
            }
			else if (pij < x_dim*l*l)        { S10[k][pij - x_dim*l*l + l*l] = w3; }    //upper lower
			else if (pij < (x_dim*l*l + l*l))
            {
				if (y < 0) { S11[k][pij - x_dim*l*l] = w3; }
				else    { S10[k][pij - x_dim*l*l] = w3; }             //upper lower or upper upper
            }           
			else if (pij < (x_dim*l*l + 2 * l*l)){ S11[k][pij - (x_dim*l*l + l*l)] = w3; }     //upper upper
            
            pij = calc(i+dyCap+1,j+dxCap+1);

			if (pij < -x_dim*l*l)            { S00[k][pij + x_dim*l*l + l*l] = w4; } //lower lower
			else if (pij < -x_dim*l*l + l*l)
            {   
				if (y < 0){ S01[k][pij + x_dim*l*l] = w4; }
				else    { S00[k][pij + x_dim*l*l] = w4; }                            //lower upper or lower lower
            }
			else if (pij < -x_dim*l*l + 2 * l*l) { S01[k][pij + x_dim*l*l - l*l] = w4; }       //lower upper
            else if(pij<0)
            {   
                if(x<0) {S10[k][pij+l*l] = w4;}
                else    {S00[k][pij+l*l] = w4;}//upper lower or lower lower
            }
            else if(pij<l*l)
            {
                if(x<0 && y<0)          {S11[k][pij] = w4;}               //Can be all four
                else if(x<0 && y>=0)    {S10[k][pij] = w4;}
                else if(x>=0 && y<0)    {S01[k][pij] = w4;}
                else                    {S00[k][pij] = w4;}
            }
            else if(pij<2*l*l)
            {
                if(x<0){S11[k][pij-l*l] = w4;}           //lower upper or upper upper
                else   {S01[k][pij-l*l] = w4;}
            }
			else if (pij < x_dim*l*l)        { S10[k][pij - x_dim*l*l + l*l] = w4; }    //upper lower
			else if (pij < (x_dim*l*l + l*l))
            {
				if (y < 0) { S11[k][pij - x_dim*l*l] = w4; }
				else    { S10[k][pij - x_dim*l*l] = w4; }             //upper lower or upper upper
            }           
			else if (pij < (x_dim*l*l + 2 * l*l)){ S11[k][pij - (x_dim*l*l + l*l)] = w4; }     //upper upper
            
            k++;
        }
    }
    
}

HRESULT CalculateA()
{
	HRESULT hr = SUCCESS;

	int i,j,k;
	for(i = 0;i<l*l;i++)
    {
		for (j = 0; j < l*l; j++)
		{
			D1[i][j] = (double)1 / (l*l*l);
			//D[i][j] = (double)1 / (l*l);
		}
        //D1[i][j] =(double)1/(l*l*l);					//seems incorrect to me
        D[i] = (double)1/(l*l);
    }

    for(k = 0;k<l*l;k++)
    {
        //get New x and y
        CalcShiftMat(mv[k].x,mv[k].y);
        
        //Calculate Transpose of all S
        for(i = 0;i<(l*l);i++)
        {
            for(j = 0;j<(l*l);j++)
            {
                S00T[i][j] = S00[j][i];
                S01T[i][j] = S01[j][i];
                S10T[i][j] = S10[j][i];
                S11T[i][j] = S11[j][i];
            }
        }
               
        // Calculate 16 shift-transpose matrices
        double temp[(l*l)][(l*l)] = {{0}};
        double temp1[(l*l)][(l*l)] = {{0}};
        double temp2[(l*l)][(l*l)] = {{0}};
        double temp3[(l*l)][(l*l)] = {{0}};
        double temp4[(l*l)][(l*l)] = {{0}};


        MatMul1(D1,S00,temp);
        MatMul1(S00T,temp,temp1);
        MatMul1(D1,S11,temp);
        MatMul1(S11T,temp,temp2);
        MatMul1(D1,S10,temp);
        MatMul1(S10T,temp,temp3);
        MatMul1(D1,S01,temp);
        MatMul1(S01T,temp,temp4);
        //Assign these to A00
        for(i = 0;i<(l*l);i++)
        {
            for(j = 0;j<(l*l);j++)
               A00[i][j]     += temp1[i][j] + temp2[i][j] + temp3[i][j] + temp4[i][j];
        }

        /*for(int i = 0;i<(l*l); i++)
        {
            for(int j = 0; j<(l*l); j++)
                printf("%f    ", temp2[i][j]);
            printf("\n");
        }
        printf("\n\n\n\n");*/

        MatMul1(D1,S01,temp);
        MatMul1(S00T,temp,temp1);
        MatMul1(D1,S11,temp);
        MatMul1(S10T,temp,temp2);
        MatMul1(D1,S00,temp);
        MatMul1(S01T,temp,temp3);
        MatMul1(D1,S10,temp);
        MatMul1(S11T,temp,temp4);
        //Assign these to A01 and A0bar1
        for(i = 0;i<(l*l);i++)
        {
            for(j = 0;j<(l*l);j++)
            {
               A01[i][j]     += temp1[i][j] + temp2[i][j];
               A0bar1[i][j]  += temp3[i][j] + temp4[i][j];
            }
        }
        
        MatMul1(D1,S10,temp);
        MatMul1(S00T,temp,temp1);
        MatMul1(D1,S11,temp);
        MatMul1(S01T,temp,temp2);
        MatMul1(D1,S01,temp);
        MatMul1(S11T,temp,temp3);
        MatMul1(D1,S00,temp);
        MatMul1(S10T,temp,temp4);
        //Assign these to A10 and Abar10
        for(i = 0;i<(l*l);i++)
        {
            for(j = 0;j<(l*l);j++)
            {
               A10[i][j]     += temp1[i][j] + temp2[i][j];
               Abar10[i][j]  += temp3[i][j] + temp4[i][j];
            }
        }
        
        MatMul1(D1,S11,temp);
        MatMul1(S00T,temp,temp1);
        MatMul1(D1,S01,temp);
        MatMul1(S10T,temp,temp2);
        MatMul1(D1,S10,temp);
        MatMul1(S01T,temp,temp3);
        MatMul1(D1,S00,temp);
        MatMul1(S11T,temp,temp4);
        //Assign these to A11 and Abar11 and A1bar1 and Abar1bar1
        for(i = 0;i<(l*l);i++)
        {
            for(j = 0;j<(l*l);j++)
            {
               A11[i][j]     += temp1[i][j];
               Abar11[i][j]  += temp2[i][j];
               A1bar1[i][j]  += temp3[i][j];
               Abar1bar1[i][j] += temp4[i][j];
            }
        }

        //Creating AT matrices
        
        if(mv[k].x<0 && mv[k].y<0)
        {
            MatMul1_(S00,D,BTbar1bar1[k]);
            MatMul1_(S01,D,BTbar10[k]);
            MatMul1_(S10,D,BT0bar1[k]);
            MatMul1_(S11,D,BT00[k]);

			/*MatMul1(D, S00, BTbar1bar1);
			MatMul1(D, S01, BTbar10);
			MatMul1(D, S10, BT0bar1);
			MatMul1(D, S11, BT00);*/

        }
        else if(mv[k].x<0 && mv[k].y>=0)
        {
            MatMul1_(S00,D,BTbar10[k]);
            MatMul1_(S01,D,BTbar11[k]);
            MatMul1_(S10,D,BT00[k]);
            MatMul1_(S11,D,BT01[k]);

			/*MatMul1(D, S00, BTbar10);
			MatMul1(D, S01, BTbar11);
			MatMul1(D, S10, BT00);
			MatMul1(D, S11, BT01);*/
        }
        else if(mv[k].x>=0 && mv[k].y<0)
        {
            MatMul1_(S00,D,BT0bar1[k]);
            MatMul1_(S01,D,BT00[k]);
            MatMul1_(S10,D,BT1bar1[k]);
            MatMul1_(S11,D,BT10[k]);

			/*MatMul1(D, S00, BT0bar1);
			MatMul1(D, S01, BT00);
			MatMul1(D, S10, BT1bar1);
			MatMul1(D, S11, BT10);*/
        }
        else
        {
            MatMul1_(S00,D,BT00[k]);
            MatMul1_(S01,D,BT01[k]);
            MatMul1_(S10,D,BT10[k]);
            MatMul1_(S11,D,BT11[k]);

			/*MatMul1(D, S00, BT00);
			MatMul1(D, S01, BT01);
			MatMul1(D, S10, BT10);
			MatMul1(D, S11, BT11);*/
        }
        //Transpose
        for(i = 0;i<(l*l);i++)
        {
            for(j = 0;j<(l*l);j++)
            {
                AT00[i][j]        =BT00[j][i];
                AT10[i][j]        =BT10[j][i];
                AT01[i][j]        =BT01[j][i];
                AT11[i][j]        =BT11[j][i];
                ATbar10[i][j]     =BTbar10[j][i];
                AT0bar1[i][j]     =BT0bar1[j][i];
                AT1bar1[i][j]     =BT1bar1[j][i];
                ATbar11[i][j]     =BTbar11[j][i];
                ATbar1bar1[i][j]  =BTbar1bar1[j][i];  

				/*AT00[i][j] += BT00[j][i];
				AT10[i][j] += BT10[j][i];
				AT01[i][j] += BT01[j][i];
				AT11[i][j] += BT11[j][i];
				ATbar10[i][j] += BTbar10[j][i];
				AT0bar1[i][j] += BT0bar1[j][i];
				AT1bar1[i][j] += BT1bar1[j][i];
				ATbar11[i][j] += BTbar11[j][i];
				ATbar1bar1[i][j] += BTbar1bar1[j][i];*/
            }
        }
        
        flushShift();
    }
	return hr;
}