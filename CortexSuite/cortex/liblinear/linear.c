#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <locale.h>
#include "linear.h"
#include "tron.h"
typedef signed char schar;
//swap();
//#ifndef min
//static float min(float x,float y) { return (x<y)?x:y; }//remove template
//#endif
//#ifndef max
//static float max(float x,float y) { return (x>y)?x:y; }//remove inline and template
//#endif
//static void clone(float*& dst, float* src, int n)//remove inline and template; dst and src may be different
//{
//	dst = (float*)malloc(n*sizeof(float));//new replaced by malloc
//	memcpy((void *)dst,(void *)src,sizeof(float)*n);
//}
#define Malloc(type,n) (type *)malloc((n)*sizeof(type))
#define INF HUGE_VAL

static void print_string_stdout(const char *s)
{
	fputs(s,stdout);
	fflush(stdout);
}

static void (*liblinear_print_string) (const char *) = &print_string_stdout;

#if 1
static void info(const char *fmt,...)
{
	char buf[BUFSIZ];
	va_list ap;
	va_start(ap,fmt);
	vsprintf(buf,fmt,ap);
	va_end(ap);
	(*liblinear_print_string)(buf);
}
#else
static void info(const char *fmt,...) {}
#endif


void l2r_lr_fun_constructor(struct tagl2r_lr_fun *this, const struct problem *prob, double *C)//constructor
{
	int l = prob->l;
	this->prob = prob;

	this->z = (double *)malloc(l*sizeof(double));
	this->D = (double *)malloc(l*sizeof(double));
	this->C = C;
}

void l2r_lr_fun_destructor(struct tagl2r_lr_fun *this)//destructor
{
	free(this->z);
	free(this->D);
}

double l2r_lr_fun_fun(struct tagl2r_lr_fun *this, double *w)
{
	int i;
	double f=0;
	double *y=this->prob->y;
	int l=this->prob->l;
	int w_size=this->get_nr_variable(this);

	this->Xv(this, w, this->z);

	for(i=0;i<w_size;i++)
		f += w[i]*w[i];
	f /= 2.0;
	for(i=0;i<l;i++)
	{
		double yz = y[i]*this->z[i];
		if (yz >= 0)
			f += this->C[i]*log(1 + exp(-yz));
		else
			f += this->C[i]*(-yz+log(1 + exp(yz)));
	}

	return(f);
}

void l2r_lr_fun_grad(struct tagl2r_lr_fun *this, double *w, double *g)
{
	int i;
	double *y=this->prob->y;
	int l=this->prob->l;
	int w_size=this->get_nr_variable(this);

	for(i=0;i<l;i++)
	{
		this->z[i] = 1/(1 + exp(-y[i]*this->z[i]));
		this->D[i] = this->z[i]*(1-this->z[i]);
		this->z[i] = this->C[i]*(this->z[i]-1)*y[i];
	}
	this->XTv(this, this->z, g);

	for(i=0;i<w_size;i++)
		g[i] = w[i] + g[i];
}

int l2r_lr_fun_get_nr_variable(struct tagl2r_lr_fun *this)
{
	return this->prob->n;
}

void l2r_lr_fun_Hv(struct tagl2r_lr_fun *this, double *s, double *Hs)
{
	int i;
	int l=this->prob->l;
	int w_size=this->get_nr_variable(this);
	double *wa = (double*)malloc(l*sizeof(double));
	double *C = this->C;
	double *D = this->D;

	this->Xv(this, s, wa);
	for(i=0;i<l;i++)
		wa[i] = C[i]*D[i]*wa[i];

	this->XTv(this, wa, Hs);
	for(i=0;i<w_size;i++)
		Hs[i] = s[i] + Hs[i];
	free(wa);
}

void l2r_lr_fun_Xv(struct tagl2r_lr_fun *this, double *v, double *Xv)
{
	int i;
	int l=this->prob->l;
	struct feature_node **x=this->prob->x;

	for(i=0;i<l;i++)
	{
		struct feature_node *s=x[i];
		Xv[i]=0;
		while(s->index!=-1)
		{
			Xv[i]+=v[s->index-1]*s->value;
			s++;
		}
	}
}

void l2r_lr_fun_XTv(struct tagl2r_lr_fun *this, double *v, double *XTv)
{
	int i;
	int l=this->prob->l;
	int w_size=this->get_nr_variable(this);
	struct feature_node **x=this->prob->x;

	for(i=0;i<w_size;i++)
		XTv[i]=0;
	for(i=0;i<l;i++)
	{
		struct feature_node *s=x[i];
		while(s->index!=-1)
		{
			XTv[s->index-1]+=v[i]*s->value;
			s++;
		}
	}
}

void l2r_lr_fun_initialise(struct tagl2r_lr_fun *this)//initialise the function pointers in the struct
{
	this->constructor = &l2r_lr_fun_constructor;
	this->destructor = &l2r_lr_fun_destructor;

	this->fun = &l2r_lr_fun_fun;
	this->grad = &l2r_lr_fun_grad;
	this->Hv = &l2r_lr_fun_Hv;
	this->get_nr_variable = &l2r_lr_fun_get_nr_variable;

	this->Xv = &l2r_lr_fun_Xv;
	this->XTv = &l2r_lr_fun_XTv;
}








void l2r_l2_svc_fun_constructor(struct tagl2r_l2_svc_fun *this, const struct problem *prob, double *C)
{
	int l=prob->l;

	this->prob = prob;

	this->z = (double*)malloc(l*sizeof(double));
	this->D = (double*)malloc(l*sizeof(double));
	this->I = (int*)malloc(l*sizeof(int));
	this->C = C;
}

void l2r_l2_svc_fun_destructor(struct tagl2r_l2_svc_fun *this)
{
	free(this->z);
	free(this->D);
	free(this->I);
}

double l2r_l2_svc_fun_fun(struct tagl2r_l2_svc_fun *this, double *w)
{
	int i;
	double f=0;
	double *y=this->prob->y;
	int l=this->prob->l;
	int w_size=this->get_nr_variable(this);
	double *z = this->z;

	this->Xv(this, w, z);

	for(i=0;i<w_size;i++)
		f += w[i]*w[i];
	f /= 2.0;
	for(i=0;i<l;i++)
	{
		double d;
		this->z[i] = y[i]*this->z[i];
		d = 1-this->z[i];
		if (d > 0)
			f += this->C[i]*d*d;
	}

	return(f);
}

void l2r_l2_svc_fun_grad(struct tagl2r_l2_svc_fun *this, double *w, double *g)
{
	int i;
	double *y=this->prob->y;
	int l=this->prob->l;
	int w_size=this->get_nr_variable(this);
	double *C = this->C;

	this->sizeI = 0;
	for (i=0;i<l;i++)
		if (this->z[i] < 1)
		{
			this->z[this->sizeI] = C[i]*y[i]*(this->z[i]-1);
			this->I[this->sizeI] = i;
			this->sizeI++;
		}
	this->subXTv(this, this->z, g);

	for(i=0;i<w_size;i++)
		g[i] = w[i] + 2*g[i];
}

int l2r_l2_svc_fun_get_nr_variable(struct tagl2r_l2_svc_fun *this)
{
	return this->prob->n;
}

void l2r_l2_svc_fun_Hv(struct tagl2r_l2_svc_fun *this, double *s, double *Hs)
{
	int i;
	int w_size=this->get_nr_variable(this);
	double *wa = (double*)malloc(this->sizeI*sizeof(double));
	int *I = this->I;

	this->subXv(this, s, wa);
	for(i=0;i<this->sizeI;i++)
		wa[i] = this->C[I[i]]*wa[i];

	this->subXTv(this, wa, Hs);
	for(i=0;i<w_size;i++)
		Hs[i] = s[i] + 2*Hs[i];
	free(wa);
}

void l2r_l2_svc_fun_Xv(struct tagl2r_l2_svc_fun *this, double *v, double *Xv)
{
	int i;
	int l=this->prob->l;
	struct feature_node **x=this->prob->x;

	for(i=0;i<l;i++)
	{
		struct feature_node *s=x[i];
		Xv[i]=0;
		while(s->index!=-1)
		{
			Xv[i]+=v[s->index-1]*s->value;
			s++;
		}
	}
}

void l2r_l2_svc_fun_subXv(struct tagl2r_l2_svc_fun *this, double *v, double *Xv)
{
	int i;
	struct feature_node **x=this->prob->x;
	int *I = this->I;

	for(i=0;i<this->sizeI;i++)
	{
		struct feature_node *s=x[I[i]];
		Xv[i]=0;
		while(s->index!=-1)
		{
			Xv[i]+=v[s->index-1]*s->value;
			s++;
		}
	}
}

void l2r_l2_svc_fun_subXTv(struct tagl2r_l2_svc_fun *this, double *v, double *XTv)
{
	int i;
	int w_size=this->get_nr_variable(this);
	struct feature_node **x=this->prob->x;
	int *I = this->I;

	for(i=0;i<w_size;i++)
		XTv[i]=0;
	for(i=0;i<this->sizeI;i++)
	{
		struct feature_node *s=x[I[i]];
		while(s->index!=-1)
		{
			XTv[s->index-1]+=v[i]*s->value;
			s++;
		}
	}
}

void l2r_l2_svc_fun_initialise(struct tagl2r_l2_svc_fun *this)//initialise the function pointers in the struct
{
	this->constructor = &l2r_l2_svc_fun_constructor;
	this->destructor = &l2r_l2_svc_fun_destructor;

	this->fun = &l2r_l2_svc_fun_fun;
	this->grad = &l2r_l2_svc_fun_grad;
	this->Hv = &l2r_l2_svc_fun_Hv;
	this->get_nr_variable = &l2r_l2_svc_fun_get_nr_variable;

	this->Xv = &l2r_l2_svc_fun_Xv;
	this->subXv = &l2r_l2_svc_fun_subXv;
	this->subXTv = &l2r_l2_svc_fun_subXTv;
}










void l2r_l2_svr_fun_constructor(struct tagl2r_l2_svr_fun *this, const struct problem *prob, double *C, double p)
{
	int l=prob->l;

	this->prob = prob;

	this->z = (double*)malloc(l*sizeof(double));
	this->D = (double*)malloc(l*sizeof(double));
	this->I = (int*)malloc(l*sizeof(int));
	this->C = C;
	this->p = p;
}

double l2r_l2_svr_fun_fun(struct tagl2r_l2_svr_fun *this, double *w)
{
	int i;
	double f=0;
	double *y=this->prob->y;
	int l=this->prob->l;
	int w_size=this->get_nr_variable(this);
	double d;

	this->Xv(this, w, this->z);

	for(i=0;i<w_size;i++)
		f += w[i]*w[i];
	f /= 2;
	for(i=0;i<l;i++)
	{
		d = this->z[i] - y[i];
		if(d < this->p*(-1))
			f += this->C[i]*(d+this->p)*(d+this->p);
		else if(d > this->p)
			f += this->C[i]*(d-this->p)*(d-this->p);
	}

	return(f);
}

