#ifndef _TRON_H
#define _TRON_H

//TRON for l2r_lr_fun
typedef struct tagTRON_l2r_lr TRON_l2r_lr;
struct tagTRON_l2r_lr
{
	void (*constructor)(struct tagTRON_l2r_lr *, struct tagl2r_lr_fun *fun_obj, double eps, int max_iter);
	//different "function" structs; default double eps = 0.1, int max_iter = 1000
//	void (*destructor)(struct tagTRON_l2r_lr *this);

	void (*tron)(struct tagTRON_l2r_lr *, double *w);
	void (*set_print_string)(struct tagTRON_l2r_lr *, void (*i_print) (const char *buf));

	//originally private:
	int (*trcg)(struct tagTRON_l2r_lr *, double delta, double *g, double *s, double *r);
	double (*norm_inf)(struct tagTRON_l2r_lr *, int n, double *x);

	double eps;
	int max_iter;
	//different "function" structs
	struct tagl2r_lr_fun *fun_obj;
	void (*info)(struct tagTRON_l2r_lr *this, const char *fmt,...);
	void (*tron_print_string)(const char *buf);
};


//TRON for l2r_l2_svc_fun
typedef struct tagTRON_l2r_l2_svc TRON_l2r_l2_svc;
struct tagTRON_l2r_l2_svc
{
	void (*constructor)(struct tagTRON_l2r_l2_svc *this, struct tagl2r_l2_svc_fun *fun_obj, double eps, int max_iter);
	//different "function" structs; default double eps = 0.1, int max_iter = 1000
//	void (*destructor)(struct tagTRON_l2r_l2_svc *this);

	void (*tron)(struct tagTRON_l2r_l2_svc *this, double *w);
	void (*set_print_string)(struct tagTRON_l2r_l2_svc *this, void (*i_print) (const char *buf));

	//originally private:
	int (*trcg)(struct tagTRON_l2r_l2_svc *this, double delta, double *g, double *s, double *r);
	double (*norm_inf)(struct tagTRON_l2r_l2_svc *this, int n, double *x);

	double eps;
	int max_iter;
	//different "function" structs
	struct tagl2r_l2_svc_fun *fun_obj;
	void (*info)(struct tagTRON_l2r_l2_svc *this, const char *fmt,...);
	void (*tron_print_string)(const char *buf);
};


//TRON for l2r_l2_svr_fun
typedef struct tagTRON_l2r_l2_svr TRON_l2r_l2_svr;
struct tagTRON_l2r_l2_svr
{
	void (*constructor)(struct tagTRON_l2r_l2_svr *this, struct tagl2r_l2_svr_fun *fun_obj, double eps, int max_iter);
	//different "function" structs; default double eps = 0.1, int max_iter = 1000
//	void (*destructor)(struct tagTRON_l2r_l2_svr *this);

	void (*tron)(struct tagTRON_l2r_l2_svr *this, double *w);
	void (*set_print_string)(struct tagTRON_l2r_l2_svr *this, void (*i_print) (const char *buf));

	//originally private:
	int (*trcg)(struct tagTRON_l2r_l2_svr *this, double delta, double *g, double *s, double *r);
	double (*norm_inf)(struct tagTRON_l2r_l2_svr *this, int n, double *x);

	double eps;
	int max_iter;
	//different "function" structs
	struct tagl2r_l2_svr_fun *fun_obj;
	void (*info)(struct tagTRON_l2r_l2_svr *this, const char *fmt,...);
	void (*tron_print_string)(const char *buf);
};

void TRON_initialise_l2r_lr(struct tagTRON_l2r_lr *this);
void TRON_initialise_l2r_l2_svc(struct tagTRON_l2r_l2_svc *this);
void TRON_initialise_l2r_l2_svr(struct tagTRON_l2r_l2_svr *this);

#endif
