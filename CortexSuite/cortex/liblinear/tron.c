#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "tron.h"
#include "linear.h"

#ifndef mindouble
static double mindouble(double x,double y) { return (x<y)?x:y; }
#endif

#ifndef maxdouble
static double maxdouble(double x,double y) { return (x>y)?x:y; }
#endif

#ifdef __cplusplus
extern "C" {
#endif

extern double dnrm2_(int *, double *, int *);
extern double ddot_(int *, double *, int *, double *, int *);
extern int daxpy_(int *, double *, double *, int *, double *, int *);
extern int dscal_(int *, double *, double *, int *);

#ifdef __cplusplus
}
#endif

static void default_print(const char *buf)
{
	fputs(buf,stdout);
	fflush(stdout);
}


//TRON_l2r_lr:

void TRON_info_l2r_lr(struct tagTRON_l2r_lr *this, const char *fmt,...)
{
	char buf[BUFSIZ];
	va_list ap;
	va_start(ap,fmt);
	vsprintf(buf,fmt,ap);
	va_end(ap);
	this->tron_print_string(buf);
}

void TRON_constructor_l2r_lr(struct tagTRON_l2r_lr *this, struct tagl2r_lr_fun *fun_obj, double eps, int max_iter)
{
	this->fun_obj=fun_obj;
	this->eps=eps;
	this->max_iter=max_iter;
	this->tron_print_string = default_print;
}

void TRON_tron_l2r_lr(struct tagTRON_l2r_lr *this, double *w)
{
	struct tagl2r_lr_fun *fun_obj = this->fun_obj;
	double eps = this->eps;
	int max_iter = this->max_iter;

	// Parameters for updating the iterates.
	double eta0 = 1e-4, eta1 = 0.25, eta2 = 0.75;

	// Parameters for updating the trust region size delta.
	double sigma1 = 0.25, sigma2 = 0.5, sigma3 = 4;

	int n = fun_obj->get_nr_variable(fun_obj);
	int i, cg_iter;
	double delta, snorm, one=1.0;
	double alpha, f, fnew, prered, actred, gs;
	int search = 1, iter = 1, inc = 1;
	double *s = (double*)malloc(n*sizeof(double));
	double *r = (double*)malloc(n*sizeof(double));
	double *w_new = (double*)malloc(n*sizeof(double));
	double *g = (double*)malloc(n*sizeof(double));
	double gnorm1;
	double gnorm;

	for (i=0; i<n; i++)
		w[i] = 0;

        f = fun_obj->fun(fun_obj, w);
	fun_obj->grad(fun_obj, w, g);
	delta = dnrm2_(&n, g, &inc);
	gnorm1 = delta;
	gnorm = gnorm1;

	if (gnorm <= eps*gnorm1)
		search = 0;

	iter = 1;

	while (iter <= max_iter && search)
	{
		cg_iter = this->trcg(this, delta, g, s, r);

		memcpy(w_new, w, sizeof(double)*n);
		daxpy_(&n, &one, s, &inc, w_new, &inc);

		gs = ddot_(&n, g, &inc, s, &inc);
		prered = -0.5*(gs-ddot_(&n, s, &inc, r, &inc));
                fnew = fun_obj->fun(fun_obj, w_new);

		// Compute the actual reduction.
	        actred = f - fnew;

		// On the first iteration, adjust the initial step bound.
		snorm = dnrm2_(&n, s, &inc);
		if (iter == 1)
			delta = mindouble(delta, snorm);

		// Compute prediction alpha*snorm of the step.
		if (fnew - f - gs <= 0)
			alpha = sigma3;
		else
			alpha = maxdouble(sigma1, -0.5*(gs/(fnew - f - gs)));

		// Update the trust region bound according to the ratio of actual to predicted reduction.
		if (actred < eta0*prered)
			delta = mindouble(maxdouble(alpha, sigma1)*snorm, sigma2*delta);
		else if (actred < eta1*prered)
			delta = maxdouble(sigma1*delta, mindouble(alpha*snorm, sigma2*delta));
		else if (actred < eta2*prered)
			delta = maxdouble(sigma1*delta, mindouble(alpha*snorm, sigma3*delta));
		else
			delta = maxdouble(delta, mindouble(alpha*snorm, sigma3*delta));

		this->info(this, "iter %2d act %5.3e pre %5.3e delta %5.3e f %5.3e |g| %5.3e CG %3d\n", iter, actred, prered, delta, f, gnorm, cg_iter);

		if (actred > eta0*prered)
		{
			iter++;
			memcpy(w, w_new, sizeof(double)*n);
			f = fnew;
		        fun_obj->grad(fun_obj, w, g);

			gnorm = dnrm2_(&n, g, &inc);
			if (gnorm <= eps*gnorm1)
				break;
		}
		if (f < -1.0e+32)
		{
			this->info(this, "WARNING: f < -1.0e+32\n");
			break;
		}
		if (fabs(actred) <= 0 && prered <= 0)
		{
			this->info(this, "WARNING: actred and prered <= 0\n");
			break;
		}
		if (fabs(actred) <= 1.0e-12*fabs(f) &&
		    fabs(prered) <= 1.0e-12*fabs(f))
		{
			this->info(this, "WARNING: actred and prered too small\n");
			break;
		}
	}

	free(g);
	free(r);
	free(w_new);
	free(s);
}