void l2r_l2_svr_fun_grad(struct tagl2r_l2_svr_fun *this, double *w, double *g)
{
	int i;
	double *y=this->prob->y;
	int l=this->prob->l;
	int w_size=this->get_nr_variable(this);
	double d;

	this->sizeI = 0;
	for(i=0;i<l;i++)
	{
		d = this->z[i] - y[i];

		// generate index set I
		if(d < -(this->p))
		{
			this->z[this->sizeI] = this->C[i]*(d+this->p);
			this->I[this->sizeI] = i;
			this->sizeI++;
		}
		else if(d > this->p)
		{
			this->z[this->sizeI] = this->C[i]*(d-this->p);
			this->I[this->sizeI] = i;
			this->sizeI++;
		}

	}
	this->subXTv(this, this->z, g);

	for(i=0;i<w_size;i++)
		g[i] = w[i] + 2*g[i];
}

void l2r_l2_svr_fun_Hv(struct tagl2r_l2_svr_fun *this, double *s, double *Hs)
{
	int i;
	int w_size=this->get_nr_variable(this);
	double *wa = (double*)malloc(this->sizeI*sizeof(double));
	int *I = this->I;

	this->subXv(this, s, wa);
	for(i=0;i<this->sizeI;i++)
		wa[i] = this->C[I[i]]*wa[i];

	this->subXTv(this, wa, Hs);
	for(i=0;i<w_size;i++)
		Hs[i] = s[i] + 2*Hs[i];
	free(wa);
}

int l2r_l2_svr_fun_get_nr_variable(struct tagl2r_l2_svr_fun *this)//inherited from l2r_l2_svc_fun
{
	return this->prob->n;
}

void l2r_l2_svr_fun_Xv(struct tagl2r_l2_svr_fun *this, double *v, double *Xv)//inherited from l2r_l2_svc_fun
{
	int i;
	int l=this->prob->l;
	struct feature_node **x=this->prob->x;

	for(i=0;i<l;i++)
	{
		struct feature_node *s=x[i];
		Xv[i]=0;
		while(s->index!=-1)
		{
			Xv[i]+=v[s->index-1]*s->value;
			s++;
		}
	}
}

void l2r_l2_svr_fun_subXv(struct tagl2r_l2_svr_fun *this, double *v, double *Xv)
{
	int i;
	struct feature_node **x=this->prob->x;
	int *I = this->I;

	for(i=0;i<this->sizeI;i++)
	{
		struct feature_node *s=x[I[i]];
		Xv[i]=0;
		while(s->index!=-1)
		{
			Xv[i]+=v[s->index-1]*s->value;
			s++;
		}
	}
}

void l2r_l2_svr_fun_subXTv(struct tagl2r_l2_svr_fun *this, double *v, double *XTv)//inherited from l2r_l2_svc_fun
{
	int i;
	int w_size=this->get_nr_variable(this);
	struct feature_node **x=this->prob->x;
	int *I = this->I;

	for(i=0;i<w_size;i++)
		XTv[i]=0;
	for(i=0;i<this->sizeI;i++)
	{
		struct feature_node *s=x[I[i]];
		while(s->index!=-1)
		{
			XTv[s->index-1]+=v[i]*s->value;
			s++;
		}
	}
}

void l2r_l2_svr_fun_initialise(struct tagl2r_l2_svr_fun *this)//initialise the function pointers in the struct
{
	this->constructor = &l2r_l2_svr_fun_constructor;
//	this->destructor = &l2r_l2_svr_fun_destructor;

	this->fun = &l2r_l2_svr_fun_fun;
	this->grad = &l2r_l2_svr_fun_grad;
	this->Hv = &l2r_l2_svr_fun_Hv;
	this->get_nr_variable = &l2r_l2_svr_fun_get_nr_variable;

	this->Xv = &l2r_l2_svr_fun_Xv;
	this->subXv = &l2r_l2_svr_fun_subXv;
	this->subXTv = &l2r_l2_svr_fun_subXTv;
}









// A coordinate descent algorithm for 
// multi-class support vector machines by Crammer and Singer
//
//  min_{\alpha}  0.5 \sum_m ||w_m(\alpha)||^2 + \sum_i \sum_m e^m_i alpha^m_i
//    s.t.     \alpha^m_i <= C^m_i \forall m,i , \sum_m \alpha^m_i=0 \forall i
// 
//  where e^m_i = 0 if y_i  = m,
//        e^m_i = 1 if y_i != m,
//  C^m_i = C if m  = y_i, 
//  C^m_i = 0 if m != y_i, 
//  and w_m(\alpha) = \sum_i \alpha^m_i x_i 
//
// Given: 
// x, y, C
// eps is the stopping tolerance
//
// solution will be put in w
//
// See Appendix of LIBLINEAR paper, Fan et al. (2008)

#define GETI(i) ((int) prob->y[i])
// To support weights for instances, use GETI(i) (i)

void Solver_MCSVM_CS_constructor(struct tagSolver_MCSVM_CS *this, const struct problem *prob, int nr_class, double *weighted_C, double eps, int max_iter)
{
	this->w_size = prob->n;
	this->l = prob->l;
	this->nr_class = nr_class;
	this->eps = eps;
	this->max_iter = max_iter;
	this->prob = prob;
	this->B = (double*)malloc(nr_class*sizeof(double));
	this->G = (double*)malloc(nr_class*sizeof(double));
	this->C = weighted_C;
}

void Solver_MCSVM_CS_destructor(struct tagSolver_MCSVM_CS *this)
{
	free(this->B);
	free(this->G);
}

int compare_double(const void *a, const void *b)
{
	if(*(double *)a > *(double *)b)
		return -1;
	if(*(double *)a < *(double *)b)
		return 1;
	return 0;
}

void Solver_MCSVM_CS_solve_sub_problem(struct tagSolver_MCSVM_CS *this, double A_i, int yi, double C_yi, int active_i, double *alpha_new)
{
	int r;
	double *D;
	double beta;
	
	D = (double*)malloc(active_i*sizeof(double));
	memcpy((void *)D,(void *)this->B,sizeof(double)*active_i);
	//clone(D, this->B, active_i);

	if(yi < active_i)
		D[yi] += A_i*C_yi;
	qsort(D, active_i, sizeof(double), compare_double);

	beta = D[0] - A_i*C_yi;
	for(r=1;r<active_i && beta<r*D[r];r++)
		beta += D[r];
	beta /= r;

	for(r=0;r<active_i;r++)
	{
		if(r == yi)
			alpha_new[r] = (C_yi < (beta-this->B[r])/A_i)?C_yi : (beta-this->B[r])/A_i;
		else
			alpha_new[r] = ((double)0 < (beta - this->B[r])/A_i)?(double)0 : (beta - this->B[r])/A_i;
	}
	free(D);
}

int Solver_MCSVM_CS_be_shrunk(struct tagSolver_MCSVM_CS *this, int i, int m, int yi, double alpha_i, double minG)
{
	double bound = 0;
	if(m == yi)
		bound = this->C[(int) this->prob->y[i]];
	if(alpha_i == bound && this->G[m] < minG)
		return 1;
	return 0;
}

void Solver_MCSVM_CS_Solve(struct tagSolver_MCSVM_CS *this, double *w)
{
	//no need to refer to struct member variables
	int l = this->l;
	int nr_class = this->nr_class;
	double *B = this->B;
	double *C = this->C;
	double *G = this->G;
	int w_size = this->w_size;
	int max_iter = this->max_iter;
	double eps = this->eps;
	const struct problem *prob = this->prob;

	int i, m, s;
	int iter = 0;
	double *alpha =  (double*)malloc(l*nr_class*sizeof(double));
	double *alpha_new = (double*)malloc(nr_class*sizeof(double));
	int *index = (int*)malloc(l*sizeof(int));
	double *QD = (double*)malloc(l*sizeof(double));
	int *d_ind = (int*)malloc(nr_class*sizeof(int));
	double *d_val = (double*)malloc(nr_class*sizeof(double));
	int *alpha_index = (int*)malloc(nr_class*l*sizeof(int));
	int *y_index = (int*)malloc(l*sizeof(int));
	int active_size = l;
	int *active_size_i = (int*)malloc(l*sizeof(int));
	double eps_shrink = ((10.0*eps) > (double)1.0)?(10.0*eps) : (double)1.0; // stopping tolerance for shrinking
	int start_from_all = 1;

	double v;
	int nSV;

	// Initial alpha can be set here. Note that 
	// sum_m alpha[i*nr_class+m] = 0, for all i=1,...,l-1
	// alpha[i*nr_class+m] <= C[GETI(i)] if prob->y[i] == m
	// alpha[i*nr_class+m] <= 0 if prob->y[i] != m
	// If initial alpha isn't zero, uncomment the for loop below to initialize w
	for(i=0;i<l*nr_class;i++)
		alpha[i] = 0;

	for(i=0;i<w_size*nr_class;i++)
		w[i] = 0;
	for(i=0;i<l;i++)
	{
		struct feature_node *xi;
		for(m=0;m<nr_class;m++)
			alpha_index[i*nr_class+m] = m;
		xi = prob->x[i];
		QD[i] = 0;
		while(xi->index != -1)
		{
			double val = xi->value;
			QD[i] += val*val;

			// Uncomment the for loop if initial alpha isn't zero
			// for(m=0; m<nr_class; m++)
			//	w[(xi->index-1)*nr_class+m] += alpha[i*nr_class+m]*val;
			xi++;
		}
		active_size_i[i] = nr_class;
		y_index[i] = (int)prob->y[i];
		index[i] = i;
	}

	while(iter < max_iter)
	{
		double stopping = -INF;
		for(i=0;i<active_size;i++)
		{
			int j = i+rand()%(active_size-i);
			int swaptemp = index[i];
			index[i] = index[j];
			index[j] = swaptemp;
			//swapint(index[i], index[j]);
		}
		for(s=0;s<active_size;s++)
		{
			double Ai;
			double *alpha_i;
			int *alpha_index_i;
			i = index[s];
			Ai = QD[i];
			alpha_i = &alpha[i*nr_class];
			alpha_index_i = &alpha_index[i*nr_class];

			if(Ai > 0)
			{
				struct feature_node *xi;
				double minG = INF;
				double maxG = -INF;
				int nz_d;

				for(m=0;m<active_size_i[i];m++)
					G[m] = 1;
				if(y_index[i] < active_size_i[i])
					G[y_index[i]] = 0;

				xi = prob->x[i];
				while(xi->index!= -1)
				{
					double *w_i = &w[(xi->index-1)*nr_class];
					for(m=0;m<active_size_i[i];m++)
						G[m] += w_i[alpha_index_i[m]]*(xi->value);
					xi++;
				}

				for(m=0;m<active_size_i[i];m++)
				{
					if(alpha_i[alpha_index_i[m]] < 0 && G[m] < minG)
						minG = G[m];
					if(G[m] > maxG)
						maxG = G[m];
				}
				if(y_index[i] < active_size_i[i])
					if(alpha_i[(int) prob->y[i]] < C[GETI(i)] && G[y_index[i]] < minG)
						minG = G[y_index[i]];

				for(m=0;m<active_size_i[i];m++)
				{
					if(this->be_shrunk(this, i, m, y_index[i], alpha_i[alpha_index_i[m]], minG))
					{
						active_size_i[i]--;
						while(active_size_i[i]>m)
						{
							if(!this->be_shrunk(this, i, active_size_i[i], y_index[i],
											alpha_i[alpha_index_i[active_size_i[i]]], minG))
							{
								int swaptemp1;
								double swaptemp2;
								//swapint(alpha_index_i[m], alpha_index_i[active_size_i[i]]);
								swaptemp1 = alpha_index_i[m];
								alpha_index_i[m] = alpha_index_i[active_size_i[i]];
								alpha_index_i[active_size_i[i]] = swaptemp1;
								//swapdouble(G[m], G[active_size_i[i]]);
								swaptemp2 = G[m];
								G[m] = G[active_size_i[i]];
								G[active_size_i[i]] = swaptemp2;

								if(y_index[i] == active_size_i[i])
									y_index[i] = m;
								else if(y_index[i] == m)
									y_index[i] = active_size_i[i];
								break;
							}
							active_size_i[i]--;
						}
					}
				}

				if(active_size_i[i] <= 1)
				{
					int swaptemp;
					active_size--;
					//swapint(index[s], index[active_size]);
					swaptemp = index[s];
					index[s] = index[active_size];
					index[active_size] = swaptemp;
					s--;
					continue;
				}

				if(maxG-minG <= 1e-12)
					continue;
				else
					stopping = ((maxG - minG) > stopping)?(maxG - minG) : stopping;

				for(m=0;m<active_size_i[i];m++)
					B[m] = G[m] - Ai*alpha_i[alpha_index_i[m]] ;

				this->solve_sub_problem(this, Ai, y_index[i], C[GETI(i)], active_size_i[i], alpha_new);
				nz_d = 0;
				for(m=0;m<active_size_i[i];m++)
				{
					double d = alpha_new[m] - alpha_i[alpha_index_i[m]];
					alpha_i[alpha_index_i[m]] = alpha_new[m];
					if(fabs(d) >= 1e-12)
					{
						d_ind[nz_d] = alpha_index_i[m];
						d_val[nz_d] = d;
						nz_d++;
					}
				}

				xi = prob->x[i];
				while(xi->index != -1)
				{
					double *w_i = &w[(xi->index-1)*nr_class];
					for(m=0;m<nz_d;m++)
						w_i[d_ind[m]] += d_val[m]*xi->value;
					xi++;
				}
			}
		}

		iter++;
		if(iter % 10 == 0)
		{
			info(".");
		}

		if(stopping < eps_shrink)
		{
			if(stopping < eps && start_from_all == 1)
				break;
			else
			{
				active_size = l;
				for(i=0;i<l;i++)
					active_size_i[i] = nr_class;
				info("*");
				eps_shrink = (eps_shrink/2 > eps)?eps_shrink/2 : eps;
				start_from_all = 1;
			}
		}
		else
			start_from_all = 0;
	}

	info("\noptimization finished, #iter = %d\n",iter);
	if (iter >= max_iter)
		info("\nWARNING: reaching max number of iterations\n");

	// calculate objective value
	v = 0;
	nSV = 0;
	for(i=0;i<w_size*nr_class;i++)
		v += w[i]*w[i];
	v = 0.5*v;
	for(i=0;i<l*nr_class;i++)
	{
		v += alpha[i];
		if(fabs(alpha[i]) > 0)
			nSV++;
	}
	for(i=0;i<l;i++)
		v -= alpha[i*nr_class+(int)prob->y[i]];
	info("Objective value = %lf\n",v);
	info("nSV = %d\n",nSV);

	free(alpha);
	free(alpha_new);
	free(index);
	free(QD);
	free(d_ind);
	free(d_val);
	free(alpha_index);
	free(y_index);
	free(active_size_i);
}

