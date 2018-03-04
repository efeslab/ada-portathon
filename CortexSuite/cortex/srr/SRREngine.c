#include "SRREngine.h"

//buffer for HR image :->
double ***f;

//double b [n/l][(l*l)]  = {0};
double b[x_dim][(l*l)] = {{0}};
double g [(l*l)]       = {0};
double gCap [(l*l)]    = {0};

//Regularization Matrix
double TikReg [(l*l)][(l*l)] = {{0}};
//Transpose of A00
double** A00T;


//MATRIX MULTIPLICATION ON l square RANGE
void MatMul (double** mat1, double mat2[], double result[])
{
	int i,j;
    for (i = 0; i< (l*l); i++)
    {
        for (j = 0; j <(l*l); j++)
        {
            result[i] += mat1[i][j] * mat2[j];
        }
    }
}

void MatMul_ (double** mat1, double** mat2, double result[(l*l)][(l*l)])
{
	int i, j, k;
    for(i = 0; i<(l*l); i++)
    {
        for(j = 0 ; j<(l*l); j++)
        {
            for(k = 0; k<(l*l); k++)
                result[i][j] += mat1[i][k]*mat2[k][j];
        }
    }
}

//MATRIX ADDITION ON l square RANGE
void MatAdd(double mat1[],double mat2[])
{
	int i;
    for(i = 0;i<(l*l);i++)
        mat1[i] += mat2[i];
}
//MATRIX SUBTRACTION ON l square RANGE
void MatSub(double mat1[],double mat2[], double res[])
{
	int i;
    for(i = 0;i<(l*l);i++)
        res[i] = mat1[i] - mat2[i];
}


void GaussSeidel(double** A1,double* X,double* Y)
{
	//double temp[(l*l)];
	//int flag = 0;
    int i,j;
    double A[(l*l)][(l*l)];
    for(i = 0;i<(l*l);i++)
	{
		for(j = 0;j<(l*l);j++)
        {
            A[i][j] = A1[i][j];
        }
    }

	for(i = 0;i<(l*l);i++)
	{
		Y[i] = Y[i]/A[i][i];
		for(j = 0;j<(l*l);j++)
			if(i!=j)
				A[i][j] = (double)A[i][j]/(double)A[i][i];

	}
	int cnt = 0;
    while(cnt < 1)				
	{
		cnt++;
        /*for(i = 0;i<(l*l);i++)
			temp[i] = X[i];*/

		for(i = 0;i<(l*l);i++)
		{
			X[i] = Y[i];
			for(j = 0;j<(l*l);j++)
				if(j!=i)
				X[i] = X[i]-A[i][j]*X[j];
		}

		/*for(i = 0;i<(l*l);i++)
        {
			if((int)temp[i] == (int)X[i])
				flag = 1;
			else
			{
				flag = 0;
				break;
			}
        }
        if(flag == 1) break;*/
        
	}
}

//THIS FUNCTION SOLVES THE LINEAR EQUATION (A00)*(f) = (b) ON l^2 RANGE ... 
void Gauss(int rn, int pn)/***/
{
    double mat[(l*l)];
	int i;
	//double res[(l*l)] = {0};
    for(i = 0;i<(l*l);i++)
        mat[i] = b[pn-1][i];
	//MatMul(A00T,mat,res);
    GaussSeidel(A00,f[rn][pn],mat);
}

void get_g(int rn,int pn)
{
	int i;
    if(rn<0 || pn<0 || rn>=y_dim ||pn>=x_dim)
    {
        for(i = 0; i<(l*l); i++)
            g[i] = 0;
    }
    else
    {
		for (i = 0; i < l*l; i++)
		{
			int temp_pn = 0;
			int temp_rn = 0;
			//if(abs(mv[i].x) > (double)1.0) pn -= floor(mv[i].x);
			if (mv[i].x >(double)1.0) temp_pn = pn - floor(mv[i].x);
			else if (mv[i].x <(double)-1.0) temp_pn = pn + abs(floor(mv[i].x)) - 1;
			else temp_pn = pn;
			//if(abs(mv[i].y) > (double)1.0) rn -= floor(mv[i].y);
			if (mv[i].y >(double)1.0) temp_rn = rn - floor(mv[i].x);
			else if (mv[i].y < (double)-1.0) temp_rn = rn + abs(floor(mv[i].x)) - 1;
			else temp_rn = rn;
			//if (rn < 0 || pn < 0 || rn >= n / l || pn >= n / l) g[i] = 0;
			if (temp_rn < 0) temp_rn = 0;
			if (temp_pn < 0) temp_pn = 0;
			if (temp_rn >= y_dim) temp_rn = y_dim - 1;
			if (temp_pn >= x_dim) temp_pn = x_dim - 1;
			g[i] = LR[i][temp_rn][temp_pn];
		}
    }
}

void flush_b()
{
	int i,j;
    for(j = 0;j<x_dim;j++)
        for(i = 0;i<l*l;i++)
            b[j][i] = 0;
}

void flush_arr(double temp[])
{
	int i;
	for(i = 0;i < l*l;i++)
		temp[i] = 0.0;
}