int TRON_trcg_l2r_lr(struct tagTRON_l2r_lr *this, double delta, double *g, double *s, double *r)
{
	struct tagl2r_lr_fun *fun_obj = this->fun_obj;
	double eps = this->eps;
	int max_iter = this->max_iter;

	int i, inc = 1;
	int n = fun_obj->get_nr_variable(fun_obj);
	double one = 1;
	double *d = (double*)malloc(n*sizeof(double));
	double *Hd = (double*)malloc(n*sizeof(double));
	double rTr, rnewTrnew, alpha, beta, cgtol;
	int cg_iter;

	for (i=0; i<n; i++)
	{
		s[i] = 0;
		r[i] = -g[i];
		d[i] = r[i];
	}
	cgtol = 0.1*dnrm2_(&n, g, &inc);

	cg_iter = 0;
	rTr = ddot_(&n, r, &inc, r, &inc);
	while (1)
	{
		if (dnrm2_(&n, r, &inc) <= cgtol)
			break;
		cg_iter++;
		fun_obj->Hv(fun_obj, d, Hd);

		alpha = rTr/ddot_(&n, d, &inc, Hd, &inc);
		daxpy_(&n, &alpha, d, &inc, s, &inc);
		if (dnrm2_(&n, s, &inc) > delta)
		{
			double std;
			double sts;
			double dtd;
			double dsq;
			double rad;

			this->info(this, "cg reaches trust region boundary\n");
			alpha = -alpha;
			daxpy_(&n, &alpha, d, &inc, s, &inc);

			std = ddot_(&n, s, &inc, d, &inc);
			sts = ddot_(&n, s, &inc, s, &inc);
			dtd = ddot_(&n, d, &inc, d, &inc);
			dsq = delta*delta;
			rad = sqrt(std*std + dtd*(dsq-sts));
			if (std >= 0)
				alpha = (dsq - sts)/(std + rad);
			else
				alpha = (rad - std)/dtd;
			daxpy_(&n, &alpha, d, &inc, s, &inc);
			alpha = -alpha;
			daxpy_(&n, &alpha, Hd, &inc, r, &inc);
			break;
		}
		alpha = -alpha;
		daxpy_(&n, &alpha, Hd, &inc, r, &inc);
		rnewTrnew = ddot_(&n, r, &inc, r, &inc);
		beta = rnewTrnew/rTr;
		dscal_(&n, &beta, d, &inc);
		daxpy_(&n, &one, r, &inc, d, &inc);
		rTr = rnewTrnew;
	}

	free(d);
	free(Hd);

	return(cg_iter);
}

double TRON_norm_inf_l2r_lr(struct tagTRON_l2r_lr *this, int n, double *x)
{
	int i;
	double dmax = fabs(x[0]);
	for (i=1; i<n; i++)
		if (fabs(x[i]) >= dmax)
			dmax = fabs(x[i]);
	return(dmax);
}

void TRON_set_print_string_l2r_lr(struct tagTRON_l2r_lr *this, void (*print_string) (const char *buf))
{
	this->tron_print_string = print_string;
}