void Solver_MCSVM_CS_initialise(struct tagSolver_MCSVM_CS *this)//initialise the function pointers in the struct
{
	this->constructor = &Solver_MCSVM_CS_constructor;
	this->destructor = &Solver_MCSVM_CS_destructor;

	this->Solve = &Solver_MCSVM_CS_Solve;
	this->solve_sub_problem = &Solver_MCSVM_CS_solve_sub_problem;
	this->be_shrunk = &Solver_MCSVM_CS_be_shrunk;
}











// A coordinate descent algorithm for 
// L1-loss and L2-loss SVM dual problems
//
//  min_\alpha  0.5(\alpha^T (Q + D)\alpha) - e^T \alpha,
//    s.t.      0 <= \alpha_i <= upper_bound_i,
// 
//  where Qij = yi yj xi^T xj and
//  D is a diagonal matrix 
//
// In L1-SVM case:
// 		upper_bound_i = Cp if y_i = 1
// 		upper_bound_i = Cn if y_i = -1
// 		D_ii = 0
// In L2-SVM case:
// 		upper_bound_i = INF
// 		D_ii = 1/(2*Cp)	if y_i = 1
// 		D_ii = 1/(2*Cn)	if y_i = -1
//
// Given: 
// x, y, Cp, Cn
// eps is the stopping tolerance
//
// solution will be put in w
// 
// See Algorithm 3 of Hsieh et al., ICML 2008

#undef GETI
#define GETI(i) (y[i]+1)
// To support weights for instances, use GETI(i) (i)

static void solve_l2r_l1l2_svc(
	const struct problem *prob, double *w, double eps,
	double Cp, double Cn, int solver_type)
{
	int l = prob->l;
	int w_size = prob->n;
	int i, s, iter = 0;
	double C, d, G;
	double *QD = (double*)malloc(l*sizeof(double));
	int max_iter = 1000;
	int *index = (int*)malloc(l*sizeof(int));
	double *alpha = (double*)malloc(l*sizeof(double));
	schar *y = (schar*)malloc(l*sizeof(schar));
	int active_size = l;

	// PG: projected gradient, for shrinking and stopping
	double PG;
	double PGmax_old = INF;
	double PGmin_old = -INF;
	double PGmax_new, PGmin_new;

	// default solver_type: L2R_L2LOSS_SVC_DUAL
	double diag[3] = {0.5/Cn, 0, 0.5/Cp};
	double upper_bound[3] = {INF, 0, INF};
	double v;
	int nSV;

	if(solver_type == L2R_L1LOSS_SVC_DUAL)
	{
		diag[0] = 0;
		diag[2] = 0;
		upper_bound[0] = Cn;
		upper_bound[2] = Cp;
	}

	for(i=0; i<l; i++)
	{
		if(prob->y[i] > 0)
		{
			y[i] = +1;
		}
		else
		{
			y[i] = -1;
		}
	}

	// Initial alpha can be set here. Note that
	// 0 <= alpha[i] <= upper_bound[GETI(i)]
	for(i=0; i<l; i++)
		alpha[i] = 0;

	for(i=0; i<w_size; i++)
		w[i] = 0;
	for(i=0; i<l; i++)
	{
		struct feature_node *xi;
		QD[i] = diag[GETI(i)];

		xi = prob->x[i];
		while (xi->index != -1)
		{
			double val = xi->value;
			QD[i] += val*val;
			w[xi->index-1] += y[i]*alpha[i]*val;
			xi++;
		}
		index[i] = i;
	}

	while (iter < max_iter)
	{
		PGmax_new = -INF;
		PGmin_new = INF;

		for (i=0; i<active_size; i++)
		{
			int j = i+rand()%(active_size-i);
			//swapint(index[i], index[j]);
			int swaptemp = index[i];
			index[i] = index[j];
			index[j] = swaptemp;
		}

		for (s=0; s<active_size; s++)
		{
			schar yi;
			struct feature_node *xi;
			i = index[s];
			G = 0;
			yi = y[i];

			xi = prob->x[i];
			while(xi->index!= -1)
			{
				G += w[xi->index-1]*(xi->value);
				xi++;
			}
			G = G*yi-1;

			C = upper_bound[GETI(i)];
			G += alpha[i]*diag[GETI(i)];

			PG = 0;
			if (alpha[i] == 0)
			{
				if (G > PGmax_old)
				{
					int swaptemp;
					active_size--;
					//swapint(index[s], index[active_size]);
					swaptemp = index[s];
					index[s] = index[active_size];
					index[active_size] = swaptemp;

					s--;
					continue;
				}
				else if (G < 0)
					PG = G;
			}
			else if (alpha[i] == C)
			{
				if (G < PGmin_old)
				{
					int swaptemp;
					active_size--;
					//swapint(index[s], index[active_size]);
					swaptemp = index[s];
					index[s] = index[active_size];
					index[active_size] = swaptemp;

					s--;
					continue;
				}
				else if (G > 0)
					PG = G;
			}
			else
				PG = G;

			PGmax_new = (PGmax_new > PG)?PGmax_new : PG;
			PGmin_new = (PGmin_new < PG)?PGmin_new : PG;

			if(fabs(PG) > 1.0e-12)
			{
				double alpha_old = alpha[i];
				alpha[i] = ((((alpha[i] - G/QD[i]) > 0.0)?(alpha[i] - G/QD[i]) : 0.0) < C)?(((alpha[i] - G/QD[i]) > 0.0)?(alpha[i] - G/QD[i]) : 0.0) : C;
				d = (alpha[i] - alpha_old)*yi;
				xi = prob->x[i];
				while (xi->index != -1)
				{
					w[xi->index-1] += d*xi->value;
					xi++;
				}
			}
		}

		iter++;
		if(iter % 10 == 0)
			info(".");

		if(PGmax_new - PGmin_new <= eps)
		{
			if(active_size == l)
				break;
			else
			{
				active_size = l;
				info("*");
				PGmax_old = INF;
				PGmin_old = -INF;
				continue;
			}
		}
		PGmax_old = PGmax_new;
		PGmin_old = PGmin_new;
		if (PGmax_old <= 0)
			PGmax_old = INF;
		if (PGmin_old >= 0)
			PGmin_old = -INF;
	}

	info("\noptimization finished, #iter = %d\n",iter);
	if (iter >= max_iter)
		info("\nWARNING: reaching max number of iterations\nUsing -s 2 may be faster (also see FAQ)\n\n");

	// calculate objective value

	v = 0;
	nSV = 0;
	for(i=0; i<w_size; i++)
		v += w[i]*w[i];
	for(i=0; i<l; i++)
	{
		v += alpha[i]*(alpha[i]*diag[GETI(i)] - 2);
		if(alpha[i] > 0)
			++nSV;
	}
	info("Objective value = %lf\n",v/2);
	info("nSV = %d\n",nSV);

	free(QD);
	free(alpha);
	free(y);
	free(index);
}


// A coordinate descent algorithm for 
// L1-loss and L2-loss epsilon-SVR dual problem
//
//  min_\beta  0.5\beta^T (Q + diag(lambda)) \beta - p \sum_{i=1}^l|\beta_i| + \sum_{i=1}^l yi\beta_i,
//    s.t.      -upper_bound_i <= \beta_i <= upper_bound_i,
// 
//  where Qij = xi^T xj and
//  D is a diagonal matrix 
//
// In L1-SVM case:
// 		upper_bound_i = C
// 		lambda_i = 0
// In L2-SVM case:
// 		upper_bound_i = INF
// 		lambda_i = 1/(2*C)
//
// Given: 
// x, y, p, C
// eps is the stopping tolerance
//
// solution will be put in w
//
// See Algorithm 4 of Ho and Lin, 2012   

#undef GETI
#define GETI(i) (0)
// To support weights for instances, use GETI(i) (i)