void get_b(int rn)
{
	int i,j;
    double temp1[l*l] = {0},temp2[l*l] = {0};
    flush_b();
	for (i = 1 ; i <= x_dim ; i++)
    {
        
        get_g(rn-2,i-2);
        MatMul(AT11,g,temp1);
        
        get_g(rn-1,i-2);
        MatMul(AT10,g,temp2);
        MatAdd(temp1,temp2);
        flush_arr(temp2);
        
        get_g(rn,i-2);
        MatMul(AT1bar1,g,temp2);
        MatAdd(temp1,temp2);
        flush_arr(temp2);
        
        get_g(rn-2,i-1);
        MatMul(AT01,g,temp2);
        MatAdd(temp1,temp2);
        flush_arr(temp2);

        get_g(rn-1,i-1);
        MatMul(AT00,g,temp2);
        MatAdd(temp1,temp2);
        flush_arr(temp2);

        get_g(rn,i-1);
        MatMul(AT0bar1,g,temp2);
        MatAdd(temp1,temp2);
        flush_arr(temp2);

        get_g(rn-2,i);
        MatMul(ATbar11,g,temp2);
        MatAdd(temp1,temp2);
        flush_arr(temp2);

        get_g(rn-1,i);
        MatMul(ATbar10,g,temp2);
        MatAdd(temp1,temp2);
        flush_arr(temp2);

        get_g(rn,i);
        MatMul(ATbar1bar1,g,temp2);
        MatAdd(temp1,temp2);
        flush_arr(temp2);

        for(j = 0;j<(l*l);j++)
            gCap[j] = temp1[j];
        flush_arr(temp1);
        
        MatMul(Abar11,f[rn+1][i-1],temp1);
        MatMul(A01,f[rn+1][i],temp2);
        MatAdd(temp1,temp2);
        flush_arr(temp2);
        MatMul(A11,f[rn+1][i+1],temp2);
        MatAdd(temp1,temp2);
        MatSub(gCap,temp1,b[i-1]);
        flush_arr(temp1);
        flush_arr(temp2);

        MatMul(Abar1bar1,f[rn-1][i-1],temp1);
        MatMul(A0bar1,f[rn-1][i],temp2);
        MatAdd(temp1,temp2);
        flush_arr(temp2);
        MatMul(A1bar1,f[rn-1][i+1],temp2);
        MatAdd(temp1,temp2);
        //flush_arr(temp2);
        MatSub(b[i-1],temp1,b[i-1]);
        
        flush_arr(temp1);
		flush_arr(temp2);
        
    }
}

void modify_b(int rn, int pn)
{
    double temp1[l*l] = {0};
    double temp2[l*l] = {0};

    MatMul(Abar10,f[rn][pn-1],temp1);
    MatMul(A10,f[rn][pn+1],temp2);
    MatAdd(temp1,temp2);
    MatSub(b[pn-1],temp1,b[pn-1]);
}

void solve_pixel(int rn, int pn)
{
    modify_b(rn,pn);
    /*if(rn == 1 && pn == 1)
    {
        for(int i =0; i<(l*l); i++)
            printf("%lf     ",b[pn-1][i]);
        getch();
    }*/
    //Solve for A00f = b;
    //GaussSeidel(A00,f[rn][pn],b[pn-1]);
    Gauss(rn,pn);
}

void solve_row(int rn)
{
    get_b(rn);
	int i;
    for (i = 1; i<=x_dim ; i+=2)
    {
        solve_pixel(rn,i);
    }
    for (i = 2; i<=x_dim ; i+=2)
    {
        solve_pixel(rn,i);
    }
    flush_b();
}

HRESULT SRREngine123()
{
	HRESULT hr = SUCCESS;
	
	//int flag = 0;
	int count = 0;
	//double Res[(l*l)][(l*l)] = {0};
    
    //Allocate memory to temp array ...
    /*double ***temp = (double ***) calloc((n/l)+2,sizeof(double**));
    for(int i = 0; i<(n/l)+2; i++)
    {
        temp[i] = (double **) calloc((n/l)+2, sizeof(double*));
    }

    for(int i = 0;i<(n/l)+2; i++)
    {
        for(int j = 0;j<(n/l)+2; j++)
        {
            temp[i][j] = (double *) calloc((l*l),sizeof(double));
        }
    }*/
    
	int i, j;
        
    //Regularization Term
    for(i = 0; i<(l*l); i++)
    {
        for(j = 0; j<(l*l); j++)
        {
            if(i == j) TikReg[i][j] = ALPHA;
            //A00T[j][i] = A00[i][j];
        }
    }

    //MatMul_(A00T,A00,Res);

	//New A00 with Added Regularization Factor ...
    for(i = 0;i<l*l;i++)
		for(j = 0;j<l*l;j++)
			A00[i][j] += TikReg[i][j];
	
    while(count<(l*l*l*l))//count<100
    {
        //flag =0;
           
        //Copy f to temp
        /*for(int i = 0; i<n/l+2; i++)
          for(int j = 0; j<n/l+2; j++)
              for(int k = 0; k<(l*l); k++)
                  temp[i][j][k] = f[i][j][k];*/
                        
        for (i = 1; i <= y_dim; i+=2)
        {
            solve_row(i);
        }
        for (i = 2; i <= y_dim; i+=2)
        {
            solve_row(i);
        }
        
        //Check if Temp is Equal to f
        /*for(int i = 0; i<n/l+2; i++)
        {
            for(int j = 0; j<n/l+2; j++)
            {
                for(int k = 0; k<l*l; k++)
                {
                    if((int)temp[i][j][k] != (int)f[i][j][k])
                    {
                        flag =1;
                        //printf("\n\n%d, %d\n",i,j);
                        //printf("\n%f  =  %f\n\n", temp[i][j][k], f[i][j][k]);
                        //getch();
                        break;
                    }
                }
                if(flag == 1) break;
            }
            if(flag == 1) break;
        }
        if(flag == 0) break;*/
		count++;
   }
   
   //Free Temp memory ...
   /*for(int i = 0;i<(n/l)+2; i++)
   {
       for(int j = 0;j<(n/l)+2; j++)
       {
           free(temp[i][j]);
       }
   }
   for(int i = 0; i<(n/l)+2; i++)
   {
       free(temp[i]);
   }
    
   free(temp);*/
   return hr;
}