void TRON_initialise_l2r_lr(struct tagTRON_l2r_lr *this)
{
	this->constructor = &TRON_constructor_l2r_lr;
	this->tron = &TRON_tron_l2r_lr;
	this->set_print_string = &TRON_set_print_string_l2r_lr;
	this->trcg = &TRON_trcg_l2r_lr;
	this->norm_inf = &TRON_norm_inf_l2r_lr;
	this->info = &TRON_info_l2r_lr;
}








//TRON_l2r_l2_svc:

void TRON_info_l2r_l2_svc(struct tagTRON_l2r_l2_svc *this, const char *fmt,...)
{
	char buf[BUFSIZ];
	va_list ap;
	va_start(ap,fmt);
	vsprintf(buf,fmt,ap);
	va_end(ap);
	this->tron_print_string(buf);
}

void TRON_constructor_l2r_l2_svc(struct tagTRON_l2r_l2_svc *this, struct tagl2r_l2_svc_fun *fun_obj, double eps, int max_iter)
{
	this->fun_obj=fun_obj;
	this->eps=eps;
	this->max_iter=max_iter;
	this->tron_print_string = default_print;
}

void TRON_tron_l2r_l2_svc(struct tagTRON_l2r_l2_svc *this, double *w)
{
	struct tagl2r_l2_svc_fun *fun_obj = this->fun_obj;
	double eps = this->eps;
	int max_iter = this->max_iter;

	// Parameters for updating the iterates.
	double eta0 = 1e-4, eta1 = 0.25, eta2 = 0.75;

	// Parameters for updating the trust region size delta.
	double sigma1 = 0.25, sigma2 = 0.5, sigma3 = 4;

	int n = fun_obj->get_nr_variable(fun_obj);
	int i, cg_iter;
	double delta, snorm, one=1.0;
	double alpha, f, fnew, prered, actred, gs;
	int search = 1, iter = 1, inc = 1;
	double *s = (double*)malloc(n*sizeof(double));
	double *r = (double*)malloc(n*sizeof(double));
	double *w_new = (double*)malloc(n*sizeof(double));
	double *g = (double*)malloc(n*sizeof(double));
	double gnorm1;
	double gnorm;

	for (i=0; i<n; i++)
		w[i] = 0;

        f = fun_obj->fun(fun_obj, w);
	fun_obj->grad(fun_obj, w, g);
	delta = dnrm2_(&n, g, &inc);
	gnorm1 = delta;
	gnorm = gnorm1;

	if (gnorm <= eps*gnorm1)
		search = 0;

	iter = 1;

	while (iter <= max_iter && search)
	{
		cg_iter = this->trcg(this, delta, g, s, r);

		memcpy(w_new, w, sizeof(double)*n);
		daxpy_(&n, &one, s, &inc, w_new, &inc);

		gs = ddot_(&n, g, &inc, s, &inc);
		prered = -0.5*(gs-ddot_(&n, s, &inc, r, &inc));
                fnew = fun_obj->fun(fun_obj, w_new);

		// Compute the actual reduction.
	        actred = f - fnew;

		// On the first iteration, adjust the initial step bound.
		snorm = dnrm2_(&n, s, &inc);
		if (iter == 1)
			delta = mindouble(delta, snorm);

		// Compute prediction alpha*snorm of the step.
		if (fnew - f - gs <= 0)
			alpha = sigma3;
		else
			alpha = maxdouble(sigma1, -0.5*(gs/(fnew - f - gs)));

		// Update the trust region bound according to the ratio of actual to predicted reduction.
		if (actred < eta0*prered)
			delta = mindouble(maxdouble(alpha, sigma1)*snorm, sigma2*delta);
		else if (actred < eta1*prered)
			delta = maxdouble(sigma1*delta, mindouble(alpha*snorm, sigma2*delta));
		else if (actred < eta2*prered)
			delta = maxdouble(sigma1*delta, mindouble(alpha*snorm, sigma3*delta));
		else
			delta = maxdouble(delta, mindouble(alpha*snorm, sigma3*delta));

		this->info(this, "iter %2d act %5.3e pre %5.3e delta %5.3e f %5.3e |g| %5.3e CG %3d\n", iter, actred, prered, delta, f, gnorm, cg_iter);

		if (actred > eta0*prered)
		{
			iter++;
			memcpy(w, w_new, sizeof(double)*n);
			f = fnew;
		        fun_obj->grad(fun_obj, w, g);

			gnorm = dnrm2_(&n, g, &inc);
			if (gnorm <= eps*gnorm1)
				break;
		}
		if (f < -1.0e+32)
		{
			this->info(this, "WARNING: f < -1.0e+32\n");
			break;
		}
		if (fabs(actred) <= 0 && prered <= 0)
		{
			this->info(this, "WARNING: actred and prered <= 0\n");
			break;
		}
		if (fabs(actred) <= 1.0e-12*fabs(f) &&
		    fabs(prered) <= 1.0e-12*fabs(f))
		{
			this->info(this, "WARNING: actred and prered too small\n");
			break;
		}
	}

	free(g);
	free(r);
	free(w_new);
	free(s);
}