static void solve_l2r_l1l2_svr(
	const struct problem *prob, double *w, const struct parameter *param,
	int solver_type)
{
	int l = prob->l;
	double C = param->C;
	double p = param->p;
	int w_size = prob->n;
	double eps = param->eps;
	int i, s, iter = 0;
	int max_iter = 1000;
	int active_size = l;
	int *index = (int*)malloc(l*sizeof(int));

	double d, G, H;
	double Gmax_old = INF;
	double Gmax_new, Gnorm1_new;
	double Gnorm1_init;
	double *beta = (double*)malloc(l*sizeof(double));
	double *QD = (double*)malloc(l*sizeof(double));
	double *y = prob->y;

	double v = 0;
	int nSV = 0;

	// L2R_L2LOSS_SVR_DUAL
	double lambda[1], upper_bound[1];
	lambda[0] = 0.5/C;
	upper_bound[0] = INF;

	if(solver_type == L2R_L1LOSS_SVR_DUAL)
	{
		lambda[0] = 0;
		upper_bound[0] = C;
	}

	// Initial beta can be set here. Note that
	// -upper_bound <= beta[i] <= upper_bound
	for(i=0; i<l; i++)
		beta[i] = 0;

	for(i=0; i<w_size; i++)
		w[i] = 0;
	for(i=0; i<l; i++)
	{
		struct feature_node *xi;
		QD[i] = 0;
		xi = prob->x[i];
		while(xi->index != -1)
		{
			double val = xi->value;
			QD[i] += val*val;
			w[xi->index-1] += beta[i]*val;
			xi++;
		}

		index[i] = i;
	}


	while(iter < max_iter)
	{
		Gmax_new = 0;
		Gnorm1_new = 0;

		for(i=0; i<active_size; i++)
		{
			int j = i+rand()%(active_size-i);
			//swapint(index[i], index[j]);
			int swaptemp = index[i];
			index[i] = index[j];
			index[j] = swaptemp;
		}

		for(s=0; s<active_size; s++)
		{
			struct feature_node *xi;
			double Gp;
			double Gn;
			double violation;
			double beta_old;

			i = index[s];
			G = -y[i] + lambda[GETI(i)]*beta[i];
			H = QD[i] + lambda[GETI(i)];

			xi = prob->x[i];
			while(xi->index != -1)
			{
				int ind = xi->index-1;
				double val = xi->value;
				G += val*w[ind];
				xi++;
			}

			Gp = G+p;
			Gn = G-p;
			violation = 0;
			if(beta[i] == 0)
			{
				if(Gp < 0)
					violation = -Gp;
				else if(Gn > 0)
					violation = Gn;
				else if(Gp>Gmax_old && Gn<-Gmax_old)
				{
					int swaptemp;
					active_size--;
					//swapint(index[s], index[active_size]);
					swaptemp = index[s];
					index[s] = index[active_size];
					index[active_size] = swaptemp;

					s--;
					continue;
				}
			}
			else if(beta[i] >= upper_bound[GETI(i)])
			{
				if(Gp > 0)
					violation = Gp;
				else if(Gp < -Gmax_old)
				{
					int swaptemp;
					active_size--;
					//swapint(index[s], index[active_size]);
					swaptemp = index[s];
					index[s] = index[active_size];
					index[active_size] = swaptemp;

					s--;
					continue;
				}
			}
			else if(beta[i] <= -upper_bound[GETI(i)])
			{
				if(Gn < 0)
					violation = -Gn;
				else if(Gn > Gmax_old)
				{
					int swaptemp;
					active_size--;
					//swapint(index[s], index[active_size]);
					swaptemp = index[s];
					index[s] = index[active_size];
					index[active_size] = swaptemp;

					s--;
					continue;
				}
			}
			else if(beta[i] > 0)
				violation = fabs(Gp);
			else
				violation = fabs(Gn);

			Gmax_new = (Gmax_new > violation)?Gmax_new : violation;
			Gnorm1_new += violation;

			// obtain Newton direction d
			if(Gp < H*beta[i])
				d = -Gp/H;
			else if(Gn > H*beta[i])
				d = -Gn/H;
			else
				d = -beta[i];

			if(fabs(d) < 1.0e-12)
				continue;

			beta_old = beta[i];
			beta[i] = (((beta[i]+d > -upper_bound[GETI(i)])?beta[i]+d : -upper_bound[GETI(i)]) > upper_bound[GETI(i)])?((beta[i]+d > -upper_bound[GETI(i)])?beta[i]+d : -upper_bound[GETI(i)]) : upper_bound[GETI(i)];
			d = beta[i]-beta_old;

			if(d != 0)
			{
				xi = prob->x[i];
				while(xi->index != -1)
				{
					w[xi->index-1] += d*xi->value;
					xi++;
				}
			}
		}

		if(iter == 0)
			Gnorm1_init = Gnorm1_new;
		iter++;
		if(iter % 10 == 0)
			info(".");

		if(Gnorm1_new <= eps*Gnorm1_init)
		{
			if(active_size == l)
				break;
			else
			{
				active_size = l;
				info("*");
				Gmax_old = INF;
				continue;
			}
		}

		Gmax_old = Gmax_new;
	}

	info("\noptimization finished, #iter = %d\n", iter);
	if(iter >= max_iter)
		info("\nWARNING: reaching max number of iterations\nUsing -s 11 may be faster\n\n");

	// calculate objective value
	v = 0;
	nSV = 0;
	for(i=0; i<w_size; i++)
		v += w[i]*w[i];
	v = 0.5*v;
	for(i=0; i<l; i++)
	{
		v += p*fabs(beta[i]) - y[i]*beta[i] + 0.5*lambda[GETI(i)]*beta[i]*beta[i];
		if(beta[i] != 0)
			nSV++;
	}

	info("Objective value = %lf\n", v);
	info("nSV = %d\n",nSV);

	free(beta);
	free(QD);
	free(index);
}


// A coordinate descent algorithm for 
// the dual of L2-regularized logistic regression problems
//
//  min_\alpha  0.5(\alpha^T Q \alpha) + \sum \alpha_i log (\alpha_i) + (upper_bound_i - \alpha_i) log (upper_bound_i - \alpha_i),
//    s.t.      0 <= \alpha_i <= upper_bound_i,
// 
//  where Qij = yi yj xi^T xj and 
//  upper_bound_i = Cp if y_i = 1
//  upper_bound_i = Cn if y_i = -1
//
// Given: 
// x, y, Cp, Cn
// eps is the stopping tolerance
//
// solution will be put in w
//
// See Algorithm 5 of Yu et al., MLJ 2010

#undef GETI
#define GETI(i) (y[i]+1)
// To support weights for instances, use GETI(i) (i)

void solve_l2r_lr_dual(const struct problem *prob, double *w, double eps, double Cp, double Cn)
{
	int l = prob->l;
	int w_size = prob->n;
	int i, s, iter = 0;
	double *xTx = (double*)malloc(l*sizeof(double));
	int max_iter = 1000;
	int *index = (int*)malloc(l*sizeof(int));	
	double *alpha = (double*)malloc(2*l*sizeof(double)); // store alpha and C - alpha
	schar *y = (schar*)malloc(l*sizeof(schar));
	int max_inner_iter = 100; // for inner Newton
	double innereps = 1e-2;
	double innereps_min = (1e-8 < eps)?1e-8 : eps;
	double upper_bound[3] = {Cn, 0, Cp};
	double v;

	for(i=0; i<l; i++)
	{
		if(prob->y[i] > 0)
		{
			y[i] = +1;
		}
		else
		{
			y[i] = -1;
		}
	}
	
	// Initial alpha can be set here. Note that
	// 0 < alpha[i] < upper_bound[GETI(i)]
	// alpha[2*i] + alpha[2*i+1] = upper_bound[GETI(i)]
	for(i=0; i<l; i++)
	{
		alpha[2*i] = (0.001*upper_bound[GETI(i)] < 1e-8)?0.001*upper_bound[GETI(i)] : 1e-8;
		alpha[2*i+1] = upper_bound[GETI(i)] - alpha[2*i];
	}

	for(i=0; i<w_size; i++)
		w[i] = 0;
	for(i=0; i<l; i++)
	{
		struct feature_node *xi;
		xTx[i] = 0;
		xi = prob->x[i];
		while (xi->index != -1)
		{
			double val = xi->value;
			xTx[i] += val*val;
			w[xi->index-1] += y[i]*alpha[2*i]*val;
			xi++;
		}
		index[i] = i;
	}

	while (iter < max_iter)
	{
		int newton_iter;
		double Gmax;
		for (i=0; i<l; i++)
		{
			int j = i+rand()%(l-i);
			//swapint(index[i], index[j]);
			int swaptemp = index[i];
			index[i] = index[j];
			index[j] = swaptemp;
		}
		newton_iter = 0;
		Gmax = 0;
		for (s=0; s<l; s++)
		{
			schar yi;
			double C;
			double ywTx, xisq;
			struct feature_node *xi;
			double a, b;
			int ind1, ind2, sign;
			double alpha_old;
			double z;
			double gp;
			const double eta = 0.1; // xi in the paper
			int inner_iter;

			i = index[s];
			yi = y[i];
			C = upper_bound[GETI(i)];
			ywTx = 0;
			xisq = xTx[i];
			xi = prob->x[i];
			while (xi->index != -1)
			{
				ywTx += w[xi->index-1]*xi->value;
				xi++;
			}
			ywTx *= y[i];
			a = xisq;
			b = ywTx;

			// Decide to minimize g_1(z) or g_2(z)
			ind1 = 2*i;
			ind2 = 2*i+1;
			sign = 1;
			if(0.5*a*(alpha[ind2]-alpha[ind1])+b < 0)
			{
				ind1 = 2*i+1;
				ind2 = 2*i;
				sign = -1;
			}

			//  g_t(z) = z*log(z) + (C-z)*log(C-z) + 0.5a(z-alpha_old)^2 + sign*b(z-alpha_old)
			alpha_old = alpha[ind1];
			z = alpha_old;
			if(C - z < 0.5 * C)
				z = 0.1*z;
			gp = a*(z-alpha_old)+sign*b+log(z/(C-z));
			Gmax = (Gmax > fabs(gp))?Gmax : fabs(gp);

			// Newton method on the sub-problem
			//const double eta = 0.1; // xi in the paper
			inner_iter = 0;
			while (inner_iter <= max_inner_iter)
			{
				double gpp;
				double tmpz;
				if(fabs(gp) < innereps)
					break;
				gpp = a + C/(C-z)/z;
				tmpz = z - gp/gpp;
				if(tmpz <= 0)
					z *= eta;
				else // tmpz in (0, C)
					z = tmpz;
				gp = a*(z-alpha_old)+sign*b+log(z/(C-z));
				newton_iter++;
				inner_iter++;
			}

			if(inner_iter > 0) // update w
			{
				alpha[ind1] = z;
				alpha[ind2] = C-z;
				xi = prob->x[i];
				while (xi->index != -1)
				{
					w[xi->index-1] += sign*(z-alpha_old)*yi*xi->value;
					xi++;
				}
			}
		}

		iter++;
		if(iter % 10 == 0)
			info(".");

		if(Gmax < eps)
			break;

		if(newton_iter <= l/10)
			innereps = (innereps_min > 0.1*innereps)?innereps_min : 0.1*innereps;

	}

	info("\noptimization finished, #iter = %d\n",iter);
	if (iter >= max_iter)
		info("\nWARNING: reaching max number of iterations\nUsing -s 0 may be faster (also see FAQ)\n\n");

	// calculate objective value

	v = 0;
	for(i=0; i<w_size; i++)
		v += w[i] * w[i];
	v *= 0.5;
	for(i=0; i<l; i++)
		v += alpha[2*i] * log(alpha[2*i]) + alpha[2*i+1] * log(alpha[2*i+1])
			- upper_bound[GETI(i)] * log(upper_bound[GETI(i)]);
	info("Objective value = %lf\n", v);

	free(xTx);
	free(alpha);
	free(y);
	free(index);
}

// A coordinate descent algorithm for 
// L1-regularized L2-loss support vector classification
//
//  min_w \sum |wj| + C \sum max(0, 1-yi w^T xi)^2,
//
// Given: 
// x, y, Cp, Cn
// eps is the stopping tolerance
//
// solution will be put in w
//
// See Yuan et al. (2010) and appendix of LIBLINEAR paper, Fan et al. (2008)

#undef GETI
#define GETI(i) (y[i]+1)
// To support weights for instances, use GETI(i) (i)

static void solve_l1r_l2_svc(
	struct problem *prob_col, double *w, double eps,
	double Cp, double Cn)
{
	int l = prob_col->l;
	int w_size = prob_col->n;
	int j, s, iter = 0;
	int max_iter = 1000;
	int active_size = w_size;
	int max_num_linesearch = 20;

	double sigma = 0.01;
	double d, G_loss, G, H;
	double Gmax_old = INF;
	double Gmax_new, Gnorm1_new;
	double Gnorm1_init;
	double d_old, d_diff;
	double loss_old, loss_new;
	double appxcond, cond;

	int *index = (int*)malloc(w_size*sizeof(int));
	schar *y = (schar*)malloc(l*sizeof(schar));
	double *b = (double*)malloc(l*sizeof(double)); // b = 1-ywTx
	double *xj_sq = (double*)malloc(w_size*sizeof(double));
	struct feature_node *x;

	double C[3] = {Cn,0,Cp};
	double v;
	int nnz;

	// Initial w can be set here.
	for(j=0; j<w_size; j++)
		w[j] = 0;

	for(j=0; j<l; j++)
	{
		b[j] = 1;
		if(prob_col->y[j] > 0)
			y[j] = 1;
		else
			y[j] = -1;
	}
	for(j=0; j<w_size; j++)
	{
		index[j] = j;
		xj_sq[j] = 0;
		x = prob_col->x[j];
		while(x->index != -1)
		{
			int ind = x->index-1;
			double val;
			x->value *= y[ind]; // x->value stores yi*xij
			val = x->value;
			b[ind] -= w[j]*val;
			xj_sq[j] += C[GETI(ind)]*val*val;
			x++;
		}
	}

	while(iter < max_iter)
	{
		Gmax_new = 0;
		Gnorm1_new = 0;

		for(j=0; j<active_size; j++)
		{
			int i = j+rand()%(active_size-j);
			//swapint(index[i], index[j]);
			int swaptemp = index[i];
			index[i] = index[j];
			index[j] = swaptemp;
		}

		for(s=0; s<active_size; s++)
		{
			double Gp;
			double Gn;
			double violation;
			double delta;
			int num_linesearch;

			j = index[s];
			G_loss = 0;
			H = 0;

			x = prob_col->x[j];
			while(x->index != -1)
			{
				int ind = x->index-1;
				if(b[ind] > 0)
				{
					double val = x->value;
					double tmp = C[GETI(ind)]*val;
					G_loss -= tmp*b[ind];
					H += tmp*val;
				}
				x++;
			}
			G_loss *= 2;

			G = G_loss;
			H *= 2;
			H = (H > 1e-12)?H : 1e-12;

			Gp = G+1;
			Gn = G-1;
			violation = 0;
			if(w[j] == 0)
			{
				if(Gp < 0)
					violation = -Gp;
				else if(Gn > 0)
					violation = Gn;
				else if(Gp>Gmax_old/l && Gn<-Gmax_old/l)
				{
					int swaptemp;
					active_size--;
					//swapint(index[s], index[active_size]);
					swaptemp = index[s];
					index[s] = index[active_size];
					index[active_size] = swaptemp;

					s--;
					continue;
				}
			}
			else if(w[j] > 0)
				violation = fabs(Gp);
			else
				violation = fabs(Gn);

			Gmax_new = (Gmax_new > violation)?Gmax_new : violation;
			Gnorm1_new += violation;

			// obtain Newton direction d
			if(Gp < H*w[j])
				d = -Gp/H;
			else if(Gn > H*w[j])
				d = -Gn/H;
			else
				d = -w[j];

			if(fabs(d) < 1.0e-12)
				continue;

			delta = fabs(w[j]+d)-fabs(w[j]) + G*d;
			d_old = 0;
			for(num_linesearch=0; num_linesearch < max_num_linesearch; num_linesearch++)
			{
				d_diff = d_old - d;
				cond = fabs(w[j]+d)-fabs(w[j]) - sigma*delta;

				appxcond = xj_sq[j]*d*d + G_loss*d + cond;
				if(appxcond <= 0)
				{
					x = prob_col->x[j];
					while(x->index != -1)
					{
						b[x->index-1] += d_diff*x->value;
						x++;
					}
					break;
				}

				if(num_linesearch == 0)
				{
					loss_old = 0;
					loss_new = 0;
					x = prob_col->x[j];
					while(x->index != -1)
					{
						int ind = x->index-1;
						double b_new;
						if(b[ind] > 0)
							loss_old += C[GETI(ind)]*b[ind]*b[ind];
						b_new = b[ind] + d_diff*x->value;
						b[ind] = b_new;
						if(b_new > 0)
							loss_new += C[GETI(ind)]*b_new*b_new;
						x++;
					}
				}
				else
				{
					loss_new = 0;
					x = prob_col->x[j];
					while(x->index != -1)
					{
						int ind = x->index-1;
						double b_new = b[ind] + d_diff*x->value;
						b[ind] = b_new;
						if(b_new > 0)
							loss_new += C[GETI(ind)]*b_new*b_new;
						x++;
					}
				}

				cond = cond + loss_new - loss_old;
				if(cond <= 0)
					break;
				else
				{
					d_old = d;
					d *= 0.5;
					delta *= 0.5;
				}
			}

			w[j] += d;

			// recompute b[] if line search takes too many steps
			if(num_linesearch >= max_num_linesearch)
			{
				int i;
				info("#");
				for(i=0; i<l; i++)
					b[i] = 1;

				for(i=0; i<w_size; i++)
				{
					if(w[i]==0) continue;
					x = prob_col->x[i];
					while(x->index != -1)
					{
						b[x->index-1] -= w[i]*x->value;
						x++;
					}
				}
			}
		}

		if(iter == 0)
			Gnorm1_init = Gnorm1_new;
		iter++;
		if(iter % 10 == 0)
			info(".");

		if(Gnorm1_new <= eps*Gnorm1_init)
		{
			if(active_size == w_size)
				break;
			else
			{
				active_size = w_size;
				info("*");
				Gmax_old = INF;
				continue;
			}
		}

		Gmax_old = Gmax_new;
	}

	info("\noptimization finished, #iter = %d\n", iter);
	if(iter >= max_iter)
		info("\nWARNING: reaching max number of iterations\n");

	// calculate objective value

	v = 0;
	nnz = 0;
	for(j=0; j<w_size; j++)
	{
		x = prob_col->x[j];
		while(x->index != -1)
		{
			x->value *= prob_col->y[x->index-1]; // restore x->value
			x++;
		}
		if(w[j] != 0)
		{
			v += fabs(w[j]);
			nnz++;
		}
	}
	for(j=0; j<l; j++)
		if(b[j] > 0)
			v += C[GETI(j)]*b[j]*b[j];

	info("Objective value = %lf\n", v);
	info("#nonzeros/#features = %d/%d\n", nnz, w_size);

	free(index);
	free(y);
	free(b);
	free(xj_sq);
}

// A coordinate descent algorithm for 
// L1-regularized logistic regression problems
//
//  min_w \sum |wj| + C \sum log(1+exp(-yi w^T xi)),
//
// Given: 
// x, y, Cp, Cn
// eps is the stopping tolerance
//
// solution will be put in w
//
// See Yuan et al. (2011) and appendix of LIBLINEAR paper, Fan et al. (2008)

#undef GETI
#define GETI(i) (y[i]+1)
// To support weights for instances, use GETI(i) (i)