int TRON_trcg_l2r_l2_svc(struct tagTRON_l2r_l2_svc *this, double delta, double *g, double *s, double *r)
{
	struct tagl2r_l2_svc_fun *fun_obj = this->fun_obj;
	double eps = this->eps;
	int max_iter = this->max_iter;

	int i, inc = 1;
	int n = fun_obj->get_nr_variable(fun_obj);
	double one = 1;
	double *d = (double*)malloc(n*sizeof(double));
	double *Hd = (double*)malloc(n*sizeof(double));
	double rTr, rnewTrnew, alpha, beta, cgtol;
	int cg_iter;

	for (i=0; i<n; i++)
	{
		s[i] = 0;
		r[i] = -g[i];
		d[i] = r[i];
	}
	cgtol = 0.1*dnrm2_(&n, g, &inc);

	cg_iter = 0;
	rTr = ddot_(&n, r, &inc, r, &inc);
	while (1)
	{
		if (dnrm2_(&n, r, &inc) <= cgtol)
			break;
		cg_iter++;
		fun_obj->Hv(fun_obj, d, Hd);

		alpha = rTr/ddot_(&n, d, &inc, Hd, &inc);
		daxpy_(&n, &alpha, d, &inc, s, &inc);
		if (dnrm2_(&n, s, &inc) > delta)
		{
			double std;
			double sts;
			double dtd;
			double dsq;
			double rad;

			this->info(this, "cg reaches trust region boundary\n");
			alpha = -alpha;
			daxpy_(&n, &alpha, d, &inc, s, &inc);

			std = ddot_(&n, s, &inc, d, &inc);
			sts = ddot_(&n, s, &inc, s, &inc);
			dtd = ddot_(&n, d, &inc, d, &inc);
			dsq = delta*delta;
			rad = sqrt(std*std + dtd*(dsq-sts));
			if (std >= 0)
				alpha = (dsq - sts)/(std + rad);
			else
				alpha = (rad - std)/dtd;
			daxpy_(&n, &alpha, d, &inc, s, &inc);
			alpha = -alpha;
			daxpy_(&n, &alpha, Hd, &inc, r, &inc);
			break;
		}
		alpha = -alpha;
		daxpy_(&n, &alpha, Hd, &inc, r, &inc);
		rnewTrnew = ddot_(&n, r, &inc, r, &inc);
		beta = rnewTrnew/rTr;
		dscal_(&n, &beta, d, &inc);
		daxpy_(&n, &one, r, &inc, d, &inc);
		rTr = rnewTrnew;
	}

	free(d);
	free(Hd);

	return(cg_iter);
}

double TRON_norm_inf_l2r_l2_svc(struct tagTRON_l2r_l2_svc *this, int n, double *x)
{
	int i;
	double dmax = fabs(x[0]);
	for (i=1; i<n; i++)
		if (fabs(x[i]) >= dmax)
			dmax = fabs(x[i]);
	return(dmax);
}

void TRON_set_print_string_l2r_l2_svc(struct tagTRON_l2r_l2_svc *this, void (*print_string) (const char *buf))
{
	this->tron_print_string = print_string;
}

void TRON_initialise_l2r_l2_svc(struct tagTRON_l2r_l2_svc *this)
{
	this->constructor = &TRON_constructor_l2r_l2_svc;
	this->tron = &TRON_tron_l2r_l2_svc;
	this->set_print_string = &TRON_set_print_string_l2r_l2_svc;
	this->trcg = &TRON_trcg_l2r_l2_svc;
	this->norm_inf = &TRON_norm_inf_l2r_l2_svc;
	this->info = &TRON_info_l2r_l2_svc;
}







//TRON_l2r_l2_svr:

void TRON_info_l2r_l2_svr(struct tagTRON_l2r_l2_svr *this, const char *fmt,...)
{
	char buf[BUFSIZ];
	va_list ap;
	va_start(ap,fmt);
	vsprintf(buf,fmt,ap);
	va_end(ap);
	this->tron_print_string(buf);
}

void TRON_constructor_l2r_l2_svr(struct tagTRON_l2r_l2_svr *this, struct tagl2r_l2_svr_fun *fun_obj, double eps, int max_iter)
{
	this->fun_obj=fun_obj;
	this->eps=eps;
	this->max_iter=max_iter;
	this->tron_print_string = default_print;
}

void TRON_tron_l2r_l2_svr(struct tagTRON_l2r_l2_svr *this, double *w)
{
	struct tagl2r_l2_svr_fun *fun_obj = this->fun_obj;
	double eps = this->eps;
	int max_iter = this->max_iter;

	// Parameters for updating the iterates.
	double eta0 = 1e-4, eta1 = 0.25, eta2 = 0.75;

	// Parameters for updating the trust region size delta.
	double sigma1 = 0.25, sigma2 = 0.5, sigma3 = 4;

	int n = fun_obj->get_nr_variable(fun_obj);
	int i, cg_iter;
	double delta, snorm, one=1.0;
	double alpha, f, fnew, prered, actred, gs;
	int search = 1, iter = 1, inc = 1;
	double *s = (double*)malloc(n*sizeof(double));
	double *r = (double*)malloc(n*sizeof(double));
	double *w_new = (double*)malloc(n*sizeof(double));
	double *g = (double*)malloc(n*sizeof(double));
	double gnorm1;
	double gnorm;

	for (i=0; i<n; i++)
		w[i] = 0;

        f = fun_obj->fun(fun_obj, w);
	fun_obj->grad(fun_obj, w, g);
	delta = dnrm2_(&n, g, &inc);
	gnorm1 = delta;
	gnorm = gnorm1;

	if (gnorm <= eps*gnorm1)
		search = 0;

	iter = 1;

	while (iter <= max_iter && search)
	{
		cg_iter = this->trcg(this, delta, g, s, r);

		memcpy(w_new, w, sizeof(double)*n);
		daxpy_(&n, &one, s, &inc, w_new, &inc);

		gs = ddot_(&n, g, &inc, s, &inc);
		prered = -0.5*(gs-ddot_(&n, s, &inc, r, &inc));
                fnew = fun_obj->fun(fun_obj, w_new);

		// Compute the actual reduction.
	        actred = f - fnew;

		// On the first iteration, adjust the initial step bound.
		snorm = dnrm2_(&n, s, &inc);
		if (iter == 1)
			delta = mindouble(delta, snorm);

		// Compute prediction alpha*snorm of the step.
		if (fnew - f - gs <= 0)
			alpha = sigma3;
		else
			alpha = maxdouble(sigma1, -0.5*(gs/(fnew - f - gs)));

		// Update the trust region bound according to the ratio of actual to predicted reduction.
		if (actred < eta0*prered)
			delta = mindouble(maxdouble(alpha, sigma1)*snorm, sigma2*delta);
		else if (actred < eta1*prered)
			delta = maxdouble(sigma1*delta, mindouble(alpha*snorm, sigma2*delta));
		else if (actred < eta2*prered)
			delta = maxdouble(sigma1*delta, mindouble(alpha*snorm, sigma3*delta));
		else
			delta = maxdouble(delta, mindouble(alpha*snorm, sigma3*delta));

		this->info(this, "iter %2d act %5.3e pre %5.3e delta %5.3e f %5.3e |g| %5.3e CG %3d\n", iter, actred, prered, delta, f, gnorm, cg_iter);

		if (actred > eta0*prered)
		{
			iter++;
			memcpy(w, w_new, sizeof(double)*n);
			f = fnew;
		        fun_obj->grad(fun_obj, w, g);

			gnorm = dnrm2_(&n, g, &inc);
			if (gnorm <= eps*gnorm1)
				break;
		}
		if (f < -1.0e+32)
		{
			this->info(this, "WARNING: f < -1.0e+32\n");
			break;
		}
		if (fabs(actred) <= 0 && prered <= 0)
		{
			this->info(this, "WARNING: actred and prered <= 0\n");
			break;
		}
		if (fabs(actred) <= 1.0e-12*fabs(f) &&
		    fabs(prered) <= 1.0e-12*fabs(f))
		{
			this->info(this, "WARNING: actred and prered too small\n");
			break;
		}
	}

	free(g);
	free(r);
	free(w_new);
	free(s);
}