static void solve_l1r_lr(
	const struct problem *prob_col, double *w, double eps,
	double Cp, double Cn)
{
	int l = prob_col->l;
	int w_size = prob_col->n;
	int j, s, newton_iter=0, iter=0;
	int max_newton_iter = 100;
	int max_iter = 1000;
	int max_num_linesearch = 20;
	int active_size;
	int QP_active_size;

	double nu = 1e-12;
	double inner_eps = 1;
	double sigma = 0.01;
	double w_norm, w_norm_new;
	double z, G, H;
	double Gnorm1_init;
	double Gmax_old = INF;
	double Gmax_new, Gnorm1_new;
	double QP_Gmax_old = INF;
	double QP_Gmax_new, QP_Gnorm1_new;
	double delta, negsum_xTd, cond;

	int *index = (int*)malloc(w_size*sizeof(int));
	schar *y = (schar*)malloc(l*sizeof(schar));
	double *Hdiag = (double*)malloc(w_size*sizeof(double));
	double *Grad = (double*)malloc(w_size*sizeof(double));
	double *wpd = (double*)malloc(w_size*sizeof(double));
	double *xjneg_sum = (double*)malloc(w_size*sizeof(double));
	double *xTd = (double*)malloc(l*sizeof(double));
	double *exp_wTx = (double*)malloc(l*sizeof(double));
	double *exp_wTx_new = (double*)malloc(l*sizeof(double));
	double *tau = (double*)malloc(l*sizeof(double));
	double *D = (double*)malloc(l*sizeof(double));
	struct feature_node *x;

	double C[3] = {Cn,0,Cp};
	double v ;
	int nnz;

	// Initial w can be set here.
	for(j=0; j<w_size; j++)
		w[j] = 0;

	for(j=0; j<l; j++)
	{
		if(prob_col->y[j] > 0)
			y[j] = 1;
		else
			y[j] = -1;

		exp_wTx[j] = 0;
	}

	w_norm = 0;
	for(j=0; j<w_size; j++)
	{
		w_norm += fabs(w[j]);
		wpd[j] = w[j];
		index[j] = j;
		xjneg_sum[j] = 0;
		x = prob_col->x[j];
		while(x->index != -1)
		{
			int ind = x->index-1;
			double val = x->value;
			exp_wTx[ind] += w[j]*val;
			if(y[ind] == -1)
				xjneg_sum[j] += C[GETI(ind)]*val;
			x++;
		}
	}
	for(j=0; j<l; j++)
	{
		double tau_tmp;
		exp_wTx[j] = exp(exp_wTx[j]);
		tau_tmp = 1/(1+exp_wTx[j]);
		tau[j] = C[GETI(j)]*tau_tmp;
		D[j] = C[GETI(j)]*exp_wTx[j]*tau_tmp*tau_tmp;
	}

	while(newton_iter < max_newton_iter)
	{
		int i;
		int num_linesearch;
		Gmax_new = 0;
		Gnorm1_new = 0;
		active_size = w_size;

		for(s=0; s<active_size; s++)
		{
			double tmp;
			double Gp;
			double Gn;
			double violation;

			j = index[s];
			Hdiag[j] = nu;
			Grad[j] = 0;

			tmp = 0;
			x = prob_col->x[j];
			while(x->index != -1)
			{
				int ind = x->index-1;
				Hdiag[j] += x->value*x->value*D[ind];
				tmp += x->value*tau[ind];
				x++;
			}
			Grad[j] = -tmp + xjneg_sum[j];

			Gp = Grad[j]+1;
			Gn = Grad[j]-1;
			violation = 0;
			if(w[j] == 0)
			{
				if(Gp < 0)
					violation = -Gp;
				else if(Gn > 0)
					violation = Gn;
				//outer-level shrinking
				else if(Gp>Gmax_old/l && Gn<-Gmax_old/l)
				{
					int swaptemp;
					active_size--;
					//swapint(index[s], index[active_size]);
					swaptemp = index[s];
					index[s] = index[active_size];
					index[active_size] = swaptemp;

					s--;
					continue;
				}
			}
			else if(w[j] > 0)
				violation = fabs(Gp);
			else
				violation = fabs(Gn);

			Gmax_new = (Gmax_new > violation)?Gmax_new : violation;
			Gnorm1_new += violation;
		}

		if(newton_iter == 0)
			Gnorm1_init = Gnorm1_new;

		if(Gnorm1_new <= eps*Gnorm1_init)
			break;

		iter = 0;
		QP_Gmax_old = INF;
		QP_active_size = active_size;

		for(i=0; i<l; i++)
			xTd[i] = 0;

		// optimize QP over wpd
		while(iter < max_iter)
		{
			QP_Gmax_new = 0;
			QP_Gnorm1_new = 0;

			for(j=0; j<QP_active_size; j++)
			{
				int i = j+rand()%(QP_active_size-j);
				//swapint(index[i], index[j]);
				int swaptemp = index[i];
				index[i] = index[j];
				index[j] = swaptemp;
			}

			for(s=0; s<QP_active_size; s++)
			{
				double Gp;
				double Gn;
				double violation;

				j = index[s];
				H = Hdiag[j];

				x = prob_col->x[j];
				G = Grad[j] + (wpd[j]-w[j])*nu;
				while(x->index != -1)
				{
					int ind = x->index-1;
					G += x->value*D[ind]*xTd[ind];
					x++;
				}

				Gp = G+1;
				Gn = G-1;
				violation = 0;
				if(wpd[j] == 0)
				{
					if(Gp < 0)
						violation = -Gp;
					else if(Gn > 0)
						violation = Gn;
					//inner-level shrinking
					else if(Gp>QP_Gmax_old/l && Gn<-QP_Gmax_old/l)
					{
						int swaptemp;
						QP_active_size--;
						//swapint(index[s], index[QP_active_size]);
						swaptemp = index[s];
						index[s] = index[QP_active_size];
						index[QP_active_size] = swaptemp;
						s--;
						continue;
					}
				}
				else if(wpd[j] > 0)
					violation = fabs(Gp);
				else
					violation = fabs(Gn);

				QP_Gmax_new = (QP_Gmax_new > violation)?QP_Gmax_new : violation;
				QP_Gnorm1_new += violation;

				// obtain solution of one-variable problem
				if(Gp < H*wpd[j])
					z = -Gp/H;
				else if(Gn > H*wpd[j])
					z = -Gn/H;
				else
					z = -wpd[j];

				if(fabs(z) < 1.0e-12)
					continue;
				z = (((z > -10.0)?z : -10.0) < 10.0)?((z > -10.0)?z : -10.0) : 10.0;

				wpd[j] += z;

				x = prob_col->x[j];
				while(x->index != -1)
				{
					int ind = x->index-1;
					xTd[ind] += x->value*z;
					x++;
				}
			}

			iter++;

			if(QP_Gnorm1_new <= inner_eps*Gnorm1_init)
			{
				//inner stopping
				if(QP_active_size == active_size)
					break;
				//active set reactivation
				else
				{
					QP_active_size = active_size;
					QP_Gmax_old = INF;
					continue;
				}
			}

			QP_Gmax_old = QP_Gmax_new;
		}

		if(iter >= max_iter)
			info("WARNING: reaching max number of inner iterations\n");

		delta = 0;
		w_norm_new = 0;
		for(j=0; j<w_size; j++)
		{
			delta += Grad[j]*(wpd[j]-w[j]);
			if(wpd[j] != 0)
				w_norm_new += fabs(wpd[j]);
		}
		delta += (w_norm_new-w_norm);

		negsum_xTd = 0;
		for(i=0; i<l; i++)
			if(y[i] == -1)
				negsum_xTd += C[GETI(i)]*xTd[i];

		for(num_linesearch=0; num_linesearch < max_num_linesearch; num_linesearch++)
		{
			int i;
			cond = w_norm_new - w_norm + negsum_xTd - sigma*delta;

			for(i=0; i<l; i++)
			{
				double exp_xTd = exp(xTd[i]);
				exp_wTx_new[i] = exp_wTx[i]*exp_xTd;
				cond += C[GETI(i)]*log((1+exp_wTx_new[i])/(exp_xTd+exp_wTx_new[i]));
			}

			if(cond <= 0)
			{
				int i;
				w_norm = w_norm_new;
				for(j=0; j<w_size; j++)
					w[j] = wpd[j];
				for(i=0; i<l; i++)
				{
					double tau_tmp;
					exp_wTx[i] = exp_wTx_new[i];
					tau_tmp = 1/(1+exp_wTx[i]);
					tau[i] = C[GETI(i)]*tau_tmp;
					D[i] = C[GETI(i)]*exp_wTx[i]*tau_tmp*tau_tmp;
				}
				break;
			}
			else
			{
				int i;
				w_norm_new = 0;
				for(j=0; j<w_size; j++)
				{
					wpd[j] = (w[j]+wpd[j])*0.5;
					if(wpd[j] != 0)
						w_norm_new += fabs(wpd[j]);
				}
				delta *= 0.5;
				negsum_xTd *= 0.5;
				for(i=0; i<l; i++)
					xTd[i] *= 0.5;
			}
		}

		// Recompute some info due to too many line search steps
		if(num_linesearch >= max_num_linesearch)
		{
			int i;
			for(i=0; i<l; i++)
				exp_wTx[i] = 0;

			for(i=0; i<w_size; i++)
			{
				if(w[i]==0) continue;
				x = prob_col->x[i];
				while(x->index != -1)
				{
					exp_wTx[x->index-1] += w[i]*x->value;
					x++;
				}
			}

			for(i=0; i<l; i++)
				exp_wTx[i] = exp(exp_wTx[i]);
		}

		if(iter == 1)
			inner_eps *= 0.25;

		newton_iter++;
		Gmax_old = Gmax_new;

		info("iter %3d  #CD cycles %d\n", newton_iter, iter);
	}

	info("=========================\n");
	info("optimization finished, #iter = %d\n", newton_iter);
	if(newton_iter >= max_newton_iter)
		info("WARNING: reaching max number of iterations\n");

	// calculate objective value

	v = 0;
	nnz = 0;
	for(j=0; j<w_size; j++)
		if(w[j] != 0)
		{
			v += fabs(w[j]);
			nnz++;
		}
	for(j=0; j<l; j++)
		if(y[j] == 1)
			v += C[GETI(j)]*log(1+1/exp_wTx[j]);
		else
			v += C[GETI(j)]*log(1+exp_wTx[j]);

	info("Objective value = %lf\n", v);
	info("#nonzeros/#features = %d/%d\n", nnz, w_size);

	free(index);
	free(y);
	free(Hdiag);
	free(Grad);
	free(wpd);
	free(xjneg_sum);
	free(xTd);
	free(exp_wTx);
	free(exp_wTx_new);
	free(tau);
	free(D);
}

// transpose matrix X from row format to column format
static void transpose(const struct problem *prob, struct feature_node **x_space_ret, struct problem *prob_col)
{
	int i;
	int l = prob->l;
	int n = prob->n;
	int nnz = 0;
	int *col_ptr = (int*)malloc((n+1)*sizeof(int));
	struct feature_node *x_space;
	prob_col->l = l;
	prob_col->n = n;
	prob_col->y = (double*)malloc(l*sizeof(double));
	prob_col->x = (struct feature_node**)malloc(n*sizeof(struct feature_node *));

	for(i=0; i<l; i++)
		prob_col->y[i] = prob->y[i];

	for(i=0; i<n+1; i++)
		col_ptr[i] = 0;
	for(i=0; i<l; i++)
	{
		struct feature_node *x = prob->x[i];
		while(x->index != -1)
		{
			nnz++;
			col_ptr[x->index]++;
			x++;
		}
	}
	for(i=1; i<n+1; i++)
		col_ptr[i] += col_ptr[i-1] + 1;

	x_space = (struct feature_node*)malloc((nnz+n)*sizeof(struct feature_node));
	for(i=0; i<n; i++)
		prob_col->x[i] = &x_space[col_ptr[i]];

	for(i=0; i<l; i++)
	{
		struct feature_node *x = prob->x[i];
		while(x->index != -1)
		{
			int ind = x->index-1;
			x_space[col_ptr[ind]].index = i+1; // starts from 1
			x_space[col_ptr[ind]].value = x->value;
			col_ptr[ind]++;
			x++;
		}
	}
	for(i=0; i<n; i++)
		x_space[col_ptr[i]].index = -1;

	*x_space_ret = x_space;

	free(col_ptr);
}

// label: label name, start: begin of each class, count: #data of classes, perm: indices to the original data
// perm, length l, must be allocated before calling this subroutine
static void group_classes(const struct problem *prob, int *nr_class_ret, int **label_ret, int **start_ret, int **count_ret, int *perm)
{
	int l = prob->l;
	int max_nr_class = 16;
	int nr_class = 0;
	int *label = (int*)malloc(max_nr_class*sizeof(int));
	int *count = (int*)malloc(max_nr_class*sizeof(int));
	int *data_label = (int*)malloc(l*sizeof(int));
	int i;
	int *start;

	for(i=0;i<l;i++)
	{
		int this_label = (int)prob->y[i];
		int j;
		for(j=0;j<nr_class;j++)
		{
			if(this_label == label[j])
			{
				++count[j];
				break;
			}
		}
		data_label[i] = j;
		if(j == nr_class)
		{
			if(nr_class == max_nr_class)
			{
				max_nr_class *= 2;
				label = (int *)realloc(label,max_nr_class*sizeof(int));
				count = (int *)realloc(count,max_nr_class*sizeof(int));
			}
			label[nr_class] = this_label;
			count[nr_class] = 1;
			++nr_class;
		}
	}

	start = (int*)malloc(nr_class*sizeof(int));
	start[0] = 0;
	for(i=1;i<nr_class;i++)
		start[i] = start[i-1]+count[i-1];
	for(i=0;i<l;i++)
	{
		perm[start[data_label[i]]] = i;
		++start[data_label[i]];
	}
	start[0] = 0;
	for(i=1;i<nr_class;i++)
		start[i] = start[i-1]+count[i-1];

	*nr_class_ret = nr_class;
	*label_ret = label;
	*start_ret = start;
	*count_ret = count;
	free(data_label);
}

static void train_one(const struct problem *prob, const struct parameter *param, double *w, double Cp, double Cn)
{
	double eps=param->eps;
	int pos = 0;
	int neg = 0;
	double primal_solver_tol;
	int i;
	for(i=0;i<prob->l;i++)
		if(prob->y[i] > 0)
			pos++;
	neg = prob->l - pos;

	primal_solver_tol = eps*((((pos < neg)?pos : neg) > 1)?((pos < neg)?pos : neg) : 1)/prob->l;

//	function *fun_obj=NULL;
	switch(param->solver_type)
	{
		case L2R_LR:
		{
			double *C = (double*)malloc(prob->l*sizeof(double));
			int i;
			l2r_lr_fun *fun_obj;
			TRON_l2r_lr *tron_obj;
			for(i = 0; i < prob->l; i++)
			{
				if(prob->y[i] > 0)
					C[i] = Cp;
				else
					C[i] = Cn;
			}
			fun_obj = (l2r_lr_fun*)malloc(sizeof(l2r_lr_fun));
			l2r_lr_fun_initialise(fun_obj);
			fun_obj->constructor(fun_obj, prob, C);
			tron_obj = (TRON_l2r_lr*)malloc(sizeof(TRON_l2r_lr));
			TRON_initialise_l2r_lr(tron_obj);
			tron_obj->constructor(tron_obj, fun_obj, primal_solver_tol, 1000);//default max_iter=1000
//			TRON tron_obj(fun_obj, primal_solver_tol);
			tron_obj->set_print_string(tron_obj, liblinear_print_string);
			tron_obj->tron(tron_obj, w);
			fun_obj->destructor(fun_obj);
			free(fun_obj);
//			tron_obj->destructor(tron_obj);
			free(tron_obj);
			free(C);
			break;
		}
		case L2R_L2LOSS_SVC:
		{
			double *C = (double*)malloc(prob->l*sizeof(double));
			int i;
			l2r_l2_svc_fun *fun_obj;
			TRON_l2r_l2_svc *tron_obj;
			for(i = 0; i < prob->l; i++)
			{
				if(prob->y[i] > 0)
					C[i] = Cp;
				else
					C[i] = Cn;
			}
			fun_obj = (l2r_l2_svc_fun*)malloc(sizeof(l2r_l2_svc_fun));
			l2r_l2_svc_fun_initialise(fun_obj);
			fun_obj->constructor(fun_obj, prob, C);
			tron_obj = (TRON_l2r_l2_svc*)malloc(sizeof(TRON_l2r_l2_svc));
			TRON_initialise_l2r_l2_svc(tron_obj);
			tron_obj->constructor(tron_obj, fun_obj, primal_solver_tol, 1000);//default max_iter=1000
			tron_obj->set_print_string(tron_obj, liblinear_print_string);
			tron_obj->tron(tron_obj, w);
			fun_obj->destructor(fun_obj);
			free(fun_obj);
//			tron_obj->destructor(tron_obj);
			free(tron_obj);
			free(C);
			break;
		}
		case L2R_L2LOSS_SVC_DUAL:
			solve_l2r_l1l2_svc(prob, w, eps, Cp, Cn, L2R_L2LOSS_SVC_DUAL);
			break;
		case L2R_L1LOSS_SVC_DUAL:
			solve_l2r_l1l2_svc(prob, w, eps, Cp, Cn, L2R_L1LOSS_SVC_DUAL);
			break;
		case L1R_L2LOSS_SVC:
		{
			struct problem prob_col;
			struct feature_node *x_space = NULL;
			transpose(prob, &x_space ,&prob_col);
			solve_l1r_l2_svc(&prob_col, w, primal_solver_tol, Cp, Cn);
			free(prob_col.y);
			free(prob_col.x);
			free(x_space);
			break;
		}
		case L1R_LR:
		{
			struct problem prob_col;
			struct feature_node *x_space = NULL;
			transpose(prob, &x_space ,&prob_col);
			solve_l1r_lr(&prob_col, w, primal_solver_tol, Cp, Cn);
			free(prob_col.y);
			free(prob_col.x);
			free(x_space);
			break;
		}
		case L2R_LR_DUAL:
			solve_l2r_lr_dual(prob, w, eps, Cp, Cn);
			break;
		case L2R_L2LOSS_SVR:
		{
			double *C = (double*)malloc(prob->l*sizeof(double));
			int i;
			l2r_l2_svr_fun *fun_obj;
			TRON_l2r_l2_svr *tron_obj;
			for(i = 0; i < prob->l; i++)
				C[i] = param->C;

			fun_obj = (l2r_l2_svr_fun*)malloc(sizeof(l2r_l2_svr_fun));
			l2r_l2_svr_fun_initialise(fun_obj);
			fun_obj->constructor(fun_obj, prob, C, param->p);
			tron_obj = (TRON_l2r_l2_svr*)malloc(sizeof(TRON_l2r_l2_svr));
			TRON_initialise_l2r_l2_svr(tron_obj);
			tron_obj->constructor(tron_obj, fun_obj, param->eps, 1000);//default max_iter=1000
			tron_obj->set_print_string(tron_obj, liblinear_print_string);
			tron_obj->tron(tron_obj, w);
//			fun_obj->destructor(fun_obj);
			free(fun_obj);
//			tron_obj->destructor(tron_obj);
			free(tron_obj);
			free(C);
			break;

		}
		case L2R_L1LOSS_SVR_DUAL:
			solve_l2r_l1l2_svr(prob, w, param, L2R_L1LOSS_SVR_DUAL);
			break;
		case L2R_L2LOSS_SVR_DUAL:
			solve_l2r_l1l2_svr(prob, w, param, L2R_L2LOSS_SVR_DUAL);
			break;
		default:
			fprintf(stderr, "ERROR: unknown solver_type\n");
			break;
	}
}

//
// Interface functions
//
struct model* train(const struct problem *prob, const struct parameter *param)
{
	int i,j;
	int l = prob->l;
	int n = prob->n;
	int w_size = prob->n;
	struct model *model_ = Malloc(struct model,1);

	if(prob->bias>=0)
		model_->nr_feature=n-1;
	else
		model_->nr_feature=n;
	model_->param = *param;
	model_->bias = prob->bias;

	if(param->solver_type == L2R_L2LOSS_SVR ||
	   param->solver_type == L2R_L1LOSS_SVR_DUAL ||
	   param->solver_type == L2R_L2LOSS_SVR_DUAL)
	{
		model_->w = Malloc(double, w_size);
		model_->nr_class = 2;
		model_->label = NULL;
		train_one(prob, param, &model_->w[0], 0, 0);
	}
	else
	{
		int nr_class;
		int *label = NULL;
		int *start = NULL;
		int *count = NULL;
		int *perm = Malloc(int,l);
		double *weighted_C;
		struct feature_node **x;
		int k;
		struct problem sub_prob;

		// group training data of the same class
		group_classes(prob,&nr_class,&label,&start,&count,perm);

		model_->nr_class=nr_class;
		model_->label = Malloc(int,nr_class);
		for(i=0;i<nr_class;i++)
			model_->label[i] = label[i];

		// calculate weighted C
		weighted_C = Malloc(double, nr_class);
		for(i=0;i<nr_class;i++)
			weighted_C[i] = param->C;
		for(i=0;i<param->nr_weight;i++)
		{
			for(j=0;j<nr_class;j++)
				if(param->weight_label[i] == label[j])
					break;
			if(j == nr_class)
				fprintf(stderr,"WARNING: class label %d specified in weight is not found\n", param->weight_label[i]);
			else
				weighted_C[j] *= param->weight[i];
		}

		// constructing the subproblem
		x = Malloc(struct feature_node *,l);
		for(i=0;i<l;i++)
			x[i] = prob->x[perm[i]];

		sub_prob.l = l;
		sub_prob.n = n;
		sub_prob.x = Malloc(struct feature_node *,sub_prob.l);
		sub_prob.y = Malloc(double,sub_prob.l);

		for(k=0; k<sub_prob.l; k++)
			sub_prob.x[k] = x[k];

		// multi-class svm by Crammer and Singer
		if(param->solver_type == MCSVM_CS)
		{
			Solver_MCSVM_CS* Solver;
			model_->w=Malloc(double, n*nr_class);
			for(i=0;i<nr_class;i++)
				for(j=start[i];j<start[i]+count[i];j++)
					sub_prob.y[j] = i;
		
			Solver = (Solver_MCSVM_CS*)malloc(sizeof(Solver_MCSVM_CS));
			Solver_MCSVM_CS_initialise(Solver);
			Solver->constructor(Solver, &sub_prob, nr_class, weighted_C, param->eps, 100000);
			Solver->Solve(Solver, model_->w);
			Solver->destructor(Solver);
			free(Solver);
//			Solver_MCSVM_CS Solver(&sub_prob, nr_class, weighted_C, param->eps);
//			Solver.Solve(model_->w);
		}
		else
		{
			if(nr_class == 2)
			{
				int e0;
				model_->w=Malloc(double, w_size);

				e0 = start[0]+count[0];
				k=0;
				for(; k<e0; k++)
					sub_prob.y[k] = +1;
				for(; k<sub_prob.l; k++)
					sub_prob.y[k] = -1;

				train_one(&sub_prob, param, &model_->w[0], weighted_C[0], weighted_C[1]);
			}
			else
			{
				double *w;
				model_->w=Malloc(double, w_size*nr_class);
				w=Malloc(double, w_size);
				for(i=0;i<nr_class;i++)
				{
					int si = start[i];
					int ei = si+count[i];
					int j;

					k=0;
					for(; k<si; k++)
						sub_prob.y[k] = -1;
					for(; k<ei; k++)
						sub_prob.y[k] = +1;
					for(; k<sub_prob.l; k++)
						sub_prob.y[k] = -1;

					train_one(&sub_prob, param, w, weighted_C[i], param->C);

					for(j=0;j<w_size;j++)
						model_->w[j*nr_class+i] = w[j];
				}
				free(w);
			}

		}

		free(x);
		free(label);
		free(start);
		free(count);
		free(perm);
		free(sub_prob.x);
		free(sub_prob.y);
		free(weighted_C);
	}
	return model_;
}