int TRON_trcg_l2r_l2_svr(struct tagTRON_l2r_l2_svr *this, double delta, double *g, double *s, double *r)
{
	struct tagl2r_l2_svr_fun *fun_obj = this->fun_obj;
	double eps = this->eps;
	int max_iter = this->max_iter;

	int i, inc = 1;
	int n = fun_obj->get_nr_variable(fun_obj);
	double one = 1;
	double *d = (double*)malloc(n*sizeof(double));
	double *Hd = (double*)malloc(n*sizeof(double));
	double rTr, rnewTrnew, alpha, beta, cgtol;
	int cg_iter;

	for (i=0; i<n; i++)
	{
		s[i] = 0;
		r[i] = -g[i];
		d[i] = r[i];
	}
	cgtol = 0.1*dnrm2_(&n, g, &inc);

	cg_iter = 0;
	rTr = ddot_(&n, r, &inc, r, &inc);
	while (1)
	{
		if (dnrm2_(&n, r, &inc) <= cgtol)
			break;
		cg_iter++;
		fun_obj->Hv(fun_obj, d, Hd);

		alpha = rTr/ddot_(&n, d, &inc, Hd, &inc);
		daxpy_(&n, &alpha, d, &inc, s, &inc);
		if (dnrm2_(&n, s, &inc) > delta)
		{
			double std;
			double sts;
			double dtd;
			double dsq;
			double rad;

			this->info(this, "cg reaches trust region boundary\n");
			alpha = -alpha;
			daxpy_(&n, &alpha, d, &inc, s, &inc);

			std = ddot_(&n, s, &inc, d, &inc);
			sts = ddot_(&n, s, &inc, s, &inc);
			dtd = ddot_(&n, d, &inc, d, &inc);
			dsq = delta*delta;
			rad = sqrt(std*std + dtd*(dsq-sts));
			if (std >= 0)
				alpha = (dsq - sts)/(std + rad);
			else
				alpha = (rad - std)/dtd;
			daxpy_(&n, &alpha, d, &inc, s, &inc);
			alpha = -alpha;
			daxpy_(&n, &alpha, Hd, &inc, r, &inc);
			break;
		}
		alpha = -alpha;
		daxpy_(&n, &alpha, Hd, &inc, r, &inc);
		rnewTrnew = ddot_(&n, r, &inc, r, &inc);
		beta = rnewTrnew/rTr;
		dscal_(&n, &beta, d, &inc);
		daxpy_(&n, &one, r, &inc, d, &inc);
		rTr = rnewTrnew;
	}

	free(d);
	free(Hd);

	return(cg_iter);
}

double TRON_norm_inf_l2r_l2_svr(struct tagTRON_l2r_l2_svr *this, int n, double *x)
{
	int i;
	double dmax = fabs(x[0]);
	for (i=1; i<n; i++)
		if (fabs(x[i]) >= dmax)
			dmax = fabs(x[i]);
	return(dmax);
}

void TRON_set_print_string_l2r_l2_svr(struct tagTRON_l2r_l2_svr *this, void (*print_string) (const char *buf))
{
	this->tron_print_string = print_string;
}

void TRON_initialise_l2r_l2_svr(struct tagTRON_l2r_l2_svr *this)
{
	this->constructor = &TRON_constructor_l2r_l2_svr;
	this->tron = &TRON_tron_l2r_l2_svr;
	this->set_print_string = &TRON_set_print_string_l2r_l2_svr;
	this->trcg = &TRON_trcg_l2r_l2_svr;
	this->norm_inf = &TRON_norm_inf_l2r_l2_svr;
	this->info = &TRON_info_l2r_l2_svr;
}