void cross_validation(const struct problem *prob, const struct parameter *param, int nr_fold, double *target)
{
	int i;
	int *fold_start = Malloc(int,nr_fold+1);
	int l = prob->l;
	int *perm = Malloc(int,l);

	for(i=0;i<l;i++) perm[i]=i;
	for(i=0;i<l;i++)
	{
		int j = i+rand()%(l-i);
		int swaptemp;
		//swapint(perm[i],perm[j]);
		swaptemp = perm[i];
		perm[i] = perm[j];
		perm[j] = swaptemp;
	}
	for(i=0;i<=nr_fold;i++)
		fold_start[i]=i*l/nr_fold;

	for(i=0;i<nr_fold;i++)
	{
		int begin = fold_start[i];
		int end = fold_start[i+1];
		int j,k;
		struct problem subprob;
		struct model *submodel;

		subprob.bias = prob->bias;
		subprob.n = prob->n;
		subprob.l = l-(end-begin);
		subprob.x = Malloc(struct feature_node*,subprob.l);
		subprob.y = Malloc(double,subprob.l);

		k=0;
		for(j=0;j<begin;j++)
		{
			subprob.x[k] = prob->x[perm[j]];
			subprob.y[k] = prob->y[perm[j]];
			++k;
		}
		for(j=end;j<l;j++)
		{
			subprob.x[k] = prob->x[perm[j]];
			subprob.y[k] = prob->y[perm[j]];
			++k;
		}
		submodel = train(&subprob,param);
		for(j=begin;j<end;j++)
			target[perm[j]] = predict(submodel,prob->x[perm[j]]);
		free_and_destroy_model(&submodel);
		free(subprob.x);
		free(subprob.y);
	}
	free(fold_start);
	free(perm);
}

double predict_values(const struct model *model_, const struct feature_node *x, double *dec_values)
{
	int idx;
	int n;
	double *w;
	int nr_class;
	int i;
	int nr_w;
	const struct feature_node *lx=x;

	if(model_->bias>=0)
		n=model_->nr_feature+1;
	else
		n=model_->nr_feature;
	w=model_->w;
	nr_class=model_->nr_class;
	if(nr_class==2 && model_->param.solver_type != MCSVM_CS)
		nr_w = 1;
	else
		nr_w = nr_class;

	for(i=0;i<nr_w;i++)
		dec_values[i] = 0;
	for(; (idx=lx->index)!=-1; lx++)
	{
		// the dimension of testing data may exceed that of training
		if(idx<=n)
			for(i=0;i<nr_w;i++)
				dec_values[i] += w[(idx-1)*nr_w+i]*lx->value;
	}

	if(nr_class==2)
	{
		if(model_->param.solver_type == L2R_L2LOSS_SVR ||
		   model_->param.solver_type == L2R_L1LOSS_SVR_DUAL ||
		   model_->param.solver_type == L2R_L2LOSS_SVR_DUAL)
			return dec_values[0];
		else
			return (dec_values[0]>0)?model_->label[0]:model_->label[1];
	}
	else
	{
		int dec_max_idx = 0;
		for(i=1;i<nr_class;i++)
		{
			if(dec_values[i] > dec_values[dec_max_idx])
				dec_max_idx = i;
		}
		return model_->label[dec_max_idx];
	}
}

double predict(const struct model *model_, const struct feature_node *x)
{
	double *dec_values = Malloc(double, model_->nr_class);
	double label=predict_values(model_, x, dec_values);
	free(dec_values);
	return label;
}

double predict_probability(const struct model *model_, const struct feature_node *x, double* prob_estimates)
{
	if(check_probability_model(model_))
	{
		int i;
		int nr_class=model_->nr_class;
		int nr_w;
		double label;
		if(nr_class==2)
			nr_w = 1;
		else
			nr_w = nr_class;

		label=predict_values(model_, x, prob_estimates);
		for(i=0;i<nr_w;i++)
			prob_estimates[i]=1/(1+exp(-prob_estimates[i]));

		if(nr_class==2) // for binary classification
			prob_estimates[1]=1.-prob_estimates[0];
		else
		{
			double sum=0;
			for(i=0; i<nr_class; i++)
				sum+=prob_estimates[i];

			for(i=0; i<nr_class; i++)
				prob_estimates[i]=prob_estimates[i]/sum;
		}

		return label;
	}
	else
		return 0;
}

static const char *solver_type_table[]=
{
	"L2R_LR", "L2R_L2LOSS_SVC_DUAL", "L2R_L2LOSS_SVC", "L2R_L1LOSS_SVC_DUAL", "MCSVM_CS",
	"L1R_L2LOSS_SVC", "L1R_LR", "L2R_LR_DUAL",
	"", "", "",
	"L2R_L2LOSS_SVR", "L2R_L2LOSS_SVR_DUAL", "L2R_L1LOSS_SVR_DUAL", NULL
};

int save_model(const char *model_file_name, const struct model *model_)
{
	int i;
	int nr_feature=model_->nr_feature;
	int n;
	const struct parameter *param = &model_->param;
//	const struct parameter& param = model_->param;
	int w_size;
	char *old_locale;
	int nr_w;
	FILE *fp;

	if(model_->bias>=0)
		n=nr_feature+1;
	else
		n=nr_feature;
	w_size = n;
	fp = fopen(model_file_name,"w");
	if(fp==NULL) return -1;

	old_locale = strdup(setlocale(LC_ALL, NULL));
	setlocale(LC_ALL, "C");

	if(model_->nr_class==2 && model_->param.solver_type != MCSVM_CS)
		nr_w=1;
	else
		nr_w=model_->nr_class;

	fprintf(fp, "solver_type %s\n", solver_type_table[param->solver_type]);
	fprintf(fp, "nr_class %d\n", model_->nr_class);

	if(model_->label)
	{
		fprintf(fp, "label");
		for(i=0; i<model_->nr_class; i++)
			fprintf(fp, " %d", model_->label[i]);
		fprintf(fp, "\n");
	}

	fprintf(fp, "nr_feature %d\n", nr_feature);

	fprintf(fp, "bias %.16g\n", model_->bias);

	fprintf(fp, "w\n");
	for(i=0; i<w_size; i++)
	{
		int j;
		for(j=0; j<nr_w; j++)
			fprintf(fp, "%.16g ", model_->w[i*nr_w+j]);
		fprintf(fp, "\n");
	}

	setlocale(LC_ALL, old_locale);
	free(old_locale);

	if (ferror(fp) != 0 || fclose(fp) != 0) return -1;
	else return 0;
}

struct model *load_model(const char *model_file_name)
{
	int i;
	int nr_feature;
	int n;
	int nr_class;
	double bias;
	struct model *model_;
	char *old_locale;
	char cmd[81];
	int w_size;
	int nr_w;
	struct parameter *param;

	FILE *fp = fopen(model_file_name,"r");
	if(fp==NULL) return NULL;

	model_ = Malloc(struct model,1);
	param = &model_->param;
//	struct parameter& param = model_->param;

	model_->label = NULL;

	old_locale = strdup(setlocale(LC_ALL, NULL));
	setlocale(LC_ALL, "C");

	while(1)
	{
		fscanf(fp,"%80s",cmd);
		if(strcmp(cmd,"solver_type")==0)
		{
			int i;
			fscanf(fp,"%80s",cmd);
			for(i=0;solver_type_table[i];i++)
			{
				if(strcmp(solver_type_table[i],cmd)==0)
				{
					param->solver_type=i;
					break;
				}
			}
			if(solver_type_table[i] == NULL)
			{
				fprintf(stderr,"unknown solver type.\n");

				setlocale(LC_ALL, old_locale);
				free(model_->label);
				free(model_);
				free(old_locale);
				return NULL;
			}
		}
		else if(strcmp(cmd,"nr_class")==0)
		{
			fscanf(fp,"%d",&nr_class);
			model_->nr_class=nr_class;
		}
		else if(strcmp(cmd,"nr_feature")==0)
		{
			fscanf(fp,"%d",&nr_feature);
			model_->nr_feature=nr_feature;
		}
		else if(strcmp(cmd,"bias")==0)
		{
			fscanf(fp,"%lf",&bias);
			model_->bias=bias;
		}
		else if(strcmp(cmd,"w")==0)
		{
			break;
		}
		else if(strcmp(cmd,"label")==0)
		{
			int nr_class = model_->nr_class;
			int i;
			model_->label = Malloc(int,nr_class);
			for(i=0;i<nr_class;i++)
				fscanf(fp,"%d",&model_->label[i]);
		}
		else
		{
			fprintf(stderr,"unknown text in model file: [%s]\n",cmd);
			setlocale(LC_ALL, old_locale);
			free(model_->label);
			free(model_);
			free(old_locale);
			return NULL;
		}
	}

	nr_feature=model_->nr_feature;
	if(model_->bias>=0)
		n=nr_feature+1;
	else
		n=nr_feature;
	w_size = n;
	if(nr_class==2 && param->solver_type != MCSVM_CS)
		nr_w = 1;
	else
		nr_w = nr_class;

	model_->w=Malloc(double, w_size*nr_w);
	for(i=0; i<w_size; i++)
	{
		int j;
		for(j=0; j<nr_w; j++)
			fscanf(fp, "%lf ", &model_->w[i*nr_w+j]);
		fscanf(fp, "\n");
	}

	setlocale(LC_ALL, old_locale);
	free(old_locale);

	if (ferror(fp) != 0 || fclose(fp) != 0) return NULL;

	return model_;
}

int get_nr_feature(const struct model *model_)
{
	return model_->nr_feature;
}

int get_nr_class(const struct model *model_)
{
	return model_->nr_class;
}

void get_labels(const struct model *model_, int* label)
{
	if (model_->label != NULL)
	{
		int i;
		for(i=0;i<model_->nr_class;i++)
			label[i] = model_->label[i];
	}
}

void free_model_content(struct model *model_ptr)
{
	if(model_ptr->w != NULL)
		free(model_ptr->w);
	if(model_ptr->label != NULL)
		free(model_ptr->label);
}

void free_and_destroy_model(struct model **model_ptr_ptr)
{
	struct model *model_ptr = *model_ptr_ptr;
	if(model_ptr != NULL)
	{
		free_model_content(model_ptr);
		free(model_ptr);
	}
}

void destroy_param(struct parameter* param)
{
	if(param->weight_label != NULL)
		free(param->weight_label);
	if(param->weight != NULL)
		free(param->weight);
}

const char *check_parameter(const struct problem *prob, const struct parameter *param)
{
	if(param->eps <= 0)
		return "eps <= 0";

	if(param->C <= 0)
		return "C <= 0";

	if(param->p < 0)
		return "p < 0";

	if(param->solver_type != L2R_LR
		&& param->solver_type != L2R_L2LOSS_SVC_DUAL
		&& param->solver_type != L2R_L2LOSS_SVC
		&& param->solver_type != L2R_L1LOSS_SVC_DUAL
		&& param->solver_type != MCSVM_CS
		&& param->solver_type != L1R_L2LOSS_SVC
		&& param->solver_type != L1R_LR
		&& param->solver_type != L2R_LR_DUAL
		&& param->solver_type != L2R_L2LOSS_SVR
		&& param->solver_type != L2R_L2LOSS_SVR_DUAL
		&& param->solver_type != L2R_L1LOSS_SVR_DUAL)
		return "unknown solver type";

	return NULL;
}

int check_probability_model(const struct model *model_)
{
	return (model_->param.solver_type==L2R_LR ||
			model_->param.solver_type==L2R_LR_DUAL ||
			model_->param.solver_type==L1R_LR);
}

void set_print_string_function(void (*print_func)(const char*))
{
	if (print_func == NULL)
		liblinear_print_string = &print_string_stdout;
	else
		liblinear_print_string = print_func;
}

